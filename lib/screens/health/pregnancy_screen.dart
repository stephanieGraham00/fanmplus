import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';
import '../../providers/language_provider.dart';
import '../../widgets/glass_card.dart';
import '../../data/pregnancy_data.dart';

class PregnancyScreen extends ConsumerStatefulWidget {
  const PregnancyScreen({super.key});

  @override
  ConsumerState<PregnancyScreen> createState() => _PregnancyScreenState();
}

class _PregnancyScreenState extends ConsumerState<PregnancyScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  int _selectedMonth = 1;
  int _currentQuiz = 0;
  int? _selectedAnswer;
  int _quizScore = 0;
  bool _quizCompleted = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 7, vsync: this);
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
            const Text('🤰', style: AppTextStyles.titleLarge),
            const SizedBox(width: 4),
            Text(tr.pregnancyTitle, style: AppTextStyles.titleLarge),
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text('${PregnancyData.monthlySymptoms.length + PregnancyData.foodsGood.length + PregnancyData.foodsAvoid.length + PregnancyData.emergencySigns.length + PregnancyData.emergencyNumbers.length + PregnancyData.breastfeedingTips.length + PregnancyData.birthPrepSteps.length + PregnancyData.laborStages.length + PregnancyData.quizzes.length}+', style: AppTextStyles.labelSmall.copyWith(color: AppColors.primary)),
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
            Tab(text: tr.monthByMonth),
            Tab(text: tr.food),
            Tab(text: tr.emergency),
            Tab(text: tr.breastfeeding),
            Tab(text: tr.birthPrep),
            Tab(text: tr.labor),
            Tab(text: tr.quiz),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildMonthlyTab(tr),
          _buildFoodTab(tr),
          _buildEmergencyTab(tr),
          _buildBreastfeedingTab(tr),
          _buildBirthPrepTab(tr),
          _buildLaborTab(tr),
          _buildQuizTab(tr),
        ],
      ),
    );
  }

  Widget _buildMonthlyTab(AppTranslations tr) {
    final monthData = PregnancyData.monthlySymptoms;
    final current = monthData[_selectedMonth - 1];
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('${tr.selectMonth}:', style: AppTextStyles.titleMedium),
          const SizedBox(height: 12),
          SizedBox(
            height: 50,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: 9,
              itemBuilder: (ctx, i) {
                final m = i + 1;
                final isSel = m == _selectedMonth;
                return GestureDetector(
                  onTap: () => setState(() => _selectedMonth = m),
                  child: Container(
                    width: 50,
                    margin: const EdgeInsets.only(right: 8),
                    decoration: BoxDecoration(
                      color: isSel ? AppColors.primary : AppColors.secondaryLight,
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Center(
                      child: Text(
                        '$m',
                        style: AppTextStyles.titleMedium.copyWith(
                          color: isSel ? AppColors.white : AppColors.textPrimary,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 20),
          GlassCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 80, height: 80,
                    decoration: BoxDecoration(
                      color: AppColors.primaryLight.withOpacity(0.3),
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Text(
                        '${tr.monthByMonth} $_selectedMonth',
                        style: AppTextStyles.headlineMedium.copyWith(color: AppColors.primary),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                _infoRow('📏', tr.babySize, current['babySize'] as String),
                const SizedBox(height: 12),
                _infoRow('🤒', tr.symptomsWord, current['symptoms'] as String),
                const SizedBox(height: 12),
                _infoRow('💡', tr.advice, current['advice'] as String),
              ],
            ),
          ),
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
          Text(tr.goodFoods(PregnancyData.foodsGood.length), style: AppTextStyles.headlineMedium),
          const SizedBox(height: 12),
          ...PregnancyData.foodsGood.map((f) => Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: GlassCard(
              padding: const EdgeInsets.all(14),
              child: Row(
                children: [
                  const Text('✅ ', style: TextStyle(fontSize: 16)),
                  Expanded(child: Text(f, style: AppTextStyles.bodyMedium)),
                ],
              ),
            ),
          )),
          const SizedBox(height: 24),
          Text(
            tr.avoidFoods(PregnancyData.foodsAvoid.length),
            style: AppTextStyles.headlineMedium.copyWith(color: AppColors.error),
          ),
          const SizedBox(height: 12),
          ...PregnancyData.foodsAvoid.map((f) => Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: GlassCard(
              padding: const EdgeInsets.all(14),
              gradient: LinearGradient(
                colors: [AppColors.error.withOpacity(0.03), AppColors.error.withOpacity(0.01)],
              ),
              child: Row(
                children: [
                  const Text('❌ ', style: TextStyle(fontSize: 16)),
                  Expanded(child: Text(f, style: AppTextStyles.bodyMedium)),
                ],
              ),
            ),
          )),
        ],
      ),
    );
  }

  Widget _buildEmergencyTab(AppTranslations tr) {
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
                const Text('🚨', style: TextStyle(fontSize: 32)),
                const SizedBox(width: 16),
                Expanded(
                  child: Text(
                    tr.emergencySigns,
                    style: AppTextStyles.headlineMedium.copyWith(color: AppColors.error),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          ...PregnancyData.emergencySigns.map((s) => Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: GlassCard(
              padding: const EdgeInsets.all(14),
              gradient: LinearGradient(
                colors: [AppColors.error.withOpacity(0.03), AppColors.error.withOpacity(0.01)],
              ),
              child: Row(
                children: [
                  const Text('⚠️ ', style: TextStyle(fontSize: 16)),
                  Expanded(child: Text(s, style: AppTextStyles.bodyMedium)),
                ],
              ),
            ),
          )),
          const SizedBox(height: 24),
          Text(tr.haitiNumbers, style: AppTextStyles.headlineMedium),
          const SizedBox(height: 12),
          ...PregnancyData.emergencyNumbers.map((n) => Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: GlassCard(
              padding: const EdgeInsets.all(14),
              onTap: () {},
              child: Row(
                children: [
                  Text(n['number'] as String, style: AppTextStyles.headlineMedium.copyWith(color: AppColors.primary)),
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
                  const Icon(Icons.phone, color: AppColors.primary, size: 20),
                ],
              ),
            ),
          )),
        ],
      ),
    );
  }

  Widget _buildBreastfeedingTab(AppTranslations tr) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(tr.breastfeedingTips(PregnancyData.breastfeedingTips.length), style: AppTextStyles.headlineMedium),
          const SizedBox(height: 16),
          ...PregnancyData.breastfeedingTips.map((t) => Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: GlassCard(
              padding: const EdgeInsets.all(14),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('💡 ', style: TextStyle(fontSize: 16)),
                  Expanded(child: Text(t, style: AppTextStyles.bodyMedium)),
                ],
              ),
            ),
          )),
        ],
      ),
    );
  }

  Widget _buildBirthPrepTab(AppTranslations tr) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(tr.birthPrepSteps, style: AppTextStyles.headlineMedium),
          const SizedBox(height: 16),
          ...PregnancyData.birthPrepSteps.map((s) => Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: GlassCard(
              padding: const EdgeInsets.all(14),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 32, height: 32,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: AppColors.primaryGradient,
                    ),
                    child: Center(
                      child: Text(
                        '${s['step']}',
                        style: AppTextStyles.titleSmall.copyWith(color: AppColors.white),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(s['title'] as String, style: AppTextStyles.titleMedium),
                        Text(s['detail'] as String, style: AppTextStyles.bodySmall),
                      ],
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

  Widget _buildLaborTab(AppTranslations tr) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(tr.laborStages, style: AppTextStyles.headlineMedium),
          const SizedBox(height: 16),
          ...PregnancyData.laborStages.map((s) => Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: GlassCard(
              padding: const EdgeInsets.all(14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(s['name'] as String, style: AppTextStyles.titleMedium.copyWith(color: AppColors.primary)),
                  const SizedBox(height: 4),
                  Text('${tr.duration}: ${s['duration']}', style: AppTextStyles.bodySmall),
                  const SizedBox(height: 4),
                  Text('${tr.signs}: ${s['signs']}', style: AppTextStyles.bodyMedium),
                ],
              ),
            ),
          )),
        ],
      ),
    );
  }

  Widget _buildQuizTab(AppTranslations tr) {
    final quizzes = PregnancyData.quizzes;
    if (_quizCompleted) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('🎉', style: TextStyle(fontSize: 64)),
              const SizedBox(height: 16),
              Text(tr.yourScore(_quizScore, quizzes.length), style: AppTextStyles.headlineLarge),
              const SizedBox(height: 8),
              Text(tr.keepLearning, style: AppTextStyles.bodyMedium),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    _quizCompleted = false;
                    _currentQuiz = 0;
                    _quizScore = 0;
                    _selectedAnswer = null;
                  });
                },
                style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary),
                child: Text(tr.restart),
              ),
            ],
          ),
        ),
      );
    }

    final q = quizzes[_currentQuiz];
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(tr.quizTitle, style: AppTextStyles.headlineMedium),
          const SizedBox(height: 8),
          Text(tr.question(_currentQuiz + 1, quizzes.length), style: AppTextStyles.bodySmall),
          const SizedBox(height: 20),
          GlassCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(q['question'] as String, style: AppTextStyles.titleLarge),
                const SizedBox(height: 20),
                ...(q['options'] as List).asMap().entries.map((entry) {
                  final i = entry.key;
                  final opt = entry.value as String;
                  final isSel = _selectedAnswer == i;
                  final isCorrect = _selectedAnswer != null && i == (q['answer'] as int);
                  final isWrong = _selectedAnswer != null && isSel && i != (q['answer'] as int);
                  Color? bg;
                  if (isCorrect) bg = AppColors.success.withOpacity(0.1);
                  else if (isWrong) bg = AppColors.error.withOpacity(0.1);
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: GestureDetector(
                      onTap: _selectedAnswer == null
                          ? () => setState(() => _selectedAnswer = i)
                          : null,
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: bg ?? AppColors.secondaryLight,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: isCorrect
                                ? AppColors.success
                                : isWrong
                                    ? AppColors.error
                                    : Colors.transparent,
                            width: 2,
                          ),
                        ),
                        child: Text(
                          '${String.fromCharCode(65 + i)}. $opt',
                          style: AppTextStyles.bodyMedium.copyWith(
                            fontWeight: isSel || isCorrect ? FontWeight.w600 : FontWeight.w400,
                          ),
                        ),
                      ),
                    ),
                  );
                }),
                if (_selectedAnswer != null) ...[
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: _selectedAnswer == (q['answer'] as int)
                          ? AppColors.success.withOpacity(0.1)
                          : AppColors.error.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: _selectedAnswer == (q['answer'] as int)
                            ? AppColors.success
                            : AppColors.error,
                        width: 2,
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              _selectedAnswer == (q['answer'] as int) ? '✅ ' : '❌ ',
                              style: const TextStyle(fontSize: 18),
                            ),
                            Expanded(
                              child: Text(
                                _selectedAnswer == (q['answer'] as int)
                                    ? tr.correct
                                    : tr.correctAnswer((q['options'] as List)[q['answer'] as int]),
                                style: AppTextStyles.titleMedium.copyWith(
                                  color: _selectedAnswer == (q['answer'] as int)
                                      ? AppColors.success
                                      : AppColors.error,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            const Text('💡 ', style: TextStyle(fontSize: 16)),
                            Expanded(
                              child: Text(
                                q['explanation'] as String,
                                style: AppTextStyles.bodySmall,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: ElevatedButton(
                      onPressed: () {
                        if (_selectedAnswer == (q['answer'] as int)) {
                          _quizScore++;
                        }
                        if (_currentQuiz < quizzes.length - 1) {
                          setState(() {
                            _currentQuiz++;
                            _selectedAnswer = null;
                          });
                        } else {
                          setState(() => _quizCompleted = true);
                        }
                      },
                      style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary),
                      child: Text(
                        _currentQuiz < quizzes.length - 1 ? tr.next : tr.seeScore,
                        style: AppTextStyles.buttonText,
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _infoRow(String emoji, String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(emoji, style: const TextStyle(fontSize: 20)),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: AppTextStyles.labelSmall),
              const SizedBox(height: 2),
              Text(value, style: AppTextStyles.bodyMedium),
            ],
          ),
        ),
      ],
    );
  }
}
