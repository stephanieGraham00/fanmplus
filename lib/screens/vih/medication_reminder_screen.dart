import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MedicationReminderScreen extends StatefulWidget {
  const MedicationReminderScreen({super.key});

  @override
  State<MedicationReminderScreen> createState() => _MedicationReminderScreenState();
}

class _MedicationReminderScreenState extends State<MedicationReminderScreen> {
  final List<Map<String, dynamic>> _meds = [];
  final _nameController = TextEditingController();
  TimeOfDay _selectedTime = const TimeOfDay(hour: 8, minute: 0);

  @override
  void initState() {
    super.initState();
    _loadMeds();
  }

  Future<void> _loadMeds() async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getString('vih_medications');
    if (data != null) {
      final decoded = List<Map<String, dynamic>>.from(
        (List<dynamic>.from(_decode(data))),
      );
      setState(() {
        _meds.addAll(decoded);
      });
    }
  }

  List<dynamic> _decode(String data) {
    // ignore: avoid_dynamic_calls
    return List<dynamic>.from(_parse(data));
  }

  List<dynamic> _parse(String data) {
    // Simple parse for stored list
    try {
      // Use dart:convert
      // ignore: invalid_library_annotation
      const JsonCodec codec = JsonCodec();
      final result = codec.decode(data);
      if (result is List) return result;
    } catch (_) {}
    return [];
  }

  Future<void> _saveMeds() async {
    final prefs = await SharedPreferences.getInstance();
    const JsonCodec codec = JsonCodec();
    await prefs.setString('vih_medications', codec.encode(_meds));
  }

  void _addMed() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Ajoute yon Medikaman'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Non medikaman (eg. ARV)',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            ListTile(
              title: Text('Lè: ${_selectedTime.format(context)}'),
              leading: const Icon(Icons.access_time),
              onTap: () async {
                final picked = await showTimePicker(
                  context: context,
                  initialTime: _selectedTime,
                );
                if (picked != null) {
                  setState(() => _selectedTime = picked);
                }
              },
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Anile'),
          ),
          ElevatedButton(
            onPressed: () {
              if (_nameController.text.isNotEmpty) {
                setState(() {
                  _meds.add({
                    'name': _nameController.text,
                    'time': _selectedTime.format(context),
                    'taken': false,
                  });
                });
                _saveMeds();
                _nameController.clear();
                Navigator.pop(context);
              }
            },
            child: const Text('Ajoute'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF121212) : const Color(0xFFF5F5F5),
      appBar: AppBar(
        title: const Text('Rapèl Pran Medikaman'),
        backgroundColor: const Color(0xFF1A5C1A),
        foregroundColor: Colors.white,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _InfoCard(
            title: 'Ki sa ARV ye?',
            body: 'ARV (Antiretroviral) se medikaman ki diminye kantite viris VIH nan san an. '
                'Yo pa geri VIH, men yo ede moun viv an sante pandan plizyè ane.',
            color: const Color(0xFF1A5C1A),
          ),
          const SizedBox(height: 12),
          _InfoCard(
            title: 'Poukisa enpòtan pran chak jou?',
            body: '• ARV diminye chaj viral la\n'
                '• Lè chaj viral la ba, sistèm iminitè a ka retounen fò\n'
                '• ARV anpeche VIH vin SIDA\n'
                '• Rate dòz ka fè viris la vin rezistan',
            color: const Color(0xFF2D8A2D),
          ),
          const SizedBox(height: 16),
          const Text(
            'Medikaman ou yo',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 8),
          if (_meds.isEmpty)
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: const Center(
                child: Text(
                  'Ou poko ajoute okenn medikaman.\nPeze + pou ajoute youn.',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.grey),
                ),
              ),
            )
          else
            ..._meds.map((med) => Card(
              margin: const EdgeInsets.only(bottom: 8),
              child: CheckboxListTile(
                value: med['taken'] ?? false,
                onChanged: (val) {
                  setState(() => med['taken'] = val);
                  _saveMeds();
                },
                title: Text(med['name'] ?? ''),
                subtitle: Text('Lè: ${med['time']}'),
                secondary: const Icon(Icons.medication, color: Color(0xFF1A5C1A)),
              ),
            )),
          const SizedBox(height: 12),
          _InfoCard(
            title: 'Si ou bliye pran medikaman an',
            body: '• Mwens pase 12 èdtan: pran dòz la imedyatman\n'
                '• Plis pase 12 èdtan: sote dòz la, pa pran doub dòz\n'
                '• Pa janm sispann pran medikaman san pale ak doktè',
            color: const Color(0xFFB71C1C),
          ),
          const SizedBox(height: 12),
          _InfoCard(
            title: 'Si ou pa ka peye medikaman',
            body: '• Klinik Leta bay ARV gratis an Ayiti\n'
                '• MSPP distribye ARV nan sant sante\n'
                '• Ale wè doktè oswa enfimyè ki pi pre w',
            color: const Color(0xFF00695C),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addMed,
        backgroundColor: const Color(0xFF1A5C1A),
        child: const Icon(Icons.add),
      ),
    );
  }
}

class _InfoCard extends StatelessWidget {
  final String title;
  final String body;
  final Color color;

  const _InfoCard({required this.title, required this.body, required this.color});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.info_outline, color: color, size: 18),
              const SizedBox(width: 8),
              Text(
                title,
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                  color: color,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            body,
            style: TextStyle(
              fontSize: 13,
              height: 1.5,
              color: isDark ? Colors.grey[300] : Colors.grey[700],
            ),
          ),
        ],
      ),
    );
  }
}
