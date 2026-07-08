import 'dart:math';

class MotivationService {
  MotivationService._();

  static final _rand = Random();

  static final _adjs = [
    'bèl', 'fò', 'entelijan', 'kreyatif', 'sensè', 'pasyan', 'dou', 'solid', 'klere', 'kalme',
    'detèmine', 'spirityèl', 'empathetic', 'rezistan', 'kouran', 'lapè', 'seren', 'janti', 'kannar', 'sere',
    'vanyan', 'sensèl', 'amoure', 'presye', 'granmou', 'byenveyan', 'odasye', 'ekselan', 'serye', 'jwaye',
    'optimis', 'konsyan', 'devwe', 'konpwan', 'benevol', 'liberal', 'transparan', 'inovatif', 'dinamik', 'santre',
    'afime', 'remakab', 'rekonesan', 'resiljan', 'saj', 'presan', 'rapid', 'egal', 'imans', 'divès',
    'wèbyen', 'motivatè', 'kolaboratif', 'konpetan', 'deklanche', 'sens', 'kouraz', 'solidè', 'pwomèt', 'rekonfòtan',
    'ekspresif', 'fantastik', 'merveye', 'mayifik', 'sensasyonèl', 'ekstraòdinè', 'enkwayab', 'formidab', 'jenero', 'modès',
    'entegre', 'pèmeyab', 'konsistan', 'devlope', 'endepandan', 'libre', 'otè', 'konsantre', 'byenfeme', 'entwodwi',
    '2èm', '3èm', '4èm', '5èm', '6èm', '7èm', '8èm', '9èm', '10èm', 'finalman',
  ];

  static final _nouns = [
    'fanm', 'reyèl', 'kè', 'lavi', 'rèv', 'lespri', 'santiman', 'lanmou', 'kwayans', 'fòs',
    'libète', 'eksperyans', 'creativite', 'revandikasyon', 'tranquilite', 'siksè', 'konesans', 'èd', 'solèy', 'linivè',
    'pwogrè', 'opòtinite', 'bote', 'pèp', 'kominote', 'lakay', 'lanbiyans', 'syans', 'edikasyon', 'lekti',
    'ekspresyon', 'konf', 'enerji', 'lanfè', 'rezon', 'fasilite', 'karaktè', 'pèsonalite', 'entèlijans', 'kompetans',
    'jistis', 'dwa', 'sante', 'korelasyon', 'opinyon', 'estrateji', 'aksyon', 'devlòpman', 'kanperans', 'konsyans',
    'renesans', 'fason', 'echanj', 'modèl', 'lanmòd', 'rekonèt', 'jesyon', 'epanouyisman', 'detant', 'relaksyasyon',
    'anbisyon', 'pasyon', 'vokasyon', 'meditasyon', 'plezi', 'lanmizik', 'danse', 'chante', 'penti', 'desen',
    'pwezi', 'kont', 'konpetans', 'diplomati', 'entwodiksyon', 'konsèy', 'lapriyè', 'sipò', 'kole', 'fòmasyon',
  ];

  static final _verbs = [
    'reye', 'kreye', 'transfòme', 'enpoze', 'avanse', 'libre', 'brive', 'chanje', 'jere', 'detèmine',
    'pote', 'konprann', 'esprime', 'kominike', 'angaje', 'devlope', 'atire', 'pwoteje', 'anrichi', 'enspire',
    'pèmèt', 'konsantre', 'reyalize', 'partaje', 'kontinye', 'popilarize', 'antre', 'soti', 'monte', 'desann',
    'kalkile', 'antisipe', 'pwograme', 'organize', 'konsevwa', 'kenbe', 'liberasyon', 'pwodiksyon', 'favorize', 'òganize',
    'konsolide', 'reyaji', 'rezoud', 'detekte', 'varye', 'konplete', 'ekzekite', 'itilize', 'analize', 'orëyante',
    'rekonpanse', 'benefisye', 'asepte', 'adopte', 'teste', 'konstate', 'tranformasyon', 'enteresan', 'simplifye', 'kolabore',
    'debat', 'konsilte', 'demontre', 'korespond', 'konpare', 'evolye', 'devlope', 'netwoake', 'pibliye', 'mete',
    'janbe', 'franchi', 'devlope', 'pwodui', 'envesti', 'ekonomize', 'depanse', 'jere', 'administre', 'dirije',
  ];

  static final _templates = [
    'Ou se yon {adj} {noun}!',
    'Chak jou ou vin pi {adj} nan {noun} ou.',
    'Pa janm bliye w ap {verb} ak tout {noun} ou.',
    'Lavi a bèl paske ou {adj} epi w ap {verb}.',
    'Fòs ou se {noun} ou, li fè ou {adj}.',
    'Ou kapab {verb} tout bagay ak {noun} ou.',
    'Kenbe {noun} ou, li pral {verb} w.',
    'Reyèl {noun} w ap {verb} limyè nan lavi w.',
    'Ou se {adj} epitou ou gen yon bèl {noun}.',
    'Santi {noun} ou pandan w ap {verb} lavi a.',
    '{noun} ou se pi bèl kado ou genyen.',
    'W ap {verb} ak tout fòs {noun} ou.',
    'Jodi a se yon jou pou {verb} ak {noun} ou.',
    'Ou merite tout {noun} ki genyen nan lavi a.',
    'Pale ak {noun} ou, koute kè w ki {adj}.',
    'Relaksye w epi {verb} nan {noun} ou.',
    'Chache {noun} ou chak jou pou w ka {adj}.',
    'Lavi mande pou w {verb} ak tout {noun} ou.',
    'Ou gen yon {noun} ki fè w {adj}.',
    'Santi w lib pou {verb} ak tout {noun} ou.',
    'Kontinye {verb}, paske ou se yon {adj} {noun}.',
    'W ap {verb} byen, se {noun} ou k ap gide w.',
    'Ak tout {noun} ou, ou ka {verb} lavi a.',
    'Ou {adj} paske ou konnen {noun} ou.',
    'Jodi a {noun} ou ap {verb} ak tout fòs li.',
    'Pran swen {noun} ou pou w ka toujou {adj}.',
    'Ou se yon modèl {noun} ak yon kè {adj}.',
    'Reflechi sou {noun} ou epi kontinye {verb}.',
    'Nou tout bezwen {noun} pou n ka {adj}.',
    'Lavi a se yon pakèt {noun}, jwi l epi {verb}.',
  ];

  static String generate() {
    final t = _templates[_rand.nextInt(_templates.length)];
    return t
      .replaceAll('{adj}', _adjs[_rand.nextInt(_adjs.length)])
      .replaceAll('{noun}', _nouns[_rand.nextInt(_nouns.length)])
      .replaceAll('{verb}', _verbs[_rand.nextInt(_verbs.length)]);
  }
}
