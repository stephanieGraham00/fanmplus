import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart';
import 'package:go_router/go_router.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';
import '../../providers/cycle_provider.dart';
import '../../providers/body_metrics_provider.dart';
import '../../providers/language_provider.dart';
import '../../widgets/glass_card.dart';
import '../../widgets/pam_icon.dart';
import '../../utils/helpers.dart';
import '../../models/tracker_model.dart';

class CalendarScreen extends ConsumerStatefulWidget {
  const CalendarScreen({super.key});

  @override
  ConsumerState<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends ConsumerState<CalendarScreen> {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  CalendarFormat _calendarFormat = CalendarFormat.month;

  @override
  void initState() {
    super.initState();
    // Today is selected by default
    _selectedDay = DateTime.now();
  }

  String _flowIntensityForDay(DateTime day, List<FlowLog> flowLogs) {
    final key = DateTime(day.year, day.month, day.day);
    for (final f in flowLogs) {
      final fKey = DateTime(f.date.year, f.date.month, f.date.day);
      if (fKey == key) return f.intensity;
    }
    return '';
  }

  Color? _flowColor(String intensity) {
    switch (intensity) {
      case 'spotting': return AppColors.period.withOpacity(0.25);
      case 'light': return AppColors.period.withOpacity(0.45);
      case 'medium': return AppColors.period.withOpacity(0.65);
      case 'heavy': return AppColors.period.withOpacity(0.85);
      default: return null;
    }
  }

  String _flowLabel(String intensity, AppTranslations tr) {
    switch (intensity) {
      case 'spotting': return tr.spotting;
      case 'light': return tr.lightFlow;
      case 'medium': return tr.mediumFlow;
      case 'heavy': return tr.heavyFlow;
      default: return '';
    }
  }

  Future<void> _logFlowForDay(DateTime day, String intensity) async {
    final userId = FirebaseAuth.instance.currentUser?.uid ?? '';
    if (userId.isEmpty) return;
    final flowLog = FlowLog(
      userId: userId,
      date: day,
      intensity: intensity,
    );
    ref.read(bodyMetricsProvider.notifier).addFlow(flowLog);
    ref.read(cycleProvider.notifier).onFlowLogged(flowLog);
    setState(() {});
  }

  Future<void> _removeFlowForDay(DateTime day) async {
    // For simplicity, we just log a "none" flow (not persisted)
    // In production, we'd delete the doc
  }

  void _showFlowSelector(AppTranslations tr, DateTime day, String currentIntensity) {
    final bodyMetrics = ref.read(bodyMetricsProvider);
    final existingDischarge = bodyMetrics.dischargeLogs.where((d) =>
      DateTime(d.date.year, d.date.month, d.date.day) == DateTime(day.year, day.month, day.day)
    ).toList();
    final existingMycosis = bodyMetrics.mycosisLogs.where((m) =>
      DateTime(m.date.year, m.date.month, m.date.day) == DateTime(day.year, day.month, day.day)
    ).toList();
    final currentDischargeType = existingDischarge.isNotEmpty ? existingDischarge.first.type : '';
    final currentMycosis = existingMycosis.isNotEmpty ? existingMycosis.first : null;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
      ),
      builder: (ctx) {
        return StatefulBuilder(
          builder: (ctx, setSheetState) {
            return Padding(
              padding: const EdgeInsets.all(24),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Container(
                        width: 40, height: 4,
                        decoration: BoxDecoration(
                          color: AppColors.secondaryLight,
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Text('${DateFormat('dd MMMM yyyy').format(day)}', style: AppTextStyles.headlineMedium),
                    const SizedBox(height: 16),

                    // === FLOW SECTION ===
                    Text(tr.flowIntensityLabel, style: AppTextStyles.titleMedium),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _FlowOption(
                          emoji: '💧', label: tr.spotting,
                          color: AppColors.period.withOpacity(0.3),
                          isSelected: currentIntensity == 'spotting',
                          onTap: () { Navigator.pop(ctx); _logFlowForDay(day, 'spotting'); },
                        ),
                        _FlowOption(
                          emoji: '💦', label: tr.lightFlow,
                          color: AppColors.period.withOpacity(0.5),
                          isSelected: currentIntensity == 'light',
                          onTap: () { Navigator.pop(ctx); _logFlowForDay(day, 'light'); },
                        ),
                        _FlowOption(
                          emoji: '🔴', label: tr.mediumFlow,
                          color: AppColors.period.withOpacity(0.7),
                          isSelected: currentIntensity == 'medium',
                          onTap: () { Navigator.pop(ctx); _logFlowForDay(day, 'medium'); },
                        ),
                        _FlowOption(
                          emoji: '❤️', label: tr.heavyFlow,
                          color: AppColors.period.withOpacity(0.9),
                          isSelected: currentIntensity == 'heavy',
                          onTap: () { Navigator.pop(ctx); _logFlowForDay(day, 'heavy'); },
                        ),
                      ],
                    ),
                    if (currentIntensity.isNotEmpty) ...[
                      const SizedBox(height: 8),
                      SizedBox(
                        width: double.infinity, height: 36,
                        child: TextButton(
                          onPressed: () { Navigator.pop(ctx); _removeFlowForDay(day); },
                          child: Text(tr.remove, style: TextStyle(color: AppColors.error, fontSize: 13)),
                        ),
                      ),
                    ],

                    const Divider(height: 32),

                    // === DISCHARGE SECTION ===
                    Text(tr.discharge, style: AppTextStyles.titleMedium),
                    const SizedBox(height: 4),
                    Text(tr.dischargeType, style: AppTextStyles.bodySmall.copyWith(color: AppColors.textSecondary)),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _FlowOption(
                          emoji: '⚪', label: tr.dischargeNormal,
                          color: AppColors.safe.withOpacity(0.3),
                          isSelected: currentDischargeType == 'normal',
                          onTap: () {
                            _logDischargeForDay(day, 'normal', null);
                            Navigator.pop(ctx);
                          },
                        ),
                        _FlowOption(
                          emoji: '🥛', label: tr.dischargeCreamy,
                          color: AppColors.fertile.withOpacity(0.4),
                          isSelected: currentDischargeType == 'creamy',
                          onTap: () {
                            _logDischargeForDay(day, 'creamy', null);
                            Navigator.pop(ctx);
                          },
                        ),
                        _FlowOption(
                          emoji: '🥚', label: tr.dischargeEggWhite,
                          color: AppColors.ovulation.withOpacity(0.3),
                          isSelected: currentDischargeType == 'eggWhite',
                          onTap: () {
                            _logDischargeForDay(day, 'eggWhite', null);
                            Navigator.pop(ctx);
                          },
                        ),
                        _FlowOption(
                          emoji: '💧', label: tr.dischargeWatery,
                          color: AppColors.info.withOpacity(0.3),
                          isSelected: currentDischargeType == 'watery',
                          onTap: () {
                            _logDischargeForDay(day, 'watery', null);
                            Navigator.pop(ctx);
                          },
                        ),
                        _FlowOption(
                          emoji: '🧴', label: tr.dischargeSticky,
                          color: AppColors.luteal.withOpacity(0.3),
                          isSelected: currentDischargeType == 'sticky',
                          onTap: () {
                            _logDischargeForDay(day, 'sticky', null);
                            Navigator.pop(ctx);
                          },
                        ),
                      ],
                    ),

                    const Divider(height: 32),

                    // === MYCOSIS SECTION ===
                    Text(tr.mycosisLogLabel, style: AppTextStyles.titleMedium),
                    const SizedBox(height: 4),
                    Text(tr.hasMycosis, style: AppTextStyles.bodySmall.copyWith(color: AppColors.textSecondary)),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _FlowOption(
                          emoji: '✅', label: tr.yesLabel,
                          color: AppColors.error.withOpacity(0.2),
                          isSelected: currentMycosis?.hasMycosis == true,
                          onTap: () {
                            _logMycosisForDay(day, true, []);
                            Navigator.pop(ctx);
                          },
                        ),
                        const SizedBox(width: 24),
                        _FlowOption(
                          emoji: '❌', label: tr.noLabel,
                          color: AppColors.safe.withOpacity(0.2),
                          isSelected: currentMycosis?.hasMycosis == false,
                          onTap: () {
                            _logMycosisForDay(day, false, []);
                            Navigator.pop(ctx);
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    if (currentMycosis?.hasMycosis == true && currentMycosis!.symptoms.isNotEmpty) ...[
                      const SizedBox(height: 4),
                      Text('${tr.mycosisSymptoms}: ${currentMycosis.symptoms.join(', ')}',
                        style: AppTextStyles.bodySmall.copyWith(color: AppColors.textSecondary)),
                    ],

                    const SizedBox(height: 20),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  Future<void> _logDischargeForDay(DateTime day, String type, String? color) async {
    final userId = FirebaseAuth.instance.currentUser?.uid ?? '';
    if (userId.isEmpty) return;
    final log = DischargeLog(userId: userId, date: day, type: type, color: color);
    ref.read(bodyMetricsProvider.notifier).addDischarge(log);
    setState(() {});
  }

  Future<void> _logMycosisForDay(DateTime day, bool hasMycosis, List<String> symptoms) async {
    final userId = FirebaseAuth.instance.currentUser?.uid ?? '';
    if (userId.isEmpty) return;
    final log = MycosisLog(userId: userId, date: day, hasMycosis: hasMycosis, symptoms: symptoms);
    ref.read(bodyMetricsProvider.notifier).addMycosis(log);
    setState(() {});
  }

  void _showQuickLogToday(AppTranslations tr) {
    final today = DateTime.now();
    _showFlowSelector(tr, today, _flowIntensityForDay(today, ref.read(bodyMetricsProvider).flowLogs));
  }

  @override
  Widget build(BuildContext context) {
    final tr = ref.watch(translationsProvider);
    final cycle = ref.watch(cycleProvider);
    final bodyMetrics = ref.watch(bodyMetricsProvider);

    final lastPeriod = cycle.lastPeriodDate ?? DateTime.now().subtract(const Duration(days: 14));
    final cycleLength = cycle.adaptiveCycleLength;
    final monthData = CycleCalculator.getMonthData(_focusedDay, lastPeriod, cycleLength);
    final delayInfo = CycleCalculator.getPeriodDelayInfo(lastPeriod, cycleLength);
    final periodStarts = cycle.periodStarts;
    final flowLogs = bodyMetrics.flowLogs;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(child: Text(tr.calendar, style: AppTextStyles.headlineLarge)),
                  Container(
                    decoration: BoxDecoration(
                      color: AppColors.primary.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: IconButton(
                      icon: const PamIcon(name: 'heart', size: 22, color: AppColors.primary),
                      onPressed: () => context.push('/cycle-history'),
                      tooltip: tr.viewHistoryFull,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Quick log today button
              GlassCard(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                gradient: LinearGradient(
                  colors: [AppColors.period.withOpacity(0.08), AppColors.primary.withOpacity(0.05)],
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: AppColors.period.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: const Text('🌸', style: TextStyle(fontSize: 22)),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(tr.logPeriod, style: AppTextStyles.titleMedium),
                          Text(
                            DateFormat('dd MMMM yyyy').format(DateTime.now()),
                            style: AppTextStyles.bodySmall.copyWith(color: AppColors.textSecondary),
                          ),
                        ],
                      ),
                    ),
                    TextButton.icon(
                      onPressed: () => _showQuickLogToday(tr),
                      icon: const Icon(Icons.add_circle, color: AppColors.period, size: 20),
                      label: Text(tr.todayLabel, style: TextStyle(color: AppColors.period)),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // Cycle info bar
              if (cycle.prediction != null)
                GlassCard(
                  padding: const EdgeInsets.all(16),
                  gradient: LinearGradient(
                    colors: [AppColors.primary.withOpacity(0.08), AppColors.secondary.withOpacity(0.08)],
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          _CycleInfoItem(
                            iconName: 'period',
                            label: tr.nextPeriod,
                            value: DateFormat('dd MMM').format(CycleCalculator.predictNextPeriod(lastPeriod, cycleLength)),
                            sublabel: '${CycleCalculator.daysUntilNextPeriod(lastPeriod, cycleLength)} ${tr.days}',
                            color: AppColors.period,
                          ),
                          Container(width: 1, height: 40, color: AppColors.secondaryLight),
                          _CycleInfoItem(
                            iconName: 'ovulation',
                            label: tr.ovulation,
                            value: DateFormat('dd MMM').format(CycleCalculator.predictOvulation(lastPeriod, cycleLength)),
                            sublabel: 'Day ${cycleLength - 14}',
                            color: AppColors.ovulation,
                          ),
                          Container(width: 1, height: 40, color: AppColors.secondaryLight),
                          _CycleInfoItem(
                            iconName: 'heart',
                            label: tr.fertileWindow,
                            value: CycleCalculator.getFertileWindow(lastPeriod, cycleLength),
                            sublabel: '',
                            color: AppColors.fertile,
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      if (periodStarts.length >= 2)
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                          decoration: BoxDecoration(
                            color: AppColors.success.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            '${tr.adaptivePrediction}: ${CycleCalculator.getAdaptiveCycleInfo(periodStarts)}',
                            style: AppTextStyles.labelSmall.copyWith(color: AppColors.success),
                          ),
                        ),
                    ],
                  ),
                ),
              const SizedBox(height: 16),

              // Delay warning
              if (delayInfo.isLate)
                Container(
                  margin: const EdgeInsets.only(bottom: 16),
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: delayInfo.severity == DelaySeverity.critical
                        ? AppColors.error.withOpacity(0.1)
                        : AppColors.warning.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: delayInfo.severity == DelaySeverity.critical ? AppColors.error : AppColors.warning,
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        delayInfo.severity == DelaySeverity.critical ? Icons.error_outline : Icons.warning_amber,
                        color: delayInfo.severity == DelaySeverity.critical ? AppColors.error : AppColors.warning,
                        size: 24,
                      ),
                      const SizedBox(width: 12),
                      Expanded(child: Text(delayInfo.message, style: AppTextStyles.bodySmall)),
                    ],
                  ),
                ),

              // Calendar with flow heat map
              GlassCard(
                padding: const EdgeInsets.all(12),
                borderRadius: 20,
                child: TableCalendar(
                  firstDay: DateTime.utc(2024, 1, 1),
                  lastDay: DateTime.utc(2027, 12, 31),
                  focusedDay: _focusedDay,
                  selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
                  calendarFormat: _calendarFormat,
                  onDaySelected: (selectedDay, focusedDay) {
                    setState(() { _selectedDay = selectedDay; _focusedDay = focusedDay; });
                    final intensity = _flowIntensityForDay(selectedDay, flowLogs);
                    _showFlowSelector(tr, selectedDay, intensity);
                  },
                  onFormatChanged: (format) => setState(() => _calendarFormat = format),
                  onPageChanged: (focusedDay) => _focusedDay = focusedDay,
                  calendarStyle: CalendarStyle(
                    outsideDecoration: const BoxDecoration(shape: BoxShape.circle, color: Colors.transparent),
                    selectedDecoration: const BoxDecoration(shape: BoxShape.circle, gradient: AppColors.primaryGradient),
                    todayDecoration: BoxDecoration(shape: BoxShape.circle, color: AppColors.secondaryLight),
                    weekendTextStyle: AppTextStyles.bodyMedium.copyWith(color: AppColors.primary),
                    defaultTextStyle: AppTextStyles.bodyMedium,
                  ),
                  headerStyle: HeaderStyle(
                    formatButtonVisible: true,
                    titleCentered: true,
                    titleTextStyle: AppTextStyles.titleLarge,
                    formatButtonTextStyle: AppTextStyles.titleSmall,
                    leftChevronIcon: const Icon(Icons.chevron_left, color: AppColors.primary),
                    rightChevronIcon: const Icon(Icons.chevron_right, color: AppColors.primary),
                  ),
                  calendarBuilders: CalendarBuilders(
                    defaultBuilder: (context, date, _) {
                      return _buildDayCell(date, flowLogs, monthData, tr);
                    },
                    todayBuilder: (context, date, _) {
                      return _buildDayCell(date, flowLogs, monthData, tr, isToday: true);
                    },
                    selectedBuilder: (context, date, _) {
                      return _buildDayCell(date, flowLogs, monthData, tr, isSelected: true);
                    },
                    outsideBuilder: (context, date, _) {
                      return _buildDayCell(date, flowLogs, monthData, tr, isOutside: true);
                    },
                    markerBuilder: (context, date, events) {
                      final key = DateTime(date.year, date.month, date.day);
                      final phase = monthData[key];
                      if (phase == null || phase == 'period') return null;
                      Color markerColor;
                      switch (phase) {
                        case 'fertile': markerColor = AppColors.fertile; break;
                        case 'ovulation': markerColor = AppColors.ovulation; break;
                        default: return null;
                      }
                      return Positioned(
                        bottom: 2,
                        child: Container(
                          width: 6, height: 6,
                          decoration: BoxDecoration(shape: BoxShape.circle, color: markerColor),
                        ),
                      );
                    },
                  ),
                ),
              ),
              const SizedBox(height: 12),

              // Legend
              GlassCard(
                padding: const EdgeInsets.all(12),
                borderRadius: 16,
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _LegendDot(AppColors.period, tr.period),
                        _LegendDot(AppColors.fertile, tr.fertile),
                        _LegendDot(AppColors.ovulation, tr.ovulation),
                        _LegendDot(AppColors.safe, tr.safe),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _LegendDot(AppColors.info.withOpacity(0.5), '${tr.discharge} 💧'),
                        _LegendDot(AppColors.warning.withOpacity(0.5), '${tr.mycosis} ⚠️'),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // Cycle phase + adaptive info
              if (cycle.prediction != null)
                GlassCard(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const PamIcon(name: 'heart', size: 22, color: AppColors.primary),
                          const SizedBox(width: 8),
                          Text(tr.currentPhase, style: AppTextStyles.titleMedium),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(cycle.prediction!.cyclePhase, style: AppTextStyles.headlineMedium.copyWith(color: AppColors.primary)),
                      const SizedBox(height: 4),
                      Text(tr.dayOfCycle(cycle.prediction!.cycleDay), style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSecondary)),
                    ],
                  ),
                ),
              const SizedBox(height: 16),

              // Logged items for selected month
              final monthFlows = flowLogs.where((f) => f.date.month == _focusedDay.month && f.date.year == _focusedDay.year);
              final monthDischarges = bodyMetrics.dischargeLogs.where((d) => d.date.month == _focusedDay.month && d.date.year == _focusedDay.year);
              final monthMycoses = bodyMetrics.mycosisLogs.where((m) => m.date.month == _focusedDay.month && m.date.year == _focusedDay.year);

              if (monthFlows.isNotEmpty || monthDischarges.isNotEmpty || monthMycoses.isNotEmpty)
                GlassCard(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Text('📅', style: TextStyle(fontSize: 18)),
                          const SizedBox(width: 8),
                          Text(tr.loggedPeriods, style: AppTextStyles.titleMedium),
                        ],
                      ),
                      const SizedBox(height: 12),
                      ...monthFlows.take(8).map((f) => Padding(
                        padding: const EdgeInsets.symmetric(vertical: 3),
                        child: Row(
                          children: [
                            Container(width: 12, height: 12,
                              decoration: BoxDecoration(shape: BoxShape.circle, color: _flowColor(f.intensity) ?? AppColors.period)),
                            const SizedBox(width: 10),
                            Text(DateFormat('dd MMM').format(f.date), style: AppTextStyles.bodySmall),
                            const SizedBox(width: 8),
                            Text(_flowLabel(f.intensity, tr), style: AppTextStyles.labelSmall.copyWith(color: AppColors.textSecondary)),
                          ],
                        ),
                      )),
                      if (monthDischarges.isNotEmpty) ...[
                        const SizedBox(height: 6),
                        Text(tr.discharge, style: AppTextStyles.titleSmall.copyWith(color: AppColors.info)),
                        ...monthDischarges.take(5).map((d) => Padding(
                          padding: const EdgeInsets.symmetric(vertical: 3),
                          child: Row(
                            children: [
                              Container(width: 12, height: 12,
                                decoration: BoxDecoration(shape: BoxShape.circle, color: AppColors.info)),
                              const SizedBox(width: 10),
                              Text(DateFormat('dd MMM').format(d.date), style: AppTextStyles.bodySmall),
                              const SizedBox(width: 8),
                              Text(_dischargeLabel(d.type, tr), style: AppTextStyles.labelSmall.copyWith(color: AppColors.textSecondary)),
                            ],
                          ),
                        )),
                      ],
                      if (monthMycoses.isNotEmpty) ...[
                        const SizedBox(height: 6),
                        Text(tr.mycosis, style: AppTextStyles.titleSmall.copyWith(color: AppColors.warning)),
                        ...monthMycoses.take(5).map((m) => Padding(
                          padding: const EdgeInsets.symmetric(vertical: 3),
                          child: Row(
                            children: [
                              Container(width: 12, height: 12,
                                decoration: BoxDecoration(shape: BoxShape.circle, color: m.hasMycosis ? AppColors.warning : AppColors.safe)),
                              const SizedBox(width: 10),
                              Text(DateFormat('dd MMM').format(m.date), style: AppTextStyles.bodySmall),
                              const SizedBox(width: 8),
                              Text(m.hasMycosis ? tr.yesLabel : tr.noLabel, style: AppTextStyles.labelSmall.copyWith(color: AppColors.textSecondary)),
                            ],
                          ),
                        )),
                      ],
                    ],
                  ),
                ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDayCell(DateTime date, List<FlowLog> flowLogs, Map<DateTime, String> monthData, AppTranslations tr, {bool isToday = false, bool isSelected = false, bool isOutside = false}) {
    final key = DateTime(date.year, date.month, date.day);
    final intensity = _flowIntensityForDay(date, flowLogs);
    final phase = monthData[key];
    final bgColor = _flowColor(intensity);
    final dayNum = date.day.toString();

    // Check if this day has discharge or mycosis logged
    final hasDischarge = _dischargeForDay(date) != null;
    final hasMycosis = _mycosisForDay(date) != null;

    return Container(
      margin: const EdgeInsets.all(2),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: bgColor,
        border: isToday ? Border.all(color: AppColors.primary, width: 2) : null,
      ),
      alignment: Alignment.center,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            dayNum,
            style: TextStyle(
              fontSize: 13,
              fontWeight: isToday ? FontWeight.bold : FontWeight.normal,
              color: isOutside ? AppColors.textHint : (isSelected ? Colors.white : AppColors.textPrimary),
            ),
          ),
          if (hasDischarge || hasMycosis)
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (hasDischarge)
                  Container(
                    width: 4, height: 4,
                    margin: const EdgeInsets.symmetric(horizontal: 1),
                    decoration: const BoxDecoration(shape: BoxShape.circle, color: AppColors.info),
                  ),
                if (hasMycosis)
                  Container(
                    width: 4, height: 4,
                    margin: const EdgeInsets.symmetric(horizontal: 1),
                    decoration: const BoxDecoration(shape: BoxShape.circle, color: AppColors.warning),
                  ),
              ],
            ),
        ],
      ),
    );
  }

  DischargeLog? _dischargeForDay(DateTime day) {
    final bodyMetrics = ref.read(bodyMetricsProvider);
    final matches = bodyMetrics.dischargeLogs.where((d) =>
      DateTime(d.date.year, d.date.month, d.date.day) == DateTime(day.year, day.month, day.day)
    );
    return matches.isNotEmpty ? matches.first : null;
  }

  MycosisLog? _mycosisForDay(DateTime day) {
    final bodyMetrics = ref.read(bodyMetricsProvider);
    final matches = bodyMetrics.mycosisLogs.where((m) =>
      DateTime(m.date.year, m.date.month, m.date.day) == DateTime(day.year, day.month, day.day)
    );
    return matches.isNotEmpty ? matches.first : null;
  }

  String _dischargeLabel(String type, AppTranslations tr) {
    switch (type) {
      case 'normal': return tr.dischargeNormal;
      case 'creamy': return tr.dischargeCreamy;
      case 'eggWhite': return tr.dischargeEggWhite;
      case 'watery': return tr.dischargeWatery;
      case 'sticky': return tr.dischargeSticky;
      default: return type;
    }
  }
}

