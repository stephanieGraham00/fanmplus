import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';
import '../../widgets/glass_card.dart';
import '../../providers/auth_provider.dart';
import '../../providers/user_data_provider.dart';
import '../../providers/language_provider.dart';
import '../../models/user_model.dart';

class MedicalQuestionnaireScreen extends ConsumerStatefulWidget {
  const MedicalQuestionnaireScreen({super.key});

  @override
  ConsumerState<MedicalQuestionnaireScreen> createState() =>
      _MedicalQuestionnaireScreenState();
}

class _MedicalQuestionnaireScreenState
    extends ConsumerState<MedicalQuestionnaireScreen> {
  final _pageController = PageController();
  int _currentStep = 0;
  final _totalSteps = 7;

  final _ageController = TextEditingController();
  final _weightController = TextEditingController();
  final _heightController = TextEditingController();
  final _cycleLengthController = TextEditingController(text: '28');
  final _periodLengthController = TextEditingController(text: '5');
  final _childrenCountController = TextEditingController();
  final _medicalConditionsController = TextEditingController();
  final _allergiesController = TextEditingController();
  final _medicationsController = TextEditingController();
  final _emergencyContactController = TextEditingController();
  final _emergencyPhoneController = TextEditingController();

  DateTime? _lastPeriodDate;
  bool _hasChildren = false;
  bool _hasTestedHiv = false;
  bool _isPregnant = false;
  DateTime? _dueDate;
  bool _hasHiv = false;
  bool _hasExperiencedAbuse = false;
  bool _isLoading = false;

  @override
  void dispose() {
    _pageController.dispose();
    _ageController.dispose();
    _weightController.dispose();
    _heightController.dispose();
    _cycleLengthController.dispose();
    _periodLengthController.dispose();
    _childrenCountController.dispose();
    _medicalConditionsController.dispose();
    _allergiesController.dispose();
    _medicationsController.dispose();
    _emergencyContactController.dispose();
    _emergencyPhoneController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    setState(() => _isLoading = true);
    try {
      final authUser = ref.read(authStateProvider).valueOrNull;
      if (authUser == null) return;
      final firestore = ref.read(firestoreServiceProvider);
      await firestore.updateUser(authUser.uid, {
        'age': int.tryParse(_ageController.text),
        'weight': double.tryParse(_weightController.text),
        'height': double.tryParse(_heightController.text),
        'cycle_length': int.tryParse(_cycleLengthController.text) ?? 28,
        'period_length': int.tryParse(_periodLengthController.text) ?? 5,
        'last_period_date': _lastPeriodDate?.toIso8601String(),
        'has_children': _hasChildren,
        'children_count': _hasChildren ? int.tryParse(_childrenCountController.text) : null,
        'has_tested_hiv': _hasTestedHiv,
        'is_pregnant': _isPregnant,
        'due_date': _dueDate?.toIso8601String(),
        'has_hiv': _hasHiv,
        'has_experienced_abuse': _hasExperiencedAbuse,
        'medical_conditions': _medicalConditionsController.text.isNotEmpty
            ? _medicalConditionsController.text.split(',').map((e) => e.trim()).toList()
            : [],
        'allergies': _allergiesController.text.isNotEmpty
            ? _allergiesController.text.split(',').map((e) => e.trim()).toList()
            : [],
        'medications': _medicationsController.text.isNotEmpty
            ? _medicationsController.text.split(',').map((e) => e.trim()).toList()
            : [],
        'emergency_contact': _emergencyContactController.text,
        'emergency_phone': _emergencyPhoneController.text,
      });
      ref.invalidate(currentUserDataProvider);
      if (mounted) context.go('/home');
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('❌ ${tr.questionnaireError}')),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  late AppTranslations tr;

  @override
  Widget build(BuildContext context) {
    tr = ref.watch(translationsProvider);
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close, color: AppColors.textPrimary),
          onPressed: () => context.go('/home'),
        ),
        title: Text(tr.medicalQuestionnaire, style: AppTextStyles.titleLarge),
        centerTitle: true,
      ),
      body: Column(
        children: [
          _buildStepIndicator(),
          Expanded(
            child: PageView(
              controller: _pageController,
              physics: const NeverScrollableScrollPhysics(),
              onPageChanged: (i) => setState(() => _currentStep = i),
              children: [
                _buildStep1(),
                _buildStep2(),
                _buildStep3(),
                _buildStep4(),
                _buildStep5(),
                _buildStep6(),
                _buildStep7(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStepIndicator() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
      child: Row(
        children: List.generate(_totalSteps, (i) {
          final isActive = i <= _currentStep;
          return Expanded(
            child: Container(
              height: 4,
              margin: const EdgeInsets.symmetric(horizontal: 2),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(2),
                color: isActive ? AppColors.primary : AppColors.secondaryLight,
              ),
            ),
          );
        }),
      ),
    );
  }

  Widget _stepLabel(String emoji, String title, String subtitle) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          Text(emoji, style: const TextStyle(fontSize: 48)),
          const SizedBox(height: 16),
          Text(title, style: AppTextStyles.headlineLarge, textAlign: TextAlign.center),
          const SizedBox(height: 8),
          Text(subtitle, style: AppTextStyles.bodyMedium, textAlign: TextAlign.center),
        ],
      ),
    );
  }

  Widget _buildStep1() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          _stepLabel('👩', tr.step1Title, tr.step1Desc),
          const SizedBox(height: 24),
          GlassCard(
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                TextFormField(
                  controller: _ageController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    hintText: tr.ageHintPlaceholder,
                    prefixIcon: const Icon(Icons.cake_outlined),
                  ),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _weightController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    hintText: tr.weightHintPlaceholder,
                    prefixIcon: const Icon(Icons.monitor_weight_outlined),
                  ),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _heightController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    hintText: tr.heightHintPlaceholder,
                    prefixIcon: const Icon(Icons.height),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 32),
          _nextButton(),
        ],
      ),
    );
  }

  Widget _buildStep2() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          _stepLabel('🌸', tr.step2Title, tr.step2Desc),
          const SizedBox(height: 24),
          GlassCard(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('${tr.lastPeriodLabel}:', style: AppTextStyles.titleMedium),
                const SizedBox(height: 8),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    onPressed: () async {
                      final date = await showDatePicker(
                        context: context,
                        initialDate: _lastPeriodDate ?? DateTime.now(),
                        firstDate: DateTime.now().subtract(const Duration(days: 365)),
                        lastDate: DateTime.now(),
                      );
                      if (date != null) setState(() => _lastPeriodDate = date);
                    },
                    icon: const Icon(Icons.calendar_today),
                    label: Text(
                      _lastPeriodDate != null
                          ? '${_lastPeriodDate!.day}/${_lastPeriodDate!.month}/${_lastPeriodDate!.year}'
                          : tr.selectDate,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: _cycleLengthController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    hintText: tr.normalRange21_35,
                    prefixIcon: const Icon(Icons.loop),
                  ),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _periodLengthController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    hintText: tr.normalRange3_7,
                    prefixIcon: const Icon(Icons.water_drop),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 32),
          _nextButton(),
          _backButton(),
        ],
      ),
    );
  }

  Widget _buildStep3() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          _stepLabel('👶', tr.step3Title, tr.step3Desc),
          const SizedBox(height: 24),
          GlassCard(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(tr.childrenQuestion, style: AppTextStyles.titleMedium),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: _choiceChip(tr.yes, _hasChildren, () => setState(() => _hasChildren = true)),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _choiceChip(tr.no, !_hasChildren, () => setState(() => _hasChildren = false)),
                    ),
                  ],
                ),
                if (_hasChildren) ...[
                  const SizedBox(height: 20),
                  TextFormField(
                    controller: _childrenCountController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      hintText: tr.childrenCountHint,
                      prefixIcon: const Icon(Icons.people),
                    ),
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(height: 32),
          _nextButton(),
          _backButton(),
        ],
      ),
    );
  }

  Widget _buildStep4() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          _stepLabel('🏥', tr.step4Title, tr.step4Desc),
          const SizedBox(height: 24),
          GlassCard(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(tr.hivTestedQuestion, style: AppTextStyles.titleMedium),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(child: _choiceChip(tr.yes, _hasTestedHiv, () => setState(() => _hasTestedHiv = true))),
                    const SizedBox(width: 12),
                    Expanded(child: _choiceChip(tr.no, !_hasTestedHiv, () => setState(() => _hasTestedHiv = false))),
                  ],
                ),
                const SizedBox(height: 24),
                Text(tr.pregnantNow, style: AppTextStyles.titleMedium),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(child: _choiceChip(tr.yes, _isPregnant, () => setState(() => _isPregnant = true))),
                    const SizedBox(width: 12),
                    Expanded(child: _choiceChip(tr.no, !_isPregnant, () => setState(() => _isPregnant = false))),
                  ],
                ),
                if (_isPregnant) ...[
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton.icon(
                      onPressed: () async {
                        final date = await showDatePicker(
                          context: context,
                          initialDate: _dueDate ?? DateTime.now().add(const Duration(days: 270)),
                          firstDate: DateTime.now(),
                          lastDate: DateTime.now().add(const Duration(days: 365)),
                        );
                        if (date != null) setState(() => _dueDate = date);
                      },
                      icon: const Icon(Icons.calendar_today),
                      label: Text(
                        _dueDate != null
                            ? '${tr.dueDateLabel}: ${_dueDate!.day}/${_dueDate!.month}/${_dueDate!.year}'
                            : tr.selectDueDate,
                      ),
                    ),
                  ),
                ],
                const SizedBox(height: 24),
                Text(tr.hivStatusQuestion, style: AppTextStyles.titleMedium),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(child: _choiceChip(tr.yes, _hasHiv, () => setState(() => _hasHiv = true))),
                    const SizedBox(width: 12),
                    Expanded(child: _choiceChip(tr.no, !_hasHiv, () => setState(() => _hasHiv = false))),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 32),
          _nextButton(),
          _backButton(),
        ],
      ),
    );
  }

  Widget _buildStep5() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          _stepLabel('💊', tr.step5Title, tr.step5Desc),
          const SizedBox(height: 24),
          GlassCard(
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                TextFormField(
                  controller: _medicalConditionsController,
                  maxLines: 2,
                  decoration: InputDecoration(
                    hintText: tr.conditionsHintPlaceholder,
                    prefixIcon: const Icon(Icons.health_and_safety_outlined),
                  ),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _allergiesController,
                  maxLines: 2,
                  decoration: InputDecoration(
                    hintText: tr.allergiesHintPlaceholder,
                    prefixIcon: const Icon(Icons.warning_amber_outlined),
                  ),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _medicationsController,
                  maxLines: 2,
                  decoration: InputDecoration(
                    hintText: tr.medicationsHintPlaceholder,
                    prefixIcon: const Icon(Icons.medication_outlined),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 32),
          _nextButton(),
          _backButton(),
        ],
      ),
    );
  }

  Widget _buildStep6() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          _stepLabel('🛡️', tr.step6Title, tr.step6Desc),
          const SizedBox(height: 24),
          GlassCard(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(tr.abuseQuestion, style: AppTextStyles.titleMedium),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(child: _choiceChip(tr.yes, _hasExperiencedAbuse, () => setState(() => _hasExperiencedAbuse = true))),
                    const SizedBox(width: 12),
                    Expanded(child: _choiceChip(tr.no, !_hasExperiencedAbuse, () => setState(() => _hasExperiencedAbuse = false))),
                  ],
                ),
                const SizedBox(height: 24),
                Text('${tr.emergencyContact}:', style: AppTextStyles.titleMedium),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _emergencyContactController,
                  decoration: InputDecoration(
                    hintText: tr.emergencyContactHintPlaceholder,
                    prefixIcon: const Icon(Icons.person_outline),
                  ),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _emergencyPhoneController,
                  keyboardType: TextInputType.phone,
                  decoration: InputDecoration(
                    hintText: tr.emergencyPhoneHintPlaceholder,
                    prefixIcon: const Icon(Icons.phone_outlined),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          GlassCard(
            gradient: LinearGradient(
              colors: [AppColors.info.withOpacity(0.05), AppColors.info.withOpacity(0.02)],
            ),
            child: Row(
              children: [
                const Text('🔒', style: TextStyle(fontSize: 24)),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    tr.allInfoConfidential,
                    style: AppTextStyles.bodySmall,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 32),
          _nextButton(),
          _backButton(),
        ],
      ),
    );
  }

  Widget _buildStep7() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          _stepLabel('✅', tr.step7Title, tr.step7Desc),
          const SizedBox(height: 24),
          GlassCard(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _reviewItem('👩', tr.age, _ageController.text.isNotEmpty ? '${_ageController.text} ${tr.years}' : '—'),
                _reviewItem('⚖️', tr.weight, _weightController.text.isNotEmpty ? '${_weightController.text} ${tr.kg}' : '—'),
                _reviewItem('📏', tr.height, _heightController.text.isNotEmpty ? '${_heightController.text} ${tr.cm}' : '—'),
                _reviewItem('🌸', tr.lastPeriodLabel, _lastPeriodDate != null ? '${_lastPeriodDate!.day}/${_lastPeriodDate!.month}/${_lastPeriodDate!.year}' : '—'),
                _reviewItem('👶', tr.childrenQuestion, _hasChildren ? '${tr.yes} (${_childrenCountController.text})' : tr.no),
                _reviewItem('🏥', tr.hivTestedQuestion, _hasTestedHiv ? tr.yes : tr.no),
                _reviewItem('🤰', tr.pregnantNow, _isPregnant ? tr.yes : tr.no),
                _reviewItem('🎗️', tr.hivStatusQuestion, _hasHiv ? tr.yes : tr.no),
                _reviewItem('🛡️', tr.abuseQuestion, _hasExperiencedAbuse ? tr.yes : tr.no),
              ],
            ),
          ),
          const SizedBox(height: 32),
          SizedBox(
            width: double.infinity,
            height: 56,
            child: ElevatedButton(
              onPressed: _isLoading ? null : _submit,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: AppColors.white,
                disabledBackgroundColor: AppColors.primary.withOpacity(0.5),
              ),
              child: _isLoading
                  ? const SizedBox(
                      height: 24, width: 24,
                      child: CircularProgressIndicator(strokeWidth: 2, color: AppColors.white),
                    )
                  : Text(tr.submitBtn, style: AppTextStyles.buttonText),
            ),
          ),
          _backButton(),
        ],
      ),
    );
  }

  Widget _reviewItem(String emoji, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Text('$emoji ', style: const TextStyle(fontSize: 16)),
          SizedBox(
            width: 100,
            child: Text(label, style: AppTextStyles.bodySmall),
          ),
          Expanded(
            child: Text(value, style: AppTextStyles.titleMedium),
          ),
        ],
      ),
    );
  }

  Widget _choiceChip(String label, bool isSelected, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : AppColors.secondaryLight,
          borderRadius: BorderRadius.circular(14),
        ),
        child: Center(
          child: Text(
            label,
            style: AppTextStyles.titleMedium.copyWith(
              color: isSelected ? AppColors.white : AppColors.textPrimary,
            ),
          ),
        ),
      ),
    );
  }

  Widget _nextButton() {
    return SizedBox(
      width: double.infinity,
      height: 52,
      child: ElevatedButton(
        onPressed: () => _pageController.nextPage(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        ),
        style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary),
        child: Text(tr.continueBtn, style: AppTextStyles.buttonText),
      ),
    );
  }

  Widget _backButton() {
    return Padding(
      padding: const EdgeInsets.only(top: 12),
      child: TextButton(
        onPressed: () => _pageController.previousPage(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        ),
        child: Text(tr.back, style: AppTextStyles.titleMedium),
      ),
    );
  }
}
