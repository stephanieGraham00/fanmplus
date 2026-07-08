import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';
import '../../widgets/glass_card.dart';
import '../../widgets/pam_icon.dart';
import '../../providers/language_provider.dart';

class HygieneEducationScreen extends ConsumerStatefulWidget {
  const HygieneEducationScreen({super.key});

  @override
  ConsumerState<HygieneEducationScreen> createState() => _HygieneEducationScreenState();
}

class _HygieneEducationScreenState extends ConsumerState<HygieneEducationScreen> {
  int _selectedCategory = 0;

  List<String> _categories(dynamic tr) => [
    tr.basics,
    tr.productsTab,
    tr.hygieneTab,
    tr.foodTab,
    tr.tipsTab,
    tr.bloodColorTab,
    tr.earlyLateTab,
    tr.whenDoctorTab,
  ];

  @override
  Widget build(BuildContext context) {
    final tr = ref.watch(translationsProvider);
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(tr.periodEducation, style: AppTextStyles.titleLarge),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.textPrimary),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Column(
        children: [
          // Category selector
          SizedBox(
            height: 44,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: _categories(tr).length,
              itemBuilder: (ctx, index) {
                final isSelected = index == _selectedCategory;
                return GestureDetector(
                  onTap: () => setState(() => _selectedCategory = index),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    padding: const EdgeInsets.symmetric(horizontal: 18),
                    decoration: BoxDecoration(
                      color: isSelected ? AppColors.primary : AppColors.secondaryLight,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Center(
                      child: Text(
                        _categories(tr)[index],
                        style: TextStyle(
                          color: isSelected ? Colors.white : AppColors.textPrimary,
                          fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                          fontSize: 13,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 12),

          // Content
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: _buildContent(tr),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContent(dynamic tr) {
    switch (_selectedCategory) {
      case 0:
        return _buildBasics(tr);
      case 1:
        return _buildProducts(tr);
      case 2:
        return _buildHygiene(tr);
      case 3:
        return _buildFood(tr);
      case 4:
        return _buildTips(tr);
      case 5:
        return _buildBloodColor(tr);
      case 6:
        return _buildEarlyLate(tr);
      case 7:
        return _buildWhenToSeeDoctor(tr);
      default:
        return const SizedBox();
    }
  }

  Widget _buildBasics(dynamic tr) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // What is a period
        GlassCard(
          gradient: LinearGradient(
            colors: [AppColors.period.withOpacity(0.1), AppColors.period.withOpacity(0.05)],
          ),
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const PamIcon(name: 'period', size: 28, color: AppColors.period),
                  const SizedBox(width: 10),
                  Text(tr.whatIsPeriod, style: AppTextStyles.headlineMedium),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                'Peryòd (menstruasyon) se lè miray matris la soti nan vajen an. Li rive chak 21-35 jou epi li dire 3-7 jou.',
                style: AppTextStyles.bodyMedium,
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),

        // Cycle basics
        GlassCard(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(tr.periodBasics, style: AppTextStyles.titleLarge),
              const SizedBox(height: 12),
              _CyclePhaseItem(
                day: 'Jou 1-5',
                title: 'Peryòd',
                description: 'Bag san soti. Matris la debake.',
                color: AppColors.period,
              ),
              _CyclePhaseItem(
                day: 'Jou 6-14',
                title: 'Faz Folikilè',
                description: 'Kò a preparing pou ovilasyon. Yon ovè ap grandi.',
                color: AppColors.fertile,
              ),
              _CyclePhaseItem(
                day: 'Jou 15',
                title: 'Ovilasyon',
                description: 'Yon ovè soti nan ovar yo. Chans gwosè a pi wo.',
                color: AppColors.ovulation,
              ),
              _CyclePhaseItem(
                day: 'Jou 16-28',
                title: 'Faz Luteal',
                description: 'Kò a ap tann. Si pa gen fekondasyon, peryòd ap vini.',
                color: AppColors.luteal,
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),

        // Fun facts
        GlassCard(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Bagay ou pa konnen', style: AppTextStyles.titleLarge),
              const SizedBox(height: 12),
              _FactItem(text: 'Sik mwayèn se 28 jou, men 21-35 jou se nòmal tou'),
              _FactItem(text: 'Peryòd ka dire 3-7 jou'),
              _FactItem(text: 'Ovilasyon rive anviwon jou 15 nan sik 28 jou'),
              _FactItem(text: 'Premye peryòd ou (menarche) rive anviwon 12-13 ane'),
              _FactItem(text: 'Stress, egzèsis, ak maladi ka chanje sik ou'),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildProducts(dynamic tr) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Kalite Pwodwi Mensuel', style: AppTextStyles.headlineMedium),
        const SizedBox(height: 12),
        _ProductCard(
          name: 'Servyèt Sanitè (Pad)',
          description: 'Fasil pou itilize. Vini nan plizyè gwosè. Chanje chak 4-6 èdtan.',
          pros: 'Fasil pou itilize, pa antre nan kò',
          cons: 'Ka santi l mouye, ka deplase',
          color: AppColors.period,
        ),
        const SizedBox(height: 10),
        _ProductCard(
          name: 'Tampoun',
          description: 'Antre nan vajen an. Ka itilize pandan naje. Chanje chak 4-6 èdtan.',
          pros: 'Ka naje ak li, pa santi l',
          cons: 'Ka difisil pou mete, risk TSS',
          color: AppColors.primary,
        ),
        const SizedBox(height: 10),
        _ProductCard(
          name: 'Koupe Menstruel (Cup)',
          description: 'Antre nan vajen an, kenbe san an. Reutilizab pandan ane.',
          pros: 'Ekonmik, ekolojik, dire 10 ane',
          cons: 'Ka difisil pou netwaye, antrenman bezwen',
          color: AppColors.secondary,
        ),
        const SizedBox(height: 10),
        _ProductCard(
          name: 'Panty Liner',
          description: 'Pou bag clair oswa dènye jou peryòd la. Pi mens pase pad.',
          pros: 'Léger, konfòtab',
          cons: 'Pa pou peryòd lou',
          color: AppColors.fertile,
        ),
        const SizedBox(height: 10),
        _ProductCard(
          name: 'Rad Senti (Reusable Pad)',
          description: 'Rad ki lave ak itilize ankò. Ekolojik ak ekonmik.',
          pros: 'Pa gen dechè, bon pou planèt la',
          cons: 'Bezwen lave regilyèman',
          color: AppColors.ovulation,
        ),
      ],
    );
  }

  Widget _buildHygiene(dynamic tr) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(tr.periodHygieneTips, style: AppTextStyles.headlineMedium),
        const SizedBox(height: 12),

        GlassCard(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('✅ Fè sa yo', style: AppTextStyles.titleMedium.copyWith(color: AppColors.success)),
              const SizedBox(height: 8),
              _HygieneItem(text: 'Lave men ou avan ak apre chanje pwodwi'),
              _HygieneItem(text: 'Chanje pad/tampoun chak 4-6 èdtan'),
              _HygieneItem(text: 'Itilize dlo pou netwaye pati prive yo'),
              _HygieneItem(text: 'Sèvi ak rad senti ki prop'),
              _HygieneItem(text: 'Sèvi ak pwodwi ki adapté pou ou'),
              _HygieneItem(text: 'Netwaye menm jan devan anvan dèyè'),
            ],
          ),
        ),
        const SizedBox(height: 12),

        GlassCard(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('❌ Pa fè sa yo', style: AppTextStyles.titleMedium.copyWith(color: AppColors.error)),
              const SizedBox(height: 8),
              _HygieneItem(text: 'Pa itilize menm pad plizyè jou'),
              _HygieneItem(text: 'Pa jete pad nan twalèt la'),
              _HygieneItem(text: 'Pa netwaye ak savon odè nan pati prive'),
              _HygieneItem(text: 'Pa itilize pwodwi ak parfèm'),
              _HygieneItem(text: 'Pa rete twò lontan ak menm pwodwi a'),
              _HygieneItem(text: 'Pa sèvi ak dwòg san konsèy doktè'),
            ],
          ),
        ),
        const SizedBox(height: 12),

        GlassCard(
          gradient: LinearGradient(
            colors: [AppColors.info.withOpacity(0.08), AppColors.info.withOpacity(0.03)],
          ),
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              const Icon(Icons.info_outline, color: AppColors.info, size: 24),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  'Bòn jijèn = konfyans! Pran swen kò ou pandan peryòd la.',
                  style: AppTextStyles.bodyMedium.copyWith(color: AppColors.info),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildFood(dynamic tr) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(tr.periodFood, style: AppTextStyles.headlineMedium),
        const SizedBox(height: 12),

        GlassCard(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('🥬 Manje rich an Fè', style: AppTextStyles.titleMedium),
              const SizedBox(height: 8),
              Text('Spinach, dlo, len, jidon, vyann wouj', style: AppTextStyles.bodyMedium),
              Text('Edou kont anemi pandan peryòd', style: AppTextStyles.bodySmall.copyWith(color: AppColors.textSecondary)),
            ],
          ),
        ),
        const SizedBox(height: 10),

        GlassCard(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('🍌 Fwi', style: AppTextStyles.titleMedium),
              const SizedBox(height: 8),
              Text('Papaya, banan, pòm, bèri', style: AppTextStyles.bodyMedium),
              Text('Vitamin ak mineral pou kò fò', style: AppTextStyles.bodySmall.copyWith(color: AppColors.textSecondary)),
            ],
          ),
        ),
        const SizedBox(height: 10),

