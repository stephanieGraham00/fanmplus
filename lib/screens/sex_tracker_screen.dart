import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/storage_service.dart';
import '../models/cycle_model.dart';
import '../theme/app_theme.dart';

class SexTrackerScreen extends StatefulWidget {
  const SexTrackerScreen({super.key});

  @override
  State<SexTrackerScreen> createState() => _SexTrackerScreenState();
}

class _SexTrackerScreenState extends State<SexTrackerScreen> {
  @override
  Widget build(BuildContext context) {
    final storage = context.watch<StorageService>();
    final cycle = storage.cycle;
    final recentLogs = cycle.sexLogs.reversed.take(20).toList();

    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: [AppTheme.lavenderPale, Color(0xFFFFF0F5)]),
      ),
      child: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              const Text('💕 Sex Tracker', style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: AppTheme.lavender)),
              const SizedBox(height: 4),
              const Text('Swiv aktivite seksyèl ou pou pwoteje tèt ou', style: TextStyle(color: Colors.grey, fontSize: 13)),
              const SizedBox(height: 20),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          _stat('Peryòd fètil', cycle.isFertile ? 'Wi ⚠️' : 'Non ✅', cycle.isFertile ? Colors.orange : Colors.green),
                          _stat('Pwochen règ', '${cycle.daysUntilNextPeriod} jou', AppTheme.rose),
                          _stat('Faz', cycle.phaseEmoji, AppTheme.lavender),
                        ],
                      ),
                      const SizedBox(height: 16),
                      if (cycle.isFertile)
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(color: Colors.orange.withOpacity(0.1), borderRadius: BorderRadius.circular(12), border: Border.all(color: Colors.orange.withOpacity(0.3))),
                          child: const Row(
                            children: [
                              Icon(Icons.warning_amber, color: Colors.orange, size: 20),
                              SizedBox(width: 8),
                              Expanded(child: Text('Ou nan peryòd fètil. Pran prekosyon!', style: TextStyle(color: Colors.orange, fontSize: 13, fontWeight: FontWeight.w500))),
                            ],
                          ),
                        ),
                      const SizedBox(height: 16),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          onPressed: () => _logSex(context, storage, cycle),
                          icon: const Icon(Icons.add),
                          label: const Text('Ajoute yon rapò'),
                          style: ElevatedButton.styleFrom(backgroundColor: Colors.pink),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              const Align(
                alignment: Alignment.centerLeft,
                child: Text('Istorik', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              ),
              const SizedBox(height: 8),
              if (recentLogs.isEmpty)
                const Card(child: Padding(
                  padding: EdgeInsets.all(20),
                  child: Center(child: Text('Pa gen istorik ankò', style: TextStyle(color: Colors.grey))),
                ))
              else
                ...recentLogs.map((log) => Card(
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: log.usedProtection ? Colors.green.withOpacity(0.15) : Colors.orange.withOpacity(0.15),
                      child: Icon(log.usedProtection ? Icons.shield : Icons.warning, color: log.usedProtection ? Colors.green : Colors.orange),
                    ),
                    title: Text('${log.date.day}/${log.date.month}/${log.date.year}', style: const TextStyle(fontWeight: FontWeight.w600)),
                    subtitle: Text(log.usedProtection ? 'Avèk pwoteksyon ✓' : 'San pwoteksyon ⚠️'),
                    trailing: log.notes.isNotEmpty ? Icon(Icons.note, color: Colors.grey.shade400, size: 20) : null,
                  ),
                )),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  Widget _stat(String label, String value, Color color) {
    return Column(children: [Text(value, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: color)), Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey))]);
  }

  void _logSex(BuildContext context, StorageService storage, CycleModel cycle) {
    final usedCtrl = ValueNotifier(true);
    final notesCtrl = TextEditingController();
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Ajoute yon rapò'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ValueListenableBuilder<bool>(
              valueListenable: usedCtrl,
              builder: (_, v, __) => SwitchListTile(
                title: Text(v ? 'Avèk pwoteksyon ✅' : 'San pwoteksyon ⚠️'),
                value: v,
                onChanged: (val) => usedCtrl.value = val,
                activeColor: Colors.green,
              ),
            ),
            TextField(controller: notesCtrl, maxLines: 2, decoration: const InputDecoration(labelText: 'Nòt (opsyonèl)')),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Anile')),
          ElevatedButton(
            onPressed: () {
              final logs = List<SexLog>.from(cycle.sexLogs);
              logs.add(SexLog(date: DateTime.now(), usedProtection: usedCtrl.value, notes: notesCtrl.text.trim()));
              storage.updateCycle(cycle.copyWith(sexLogs: logs));
              notesCtrl.dispose();
              Navigator.pop(ctx);
            },
            child: const Text('Anrejistre'),
          ),
        ],
      ),
    );
  }
}