class _LegendDot extends StatelessWidget {
  final Color color;
  final String label;
  const _LegendDot(this.color, this.label);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(width: 12, height: 12, decoration: BoxDecoration(shape: BoxShape.circle, color: color)),
        const SizedBox(width: 4),
        Text(label, style: AppTextStyles.bodySmall),
      ],
    );
  }
}

class _CycleInfoItem extends StatelessWidget {
  final String iconName, label, value, sublabel;
  final Color color;

  const _CycleInfoItem({required this.iconName, required this.label, required this.value, required this.sublabel, required this.color});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        PamIcon(name: iconName, size: 24, color: color),
        const SizedBox(height: 4),
        Text(label, style: AppTextStyles.labelSmall),
        const SizedBox(height: 2),
        Text(value, style: AppTextStyles.titleMedium.copyWith(color: color, fontWeight: FontWeight.bold)),
        if (sublabel.isNotEmpty)
          Text(sublabel, style: AppTextStyles.labelSmall.copyWith(color: AppColors.textSecondary)),
      ],
    );
  }
}

class _FlowOption extends StatelessWidget {
  final String emoji, label;
  final Color color;
  final bool isSelected;
  final VoidCallback onTap;

  const _FlowOption({required this.emoji, required this.label, required this.color, required this.isSelected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            width: 56, height: 56,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: color,
              border: isSelected ? Border.all(color: AppColors.primary, width: 2) : null,
            ),
            child: Center(child: Text(emoji, style: const TextStyle(fontSize: 24))),
          ),
          const SizedBox(height: 4),
          Text(label, style: AppTextStyles.labelSmall),
        ],
      ),
    );
  }
}