        GlassCard(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('🥜 Nwa ak Grenn', style: AppTextStyles.titleMedium),
              const SizedBox(height: 8),
              Text('Amand, flaxseed, grenn kalbas', style: AppTextStyles.bodyMedium),
              Text('Omega 3 edou kont doulè', style: AppTextStyles.bodySmall.copyWith(color: AppColors.textSecondary)),
            ],
          ),
        ),
        const SizedBox(height: 10),

        GlassCard(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('🍵 Bouyon cho', style: AppTextStyles.titleMedium),
              const SizedBox(height: 8),
              Text('Tè jenjanm, tè chamomile, bouyon cho', style: AppTextStyles.bodyMedium),
              Text('Relax kò ou, edou kont kramp', style: AppTextStyles.bodySmall.copyWith(color: AppColors.textSecondary)),
            ],
          ),
        ),
        const SizedBox(height: 10),

        GlassCard(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('🍫 Chokola', style: AppTextStyles.titleMedium),
              const SizedBox(height: 8),
              Text('Chokola nwa (70%+ kakao)', style: AppTextStyles.bodyMedium),
              Text('Magnèzyòm edou kont doulè ak tristès', style: AppTextStyles.bodySmall.copyWith(color: AppColors.textSecondary)),
            ],
          ),
        ),
        const SizedBox(height: 12),

        GlassCard(
          gradient: LinearGradient(
            colors: [AppColors.success.withOpacity(0.08), AppColors.success.withOpacity(0.03)],
          ),
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Text('💧 Bwè anpil dlo!', style: AppTextStyles.titleMedium.copyWith(color: AppColors.success)),
              const SizedBox(height: 4),
              Text('Dlo edou redui kramp ak fatig pandan peryòd', style: AppTextStyles.bodySmall),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTips(dynamic tr) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(tr.periodTips, style: AppTextStyles.headlineMedium),
        const SizedBox(height: 12),
        _TipCard(icon: '🎒', title: 'Pote yon ti sak', desc: 'Gen pad, rad senti, ak dlo ak ou tout tan'),
        const SizedBox(height: 8),
        _TipCard(icon: '🏊', title: 'Naje san pè', desc: 'Ou ka naje pandan peryòd ak tampoun oswa koupe'),
        const SizedBox(height: 8),
        _TipCard(icon: '🏃', title: 'Egzèsis ede', desc: 'Mache, yoga, ak egzèsis edou kont kramp'),
        const SizedBox(height: 8),
        _TipCard(icon: '😴', title: 'Repoze', desc: 'Kò ou bezwen plis repo pandan peryòd la'),
        const SizedBox(height: 8),
        _TipCard(icon: '🧘', title: 'Meditasyon', desc: 'Respire byen pou redui doulè ak estrès'),
        const SizedBox(height: 8),
        _TipCard(icon: '🌡️', title: 'Chofè', desc: 'Mete yon boutèy cho sou vant pou redui kramp'),
        const SizedBox(height: 8),
        _TipCard(icon: '📝', title: 'Jounal', desc: 'Ekri sa ou santi pou konnen Sik ou pi byen'),
        const SizedBox(height: 8),
        _TipCard(icon: '👩‍👩‍👧', title: 'Pale ak yon moun', desc: 'Pa rete poukont ou. Pale ak fanmi oswa zanmi'),
      ],
    );
  }

  Widget _buildBloodColor(dynamic tr) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(tr.bloodColorTitle, style: AppTextStyles.headlineMedium),
        const SizedBox(height: 4),
        Text('Koulè san ou ka di ou anpil bagay sou sante ou', style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSecondary)),
        const SizedBox(height: 12),

        _BloodColorCard(
          color: AppColors.period,
          name: 'Wouj klè',
          meaning: 'Nòmal! San frèch ki soti nan matris la.',
          status: '✅ Nòmal',
          statusColor: AppColors.success,
        ),
        const SizedBox(height: 10),

        _BloodColorCard(
          color: AppColors.error,
          name: 'Wouj fò',
          meaning: 'San ki gen anpil. Peryòd ou ka lou. Chanje pad regilyèman.',
          status: '✅ Nòmal si pa twò lou',
          statusColor: AppColors.success,
        ),
        const SizedBox(height: 10),

        _BloodColorCard(
          color: AppColors.warning,
          name: 'Wouj fonse / Maron',
          meaning: 'Ansyen san ki te rete nan matris la. Souvan nan kòmansman oswa fen peryòd.',
          status: '✅ Nòmal',
          statusColor: AppColors.success,
        ),
        const SizedBox(height: 10),

        _BloodColorCard(
          color: AppColors.textHint,
          name: 'Rose / Klè',
          meaning: 'San ki melanje ak sekresyon. Ka ye nan kòmansman oswa fen peryòd. Toujou nòmal.',
          status: '✅ Nòmal',
          statusColor: AppColors.success,
        ),
        const SizedBox(height: 10),

        _BloodColorCard(
          color: AppColors.luteal,
          name: 'Nwa / Trè fonse',
          meaning: 'Ansyen san. Rive nan fen peryòd. Pa enkyete si li pa gen odè mal.',
          status: '✅ Nòmal si pa gen odè',
          statusColor: AppColors.success,
        ),
        const SizedBox(height: 10),

        _BloodColorCard(
          color: AppColors.secondary,
          name: 'Gri / Blan',
          meaning: 'Sa pa san. Ka ye ak enfeksyon. Chèche èd medikal.',
          status: '⚠️ Al wè dòktè',
          statusColor: AppColors.error,
        ),
        const SizedBox(height: 10),

        _BloodColorCard(
          color: AppColors.info,
          name: 'Ble / Vèt',
          meaning: 'Sa pa san nòmal. Gen yon enfeksyon oswa lòt pwoblèm. Al wè dòktè imedyatman.',
          status: '🚨 AL WÈ DÒKTÈ',
          statusColor: AppColors.error,
        ),
        const SizedBox(height: 12),

        GlassCard(
          gradient: LinearGradient(
            colors: [AppColors.info.withOpacity(0.08), AppColors.info.withOpacity(0.03)],
          ),
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              const Icon(Icons.info_outline, color: AppColors.info, size: 24),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  'Koulè san ka chanje nan mitan peryòd la. Wouj fonse ak maron se souvan nòmal. Si ou enkyete, pale ak dòktè ou.',
                  style: AppTextStyles.bodySmall.copyWith(color: AppColors.info),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildEarlyLate(dynamic tr) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Poukisa Peryòd Prese oswa Reta?', style: AppTextStyles.headlineMedium),
        const SizedBox(height: 12),

        // Early period
        GlassCard(
          gradient: LinearGradient(
            colors: [AppColors.info.withOpacity(0.08), AppColors.info.withOpacity(0.03)],
          ),
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Icon(Icons.info_outline, color: AppColors.info, size: 22),
                  const SizedBox(width: 8),
                  Text(tr.whyIsPeriodEarly, style: AppTextStyles.titleMedium.copyWith(color: AppColors.info)),
                ],
              ),
              const SizedBox(height: 12),
              _EarlyLateItem(icon: '😴', text: 'Dòmi ki pa bon / chanjman orè dòmi'),
              _EarlyLateItem(icon: '🍺', text: 'Bwè anpil alkòl'),
              _EarlyLateItem(icon: '💊', text: 'Pran kontrasepsyon ijans (pilil lendemèn)'),
              _EarlyLateItem(icon: '😰', text: 'Stress oswa estrès mantal'),
              _EarlyLateItem(icon: '🏥', text: 'Enfeksyon oswa maladi'),
              _EarlyLateItem(icon: '🧬', text: 'Endometriyoz'),
              _EarlyLateItem(icon: '⏱️', text: 'Faz luteal ki kout'),
              _EarlyLateItem(icon: '✈️', text: 'Vwayaj oswa chanjman tan'),
            ],
          ),
        ),
        const SizedBox(height: 12),

        // Late period
        GlassCard(
          gradient: LinearGradient(
            colors: [AppColors.warning.withOpacity(0.08), AppColors.warning.withOpacity(0.03)],
          ),
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Icon(Icons.warning_amber, color: AppColors.warning, size: 22),
                  const SizedBox(width: 8),
                  Text(tr.whyIsPeriodLate, style: AppTextStyles.titleMedium.copyWith(color: AppColors.warning)),
                ],
              ),
              const SizedBox(height: 12),
              _EarlyLateItem(icon: '🤰', text: 'Gwosès — chèche tès si ou te gen sèks'),
              _EarlyLateItem(icon: '😰', text: 'Stress ki wo (kortizol)'),
              _EarlyLateItem(icon: '🤒', text: 'Ou te malad resaman'),
              _EarlyLateItem(icon: '⏰', text: 'Ovilasyon ki an reta'),
              _EarlyLateItem(icon: '🧬', text: 'Perimenopòz (apre 40 ane)'),
              _EarlyLateItem(icon: '💊', text: 'Chanjman nan pilil oswa medikaman'),
              _EarlyLateItem(icon: '✈️', text: 'Vwayaj oswa chanjman tan'),
              _EarlyLateItem(icon: '🥗', text: 'Manke vitamin D oswa B12'),
              _EarlyLateItem(icon: '⚖️', text: 'Chanjman pwa (pèdi oswa pran anpil)'),
            ],
          ),
        ),
        const SizedBox(height: 12),

        // Tips
        GlassCard(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Konsèy pou suiv sik ou', style: AppTextStyles.titleMedium),
              const SizedBox(height: 8),
              _TipItem(text: 'Anrejistre chak peryòd ou — dat kòmanse ak dat fini'),
              _TipItem(text: 'Sivri sentòm ou chak jou'),
              _TipItem(text: 'Pa enkyete si 1-2 jou reta — sa nòmal'),
              _TipItem(text: 'Si 7+ jou reta, fè tès gwosès'),
              _TipItem(text: 'Si sik ou pa regilye pandan 3 mwa, al wè dòktè'),
              _TipItem(text: 'Redwi estrès ak dòmi byen edou pou sik regilye'),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildWhenToSeeDoctor(dynamic tr) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(tr.whenToSeeDoctor, style: AppTextStyles.headlineMedium),
        const SizedBox(height: 12),

        GlassCard(
          gradient: LinearGradient(
            colors: [AppColors.error.withOpacity(0.08), AppColors.error.withOpacity(0.03)],
          ),
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Icon(Icons.warning_amber, color: AppColors.error, size: 24),
                  const SizedBox(width: 8),
                  Text('Si w gen siy sa yo, al wè dòktè:', style: AppTextStyles.titleMedium.copyWith(color: AppColors.error)),
                ],
              ),
              const SizedBox(height: 12),
              _DoctorItem(text: 'Peryòd ki twò lou (chanje pad chak 1h oswa mwens)'),
              _DoctorItem(text: 'Doulè ki anpeche w fè aktivite ou'),
              _DoctorItem(text: 'Peryòd ki dire plis pase 7 jou'),
              _DoctorItem(text: 'Pa gen peryòd pandan 3 mwa'),
              _DoctorItem(text: 'Sang ki gen odè mal'),
              _DoctorItem(text: 'Grann fièv pandan peryòd'),
              _DoctorItem(text: 'Gwosè pantalon ki chanje rapidman'),
              _DoctorItem(text: 'Gwosè poitrine ki chanje'),
            ],
          ),
        ),
        const SizedBox(height: 12),

        GlassCard(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Ki lè al lopital?', style: AppTextStyles.titleMedium),
              const SizedBox(height: 8),
              _DoctorItem(text: 'Grann fièv plis pase 38°C'),
              _DoctorItem(text: 'Doulè ki vin pi malrapidman'),
              _DoctorItem(text: 'Bwè dlo ki gen san'),
              _DoctorItem(text: 'Sentòm ki pa amelyore ak medikaman'),
            ],
          ),
        ),
        const SizedBox(height: 12),

        GlassCard(
          gradient: LinearGradient(
            colors: [AppColors.primary.withOpacity(0.08), AppColors.primary.withOpacity(0.03)],
          ),
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              const PamIcon(name: 'medical_team', size: 28, color: AppColors.primary),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Doktè ou se zanmi ou!', style: AppTextStyles.titleMedium.copyWith(color: AppColors.primary)),
                    Text('Pa pè pale ak dòktè sou peryòd ou.', style: AppTextStyles.bodySmall),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _CyclePhaseItem extends StatelessWidget {
  final String day;
  final String title;
  final String description;
  final Color color;

  const _CyclePhaseItem({required this.day, required this.title, required this.description, required this.color});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 60,
            padding: const EdgeInsets.symmetric(vertical: 6),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Center(
              child: Text(day, style: TextStyle(fontSize: 10, color: color, fontWeight: FontWeight.bold)),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: AppTextStyles.titleSmall.copyWith(color: color)),
                Text(description, style: AppTextStyles.bodySmall),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _FactItem extends StatelessWidget {
  final String text;

  const _FactItem({required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('✨ ', style: TextStyle(fontSize: 14)),
          Expanded(child: Text(text, style: AppTextStyles.bodyMedium)),
        ],
      ),
    );
  }
}

