import 'dart:math';

class BusinessService {
  BusinessService._();
  static final _rand = Random();

  static final _tips = [
    'Kòmanse vann ti sirèt, gato, bonbon lakay ou.',
    'Achte 5 pwa lwil, vann yo 1 pa 1 fè benefis.',
    'Fè ti jaden nan lakou w — pèsi, tonbezon, epina.',
    'Vann manje prepare lekòl — diri sòs pwa, legim.',
    'Fè klè, siwo myèl, vann nan katye a.',
    'Achte an gwo, divize an ti pake pou vann.',
    'Fè pen, bonbon, gato chak maten, vann nan katye.',
    'Vann dlo glase, ji fwi, fresco nan katye cho.',
    'Fè ti estann pou vann kafe ak pen chak maten.',
    'Koud rad, fè twal, vann abiman dezyèm men.',
    'Fè bèl atizan, ponyèt, zanno ak pèl, vye moso.',
    'Vann pwason sèk, lay, zepis nan mache.',
    'Achte veje nan mache an gwo, vann an detay.',
    'Fè ti peyizol, vann ze, poul, kochon.',
    'Vann prepare sòs pwa, sòs tomat, epis ki pare.',
    'Fè ti boutik lakay ou — vann debaz, savon, diri.',
    'Ofri msye, manikur lakay ou, 150 goud seans.',
    'Vann krèm natirèl ak lwil maskriti, lwil kokoye.',
    'Fè ti bijouteri ak pèl, kèk koulè, vann nan katye.',
    'Vann ti pake farin mayi, farin pitimi, diri.',
    'Achte bannann, varye, yanm, kanna, vann an detay.',
    'Fè atifs nan fèy lajan, fèl pou vann.',
    'Vann diri ak sòs pwa nan katye a midi.',
    'Fè ti biznis kafe ale, 10 goud tas.',
    'Vann ji sitwon, ji chadèk frèt nan katye a.',
    'Fè gato kodak, gato labapen, vann lekòl.',
    'Vann twal netwaye, fè lesiv pou vwazen.',
    'Fè ti jardin potaje — pèsi, tomat, piman.',
    'Vann ze bouyi ak epis — ti goute pou timoun.',
    'Achte rad vye, renouvle yo, vann yo.',
    'Fè ti boutik pwodui bote natirèl.',
    'Vann manba ak kasav, bagay tradisyonèl.',
    'Fè ti livrezon manje kay moun.',
    'Vann plant medsin — fèy doliv, fèy papay, sitwon.',
    'Fè ti komès chabon, bwa pou kwit manje.',
    'Vann glas, ti glase nan katye a.',
    'Fè atifs flè plastik pou simityè.',
    'Vann fwi sèk — pistach, nwa, kachiman.',
    'Fè ti bank kredi wotasyon ak 5 fanm.',
    'Mete 10% chak vant nan yon bokal — se kapital ou.',
    'Pran yon ti kaye, ekri tout lajan k ap rantre ak soti.',
    'Pa janm depanse benefis avan 3 mwa.',
    'Reenvesti 50% benefis ou nan machandiz.',
    'Chache yon patnè — 2 fanm ka fè plis pase yon sèl.',
    'Vann sou WhatsApp — foto pwodwi, voye nan gwoup fanm.',
    'Itilize MonCash pou resevwa peman san kontakte.',
    'Fè ti piblisite vokal nan katye a.',
    'Bay bon jan kalite — kliyan an toujou tounen.',
    'Fè yon bon lapriyè chak maten avan ou kòmanse.',
    'Pa janm dekouraje — chak gwo biznis te kòmanse ak yon ti pa.',
  ];

  static final _microCredits = [
    'Fondasyon FAFE — mikro-krè pou fanm, 0-3% enterè.',
    'Sèvi ak asosyasyon Mama Cash — ede fanm antreprenè.',
    'Kolektif Fon Fanm — prè solidè pou fanm.',
    'MADAME SARAH — prè san garanti, rembouse chak jou.',
    'Sosyete 5 fanm — chak mwa yon moun pran tout kolek la.',
    'Banque de la République — pwogram prè pou ti biznis.',
    'Kore Fanm — òganizasyon ki finanse pwojè fanm.',
    'ACEEN — asosyasyon kredi pou fanm ann Ayiti.',
    'FONKOZE — mikro-finans pou fanm nan milye riral.',
    'Kredi nan asosyasyon lokal — pi bon pase bank.',
    'Prè 3 mwa rembouse ak 20% benefis chak jou.',
    'Chache yon pàtnè ki deja gen yon biznis.',
    'Itilize MonCash pou resevwa peman san kontakte.',
    'Fè yon kont epay nan yon kès popilè.',
    'Pa janm prete nan yon moun ki mande 10% pa semèn.',
  ];

  static final _savings = [
    'Mete 25 goud chak jou nan yon bokal — 750 goud pa mwa.',
    'Achte 1 pwa diri chak jou, vann li 1 pwa pita.',
    'Pa achte bagay ou pa bezwen — se depans inutil.',
    'Fè yon ti jaden — ekonomize sou manje.',
    'Achte an gwo ak lòt fanm pou redwi pri.',
    'Vann sa w pa itilize lakay ou.',
    'Sèvi transpò piblik olye de moto-taxi.',
    'Pa achte rad chak semèn — 1 rad pa mwa ase.',
    'Prepare manje lakay olye de achte deyò.',
    'Mete lajan nan kès popilè a chak mwa.',
    'Fè yon lis sa w bezwen avan w ale nan mache.',
    'Pa janm ale nan mache san lajan kontan.',
    'Ekri tout depans ou chak jou nan yon ti kaye.',
    'Revèye w 30 minit bonè pou prepare manje.',
    'Achte pwodui nan bon jan kalite pou dire lontan.',
  ];

  static String randomTip() => _tips[_rand.nextInt(_tips.length)];
  static String randomMicroCredit() => _microCredits[_rand.nextInt(_microCredits.length)];
  static String randomSavingTip() => _savings[_rand.nextInt(_savings.length)];
  static String randomGeneral() {
    return [_randomItem(_tips), _randomItem(_microCredits), _randomItem(_savings)][_rand.nextInt(3)];
  }

  static String _randomItem(List<String> list) => list[_rand.nextInt(list.length)];
}
