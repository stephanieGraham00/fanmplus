import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';
import '../../providers/language_provider.dart';
import '../../providers/user_data_provider.dart';
import '../../data/pregnancy_data.dart';
import '../../data/hiv_data.dart';
import '../../data/abuse_data.dart';

class AIChatScreen extends ConsumerStatefulWidget {
  const AIChatScreen({super.key});

  @override
  ConsumerState<AIChatScreen> createState() => _AIChatScreenState();
}

class _AIChatScreenState extends ConsumerState<AIChatScreen> {
  final _messages = <_ChatMessage>[];
  final _controller = TextEditingController();
  final _scrollController = ScrollController();
  final _random = Random();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final tr = ref.read(translationsProvider);
      setState(() {
        _messages.add(_ChatMessage(tr.aiWelcomeMsg, true));
      });
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  String _getUserName() {
    final user = ref.read(currentUserDataProvider).valueOrNull;
    return user?.name.split(' ').first ?? 'Fanm+ Sè';
  }

  void _sendMessage(String text) {
    if (text.trim().isEmpty) return;
    final tr = ref.read(translationsProvider);
    setState(() {
      _messages.add(_ChatMessage(text, false));
    });
    _scrollToBottom();

    Future.delayed(const Duration(milliseconds: 800), () {
      setState(() {
        _messages.add(_ChatMessage(
          _getAIResponse(text.toLowerCase(), tr),
          true,
        ));
      });
      _scrollToBottom();
    });
    _controller.clear();
  }