class _ProductCard extends StatelessWidget {
  final String name;
  final String description;
  final String pros;
  final String cons;
  final Color color;

  const _ProductCard({required this.name, required this.description, required this.pros, required this.cons, required this.color});

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(name, style: AppTextStyles.titleMedium.copyWith(color: color)),
          const SizedBox(height: 4),
          Text(description, style: AppTextStyles.bodySmall),
          const SizedBox(height: 8),
          Row(
            children: [
              Icon(Icons.check_circle, color: AppColors.success, size: 14),
              const SizedBox(width: 4),
              Expanded(child: Text(pros, style: TextStyle(fontSize: 11, color: AppColors.success))),
            ],
          ),
          const SizedBox(height: 2),
          Row(
            children: [
              Icon(Icons.cancel, color: AppColors.error, size: 14),
              const SizedBox(width: 4),
              Expanded(child: Text(cons, style: TextStyle(fontSize: 11, color: AppColors.error))),
            ],
          ),
        ],
      ),
    );
  }
}

class _HygieneItem extends StatelessWidget {
  final String text;

  const _HygieneItem({required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Text('• $text', style: AppTextStyles.bodyMedium),
    );
  }
}

class _DoctorItem extends StatelessWidget {
  final String text;

  const _DoctorItem({required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.circle, size: 6, color: AppColors.error),
          const SizedBox(width: 8),
          Expanded(child: Text(text, style: AppTextStyles.bodyMedium)),
        ],
      ),
    );
  }
}

