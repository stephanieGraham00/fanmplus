import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';
import '../../widgets/glass_card.dart';
import '../../widgets/pam_icon.dart';
import '../../models/tracker_model.dart';
import '../../providers/contraception_provider.dart';
import '../../providers/language_provider.dart';

class ContraceptionScreen extends ConsumerStatefulWidget {
  const ContraceptionScreen({super.key});

  @override
  ConsumerState<ContraceptionScreen> createState() => _ContraceptionScreenState();
}

class _ContraceptionScreenState extends ConsumerState<ContraceptionScreen> {
  String _selectedMethod = 'condom';
  bool _wasProtected = true;
  bool _tookMorningAfter = false;

  List<Map<String, String>> _buildMethods(AppTranslations tr) => [
    {'id': 'condom', 'name': tr.condom, 'icon': '🛡️', 'description': 'Kapòt fi oswa gason'},
    {'id': 'pill', 'name': tr.pill, 'icon': '💊', 'description': 'Pilil kontraseptif chak jou'},
    {'id': 'injection', 'name': tr.injection, 'icon': '💉', 'description': 'Depo-Provera chak 3 mwa'},
    {'id': 'iud', 'name': tr.iud, 'icon': '🛡️', 'description': 'Sterilet dire 5-10 ane'},
    {'id': 'implant', 'name': tr.implant, 'icon': '💊', 'description': 'Norplant dire 3-5 ane'},
    {'id': 'none', 'name': 'Pa gen', 'icon': '❌', 'description': 'Pa gen metòd kontrasepsyon'},
  ];

  @override
  Widget build(BuildContext context) {
    final contraception = ref.watch(contraceptionProvider);
    final tr = ref.watch(translationsProvider);
    final methods = _buildMethods(tr);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(tr.contraceptionTitle, style: AppTextStyles.titleLarge),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.textPrimary),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Current Method
            GlassCard(
              gradient: LinearGradient(
                colors: [AppColors.primary.withOpacity(0.1), AppColors.secondary.withOpacity(0.1)],
              ),
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  const PamIcon(name: 'contraception', size: 40, color: AppColors.primary),
                  const SizedBox(height: 12),
                  Text(tr.currentMethod, style: AppTextStyles.titleLarge),
                  const SizedBox(height: 4),
                  Text(
                    methods.firstWhere((m) => m['id'] == contraception.currentMethod)['name'] as String,
                    style: AppTextStyles.headlineMedium.copyWith(color: AppColors.primary),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Quick Log
            Text(tr.recordToday, style: AppTextStyles.headlineMedium),
            const SizedBox(height: 12),
            GlassCard(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(tr.didYouUseProtection, style: AppTextStyles.titleMedium),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(
                        child: _YesNoButton(
                          label: tr.yes,
                          isYes: true,
                          isSelected: _wasProtected,
                          onTap: () => setState(() => _wasProtected = true),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _YesNoButton(
                          label: tr.no,
                          isYes: false,
                          isSelected: !_wasProtected,
                          onTap: () => setState(() => _wasProtected = false),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Text('Ki metòd?', style: AppTextStyles.titleMedium),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: methods.map((m) => GestureDetector(
                      onTap: () => setState(() => _selectedMethod = m['id'] as String),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                        decoration: BoxDecoration(
                          color: _selectedMethod == m['id']
                              ? AppColors.primary.withOpacity(0.15)
                              : AppColors.secondaryLight,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: _selectedMethod == m['id']
                                ? AppColors.primary
                                : Colors.transparent,
                          ),
                        ),
                        child: Text('${m['icon']} ${m['name']}', style: AppTextStyles.titleSmall),
                      ),
                    )).toList(),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Checkbox(
                        value: _tookMorningAfter,
                        onChanged: (v) => setState(() => _tookMorningAfter = v ?? false),
                        activeColor: AppColors.primary,
                      ),
                      Expanded(
                        child: Text('Mwen pran pilil lendemèn', style: AppTextStyles.bodyMedium),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: ElevatedButton(
                      onPressed: () {
                        ref.read(contraceptionProvider.notifier).addLog(
                          ContraceptionLog(
                            userId: '',
                            date: DateTime.now(),
                            method: _selectedMethod,
                            wasProtected: _wasProtected,
                            tookMorningAfter: _tookMorningAfter,
                          ),
                        );
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(tr.recorded),
                            behavior: SnackBarBehavior.floating,
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary),
                      child: Text(tr.confirm, style: const TextStyle(color: Colors.white)),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Stats
            Text(tr.protectionSummary, style: AppTextStyles.headlineMedium),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _StatCard(
                    label: tr.protectedLabel,
                    value: '${contraception.totalProtected}',
                    color: AppColors.success,
                    iconName: 'heart',
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _StatCard(
                    label: tr.unprotectedLabel,
                    value: '${contraception.totalUnprotected}',
                    color: AppColors.error,
                    iconName: 'med',
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _StatCard(
                    label: 'Pilil lendemèn',
                    value: '${contraception.morningAfterCount}',
                    color: AppColors.warning,
                    iconName: 'med',
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _StatCard(
                    label: 'Tx pwoteksyon',
                    value: '${(contraception.protectionRate * 100).toInt()}%',
                    color: AppColors.primary,
                    iconName: 'heart',
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // History
            Text(tr.historyTab, style: AppTextStyles.headlineMedium),
            const SizedBox(height: 12),
            if (contraception.logs.isEmpty)
              GlassCard(
                padding: const EdgeInsets.all(20),
                child: Center(
                  child: Text(
                    'Pa gen anrejistreman ankò.',
                    style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textHint),
                  ),
                ),
              )
            else
              ...contraception.logs.take(10).map((log) => Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: GlassCard(
                  padding: const EdgeInsets.all(14),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: log.wasProtected
                              ? AppColors.success.withOpacity(0.1)
                              : AppColors.error.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          log.wasProtected ? '🛡️' : '❌',
                          style: const TextStyle(fontSize: 20),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              log.method.toUpperCase(),
                              style: AppTextStyles.titleSmall,
                            ),
                            Text(
                              log.date.format(pattern: 'dd MMM yyyy'),
                              style: AppTextStyles.bodySmall,
                            ),
                          ],
                        ),
                      ),
                      if (log.tookMorningAfter)
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: AppColors.warning.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Text('Pilil lendemèn', style: TextStyle(fontSize: 10, color: AppColors.warning)),
                        ),
                    ],
                  ),
                ),
              )),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}

class _YesNoButton extends StatelessWidget {
  final String label;
  final bool isYes;
  final bool isSelected;
  final VoidCallback onTap;

  const _YesNoButton({required this.label, required this.isYes, required this.isSelected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: isSelected
              ? (isYes ? AppColors.success.withOpacity(0.15) : AppColors.error.withOpacity(0.15))
              : AppColors.secondaryLight,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected
                ? (isYes ? AppColors.success : AppColors.error)
                : Colors.transparent,
          ),
        ),
        child: Center(
          child: Text(label, style: AppTextStyles.titleMedium.copyWith(
            color: isYes ? AppColors.success : AppColors.error,
          )),
        ),
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String label;
  final String value;
  final Color color;
  final String iconName;

  const _StatCard({required this.label, required this.value, required this.color, required this.iconName});

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          PamIcon(name: iconName, size: 24, color: color),
          const SizedBox(height: 8),
          Text(value, style: AppTextStyles.headlineMedium.copyWith(color: color)),
          const SizedBox(height: 2),
          Text(label, style: AppTextStyles.labelSmall),
        ],
      ),
    );
  }
}
