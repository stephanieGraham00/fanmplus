import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';
import '../../providers/language_provider.dart';
import '../../widgets/glass_card.dart';
import '../../data/hiv_data.dart';
import '../../providers/user_data_provider.dart';

class HivScreen extends ConsumerStatefulWidget {
  const HivScreen({super.key});

  @override
  ConsumerState<HivScreen> createState() => _HivScreenState();
}

class _HivScreenState extends ConsumerState<HivScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final _medicationTimeController = TextEditingController();
  final _medicationNoteController = TextEditingController();
  List<bool> _medicationTaken = [];
  List<TimeOfDay> _medicationTimes = [];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 7, vsync: this);
    _medicationTaken = List.filled(HivData.medications.length, false);
    _medicationTimes = List.filled(HivData.medications.length, const TimeOfDay(hour: 8, minute: 0));
  }

  @override
  void dispose() {
    _tabController.dispose();
    _medicationTimeController.dispose();
    _medicationNoteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final tr = ref.watch(translationsProvider);
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.textPrimary),
          onPressed: () => context.pop(),
        ),
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('🎗️', style: AppTextStyles.titleLarge),
            const SizedBox(width: 4),
            Text(tr.hivTitle, style: AppTextStyles.titleLarge),
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: AppColors.info.withOpacity(0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text('${HivData.generalInfo.length + HivData.medications.length + HivData.foodTips.length + HivData.adherenceTips.length + HivData.motivationQuotes.length + HivData.medicalAdvice.length + HivData.supportGroups.length}+', style: AppTextStyles.labelSmall.copyWith(color: AppColors.info)),
            ),
          ],
        ),
        centerTitle: true,
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          indicatorColor: AppColors.primary,
          labelColor: AppColors.primary,
          unselectedLabelColor: AppColors.textHint,
          tabs: [
            Tab(text: tr.info),
            Tab(text: tr.medicationsWord),
            Tab(text: tr.foodTips),
            Tab(text: tr.adherence),
            Tab(text: tr.motivation),
            Tab(text: tr.medicalAdvice),
            Tab(text: tr.support),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildInfoTab(tr),
          _buildMedicationTab(tr),
          _buildFoodTab(tr),
          _buildAdherenceTab(tr),
          _buildMotivationTab(tr),
          _buildAdviceTab(tr),
          _buildSupportTab(tr),
        ],
      ),
    );
  }

  Widget _buildInfoTab(AppTranslations tr) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(tr.generalInfo(HivData.generalInfo.length), style: AppTextStyles.headlineMedium),
          const SizedBox(height: 16),
          ...HivData.generalInfo.map((item) => Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: GlassCard(
              padding: const EdgeInsets.all(14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(item['title'] as String, style: AppTextStyles.titleMedium.copyWith(color: AppColors.primary)),
                  const SizedBox(height: 4),
                  Text(item['content'] as String, style: AppTextStyles.bodyMedium),
                ],
              ),
            ),
          )),
        ],
      ),
    );
  }

  Widget _buildMedicationTab(AppTranslations tr) {
    final userData = ref.watch(currentUserDataProvider).valueOrNull;
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(tr.hivMedications(HivData.medications.length), style: AppTextStyles.headlineMedium),
          const SizedBox(height: 8),
          Text(
            userData?.hasHiv == true ? tr.youDeclaredHiv : tr.generalHivInfo,
            style: AppTextStyles.bodySmall,
          ),
          const SizedBox(height: 16),
          ...HivData.medications.asMap().entries.map((entry) {
            final i = entry.key;
            final med = entry.value;
            return Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: GlassCard(
                padding: const EdgeInsets.all(14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(med['name'] as String, style: AppTextStyles.titleLarge.copyWith(color: AppColors.primary)),
                        ),
                        GestureDetector(
                          onTap: () async {
                            final time = await showTimePicker(
                              context: context,
                              initialTime: _medicationTimes[i],
                            );
                            if (time != null) {
                              setState(() => _medicationTimes[i] = time);
                            }
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: _medicationTaken[i] ? AppColors.success.withOpacity(0.1) : AppColors.secondaryLight,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  _medicationTaken[i] ? Icons.check_circle : Icons.access_time,
                                  size: 16,
                                  color: _medicationTaken[i] ? AppColors.success : AppColors.textPrimary,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  _medicationTaken[i]
                                      ? tr.taken
                                      : _medicationTimes[i].format(context),
                                  style: AppTextStyles.labelSmall.copyWith(
                                    color: _medicationTaken[i] ? AppColors.success : AppColors.textPrimary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Text('${tr.type}: ${med['type']} | ${tr.schedule}: ${med['schedule']}', style: AppTextStyles.bodySmall),
                    const SizedBox(height: 2),
                    Text('${tr.sideEffects}: ${med['sideEffects']}', style: AppTextStyles.bodySmall),
                    Text('💡 ${med['tips']}', style: AppTextStyles.bodySmall.copyWith(color: AppColors.info)),
                    const SizedBox(height: 8),
                    GestureDetector(
                      onTap: () {
                        setState(() => _medicationTaken[i] = !_medicationTaken[i]);
                        if (_medicationTaken[i]) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('✅ ${med['name']} ${tr.markAsTaken}'),
                              behavior: SnackBarBehavior.floating,
                            ),
                          );
                        }
                      },
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        decoration: BoxDecoration(
                          color: _medicationTaken[i] ? AppColors.success.withOpacity(0.1) : AppColors.primary.withOpacity(0.05),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Center(
                          child: Text(
                            _medicationTaken[i] ? '✅ ${tr.taken}' : '👆 ${tr.markAsTaken}',
                            style: AppTextStyles.titleSmall.copyWith(
                              color: _medicationTaken[i] ? AppColors.success : AppColors.primary,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildFoodTab(AppTranslations tr) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(tr.foodTipsTitle(HivData.foodTips.length), style: AppTextStyles.headlineMedium),
          const SizedBox(height: 16),
          ...HivData.foodTips.map((t) => Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: GlassCard(
              padding: const EdgeInsets.all(14),
              child: Row(
                children: [
                  const Text('🥗 ', style: TextStyle(fontSize: 16)),
                  Expanded(child: Text(t, style: AppTextStyles.bodyMedium)),
                ],
              ),
            ),
          )),
        ],
      ),
    );
  }

  Widget _buildAdherenceTab(AppTranslations tr) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(tr.adherenceTitle(HivData.adherenceTips.length), style: AppTextStyles.headlineMedium),
          const SizedBox(height: 16),
          ...HivData.adherenceTips.map((t) => Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: GlassCard(
              padding: const EdgeInsets.all(14),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('⏰ ', style: TextStyle(fontSize: 16)),
                  Expanded(child: Text(t, style: AppTextStyles.bodyMedium)),
                ],
              ),
            ),
          )),
          const SizedBox(height: 24),
          Text(tr.medicationNotes, style: AppTextStyles.titleMedium),
          const SizedBox(height: 12),
          TextFormField(
            controller: _medicationNoteController,
            maxLines: 3,
            decoration: const InputDecoration(
              hintText: 'Notes on medications...',
              filled: true,
              fillColor: AppColors.secondaryLight,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMotivationTab(AppTranslations tr) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(tr.motivationTitle(HivData.motivationQuotes.length), style: AppTextStyles.headlineMedium),
          const SizedBox(height: 16),
          ...HivData.motivationQuotes.map((q) => Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: GlassCard(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  const Text('💪 ', style: TextStyle(fontSize: 20)),
                  Expanded(
                    child: Text(
                      '"$q"',
                      style: AppTextStyles.quoteText.copyWith(fontSize: 14),
                    ),
                  ),
                ],
              ),
            ),
          )),
        ],
      ),
    );
  }

  Widget _buildAdviceTab(AppTranslations tr) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(tr.medicalAdviceTitle(HivData.medicalAdvice.length), style: AppTextStyles.headlineMedium),
          const SizedBox(height: 16),
          ...HivData.medicalAdvice.map((a) => Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: GlassCard(
              padding: const EdgeInsets.all(14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(a['title'] as String, style: AppTextStyles.titleMedium.copyWith(color: AppColors.primary)),
                  const SizedBox(height: 4),
                  Text(a['advice'] as String, style: AppTextStyles.bodyMedium),
                ],
              ),
            ),
          )),
        ],
      ),
    );
  }

  Widget _buildSupportTab(AppTranslations tr) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GlassCard(
            gradient: LinearGradient(
              colors: [AppColors.success.withOpacity(0.05), AppColors.info.withOpacity(0.03)],
            ),
            child: Row(
              children: [
                const Text('🤝', style: TextStyle(fontSize: 32)),
                const SizedBox(width: 16),
                Expanded(
                  child: Text(
                    tr.supportTitle,
                    style: AppTextStyles.headlineMedium.copyWith(color: AppColors.success),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          Text(tr.supportGroups, style: AppTextStyles.headlineMedium),
          const SizedBox(height: 12),
          ...HivData.supportGroups.map((g) => Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: GlassCard(
              padding: const EdgeInsets.all(14),
              onTap: () {},
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(g['name'] as String, style: AppTextStyles.titleMedium),
                        Text(g['description'] as String, style: AppTextStyles.bodySmall),
                        Text('📍 ${g['location']}', style: AppTextStyles.labelSmall),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(g['phone'] as String, style: AppTextStyles.titleSmall.copyWith(color: AppColors.primary)),
                  ),
                ],
              ),
            ),
          )),
        ],
      ),
    );
  }
}