class _TipCard extends StatelessWidget {
  final String icon;
  final String title;
  final String desc;

  const _TipCard({required this.icon, required this.title, required this.desc});

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      padding: const EdgeInsets.all(14),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppColors.primaryLight,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(icon, style: const TextStyle(fontSize: 20)),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: AppTextStyles.titleSmall),
                Text(desc, style: AppTextStyles.bodySmall),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _BloodColorCard extends StatelessWidget {
  final Color color;
  final String name;
  final String meaning;
  final String status;
  final Color statusColor;

  const _BloodColorCard({
    required this.color,
    required this.name,
    required this.meaning,
    required this.status,
    required this.statusColor,
  });

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      padding: const EdgeInsets.all(14),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
              border: Border.all(color: color.withOpacity(0.3), width: 2),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name, style: AppTextStyles.titleMedium.copyWith(color: color)),
                const SizedBox(height: 2),
                Text(meaning, style: AppTextStyles.bodySmall),
                const SizedBox(height: 2),
                Text(status, style: TextStyle(fontSize: 11, color: statusColor, fontWeight: FontWeight.bold)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _EarlyLateItem extends StatelessWidget {
  final String icon;
  final String text;

  const _EarlyLateItem({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(icon, style: const TextStyle(fontSize: 16)),
          const SizedBox(width: 8),
          Expanded(child: Text(text, style: AppTextStyles.bodyMedium)),
        ],
      ),
    );
  }
}

class _TipItem extends StatelessWidget {
  final String text;

  const _TipItem({required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('• ', style: TextStyle(color: AppColors.primary)),
          Expanded(child: Text(text, style: AppTextStyles.bodyMedium)),
        ],
      ),
    );
  }
}
