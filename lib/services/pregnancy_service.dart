import 'dart:math';

class PregnancyService {
  PregnancyService._();

  /// Estimate due date from last menstrual period (LMP)
  static DateTime dueDate(DateTime lmp) => lmp.add(const Duration(days: 280));

  /// Current week of pregnancy
  static int currentWeek(DateTime lmp) {
    final days = DateTime.now().difference(lmp).inDays;
    return (days ~/ 7).clamp(0, 42);
  }

  /// Trimester (1, 2, 3)
  static int trimester(int week) {
    if (week <= 13) return 1;
    if (week <= 27) return 2;
    return 3;
  }

  static final _rand = Random();

  static final _babySizes = [
    'Yon ti grenn diri 🍚',
    'Yon grenn kafe ☕',
    'Yon grenn pwa 🫘',
    'Yon grenn pistach 🥜',
    'Yon ti rezen 🍇',
    'Yon fwi seriz 🍒',
    'Yon fwi frèz 🍓',
    'Yon fwi prinye 🍑',
    'Yon fwi sitwon 🍋',
    'Yon fwa zoranj 🍊',
    'Yon grenn pèmidou 🥚',
    'Yon grenn mango 🥭',
    'Yon grenn chadèk',
    'Yon ti van|grenn',
    'Yon ti boul pate',
    'Yon ti pom 🍎',
    'Yon zaboka 🥑',
    'Yon mango 🥭',
    'Yon kokoye 🥥',
    'Yon ti kale jounou',
    'Yon bannann 🍌',
    'Yon ti papay',
    'Yon kanna',
    'Yon yanm',
    'Yon ti bebe',
    'Yon ti bebe',
    'Yon ti bebe',
    'Yon ti bebe',
    'Yon ti bebe',
    'Yon ti bebe',
    'Yon ti bebe',
    'Yon ti bebe',
    'Yon ti bebe',
    'Yon ti bebe',
    'Yon ti bebe',
    'Yon ti bebe',
    'Yon ti bebe',
    'Yon ti bebe',
    'Yon ti bebe',
    'Yon ti bebe',
    'Yon ti bebe prèt',
  ];

  static final _tips = [
    'Pran asid folik 400 mcg chak jou pou anpeche malfòmasyon.',
    'Bwar 8 vè dlo chak jou pou idratasyon.',
    'Manje fwi ak legim fre chak jou.',
    'Evite fimen, alkòl, ak dwòg pandan gwosès.',
    'Fè egzèsis modere — mache 20 minit chak jou.',
    'Dòmi sou bò gòch pou bon sikilasyon sen.',
    'Pran vitamin prensantal chak jou.',
    'Ale lopital 1 fwa pa mwa pou kontwòl.',
    'Fè tès san pou tcheke anemi ak glisemi.',
    'Si w sienyen, ale lopital imedyatman.',
    'Si doulè nan vant, pa pran medikaman san doktè.',
    'Evite manje sale anpil — li ka leve tansyon.',
    'Pran swen tete ou — yo kap fè mal pandan gwosès.',
    'Fè vaksen tetanòs (2 dòz pandan gwosès).',
    'Si tèt ou vire, chita imedyatman.',
    'Pa pote bagay lou pandan gwosès.',
    'Manje ti pòsyon, chak 2-3 èdtan.',
    'Pratike respirasyon pou prepare akouchman.',
    'Prepare yon lis nimewo ijans pou akouchman.',
    'Fè yon plan akouchman ak doktè ou.',
    'Pale ak bebe w — li tande vwa w depi 18 semèn.',
    'Si ou anemi, manje fèy, bèt, epina.',
    'Evite chat ak chen — maladi toksoplasmoz.',
    'Fè sonografi chak 3 mwa pou wè devlòpman.',
    'Prepare twal bebe a, pisin, matela avan dat la.',
    'Aprann rekonèt siy akouchman (doulè, dlo kase).',
    'Gen yon moun avè w nan sal akouchman.',
    'Aprann tete bay — li pi bon pou bebe a.',
    'Pa kite okenn moun fè w presyon sou bay tete.',
    'Chache sipò fanm ki fèk akouche — yo konprann.',
    'Pratike KANGA (po sou po) depi bebe a fèt.',
    'Okipe tèt ou apre akouchman — gwo chanjman.',
    'Si w santi w tris apre akouchman, pale ak yon doktè.',
    'Depresyon postpartum se reyèl — pa wont pou mande èd.',
    'Li sou devlòpman bebe a chak semèn.',
    'Fè lis non ti bebe a ak mari w.',
    'Prepare lajan pou depans akouchman.',
    'Chache kote ki pi pre w pou akouchman.',
    'Kouche alhò, evite kanpe twòp nan dènye mwa.',
    'Manje pwason (ki gen omega 3) pou sèvo bebe a.',
  ];

  static final _dangerSigns = [
    '⚠️ Siyenman pandan gwosès',
    '⚠️ Doulè nan vant ki pa ale',
    '⚠️ Tèt fè mal grav ak vizyon twoub',
    '⚠️ Bebe a sispann bouje',
    '⚠️ Lapli dlo kase (dlo ap koule)',
    '⚠️ Lafyèv pandan gwosès',
    '⚠️ Vomi twòp (pa ka kenbe anyen)',
    '⚠️ Doule lè w pipi',
    '⚠️ Gonfleman nan figi ak men',
    '⚠️ Batman kè vit san rezon',
    '⚠️ Fòs moute chak jou',
    '⚠️ San ak doulè nan dènye mwa',
  ];

  static String babySize(int week) => _babySizes[week.clamp(0, _babySizes.length - 1)];
  static String tip(int week) => _tips[week % _tips.length];
  static String randomTip() => _tips[_rand.nextInt(_tips.length)];
  static String randomDangerSign() => _dangerSigns[_rand.nextInt(_dangerSigns.length)];
}