  String _getAIResponse(String q, AppTranslations tr) {
    final user = ref.read(currentUserDataProvider).valueOrNull;
    final isPregnant = user?.isPregnant == true;
    final hasHiv = user?.hasHiv == true;
    final hasAbuse = user?.hasExperiencedAbuse == true;
    final name = user?.name.split(' ').first ?? 'Fanm+ Sè';

    if (q.contains('bonjour') || q.contains('hi') || q.contains('hello') || q.contains('salut') || q.contains('hey')) {
      if (isPregnant) return tr.aiPregnantGreeting(name);
      if (hasHiv) return tr.aiHivGreeting(name);
      return tr.aiDefaultResponse(name);
    }

    if (q.contains('period') || q.contains('cycle') || q.contains('menstru') || q.contains('règle')) {
      return tr.aiPeriodResponse;
    }

    if (q.contains('pregnancy') || q.contains('pregnant') || q.contains('grossess') || q.contains('enceinte') || q.contains('bébé') || q.contains('baby')) {
      if (isPregnant) {
        final monthData = PregnancyData.monthlySymptoms;
        final advice = monthData[_random.nextInt(monthData.length)];
        return '${tr.aiPregnancyResponse(name)} ${advice['advice']} ${tr.aiPregnancyTipResponse}';
      }
      return tr.aiPregnancyGeneric;
    }

    if (q.contains('hiv') || q.contains('vih') || q.contains('sida') || q.contains('arv') || q.contains('treatment')) {
      if (hasHiv) {
        final info = HivData.generalInfo[_random.nextInt(HivData.generalInfo.length)];
        final quote = HivData.motivationQuotes[_random.nextInt(HivData.motivationQuotes.length)];
        return '${tr.aiHivResponse(name)} $quote\n\n${info['title']}: ${info['content']}';
      }
      return tr.aiHivGeneric;
    }

    if (q.contains('abuse') || q.contains('violence') || q.contains('viol') || q.contains('menac') || q.contains('danger') || q.contains('sos')) {
      final rights = AbuseData.rightsStatements[_random.nextInt(AbuseData.rightsStatements.length)];
      final number = AbuseData.haitiNumbers[_random.nextInt(AbuseData.haitiNumbers.length)];
      if (hasAbuse) {
        return '${tr.aiAbuseResponse(name)} $rights\n\n${tr.emergencyContactLabel(number['name'] as String, number['number'] as String)}';
      }
      return '${tr.aiAbuseGeneric}\n\n${tr.emergencyContactLabel(number['name'] as String, number['number'] as String)}';
    }

    if (q.contains('rights') || q.contains('droit') || q.contains('liberté')) {
      return tr.aiRightsResponse;
    }

    if (q.contains('contraception') || q.contains('condom') || q.contains('pill') || q.contains('préservatif') || q.contains('pilule')) {
      return tr.aiContraceptionResponse;
    }

    if (q.contains('food') || q.contains('nourri') || q.contains('aliment') || q.contains('manger') || q.contains('eau') || q.contains('water')) {
      if (isPregnant) {
        final good = PregnancyData.foodsGood[_random.nextInt(PregnancyData.foodsGood.length)];
        return '🥗 $good';
      }
      if (hasHiv) {
        final tip = HivData.foodTips[_random.nextInt(HivData.foodTips.length)];
        return '🥗 $tip';
      }
      return tr.aiNutritionResponse;
    }

    if (q.contains('mental') || q.contains('depression') || q.contains('anxiété') || q.contains('triste') || q.contains('peur') || q.contains('stress')) {
      return tr.aiMentalHealthResponse;
    }

    if (q.contains('education') || q.contains('éducation') || q.contains('puberté') || q.contains('sexuel') || q.contains('école')) {
      return tr.aiEducationResponse;
    }

    if (q.contains('doctor') || q.contains('médecin') || q.contains('hôpital') || q.contains('hospital') || q.contains('santé')) {
      return tr.aiHealthResponse;
    }

    if (isPregnant && (q.contains('symptom') || q.contains('symptôme') || q.contains('conseil') || q.contains('advice'))) {
      final month = PregnancyData.monthlySymptoms[_random.nextInt(PregnancyData.monthlySymptoms.length)];
      return '💡 ${month['advice']} ${month['symptoms']}';
    }

    if (hasHiv && (q.contains('medication') || q.contains('médicament') || q.contains('adherence') || q.contains('take'))) {
      final med = HivData.medications[_random.nextInt(HivData.medications.length)];
      final tip = HivData.adherenceTips[_random.nextInt(HivData.adherenceTips.length)];
      return '${tr.aiHivMedResponse} ${med['name']}: ${med['schedule']}. ${med['tips']} ⏰ $tip';
    }

    if (hasAbuse && (q.contains('safety') || q.contains('sécurité') || q.contains('plan') || q.contains('leave') || q.contains('partir'))) {
      final s = AbuseData.safetyPlanSteps[_random.nextInt(AbuseData.safetyPlanSteps.length)];
      final n = AbuseData.haitiNumbers[_random.nextInt(AbuseData.haitiNumbers.length)];
      return '${tr.aiSafetyResponse} $s\n\n${tr.emergencyContactLabel(n['name'] as String, n['number'] as String)}';
    }

    return tr.aiThankYou;
  }

