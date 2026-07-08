import 'dart:math';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../services/storage_service.dart';
import '../models/cycle_model.dart';
import '../theme/app_theme.dart';

class CycleTrackerScreen extends StatefulWidget {
  const CycleTrackerScreen({super.key});

  @override
  State<CycleTrackerScreen> createState() => _CycleTrackerScreenState();
}

class _CycleTrackerScreenState extends State<CycleTrackerScreen> with SingleTickerProviderStateMixin {
  final _notesController = TextEditingController();
  bool _notesInitialized = false;
  late PageController _pageCtrl;
  late AnimationController _animCtrl;
  final _today = DateTime.now();
  DateTime _viewMonth = DateTime.now();

  final _symptoms = ['Kramp', 'Tèt', 'Fatig', 'Vant', 'Do', 'Emosyon', 'Anvi manje', 'Gonfle', 'Enèji', 'San'];

  @override
  void initState() {
    super.initState();
    _pageCtrl = PageController(initialPage: 12 * 12);
    _animCtrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 600));
    _animCtrl.forward();
  }

  @override
  void dispose() {
    _notesController.dispose();
    _pageCtrl.dispose();
    _animCtrl.dispose();
    super.dispose();
  }

  String get _monthLabel => DateFormat('MMMM yyyy', 'fr').format(_viewMonth);
  String get _monthLabelCreole => {
    'janvier': 'Janvye', 'février': 'Fevriye', 'mars': 'Mas', 'avril': 'Avril',
    'mai': 'Me', 'juin': 'Jen', 'juillet': 'Jiyè', 'août': 'Out',
    'septembre': 'Septanm', 'octobre': 'Oktòb', 'novembre': 'Novanm', 'décembre': 'Desanm',
  }[DateFormat('MMMM', 'fr').format(_viewMonth).toLowerCase()] ?? DateFormat('MMMM', 'fr').format(_viewMonth);

  void _prevMonth() => setState(() => _viewMonth = DateTime(_viewMonth.year, _viewMonth.month - 1));
  void _nextMonth() => setState(() => _viewMonth = DateTime(_viewMonth.year, _viewMonth.month + 1));

  @override
  Widget build(BuildContext context) {
    final storage = context.watch<StorageService>();
    final cycle = storage.cycle;

    if (!_notesInitialized && cycle.notes.isNotEmpty) {
      _notesInitialized = true;
      _notesController.text = cycle.notes;
    }

    final firstDay = DateTime(_viewMonth.year, _viewMonth.month, 1);
    final lastDay = DateTime(_viewMonth.year, _viewMonth.month + 1, 0);
    final startWeekday = firstDay.weekday % 7;
    final daysInMonth = lastDay.day;

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: [Color(0xFFFFF0F5), Color(0xFFF3E8FF)]),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                // Header
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(colors: [AppTheme.rose, AppTheme.lavender]),
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: [BoxShadow(color: AppTheme.rose.withOpacity(0.3), blurRadius: 15, offset: const Offset(0, 5))],
                  ),
                  child: Column(children: [
                    Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                      _miniStat(cycle.day, 'Jou', Icons.calendar_today),
                      _miniStat(cycle.phaseName, 'Faz', Icons.circle),
                      _miniStat('${cycle.cycleLength}j', 'Sik', Icons.repeat),
                    ]),
                    const SizedBox(height: 12),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: LinearProgressIndicator(
                        value: cycle.cycleLength > 0 ? cycle.day / cycle.cycleLength : 0,
                        backgroundColor: Colors.white.withOpacity(0.3),
                        color: Colors.white,
                        minHeight: 6,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text('${cycle.day}/${cycle.cycleLength} jou', style: const TextStyle(color: Colors.white70, fontSize: 12)),
                  ]),
                ),
                const SizedBox(height: 16),

                // Fertility + Risk card
                Row(children: [
                  Expanded(child: _infoCard('Fenèt fètil', cycle.isInFertileWindow ? '🥚 Wi' : '🌱 Non', cycle.isInFertileWindow ? Colors.orange : Colors.green)),
                  const SizedBox(width: 8),
                  Expanded(child: _infoCard('Risks gwosès', cycle.riskLabel, cycle.pregnancyRisk >= 10 ? Colors.red : Colors.green)),
                  const SizedBox(width: 8),
                  Expanded(child: _infoCard('Pwochen règ', '${cycle.daysUntilNextPeriod} jou', AppTheme.rose)),
                ]),
                const SizedBox(height: 16),

                // Calendar
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10)],
                  ),
                  padding: const EdgeInsets.all(16),
                  child: Column(children: [
                    Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                      IconButton(icon: const Icon(Icons.chevron_left), onPressed: _prevMonth),
                      Text(_monthLabelCreole, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppTheme.lavender)),
                      IconButton(icon: const Icon(Icons.chevron_right), onPressed: _nextMonth),
                    ]),
                    const SizedBox(height: 8),
                    Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children:
                      ['Di', 'Le', 'Ma', 'Me', 'Je', 'Va', 'Sa'].map((d) =>
                        SizedBox(width: 36, child: Text(d, textAlign: TextAlign.center, style: TextStyle(fontSize: 12, color: Colors.grey[500], fontWeight: FontWeight.w600)))
                      ).toList(),
                    ),
                    const SizedBox(height: 8),
                    GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 7, mainAxisSpacing: 4, crossAxisSpacing: 4, childAspectRatio: 1,
                      ),
                      itemCount: startWeekday + daysInMonth,
                      itemBuilder: (_, i) {
                        if (i < startWeekday) return const SizedBox();
                        final dayNum = i - startWeekday + 1;
                        final date = DateTime(_viewMonth.year, _viewMonth.month, dayNum);
                        final isToday = date.day == _today.day && date.month == _today.month && date.year == _today.year;
                        final isPeriod = date.isAfter(cycle.startDate.subtract(const Duration(days: 1))) && date.isBefore(cycle.startDate.add(Duration(days: cycle.periodLength)));
                        final cycleDay = date.difference(cycle.startDate).inDays + 1;
                        final isFertile = cycleDay >= cycle.fertileStart && cycleDay <= cycle.fertileEnd && cycleDay > 0 && cycleDay <= cycle.cycleLength;
                        final isOvulation = cycleDay == cycle.ovulationDay;

                        return AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          decoration: BoxDecoration(
                            color: isToday ? AppTheme.rose : (isOvulation ? Colors.orange.withOpacity(0.3) : (isFertile ? AppTheme.lavenderPale : (isPeriod ? AppTheme.roseLight : Colors.transparent))),
                            shape: BoxShape.circle,
                            border: isToday ? Border.all(color: AppTheme.rose, width: 2) : null,
                          ),
                          child: Center(
                            child: Text(
                              '$dayNum',
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: isToday ? FontWeight.bold : FontWeight.normal,
                                color: isPeriod ? AppTheme.rose : (isOvulation ? Colors.orange.shade800 : (isFertile ? AppTheme.lavender : Colors.black87)),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 8),
                    Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                      _legend(AppTheme.roseLight, 'Règ'),
                      const SizedBox(width: 12),
                      _legend(AppTheme.lavenderPale, 'Fètil'),
                      const SizedBox(width: 12),
                      _legend(Colors.orange.withOpacity(0.3), 'Ovilasyon'),
                    ]),
                  ]),
                ),
                const SizedBox(height: 16),

                // Phase details
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10)],
                  ),
                  child: Column(children: [
                    Row(children: [
                      Text(cycle.phaseEmoji, style: const TextStyle(fontSize: 28)),
                      const SizedBox(width: 12),
                      Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                        Text(cycle.phaseName, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppTheme.lavender)),
                        Text(_phaseDescription(cycle.phase), style: TextStyle(fontSize: 12, color: Colors.grey[600])),
                      ]),
                    ]),
                    const SizedBox(height: 12),
                    _phaseTip(cycle.phase),
                  ]),
                ),
                const SizedBox(height: 16),

                // Day controls
                Row(children: [
                  Expanded(
                    child: SizedBox(
                      height: 48,
                      child: ElevatedButton.icon(
                        onPressed: () => _nextDay(cycle, storage),
                        icon: const Icon(Icons.add),
                        label: const Text('Jou +'),
                        style: ElevatedButton.styleFrom(backgroundColor: AppTheme.rose, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14))),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: SizedBox(
                      height: 48,
                      child: OutlinedButton.icon(
                        onPressed: cycle.day > 1 ? () => _prevDay(cycle, storage) : null,
                        icon: const Icon(Icons.remove),
                        label: const Text('Jou -'),
                        style: OutlinedButton.styleFrom(shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14))),
                      ),
                    ),
                  ),
                ]),
                const SizedBox(height: 16),

                // Symptoms
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10)],
                  ),
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    const Row(children: [Icon(Icons.healing, color: AppTheme.rose), SizedBox(width: 8), Text('Sentòm', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold))]),
                    const SizedBox(height: 12),
                    Wrap(spacing: 8, runSpacing: 8, children: _symptoms.map((s) {
                      final sel = cycle.symptoms.contains(s);
                      return FilterChip(
                        label: Text(s, style: TextStyle(fontSize: 13, color: sel ? AppTheme.rose : Colors.grey[700])),
                        selected: sel,
                        onSelected: (v) {
                          final ns = List<String>.from(cycle.symptoms);
                          v ? ns.add(s) : ns.remove(s);
                          storage.updateCycle(cycle.copyWith(symptoms: ns));
                        },
                        selectedColor: AppTheme.roseLight,
                        checkmarkColor: AppTheme.rose,
                        backgroundColor: Colors.grey[100],
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                      );
                    }).toList()),
                  ]),
                ),
                const SizedBox(height: 16),

                // Notes
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10)],
                  ),
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    const Row(children: [Icon(Icons.note, color: AppTheme.lavender), SizedBox(width: 8), Text('Nòt', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold))]),
                    const SizedBox(height: 12),
                    TextField(
                      controller: _notesController,
                      maxLines: 3,
                      decoration: InputDecoration(hintText: 'Kòman w santi w jodi a?', hintStyle: TextStyle(color: Colors.grey[400]), border: OutlineInputBorder(borderRadius: BorderRadius.circular(12))),
                      onChanged: (v) => storage.updateCycle(cycle.copyWith(notes: v)),
                    ),
                  ]),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _nextDay(CycleModel cycle, StorageService storage) {
    if (cycle.day >= cycle.cycleLength) {
      final newStart = cycle.startDate.add(Duration(days: cycle.cycleLength));
      storage.updateCycle(CycleModel(
        day: 1, startDate: newStart,
        cycleLength: cycle.averageCycleLength,
        periodLength: cycle.periodLength,
        pastCycleLengths: [...cycle.pastCycleLengths, cycle.cycleLength],
      ));
    } else {
      storage.updateCycle(cycle.copyWith(day: cycle.day + 1));
    }
  }

  void _prevDay(CycleModel cycle, StorageService storage) {
    if (cycle.day > 1) storage.updateCycle(cycle.copyWith(day: cycle.day - 1));
  }

  Widget _miniStat(String value, String label, IconData icon) {
    return Column(children: [
      Icon(icon, color: Colors.white, size: 20),
      const SizedBox(height: 4),
      Text(value, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
      Text(label, style: const TextStyle(fontSize: 10, color: Colors.white70)),
    ]);
  }

  Widget _infoCard(String title, String value, Color color) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 8)]),
      child: Column(children: [
        Text(value, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: color)),
        Text(title, style: TextStyle(fontSize: 11, color: Colors.grey[600])),
      ]),
    );
  }

  Widget _legend(Color color, String label) {
    return Row(mainAxisSize: MainAxisSize.min, children: [
      Container(width: 12, height: 12, decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
      const SizedBox(width: 4),
      Text(label, style: TextStyle(fontSize: 11, color: Colors.grey[600])),
    ]);
  }

  String _phaseDescription(int phase) {
    const desc = {
      0: 'Premye jou règ ou. Kò w ap renouvle tèt li.',
      1: 'Aprè règ, kò w prepare pou yon nouvo sik.',
      2: 'Peryòd fètilite maksimòm. Si w pa vle gwosès, pwoteje w.',
      3: 'Kò w ap prepare pou yon lòt sik. Sentòm PMS ka parèt.',
    };
    return desc[phase] ?? '';
  }

  Widget _phaseTip(int phase) {
    final tips = {
      0: '💧 Pran repos, bwar dlo cho, sèvi kousen chofe pou doulè.',
      1: '🌱 Bon moman pou fè egzèsis, li, planifye.',
      2: '🥚 Si w vle gwosès, se kounye a! Sinon, sèvi kapòt.',
      3: '🌙 Sèvi tekhnik detant, meditasyon, dòmi bonè.',
    };
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(color: AppTheme.lavenderPale.withOpacity(0.3), borderRadius: BorderRadius.circular(12)),
      child: Row(children: [
        Expanded(child: Text(tips[phase] ?? '', style: const TextStyle(fontSize: 13, color: AppTheme.lavender))),
      ]),
    );
  }
}
