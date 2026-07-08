class AppConstants {
  static const String appName = 'Fanm+ AI';
  static const String appTagline = 'Konesans, Sante, Libète';
  static const String appVersion = '1.0.0';
  static const String adminEmail = 'admin@fanmplus.com';
  static const String defaultPassword = 'admin123';

  static const double cardRadius = 30;
  static const double cardRadiusSmall = 16;
  static const double paddingLarge = 24;
  static const double paddingMedium = 16;
  static const double paddingSmall = 12;

  static const List<String> symptoms = [
    'Pain', 'Cramps', 'Headache', 'Acne', 'Bloating',
    'Back pain', 'Breast tenderness', 'Fatigue',
    'Nausea', 'Appetite', 'Mood', 'Anxiety',
    'Depression', 'Libido', 'Energy', 'Weight',
    'Cervical mucus', 'Temperature',
  ];

  static const Map<String, String> moodEmojis = {
    'Happy': '😊', 'Loved': '🥰', 'Sad': '😢',
    'Angry': '😡', 'Tired': '😴', 'Stressed': '😰',
    'Excited': '😍',
  };

  static const List<String> motivationalQuotes = [
    'Ou pi fò pase sa w konnen.',
    'Chak fanm gen pouvwa chanje mond lan.',
    'Kò w, règ ou.',
    'Ou pa poukont ou.',
    'Konesans se pouvwa.',
    'Ou merite lanmou ak respè.',
    'Chak jou se yon nouvo kòmansman.',
    'Fò, bèl, san rete!',
  ];

  static const List<String> cyclePhases = [
    'Menstrual', 'Follicular', 'Ovulation', 'Luteal',
  ];

  static const List<int> cycleLengths = [21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32, 33, 34, 35];
  static const List<int> periodLengths = [3, 4, 5, 6, 7, 8];

  // Discharge/cervical mucus types
  static const List<String> dischargeTypes = [
    'normal', 'creamy', 'eggWhite', 'watery', 'sticky',
  ];

  // Discharge colors
  static const List<String> dischargeColors = [
    'clear', 'white', 'yellow', 'green', 'brown',
  ];

  // Mycosis symptoms
  static const List<String> mycosisSymptoms = [
    'itching', 'burning', 'redness', 'swelling', 'pain',
  ];
}
