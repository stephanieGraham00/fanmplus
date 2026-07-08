import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../services/storage_service.dart';
import '../theme/app_theme.dart';
import '../widgets/app_icon.dart';
import '../utils/cycle_helpers.dart';

class CycleHistoryScreen extends StatelessWidget {
  const CycleHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cycle = context.watch<StorageService>().cycle;
    final lengths = cycle.pastCycleLengths;

    final avg = lengths.isEmpty ? cycle.cycleLength : (lengths.reduce((a, b) => a + b) ~/ lengths.length);
    final shortest = lengths.isEmpty ? cycle.cycleLength : lengths.reduce((a, b) => a < b ? a : b);
    final longest = lengths.isEmpty ? cycle.cycleLength : lengths.reduce((a, b) => a > b ? a : b);

    return Scaffold(
      appBar: AppBar(title: const Text('Historique du cycle'), backgroundColor: AppTheme.lavender),
      body: Container(
        decoration: const BoxDecoration(gradient: AppTheme.bgGradient),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(children: [
                _stat('$avg', 'Moyenne', AppTheme.lavender, 'paper'),
                const SizedBox(width: 8),
                _stat('$shortest', 'Plus court', AppTheme.rose, 'pad'),
                const SizedBox(width: 8),
                _stat('$longest', 'Plus long', AppTheme.gold, 'bottle'),
                const SizedBox(width: 8),
                _stat('${lengths.length}', 'Cycles', Colors.green, 'medical'),
              ]),
              const SizedBox(height: 20),

              if (lengths.isEmpty)
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(40),
                  decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20)),
                  child: const Column(children: [
                    AppIcon('paper', size: 48),
                    SizedBox(height: 16),
                    Text('Pas encore assez d\'historique.\nSuivez votre cycle pendant plusieurs mois pour voir les statistiques.', textAlign: TextAlign.center, style: TextStyle(color: Colors.grey)),
                  ]),
                )
              else ...[
                const Text('Chaque cycle', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppTheme.lavender)),
                const SizedBox(height: 12),
                ...List.generate(lengths.length, (i) {
                  final len = lengths[lengths.length - 1 - i];
                  return Container(
                    margin: const EdgeInsets.only(bottom: 8),
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16)),
                    child: Row(children: [
                      Container(
                        width: 40, height: 40,
                        decoration: BoxDecoration(color: AppTheme.roseLight, borderRadius: BorderRadius.circular(12)),
                        child: const AppIcon('paper', size: 22, color: AppTheme.rose),
                      ),
                      const SizedBox(width: 12),
                      Text('Cycle ${lengths.length - i}', style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
                      const Spacer(),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(color: AppTheme.lavenderPale, borderRadius: BorderRadius.circular(20)),
                        child: Text('$len jours', style: const TextStyle(color: AppTheme.lavender, fontWeight: FontWeight.bold)),
                      ),
                    ]),
                  );
                }),
              ],

              if (cycle.periodDates.isNotEmpty) ...[
                const SizedBox(height: 20),
                const Text('Dates des règles passées', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppTheme.rose)),
                const SizedBox(height: 12),
                Wrap(spacing: 8, runSpacing: 8, children: cycle.periodDates.reversed.take(12).map((d) =>
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(color: AppTheme.rosePale, borderRadius: BorderRadius.circular(16)),
                    child: Text(DateFormat('dd MMM yy', 'fr').format(d), style: const TextStyle(fontSize: 12, color: AppTheme.rose)),
                  )).toList(),
                ),
              ],
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _stat(String value, String label, Color color, String icon) => Expanded(
    child: Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16)),
      child: Column(children: [
        AppIcon(icon, size: 22, color: color),
        const SizedBox(height: 4),
        Text(value, style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: color)),
        const SizedBox(height: 4),
        Text(label, style: const TextStyle(fontSize: 11, color: Colors.grey)),
      ]),
    ),
  );
}
