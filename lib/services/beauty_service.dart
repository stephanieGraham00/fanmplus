import 'dart:math';

class BeautyService {
  BeautyService._();
  static final _rand = Random();

  static final _recipes = [
    {'title': 'Mask zaboka ak siwo myèl', 'ing': '½ zaboka + 1 gwo siwo myèl', 'how': 'Pile zaboka a, melanje ak siwo myèl. Mete sou figi 15 minit. Rense ak dlo tyèd. Po w ap vin dou ak briyan.'},
    {'title': 'Lwil maskriti pou cheve', 'ing': '2 gwo lwil maskriti + 5 gout lwil esansyèl lavand', 'how': 'Melanje lwil yo. Mete sou cheve, masaje po tèt. Kouvri ak yon bonè 30 minit. Lave ak chanpou natirèl.'},
    {'title': 'Mask siwo myèl ak sitwon', 'ing': '1 gwo siwo myèl + ½ sitwon', 'how': 'Melanje siwo myèl ak ji sitwon. Mete sou figi 10 minit. Rense byen. Sa ede netwaye po a ak diminye tach.'},
    {'title': 'Gommaj sik ak lwil kokoye', 'ing': '2 gwo sik + 1 gwo lwil kokoye', 'how': 'Melanje sik ak lwil kokoye. Fwote sou po a avèk mouvman sikilè 5 minit. Rense ak dlo tyèd.'},
    {'title': 'Mask lwil oliv ak ze', 'ing': '1 ze + 1 gwo lwil oliv', 'how': 'Bat ze a, ajoute lwil oliv. Mete sou cheve 20 minit. Lave ak dlo frèt. Cheve w ap vin fò ak briyan.'},
    {'title': 'Krèm lwil kokoye ak lwil be karite', 'ing': '3 gwo lwil kokoye + 2 gwo lwil be karite', 'how': 'Chofe lwil yo ansanm, kite refwadi. Sere nan yon bokal. Sèvi chak jou pou po sèch.'},
    {'title': 'Mask labou ak vèje', 'ing': '2 gwo labou (kaolan) + 1 gwo vèje', 'how': 'Melanje labou ak vèje. Mete sou figi 10 minit. Rense ak dlo tyèd. Sa retire pwenti nwa yo.'},
    {'title': 'Lwil kale je ak kamomiy', 'ing': '1 sache kamomiy + dlo cho', 'how': 'Pran yon sache kamomiy, mete nan dlo cho. Refwadi, mete sou je fèmen 10 minit. Sa retire bouk je yo.'},
    {'title': 'Mask papay ak siwo myèl', 'ing': '½ papay mi + 1 gwo siwo myèl', 'how': 'Pile papay la, melanje ak siwo myèl. Mete sou figi 15 minit. Rense. Vitamin A nan papay ede po a.'},
    {'title': 'Sérum vitamin E', 'ing': '2 kapsil vitamin E + 1 gwo lwil amann dou', 'how': 'Pèse kapsil yo, melanje ak lwil amann dou. Sere nan yon ti boutèy. Sèvi chak swa pou po briyan.'},
    {'title': 'Mask kannèl ak siwo myèl', 'ing': '1 ti gwo kannèl + 2 gwo siwo myèl', 'how': 'Melanje kannèl ak siwo myèl. Mete sou figi 10 minit. Rense. Sa ede diminye akne ak enflamasyon.'},
    {'title': 'Tretman cheve ak lwil kokoye', 'ing': '3 gwo lwil kokoye + 1 gwo lwil masjoli', 'how': 'Chofe lwil yo, masaje po tèt ak cheve. Kouvri 30 minit. Lave ak chanpou dou. Fè sa 1 fwa pa semèn.'},
    {'title': 'Mask avwàn ak lèt', 'ing': '3 gwo avwàn + ½ vè lèt', 'how': 'Melanje avwàn ak lèt, kite chita 5 minit. Mete sou figi 15 minit. Rense. Po a ap vin kalme ak dou.'},
    {'title': 'Tòn legim vèt', 'ing': '½ konkonm + ½ sitwon + 1 gwo dlo woz', 'how': 'Pile konkonm nan, ajoute ji sitwon, dlo woz. Sere nan frijidè. Sèvi chak maten kòm tòn pou figi.'},
    {'title': 'Mask lwil masjoli ak siwo myèl', 'ing': '2 gwo lwil masjoli + 1 gwo siwo myèl', 'how': 'Melanje lwil masjoli ak siwo myèl. Mete sou figi 15 minit. Rense. Po a ap vin byen idrate.'},
    {'title': 'Bwòs cheve sèk', 'ing': '1 bwòs cheve ak pwav natirèl', 'how': 'Bwòs cheve ou chak swa avan dòmi pou 5 minit. Sa ede sikilasyon san nan po tèt ak fè cheve grandi.'},
    {'title': 'Mask avoka ak lwil oliv', 'ing': '½ avoka + 1 gwo lwil oliv', 'how': 'Pile avoka a, melanje ak lwil oliv. Mete sou figi 20 minit. Rense. Po a ap vin nouris ak briyan.'},
    {'title': 'Sérum cheve ak gliserin', 'ing': '2 gwo gliserin + 1 gwo lwil rès', 'how': 'Melanje gliserin ak lwil rès. Mete yon ti kantite sou cheve a. Sa fè cheve a briyan san yo pa gra.'},
    {'title': 'Mask konkonm ak vèje', 'ing': '½ konkonm + 1 gwo vèje', 'how': 'Pile konkonm nan, melanje ak vèje. Mete sou figi 10 minit. Rense. Sa lafrechi po a.'},
    {'title': 'Bwason bote', 'ing': '1 vè dlo tyèd + ½ sitwon + 1 ti gwo jengèb', 'how': 'Melanje ji sitwon ak jengèb nan dlo tyèd. Bwe chak maten ajenou. Sa netwaye san an ak fè po a klere.'},
    {'title': 'Mask tomat ak siwo myèl', 'ing': '½ tomat mi + 1 gwo siwo myèl', 'how': 'Pile tomat la, melanje ak siwo myèl. Mete sou figi 15 minit. Rense. Vitamin C nan tomat ede po a.'},
    {'title': 'Huil esansyèl pou detant', 'ing': '5 gout lwil lavand + 3 gout lwil kamomiy + 2 gwo lwil amann dou', 'how': 'Melanje tout lwil yo. Sere nan yon ti boutèy. Sèvi pou masaje tèt, kou, zepòl avan dòmi.'},
    {'title': 'Mask farin mayi ak lèt', 'ing': '2 gwo farin mayi + ½ vè lèt', 'how': 'Melanje farin mayi ak lèt. Mete sou figi 10 minit. Rense. Sa retire sel mò ak netwaye po a.'},
    {'title': 'Tretaman lèv ak siwo myèl', 'ing': '1 gwo siwo myèl + ½ gwo lwil kokoye', 'how': 'Melanje siwo myèl ak lwil kokoye. Mete sou lèv chak swa. Lèv w ap vin dou ak woz.'},
  ];

  static String get randomRecipe {
    final r = _recipes[_rand.nextInt(_recipes.length)];
    return '🌸 ${r['title']}\n\nEngredyan: ${r['ing']}\n\nFason: ${r['how']}';
  }

  static String randomTitle() => _recipes[_rand.nextInt(_recipes.length)]['title'] ?? '';
  static String randomIngredients() => _recipes[_rand.nextInt(_recipes.length)]['ing'] ?? '';
  static String randomHowTo() => _recipes[_rand.nextInt(_recipes.length)]['how'] ?? '';
}
