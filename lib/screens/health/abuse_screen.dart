import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';
import '../../providers/language_provider.dart';
import '../../widgets/glass_card.dart';
import '../../data/abuse_data.dart';

class AbuseScreen extends ConsumerStatefulWidget {
  const AbuseScreen({super.key});

  @override
  ConsumerState<AbuseScreen> createState() => _AbuseScreenState();
}

class _AbuseScreenState extends ConsumerState<AbuseScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 8, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
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
            const Text('🛡️', style: AppTextStyles.titleLarge),
            const SizedBox(width: 4),
            Text(tr.abuseTitle, style: AppTextStyles.titleLarge),
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: AppColors.error.withOpacity(0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text('${AbuseData.abuseTypes.length + AbuseData.stepsAfterAbuse.length + AbuseData.haitiNumbers.length + AbuseData.rightsStatements.length + AbuseData.safetyPlanSteps.length + AbuseData.protectionTips.length + AbuseData.signsOfDanger.length}+', style: AppTextStyles.labelSmall.copyWith(color: AppColors.error)),
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
            Tab(text: tr.types),
            Tab(text: tr.steps),
            Tab(text: tr.numbers),
            Tab(text: tr.yourRights),
            Tab(text: tr.safetyPlan),
            Tab(text: tr.protection),
            Tab(text: tr.dangerSigns),
            Tab(text: tr.cyberHarassment),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildTypesTab(tr),
          _buildStepsTab(tr),
          _buildNumbersTab(tr),
          _buildRightsTab(tr),
          _buildSafetyTab(tr),
          _buildProtectionTab(tr),
          _buildDangerSignsTab(tr),
          _buildCyberTab(tr),
        ],
      ),
    );
  }

  Widget _buildTypesTab(AppTranslations tr) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(tr.abuseTypes(AbuseData.abuseTypes.length), style: AppTextStyles.headlineMedium),
          const SizedBox(height: 16),
          ...AbuseData.abuseTypes.map((a) => Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: GlassCard(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(a['type'] as String, style: AppTextStyles.titleLarge.copyWith(color: AppColors.error)),
                  const SizedBox(height: 8),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('⚠️ ', style: TextStyle(fontSize: 14)),
                      Expanded(
                        child: Text('${tr.signsWord}: ${a['signs']}', style: AppTextStyles.bodyMedium),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('💡 ', style: TextStyle(fontSize: 14)),
                      Expanded(
                        child: Text('${tr.action}: ${a['action']}', style: AppTextStyles.bodyMedium.copyWith(color: AppColors.info)),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          )),
        ],
      ),
    );
  }

  Widget _buildStepsTab(AppTranslations tr) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GlassCard(
            gradient: LinearGradient(
              colors: [AppColors.error.withOpacity(0.05), AppColors.error.withOpacity(0.02)],
            ),
            child: Row(
              children: [
                const Text('🛡️', style: TextStyle(fontSize: 32)),
                const SizedBox(width: 16),
                Expanded(
                  child: Text(
                    '${tr.stepsAfterAbuse} (${AbuseData.stepsAfterAbuse.length})',
                    style: AppTextStyles.headlineMedium.copyWith(color: AppColors.error),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          ...AbuseData.stepsAfterAbuse.map((s) => Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: GlassCard(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(s['title'] as String, style: AppTextStyles.titleMedium.copyWith(color: AppColors.primary)),
                  const SizedBox(height: 4),
                  Text(s['detail'] as String, style: AppTextStyles.bodyMedium),
                ],
              ),
            ),
          )),
        ],
      ),
    );
  }

  Widget _buildNumbersTab(AppTranslations tr) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [AppColors.error, AppColors.primary],
              ),
              borderRadius: BorderRadius.circular(30),
            ),
            child: Column(
              children: [
                const Text('📞', style: TextStyle(fontSize: 48)),
                const SizedBox(height: 12),
                Text(
                  tr.emergencyNumbersHaiti,
                  style: const TextStyle(
                    fontSize: 22, fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  tr.callNow,
                  style: const TextStyle(fontSize: 14, color: Colors.white70),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          ...AbuseData.haitiNumbers.map((n) => Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: GlassCard(
              padding: const EdgeInsets.all(14),
              onTap: () {},
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: AppColors.error.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Text(n['number'] as String, style: AppTextStyles.titleMedium.copyWith(color: AppColors.error)),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(n['name'] as String, style: AppTextStyles.titleMedium),
                        Text(n['description'] as String, style: AppTextStyles.bodySmall),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: AppColors.success.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.phone, color: AppColors.success, size: 20),
                  ),
                ],
              ),
            ),
          )),
        ],
      ),
    );
  }

  Widget _buildRightsTab(AppTranslations tr) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [AppColors.primary.withOpacity(0.8), AppColors.secondary.withOpacity(0.8)],
              ),
              borderRadius: BorderRadius.circular(30),
            ),
            child: Column(
              children: [
                const Text('✊', style: TextStyle(fontSize: 48)),
                const SizedBox(height: 12),
                Text(
                  tr.rightsTitle,
                  style: const TextStyle(
                    fontSize: 22, fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          ...AbuseData.rightsStatements.map((r) => Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: GlassCard(
              padding: const EdgeInsets.all(14),
              child: Row(
                children: [
                  const Text('✊ ', style: TextStyle(fontSize: 18)),
                  Expanded(child: Text(r, style: AppTextStyles.bodyMedium)),
                ],
              ),
            ),
          )),
        ],
      ),
    );
  }

  Widget _buildSafetyTab(AppTranslations tr) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(tr.safetyPlanTitle(AbuseData.safetyPlanSteps.length), style: AppTextStyles.headlineMedium),
          const SizedBox(height: 16),
          ...AbuseData.safetyPlanSteps.map((s) => Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: GlassCard(
              padding: const EdgeInsets.all(14),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('✅ ', style: TextStyle(fontSize: 16)),
                  Expanded(child: Text(s, style: AppTextStyles.bodyMedium)),
                ],
              ),
            ),
          )),
        ],
      ),
    );
  }

  Widget _buildProtectionTab(AppTranslations tr) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(tr.protectionTitle(AbuseData.protectionTips.length), style: AppTextStyles.headlineMedium),
          const SizedBox(height: 16),
          ...AbuseData.protectionTips.map((t) => Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: GlassCard(
              padding: const EdgeInsets.all(14),
              child: Row(
                children: [
                  const Text('🛡️ ', style: TextStyle(fontSize: 16)),
                  Expanded(child: Text(t, style: AppTextStyles.bodyMedium)),
                ],
              ),
            ),
          )),
        ],
      ),
    );
  }

  Widget _buildDangerSignsTab(AppTranslations tr) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GlassCard(
            gradient: LinearGradient(
              colors: [AppColors.error.withOpacity(0.08), AppColors.error.withOpacity(0.03)],
            ),
            child: Row(
              children: [
                const Text('⚠️', style: TextStyle(fontSize: 32)),
                const SizedBox(width: 16),
                Expanded(
                  child: Text(
                    tr.dangerSignsTitle,
                    style: AppTextStyles.headlineMedium.copyWith(color: AppColors.error),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          ...AbuseData.signsOfDanger.map((s) => Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: GlassCard(
              padding: const EdgeInsets.all(14),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('🚩 ', style: TextStyle(fontSize: 16)),
                  Expanded(child: Text(s, style: AppTextStyles.bodyMedium)),
                ],
              ),
            ),
          )),
        ],
      ),
    );
  }

  Widget _buildCyberTab(AppTranslations tr) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF1A237E), Color(0xFF4A148C)],
              ),
              borderRadius: BorderRadius.circular(30),
            ),
            child: Column(
              children: [
                const Text('📱', style: TextStyle(fontSize: 48)),
                const SizedBox(height: 12),
                Text(
                  tr.cyberHarassment,
                  style: const TextStyle(
                    fontSize: 22, fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  tr.cyberSubtitle,
                  style: const TextStyle(fontSize: 14, color: Colors.white70),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          Text(tr.cyberTypes, style: AppTextStyles.headlineMedium),
          const SizedBox(height: 12),
          ...AbuseData.cyberHarassmentInfo.map((c) => Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: GlassCard(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(c['title'] as String, style: AppTextStyles.titleMedium.copyWith(color: AppColors.primary)),
                  const SizedBox(height: 6),
                  Text(c['detail'] as String, style: AppTextStyles.bodyMedium),
                ],
              ),
            ),
          )),
          const SizedBox(height: 20),
          Text(tr.cyberSteps, style: AppTextStyles.headlineMedium),
          const SizedBox(height: 12),
          ...AbuseData.cyberHarassmentSteps.map((s) => Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: GlassCard(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(s['title'] as String, style: AppTextStyles.titleMedium.copyWith(color: AppColors.error)),
                  const SizedBox(height: 4),
                  Text(s['detail'] as String, style: AppTextStyles.bodyMedium),
                ],
              ),
            ),
          )),
          const SizedBox(height: 20),
          Text(tr.cyberHelp, style: AppTextStyles.headlineMedium),
          const SizedBox(height: 12),
          ...AbuseData.cyberNumbers.map((n) => Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: GlassCard(
              padding: const EdgeInsets.all(14),
              onTap: () {},
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: const Color(0xFF1A237E).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Text(n['number'] as String, style: AppTextStyles.titleMedium.copyWith(color: const Color(0xFF1A237E))),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(n['name'] as String, style: AppTextStyles.titleMedium),
                        Text(n['description'] as String, style: AppTextStyles.bodySmall),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          )),
          const SizedBox(height: 20),
          GlassCard(
            gradient: LinearGradient(
              colors: [AppColors.error.withOpacity(0.05), AppColors.error.withOpacity(0.02)],
            ),
            child: Row(
              children: [
                const Text('🛡️', style: TextStyle(fontSize: 32)),
                const SizedBox(width: 16),
                Expanded(
                  child: Text(
                    tr.notYourFault,
                    style: AppTextStyles.titleMedium.copyWith(color: AppColors.error),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 40),
        ],
      ),
    );
  }
}