  void _scrollToBottom() {
    Future.delayed(const Duration(milliseconds: 100), () {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final tr = ref.watch(translationsProvider);
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
              child: Row(
                children: [
                  Text(tr.aiChatTitle, style: AppTextStyles.headlineLarge),
                  const Spacer(),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppColors.success.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(width: 8, height: 8, decoration: const BoxDecoration(shape: BoxShape.circle, color: AppColors.success)),
                        const SizedBox(width: 4),
                        Text(tr.active, style: AppTextStyles.labelSmall.copyWith(color: AppColors.success)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView.builder(
                controller: _scrollController,
                padding: const EdgeInsets.symmetric(horizontal: 20),
                itemCount: _messages.length,
                itemBuilder: (ctx, i) {
                  final msg = _messages[i];
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Row(
                      mainAxisAlignment: msg.isBot ? MainAxisAlignment.start : MainAxisAlignment.end,
                      children: [
                        if (msg.isBot) ...[
                          Container(
                            width: 30, height: 30,
                            decoration: const BoxDecoration(shape: BoxShape.circle, gradient: AppColors.primaryGradient),
                            child: const Center(child: Text('AI', style: TextStyle(fontSize: 10, color: AppColors.white, fontWeight: FontWeight.bold))),
                          ),
                          const SizedBox(width: 8),
                        ],
                        Flexible(
                          child: Container(
                            padding: const EdgeInsets.all(14),
                            decoration: BoxDecoration(
                              gradient: msg.isBot
                                  ? AppColors.cardGradient
                                  : AppColors.primaryGradient,
                              borderRadius: BorderRadius.only(
                                topLeft: const Radius.circular(20),
                                topRight: const Radius.circular(20),
                                bottomLeft: msg.isBot ? const Radius.circular(4) : const Radius.circular(20),
                                bottomRight: msg.isBot ? const Radius.circular(20) : const Radius.circular(4),
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: AppColors.primary.withOpacity(0.06),
                                  blurRadius: 10,
                                ),
                              ],
                            ),
                            child: Text(
                              msg.text,
                              style: AppTextStyles.bodyMedium.copyWith(
                                color: msg.isBot ? AppColors.textPrimary : AppColors.white,
                              ),
                            ),
                          ),
                        ),
                        if (!msg.isBot) ...[
                          const SizedBox(width: 8),
                          Container(
                            width: 30, height: 30,
                            decoration: const BoxDecoration(shape: BoxShape.circle, color: AppColors.primaryLight),
                            child: const Center(child: Text('👤', style: TextStyle(fontSize: 14))),
                          ),
                        ],
                      ],
                    ),
                  );
                },
              ),
            ),
            Container(
              height: 44,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  _topicChip('🌸', tr.topicPeriod, tr),
                  _topicChip('👶', tr.topicPregnancy, tr),
                  _topicChip('🎗️', tr.topicHiv, tr),
                  _topicChip('🛡️', tr.topicAbuse, tr),
                  _topicChip('✊', tr.topicRights, tr),
                  _topicChip('💊', tr.topicContraception, tr),
                  _topicChip('🥗', tr.topicFood, tr),
                  _topicChip('🧠', tr.topicMentalHealth, tr),
                  _topicChip('💋', tr.topicEducation, tr),
                  _topicChip('🏥', tr.topicHealth, tr),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
              decoration: BoxDecoration(
                color: AppColors.white,
                boxShadow: [BoxShadow(color: AppColors.primary.withOpacity(0.04), blurRadius: 10, offset: const Offset(0, -4))],
              ),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _controller,
                      decoration: InputDecoration(
                        hintText: tr.askQuestionPlaceholder,
                        filled: true,
                        fillColor: AppColors.secondaryLight,
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(25), borderSide: BorderSide.none),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                      ),
                      onSubmitted: _sendMessage,
                    ),
                  ),
                  const SizedBox(width: 8),
                  GestureDetector(
                    onTap: () => _sendMessage(_controller.text),
                    child: Container(
                      width: 48, height: 48,
                      decoration: const BoxDecoration(shape: BoxShape.circle, gradient: AppColors.primaryGradient),
                      child: const Center(child: Icon(Icons.send, color: AppColors.white, size: 20)),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _topicChip(String emoji, String label, AppTranslations tr) {
    return Padding(
      padding: const EdgeInsets.only(right: 6),
      child: GestureDetector(
        onTap: () => _sendMessage(label),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: AppColors.secondaryLight,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(emoji, style: const TextStyle(fontSize: 14)),
              const SizedBox(width: 4),
              Text(label, style: AppTextStyles.bodySmall.copyWith(fontWeight: FontWeight.w600)),
            ],
          ),
        ),
      ),
    );
  }
}

class _ChatMessage {
  final String text;
  final bool isBot;
  _ChatMessage(this.text, this.isBot);
}
