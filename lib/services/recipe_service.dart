import 'dart:math';

class RecipeService {
  RecipeService._();
  static final _rand = Random();

  static final _names = [
    'Diri sòs pwa ak legim', 'Diri ak pwa wouj', 'Diri jòn ak epis',
    'Mayi moulen ak sòs pwa', 'Pitimi ak lèt kokoye', 'Banann peze ak sòs pwa',
    'Pwason fri ak bannann peze', 'Poul an sòs ak diri', 'Vyann bèf boukannen',
    'Soup joumou tradisyonèl', 'Soup pwa', 'Kalalou ak crab',
    'Akasan', 'Labouyi mayi', 'Labouyi pitimi',
    'Labouyi banann', 'Pen patat', 'Pen kasav ak manba',
    'Tchaka', 'Tonm tonm', 'Mayi bouyi ak koko',
    'Gato kodak', 'Gato labapen', 'Gato siwo myèl',
    'Manba ak kasav', 'Fwi fre ak siwo myèl', 'Ji sitwon ak siwo myèl',
    'Chokola tradisyonèl', 'Ji chadèk', 'Ji kowosol',
    'Salad legim fre', 'Pwa bouyi ak diri', 'Legim ak vyann',
    'Bannann bouyi ak sòs pwa', 'Yanm bouyi ak sòs', 'Kola ak pate',
    'Pate chodyè', 'Pate akód', 'Marinad ak sos pwa',
    'Boulet vyann ak diri', 'Lanbi an sòs', 'Chat ak diri',
    'Akra ak kasav', 'Diri djon djon', 'Soup nanm',
  ];

  static final _ingredients = [
    'diri, pwa, epis, lwil, sèl', 'mayi, pwa, zonyon, lay, epis',
    'pitimi, lèt kokoye, sèl, vaniy', 'banann, lwil, sèl, epis',
    'pwason, sitwon, zepis, lwil', 'poul, tomat, zonyon, epis',
    'vyann bèf, piman dou, sòs tomat', 'joumon, bèf, veje, epis',
    'pwa, crab, kalalou, epis, lwil', 'farinn mayi, lèt, sèl, vaniy',
    'farinn pitimi, lèt, siwo myèl', 'patat, farinn, siwo, lèt kokoye',
    'kasav, manba, siwo myèl', 'mayi, koko, sèl, lwil',
    'farin, ze, siwo, bè', 'farin labapen, ze, siwo, bè',
    'farin, siwo myèl, ze, lèt', 'chokola, lèt, siwo, kanèl',
    'fwi fre, siwo myèl, sitwon', 'legim, vinaigrette, sèl',
    'bannann, yanm, legim, sòs', 'lanbi, epis, lwil, sitwon',
    'chat, diri, pwa, legim', 'malanga, farinn, epis, lwil',
    'djon djon, diri, epis, lwil', 'tchaka, mayi, pwa, koko',
  ];

  static final _instructions = [
    'Netwaye epis yo. Bouyi pwa yo jou lòt jou. Nan yon chodyè, mete lwil, zonyon, epis, pwa a. Kite bouyi 15 minit. Ajoute diri a ak dlo. Kouvri epi kite kwit 25 minit.',
    'Bouyi mayi a nan dlo sale. Pandan se tan, prepare sòs pwa a ak zonyon, lay, epis. Sèvi mayi a ak sòs pwa sou li.',
    'Melanje farinn lan ak dlo cho, ajoute lèt kokoye a, siwo myèl la, vaniy. Kite bouyi 20 minit. Sèvi cho.',
    'Pele bannann yo, koupe an moso, bouyi nan dlo sale. Pandan se tan, fri pwa a ak epis. Peze bannann yo, fri yo jòn anndan lwil cho.',
    'Netwaye pwason an ak sitwon ak sèl. Fri l nan lwil cho jiskaske li jòn. Sèvi ak bannann peze ak sòs pwa.',
    'Koupe poul la an moso. Mete nan chodyè ak zonyon, lay, epis, tomat. Kite bouyi 10 minit. Ajoute dlo ak veje. Kouvri, kite kwit 25 minit. Sèvi ak diri.',
    'Koupe vyann bèf la an ti moso. Marine ak epis, sitwon, lay. Boukannen sou dife 30 minit. Sèvi ak bannann ak legim.',
    'Koupe joumoun nan an moso. Bouyi ak vyann bèf la, veje yo, epis. Kite bouyi 45 minit. Sèvi cho ak pen.',
    'Bouyi pwa yo ak crab la, ajoute kalalou a, epis, lwil. Kite bouyi 30 minit. Sèvi ak diri oswa mayi.',
    'Melanje farinn mayi a ak dlo frèt. Ajoute lèt la, sèl la, vaniy. Kite bouyi 20 minit ajoute siwo myèl. Sèvi cho.',
    'Bouyi farinn pitimi a nan dlo. Ajoute lèt kokoye a ak siwo myèl la. Kite bouyi 15 minit. Sèvi cho ak kasav.',
    'Kuit patat la, kale l, pile l. Melanje ak farinn, siwo, bè. Kwit nan fou a 30 minit. Sèvi cho.',
    'Chofe kasav la sou dife. Etale manba a sou li. Sere nan yon bwat. Manje ak kafe oswa chokola.',
    'Bouyi mayi a ak koko a nan dlo sale. Sèvi cho ak yon ti sòs pwa.',
    'Melanje farinn lan ak ze, siwo, bè. Kwit nan fou a 25 minit. Sèvi ak lèt oswa kafe.',
  ];

  static String get recipe {
    final name = _names[_rand.nextInt(_names.length)];
    final ing = _ingredients[_rand.nextInt(_ingredients.length)];
    final instr = _instructions[_rand.nextInt(_instructions.length)];
    return '$name\n\nEngredyan: $ing\n\nEnstriksyon:\n$instr';
  }

  static String randomName() => _names[_rand.nextInt(_names.length)];
  static String randomIngredients() => _ingredients[_rand.nextInt(_ingredients.length)];
  static String randomInstructions() => _instructions[_rand.nextInt(_instructions.length)];
}
