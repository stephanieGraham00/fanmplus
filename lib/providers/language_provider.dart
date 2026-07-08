import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

final localeProvider = StateNotifierProvider<LocaleNotifier, Locale>((ref) {
  return LocaleNotifier();
});

final translationsProvider = Provider<AppTranslations>((ref) {
  final locale = ref.watch(localeProvider);
  return AppTranslations(locale);
});

class LocaleNotifier extends StateNotifier<Locale> {
  LocaleNotifier() : super(const Locale('en')) {
    _loadSaved();
  }

  Future<void> _loadSaved() async {
    final prefs = await SharedPreferences.getInstance();
    final code = prefs.getString('language_code') ?? 'en';
    state = Locale(code);
  }

  Future<void> setLocale(Locale locale) async {
    state = locale;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('language_code', locale.languageCode);
  }
}

class AppTranslations {
  final Locale locale;
  AppTranslations(this.locale);

  bool get _isFr => locale.languageCode == 'fr';

  String get appName => _isFr ? 'Fanm+ AI' : 'Fanm+ AI';
  String get tagline => _isFr ? 'Connaissance, Santé, Liberté' : 'Knowledge, Health, Freedom';
  String get welcomeBack => _isFr ? 'Bon retour' : 'Welcome back';
  String get hello => _isFr ? 'Bonjour' : 'Hello';

  // Auth
  String get email => _isFr ? 'E-mail' : 'Email';
  String get password => _isFr ? 'Mot de passe' : 'Password';
  String get enterEmail => _isFr ? 'Entrez votre e-mail' : 'Enter your email';
  String get enterPassword => _isFr ? 'Entrez votre mot de passe' : 'Enter your password';
  String get forgotPassword => _isFr ? 'Mot de passe oublié ?' : 'Forgot password?';
  String get login => _isFr ? 'Connexion' : 'Login';
  String get or => _isFr ? 'ou' : 'or';
  String get continueWith => (String p) => _isFr ? 'Continuer avec $p' : 'Continue with $p';
  String get noAccount => _isFr ? 'Pas de compte ? ' : "Don't have an account? ";
  String get createAccount => _isFr ? 'Créer un compte' : 'Create account';
  String get register => _isFr ? "S'inscrire" : 'Register';
  String get name => _isFr ? 'Nom' : 'Name';
  String get enterName => _isFr ? 'Entrez votre nom' : 'Enter your name';
  String get alreadyHaveAccount => _isFr ? 'Déjà un compte ? ' : 'Already have an account? ';

  // Questionnaire
  String get medicalQuestionnaire => _isFr ? 'Questionnaire Médical' : 'Medical Questionnaire';
  String get step => (int s, int t) => _isFr ? 'Étape $s sur $t' : 'Step $s of $t';
  String get personalInfo => _isFr ? 'Informations Personnelles' : 'Personal Information';
  String get knowYourBody => _isFr ? 'Connais ton corps' : 'Know your body';
  String get age => _isFr ? 'Âge' : 'Age';
  String get ageHint => _isFr ? 'Votre âge (ans)' : 'Your age (years)';
  String get weight => _isFr ? 'Poids' : 'Weight';
  String get weightHint => _isFr ? 'Poids (kg)' : 'Weight (kg)';
  String get height => _isFr ? 'Taille' : 'Height';
  String get heightHint => _isFr ? 'Taille (cm)' : 'Height (cm)';
  String get yourCycle => _isFr ? 'Votre Cycle' : 'Your Cycle';
  String get lastPeriod => _isFr ? 'Dernières règles' : 'Last period';
  String get selectDate => _isFr ? 'Choisir date' : 'Select date';
  String get cycleLengthHint => _isFr ? 'Durée cycle (jours) — normal 21-35' : 'Cycle length (days) — normal 21-35';
  String get periodLengthHint => _isFr ? 'Durée règles (jours) — normal 3-7' : 'Period length (days) — normal 3-7';
  String get family => _isFr ? 'Famille' : 'Family';
  String get haveChildren => _isFr ? 'Avez-vous des enfants ?' : 'Do you have children?';
  String get howManyChildren => _isFr ? 'Combien d\'enfants ?' : 'How many children?';
  String get yes => _isFr ? 'Oui' : 'Yes';
  String get no => _isFr ? 'Non' : 'No';
  String get sexualHealth => _isFr ? 'Santé Sexuelle' : 'Sexual Health';
  String get testedHiv => _isFr ? 'Avez-vous déjà fait un test VIH ?' : 'Have you ever tested for HIV?';
  String get areYouPregnant => _isFr ? 'Êtes-vous enceinte ?' : 'Are you pregnant?';
  String get dueDate => _isFr ? 'Date d\'accouchement' : 'Due date';
  String get selectDueDate => _isFr ? 'Choisir date d\'accouchement' : 'Select due date';
  String get haveHiv => _isFr ? 'Avez-vous le VIH ?' : 'Do you have HIV?';
  String get medicalQuestions => _isFr ? 'Questions Médicales' : 'Medical Questions';
  String get conditionsHint => _isFr ? 'Conditions médicales (séparées par virgule)' : 'Medical conditions (comma separated)';
  String get allergiesHint => _isFr ? 'Allergies (séparées par virgule)' : 'Allergies (comma separated)';
  String get medicationsHint => _isFr ? 'Médicaments (séparés par virgule)' : 'Medications (comma separated)';
  String get safety => _isFr ? 'Sécurité' : 'Safety';
  String get experiencedAbuse => _isFr ? 'Avez-vous subi des violences ?' : 'Have you experienced abuse?';
  String get emergencyContact => _isFr ? 'Contact d\'urgence' : 'Emergency contact';
  String get emergencyContactHint => _isFr ? 'Nom de la personne à contacter' : 'Name of contact person';
  String get emergencyPhoneHint => _isFr ? 'Numéro d\'urgence' : 'Emergency phone number';
  String get confidentialNote => _isFr ? 'Toutes vos informations sont confidentielles et protégées' : 'All your information is confidential and protected';
  String get review => _isFr ? 'Révision' : 'Review';
  String get reviewInfo => _isFr ? 'Vérifiez vos informations avant de terminer' : 'Check your info before finishing';
  String get continueBtn => _isFr ? 'Continuer ♥' : 'Continue ♥';
  String get back => _isFr ? 'Retour' : 'Back';
  String get save => _isFr ? 'Sauvegarder ♥' : 'Save ♥';

  // Home
  String get home => _isFr ? 'Accueil' : 'Home';
  String get yourCycleTitle => _isFr ? 'Votre Cycle' : 'Your Cycle';
  String get dailyWellness => _isFr ? 'Bien-être du jour' : 'Daily Wellness';
  String get water => _isFr ? 'Eau' : 'Water';
  String get exercise => _isFr ? 'Exercice' : 'Exercise';
  String get sleep => _isFr ? 'Sommeil' : 'Sleep';
  String get medication => _isFr ? 'Médicament' : 'Medication';
  String get howAreYou => _isFr ? 'Comment vous sentez-vous ?' : 'How are you feeling?';
  String get quickSymptoms => _isFr ? 'Symptômes Rapides' : 'Quick Symptoms';
  String get yourHealth => _isFr ? 'Votre Santé' : 'Your Health';
  String get sosAlert => _isFr ? 'Alerte Violence SOS' : 'SOS Violence Alert';
  String get sosSubtitle => _isFr ? 'Tapez pour voir les numéros d\'urgence' : 'Tap to see emergency numbers';
  String get pregnancy => _isFr ? 'Grossesse' : 'Pregnancy';
  String get pregnancySubtitle => _isFr ? 'Suivi de grossesse, alimentation, préparation' : 'Pregnancy tracking, food, and birth prep';
  String get hiv => _isFr ? 'VIH' : 'HIV';
  String get hivSubtitle => _isFr ? 'Médicaments, adhérence, alimentation, soutien' : 'Medication, adherence, food, support';
  String get abuse => _isFr ? 'Violence' : 'Abuse';
  String get abuseSubtitle => _isFr ? 'Numéros d\'urgence, vos droits, plan de sécurité' : 'Emergency numbers, your rights, safety plan';
  String get aiChat => _isFr ? 'Chat IA' : 'AI Chat';
  String get aiChatSubtitle => _isFr ? 'Posez des questions sur la santé féminine' : 'Ask questions about women\'s health';
  String get emergencyNumbers => _isFr ? 'Numéros d\'Urgence' : 'Emergency Numbers';
  String get emergencySubtitle => _isFr ? 'Kay Fanm, ambulance, hôpital' : 'Kay Fanm, ambulance, hospital';
  String get days => _isFr ? 'jours' : 'days';
  String get nextPeriod => _isFr ? 'Prochaines Règles' : 'Next Period';
  String get ovulation => _isFr ? 'Ovulation' : 'Ovulation';
  String get fertileWindow => _isFr ? 'Fenêtre Fertile' : 'Fertile Window';
  String get pregnancyChance => _isFr ? 'Chance de Grossesse' : 'Pregnancy Chance';
  String get todaySymptoms => _isFr ? 'Symptômes aujourd\'hui' : 'Today\'s symptoms';
  String get addExercise => _isFr ? 'Ajouter Exercice' : 'Add Exercise';
  String get minutes => _isFr ? 'minutes' : 'minutes';
  String get hours => _isFr ? 'heures' : 'hours';
  String get quality => _isFr ? 'Qualité' : 'Quality';
  String get confirm => _isFr ? 'Confirmer ♥' : 'Confirm ♥';
  String get close => _isFr ? 'Fermer' : 'Close';

  // Calendar
  String get calendar => _isFr ? 'Calendrier' : 'Calendar';
  String get legend => _isFr ? 'Légende' : 'Legend';
  String get period => _isFr ? 'Règles' : 'Period';
  String get fertile => _isFr ? 'Fertile' : 'Fertile';
  String get safe => _isFr ? 'Sans Risque' : 'Safe';
  String get currentPhase => _isFr ? 'Phase Actuelle' : 'Current Phase';
  String get dayOfCycle => (int d) => _isFr ? 'Jour $d du cycle' : 'Day $d of cycle';
  String get noNote => _isFr ? 'Aucune note pour ce jour.' : 'No notes for this day.';
  String get addNote => _isFr ? 'Ajouter Note' : 'Add Note';
  String get writeNote => _isFr ? 'Écrivez votre note...' : 'Write your note...';
  String get delayDays => (int d) => _isFr ? '$d jours de retard' : '$d days late';

  // Self-care
  String get selfCare => _isFr ? 'Bien-être' : 'Self-Care';
  String get selfCareSubtitle => _isFr ? 'Prendre soin de soi, c\'est prendre soin du monde ♥' : 'Taking care of yourself is taking care of the world ♥';
  String get yourMood => _isFr ? 'Votre Humeur' : 'Your Mood';
  String get waterTracker => _isFr ? 'Eau' : 'Water';
  String get waterGoal => (int g) => _isFr ? 'Objectif: $g verres/jour' : 'Goal: $g glasses/day';
  String get thisWeek => _isFr ? 'Cette semaine' : 'This week';
  String get qualityOf => (int q) => _isFr ? 'Qualité $q/5' : 'Quality $q/5';
  String get symptoms => _isFr ? 'Symptômes' : 'Symptoms';
  String get tips => _isFr ? 'Conseils' : 'Tips';
  String get meditation => _isFr ? 'Méditation' : 'Meditation';
  String get meditationDesc => _isFr ? 'Prenez 5 minutes pour bien respirer' : 'Take 5 minutes to breathe deeply';
  String get journal => _isFr ? 'Journal' : 'Journal';
  String get journalDesc => _isFr ? 'Écrivez 3 choses pour lesquelles vous êtes reconnaissante' : 'Write 3 things you\'re grateful for';
  String get walk => _isFr ? 'Marche' : 'Walk';
  String get walkDesc => _isFr ? 'Faites une petite marche de 10 min dehors' : 'Take a 10-minute walk outside';

  // Analysis
  String get analysis => _isFr ? 'Analyse' : 'Analysis';
  String get analysisSubtitle => _isFr ? 'Suivez votre santé avec les données' : 'Track your health with data';
  String get moods => _isFr ? 'Humeurs' : 'Moods';
  String get yourCycleAnalysis => _isFr ? 'Votre Cycle' : 'Your Cycle';
  String get avgCycleLength => _isFr ? 'Durée moyenne du cycle' : 'Average cycle length';
  String get periodDuration => _isFr ? 'Durée des règles' : 'Period duration';
  String get currentPhaseLabel => _isFr ? 'Phase actuelle' : 'Current phase';
  String get nextPeriodLabel => _isFr ? 'Prochaines règles' : 'Next period';
  String get nextOvulationLabel => _isFr ? 'Prochaine ovulation' : 'Next ovulation';
  String get symptomsLabel => _isFr ? 'Symptômes' : 'Symptoms';
  String get cramps => _isFr ? 'Crampes' : 'Cramps';
  String get headache => _isFr ? 'Maux de tête' : 'Headache';
  String get fatigue => _isFr ? 'Fatigue' : 'Fatigue';
  String get other => _isFr ? 'Autre' : 'Other';

  // Profile
  String get profile => _isFr ? 'Profil' : 'Profile';
  String get strongBeautiful => _isFr ? 'Forte, belle, sans limite ! ♥' : 'Strong, beautiful, unstoppable! ♥';
  String get posts => _isFr ? 'Publications' : 'Posts';
  String get followers => _isFr ? 'Abonnés' : 'Followers';
  String get following => _isFr ? 'Abonnements' : 'Following';
  String get settings => _isFr ? 'Paramètres' : 'Settings';
  String get language => _isFr ? 'Langue' : 'Language';
  String get notifications => _isFr ? 'Notifications' : 'Notifications';
  String get enabled => _isFr ? 'Activé' : 'Enabled';
  String get disabled => _isFr ? 'Désactivé' : 'Disabled';
  String get pinLock => _isFr ? 'Verrouillage PIN' : 'PIN Lock';
  String get darkMode => _isFr ? 'Mode Sombre' : 'Dark Mode';
  String get account => _isFr ? 'Compte' : 'Account';
  String get editProfile => _isFr ? 'Modifier le profil' : 'Edit Profile';
  String get premium => _isFr ? 'Premium' : 'Premium';
  String get backupSync => _isFr ? 'Sauvegarde & Sync' : 'Backup & Sync';
  String get healthReport => _isFr ? 'Rapport de santé PDF' : 'Health Report PDF';
  String get logout => _isFr ? 'Déconnexion' : 'Logout';
  String get selectLanguage => _isFr ? 'Choisir la Langue' : 'Select Language';

  // Pregnancy screen
  String get pregnancyTitle => _isFr ? 'Grossesse' : 'Pregnancy';
  String get monthByMonth => _isFr ? 'Mois par mois' : 'Month by month';
  String get food => _isFr ? 'Alimentation' : 'Food';
  String get emergency => _isFr ? 'Urgence' : 'Emergency';
  String get breastfeeding => _isFr ? 'Allaitement' : 'Breastfeeding';
  String get birthPrep => _isFr ? 'Préparation' : 'Birth Prep';
  String get labor => _isFr ? 'Travail' : 'Labor';
  String get quiz => _isFr ? 'Quiz' : 'Quiz';
  String get selectMonth => _isFr ? 'Choisir le mois :' : 'Select month:';
  String get babySize => _isFr ? 'Bébé' : 'Baby';
  String get symptomsWord => _isFr ? 'Symptômes' : 'Symptoms';
  String get advice => _isFr ? 'Conseil' : 'Advice';
  String get goodFoods => (int n) => _isFr ? '✅ Aliments bons ($n)' : '✅ Good Foods ($n)';
  String get avoidFoods => (int n) => _isFr ? '❌ Aliments à éviter ($n)' : '❌ Foods to Avoid ($n)';
  String get emergencySigns => _isFr ? 'Signes de danger — allez à l\'hôpital immédiatement' : 'Danger signs — go to hospital immediately';
  String get haitiNumbers => _isFr ? 'Numéros d\'urgence Haïti' : 'Haiti Emergency Numbers';
  String get breastfeedingTips => (int n) => _isFr ? '🤱 Conseils d\'allaitement ($n)' : '🤱 Breastfeeding Tips ($n)';
  String get birthPrepSteps => _isFr ? '📋 Préparation à l\'accouchement' : '📋 Birth Preparation';
  String get laborStages => _isFr ? '🚼 Étapes du travail' : '🚼 Labor Stages';
  String get duration => _isFr ? 'Durée' : 'Duration';
  String get signs => _isFr ? 'Signes' : 'Signs';
  String get quizTitle => _isFr ? 'Quiz Grossesse' : 'Pregnancy Quiz';
  String get question => (int c, int t) => _isFr ? 'Question $c sur $t' : 'Question $c of $t';
  String get yourScore => (int s, int t) => _isFr ? 'Votre score: $s/$t' : 'Your score: $s/$t';
  String get keepLearning => _isFr ? 'Continuez à apprendre !' : 'Keep learning!';
  String get restart => _isFr ? 'Recommencer ♥' : 'Restart ♥';
  String get correct => _isFr ? 'Bonne réponse !' : 'Correct!';
  String get correctAnswer => (String a) => _isFr ? 'La bonne réponse est: $a' : 'The correct answer is: $a';
  String get next => _isFr ? 'Suivant ♥' : 'Next ♥';
  String get seeScore => _isFr ? 'Voir mon score' : 'See my score';

  // HIV screen
  String get hivTitle => _isFr ? 'VIH' : 'HIV';
  String get info => _isFr ? 'Informations' : 'Info';
  String get medicationsWord => _isFr ? 'Médicaments' : 'Medications';
  String get foodTips => _isFr ? 'Alimentation' : 'Food';
  String get adherence => _isFr ? 'Adhérence' : 'Adherence';
  String get motivation => _isFr ? 'Motivation' : 'Motivation';
  String get medicalAdvice => _isFr ? 'Conseils Médicaux' : 'Medical Advice';
  String get support => _isFr ? 'Soutien' : 'Support';
  String get generalInfo => (int n) => _isFr ? '💡 Infos générales sur le VIH ($n)' : '💡 General HIV Info ($n)';
  String get hivMedications => (int n) => _isFr ? '💊 Médicaments VIH/ARV ($n)' : '💊 HIV Medications/ARV ($n)';
  String get type => _isFr ? 'Type' : 'Type';
  String get schedule => _isFr ? 'Horaire' : 'Schedule';
  String get sideEffects => _isFr ? 'Effets secondaires' : 'Side effects';
  String get markAsTaken => _isFr ? '👆 Marquer comme pris' : '👆 Mark as taken';
  String get taken => _isFr ? '✅ Pris' : '✅ Taken';
  String get foodTipsTitle => (int n) => _isFr ? '🥗 Alimentation et VIH ($n)' : '🥗 Food and HIV ($n)';
  String get adherenceTitle => (int n) => _isFr ? '⏰ Adhérence au traitement ($n)' : '⏰ Treatment Adherence ($n)';
  String get medicationNotes => _isFr ? '📝 Notes sur les médicaments :' : '📝 Medication notes:';
  String get motivationTitle => (int n) => _isFr ? '💪 Motivation ($n)' : '💪 Motivation ($n)';
  String get medicalAdviceTitle => (int n) => _isFr ? '🏥 Conseils Médicaux ($n)' : '🏥 Medical Advice ($n)';
  String get supportTitle => _isFr ? '🤝 Vous n\'êtes pas seule — des personnes peuvent vous aider' : '🤝 You are not alone — people can help you';
  String get supportGroups => _isFr ? 'Groupes de soutien en Haïti' : 'Support Groups in Haiti';
  String get youDeclaredHiv => _isFr ? 'Vous avez déclaré VIH+ — vous recevrez des rappels de médicaments' : 'You declared HIV+ — you will get medication reminders';
  String get generalHivInfo => _isFr ? 'Informations générales sur les médicaments VIH' : 'General info about HIV medications';
  String get called => _isFr ? 'Appelé' : 'Called';

  // Abuse screen
  String get abuseTitle => _isFr ? 'Violence' : 'Abuse';
  String get types => _isFr ? 'Types' : 'Types';
  String get steps => _isFr ? 'Étapes' : 'Steps';
  String get numbers => _isFr ? 'Numéros' : 'Numbers';
  String get yourRights => _isFr ? 'Vos Droits' : 'Your Rights';
  String get safetyPlan => _isFr ? 'Plan de Sécurité' : 'Safety Plan';
  String get protection => _isFr ? 'Protection' : 'Protection';
  String get dangerSigns => _isFr ? 'Signes de Danger' : 'Danger Signs';
  String get abuseTypes => (int n) => _isFr ? 'Types de violence ($n)' : 'Types of Abuse ($n)';
  String get signsWord => _isFr ? 'Signes' : 'Signs';
  String get action => _isFr ? 'Action' : 'Action';
  String get stepsAfterAbuse => _isFr ? 'Étapes pour sortir de la violence' : 'Steps Out of Abuse';
  String get emergencyNumbersHaiti => _isFr ? 'Numéros d\'urgence Haïti' : 'Haiti Emergency Numbers';
  String get callNow => _isFr ? 'Appeler maintenant' : 'Call now';
  String get rightsTitle => _isFr ? 'Les droits des femmes sont les droits humains' : 'Women\'s rights are human rights';
  String get safetyPlanTitle => (int n) => _isFr ? '📋 Plan de sécurité ($n)' : '📋 Safety Plan ($n)';
  String get protectionTitle => (int n) => _isFr ? '🛡️ Conseils de protection ($n)' : '🛡️ Protection Tips ($n)';
  String get dangerSignsTitle => _isFr ? '⚠️ Signes de danger — reconnaissez-les, agissez vite' : '⚠️ Danger signs — recognize them, act fast';

  // AI Chat
  String get aiChatTitle => _isFr ? 'Chat IA' : 'AI Chat';
  String get active => _isFr ? 'Actif' : 'Active';
  String get askQuestion => _isFr ? 'Posez une question...' : 'Ask a question...';
  String get aiWelcome => (String n) => _isFr ? '♥ Bienvenue $n ! Posez-moi une question ou choisissez un sujet.' : "♥ Welcome $n! Ask me a question or choose a topic.";
  String get aiMorningGreeting => (String n) => _isFr ? 'Bonjour $n ♥ Comment allez-vous aujourd\'hui ?' : "Good day $n ♥ How are you today?";
  String get aiPregnantGreeting => (String n) => _isFr ? "Bonjour $n ♥ Comment allez-vous avec bébé ?" : "Hello $n ♥ How are you and the baby?";
  String get aiHivGreeting => (String n) => _isFr ? "Bonjour $n ♥ Je suis contente de vous voir ici. Comment vous sentez-vous ?" : "Hello $n ♥ I'm glad you're here. How are you feeling?";
  String get aiDefaultResponse => (String n) => _isFr ? "♥ Merci $n ! Je peux vous aider sur les règles, la grossesse, le VIH, la violence, la contraception, l'alimentation, la santé mentale et bien d'autres sujets. Choisissez un sujet ci-dessous !" : "♥ Thanks $n! I can help you with periods, pregnancy, HIV, abuse, contraception, food, mental health, and more. Pick a topic below!";
  String get youAreNotAlone => _isFr ? 'Vous n\'êtes pas seule ♥' : 'You are not alone ♥';
  String get emergencyCall => (String n, String p) => _isFr ? "Numéro d'urgence: $n — $p" : "Emergency number: $n — $p";

  // General
  String get loading => _isFr ? 'Chargement...' : 'Loading...';
  String get error => _isFr ? 'Erreur' : 'Error';
  String get success => _isFr ? 'Succès' : 'Success';
  String get saveBtn => _isFr ? 'Sauvegarder' : 'Save';
  String get cancel => _isFr ? 'Annuler' : 'Cancel';
  String get delete => _isFr ? 'Supprimer' : 'Delete';
  String get search => _isFr ? 'Rechercher' : 'Search';
  String get noData => _isFr ? 'Aucune donnée' : 'No data';
  String get retry => _isFr ? 'Réessayer' : 'Retry';
  String get settingsTitle => _isFr ? 'Paramètres' : 'Settings';
  String get help => _isFr ? 'Aide' : 'Help';
  String get about => _isFr ? 'À propos' : 'About';
  String get version => _isFr ? 'Version 1.0.0' : 'Version 1.0.0';

  // Community & Premium
  String get community => _isFr ? 'Communauté' : 'Community';
  String get premiumTitle => _isFr ? 'Premium' : 'Premium';
  String get becomePremium => _isFr ? 'Devenir Premium ♥' : 'Go Premium ♥';

  // Quick topics for AI
  String get topicPeriod => _isFr ? 'Règles' : 'Period';
  String get topicPregnancy => _isFr ? 'Grossesse' : 'Pregnancy';
  String get topicHiv => _isFr ? 'VIH' : 'HIV';
  String get topicAbuse => _isFr ? 'Violence' : 'Abuse';
  String get topicRights => _isFr ? 'Droits' : 'Rights';
  String get topicContraception => _isFr ? 'Contraception' : 'Contraception';
  String get topicFood => _isFr ? 'Alimentation' : 'Food';
  String get topicMentalHealth => _isFr ? 'Santé mentale' : 'Mental Health';
  String get topicEducation => _isFr ? 'Éducation' : 'Education';
  String get topicHealth => _isFr ? 'Santé' : 'Health';

  // Additional Home screen keys
  String get daysUntil => _isFr ? 'jours avant' : 'days until';
  String get todayLabel => _isFr ? "Aujourd'hui" : 'Today';
  String get quickAccess => _isFr ? 'Actions Rapides' : 'Quick Actions';
  String get medicalFile => _isFr ? 'Dossier Médical' : 'Medical File';
  String get howFeeling => _isFr ? 'Comment vous sentez-vous ?' : 'How are you feeling?';
  String get quickSymptomsTitle => _isFr ? 'Symptômes Rapides' : 'Quick Symptoms';
  String get glasses => _isFr ? 'verres' : 'glasses';
  String get moodRecorded => _isFr ? 'Humeur enregistrée !' : 'Mood recorded!';
  String get hunger => _isFr ? 'Faim' : 'Hunger';
  String get backPain => _isFr ? 'Douleur dorsale' : 'Back pain';
  String get energy => _isFr ? 'Énergie' : 'Energy';
  String get chooseSymptoms => _isFr ? 'Choisissez vos symptômes :' : 'Choose your symptoms:';
  String get addSymptoms => _isFr ? 'Ajouter des Symptômes' : 'Add Symptoms';

  // Medical questionnaire additional keys
  String get hivTestedQuestion => _isFr ? 'Avez-vous déjà fait un test VIH ?' : 'Have you ever tested for HIV?';
  String get pregnantNow => _isFr ? 'Êtes-vous enceinte actuellement ?' : 'Are you pregnant now?';
  String get hivStatusQuestion => _isFr ? 'Avez-vous le VIH ?' : 'Do you have HIV?';
  String get abuseQuestion => _isFr ? 'Avez-vous subi des violences ?' : 'Have you experienced abuse?';
  String get childrenQuestion => _isFr ? 'Avez-vous des enfants ?' : 'Do you have children?';
  String get childrenCountLabel => _isFr ? 'Combien d\'enfants ?' : 'How many children?';
  String get childrenCountHint => _isFr ? 'Nombre d\'enfants' : 'Number of children';
  String get dueDateLabel => _isFr ? 'Date d\'accouchement' : 'Due date';
  String get selectDueDate => _isFr ? 'Choisir la date d\'accouchement' : 'Select due date';
  String get stepLabel => (int s, int t) => _isFr ? 'Étape $s sur $t' : 'Step $s of $t';
  String get step1Title => _isFr ? 'Informations Personnelles' : 'Personal Information';
  String get step2Title => _isFr ? 'Votre Cycle' : 'Your Cycle';
  String get step3Title => _isFr ? 'Famille' : 'Family';
  String get step4Title => _isFr ? 'Santé Sexuelle' : 'Sexual Health';
  String get step5Title => _isFr ? 'Questions Médicales' : 'Medical Questions';
  String get step6Title => _isFr ? 'Sécurité' : 'Safety';
  String get step7Title => _isFr ? 'Révision' : 'Review';
  String get step1Desc => _isFr ? 'Connais ton corps' : 'Know your body';
  String get step2Desc => _isFr ? 'Comprendre votre cycle aide à prédire' : 'Understand your cycle helps predict';
  String get step3Desc => _isFr ? 'Parlez-nous de vos enfants' : 'Tell us about your children';
  String get step4Desc => _isFr ? 'Ces informations sont confidentielles' : 'This information is confidential';
  String get step5Desc => _isFr ? 'Conditions médicales et médicaments' : 'Medical conditions and medications';
  String get step6Desc => _isFr ? 'Vous n\'êtes pas seule' : 'You are not alone';
  String get step7Desc => _isFr ? 'Vérifiez avant de terminer' : 'Check before finishing';
  String get lastPeriodLabel => _isFr ? 'Dernières règles' : 'Last period';
  String get years => _isFr ? 'ans' : 'years';
  String get kg => _isFr ? 'kg' : 'kg';
  String get cm => _isFr ? 'cm' : 'cm';
  String get normalRange21_35 => _isFr ? 'Durée (jours) — normal 21-35' : 'Length (days) — normal 21-35';
  String get normalRange3_7 => _isFr ? 'Durée (jours) — normal 3-7' : 'Length (days) — normal 3-7';
  String get ageHintPlaceholder => _isFr ? 'Votre âge' : 'Your age';
  String get weightHintPlaceholder => _isFr ? 'Poids (kg)' : 'Weight (kg)';
  String get heightHintPlaceholder => _isFr ? 'Taille (cm)' : 'Height (cm)';
  String get conditionsHintPlaceholder => _isFr ? 'Ex: diabète, hypertension' : 'E.g. diabetes, hypertension';
  String get allergiesHintPlaceholder => _isFr ? 'Ex: pénicilline, arachides' : 'E.g. penicillin, peanuts';
  String get medicationsHintPlaceholder => _isFr ? 'Médicaments que vous prenez' : 'Medications you take';
  String get emergencyContactHintPlaceholder => _isFr ? 'Nom de la personne' : 'Name of contact person';
  String get emergencyPhoneHintPlaceholder => _isFr ? 'Numéro de téléphone' : 'Phone number';
  String get allInfoConfidential => _isFr ? 'Toutes vos informations sont confidentielles et protégées' : 'All your information is confidential and protected';
  String get reviewYourInfo => _isFr ? 'Vérifiez vos informations avant de terminer' : 'Check your info before finishing';
  String get submitBtn => _isFr ? 'Terminer ♥' : 'Finish ♥';
  String get questionnaireError => _isFr ? 'Erreur lors de l\'enregistrement' : 'Error saving data';

  // AI Chat additional keys
  String get aiWelcomeMsg => _isFr ? '♥ Bienvenue dans Fanm+ AI ! Posez-moi une question ou choisissez un sujet.' : "♥ Welcome to Fanm+ AI! Ask me a question or choose a topic.";
  String get aiActive => _isFr ? 'Actif' : 'Active';
  String get askQuestionPlaceholder => _isFr ? 'Posez une question...' : 'Ask a question...';
  String get periodQuestion => _isFr ? 'Période' : 'Period';
  String get pregnancyQuestion => _isFr ? 'Grossesse' : 'Pregnancy';
  String get hivQuestion => _isFr ? 'VIH' : 'HIV';
  String get abuseQuestionTopic => _isFr ? 'Violence' : 'Abuse';
  String get rightsQuestion => _isFr ? 'Droits' : 'Rights';
  String get contraceptionQuestion => _isFr ? 'Contraception' : 'Contraception';
  String get foodQuestion => _isFr ? 'Alimentation' : 'Food';
  String get mentalHealthQuestion => _isFr ? 'Santé mentale' : 'Mental Health';
  String get educationQuestion => _isFr ? 'Éducation' : 'Education';
  String get healthQuestion => _isFr ? 'Santé' : 'Health';
  String get aiThankYou => _isFr ? '♥ Merci ! Je peux vous aider sur les règles, la grossesse, le VIH, la violence, la contraception, l\'alimentation, la santé mentale et bien d\'autres sujets. Choisissez un sujet !' : '♥ Thanks! I can help you with periods, pregnancy, HIV, abuse, contraception, food, mental health, and more. Pick a topic!';
  String get aiHelpful => _isFr ? 'Je veux vous aider ! Posez-moi une question sur la santé féminine.' : 'I want to help! Ask me about women\'s health.';
  String get aiPeriodResponse => _isFr ? 'Un cycle normal dure 21-35 jours avec des règles de 3-7 jours. Chaque femme est différente ! Suivez votre cycle avec Fanm+ AI pour mieux comprendre votre corps. Si vos règles sont en retard, faites un test de grossesse. ♥' : 'A normal cycle is 21-35 days with a period of 3-7 days. Every woman is different! Track your cycle with Fanm+ AI to better understand your body. If your period is late, take a pregnancy test. ♥';
  String get aiPregnancyResponse => (String n) => _isFr ? '$n, je vois que vous êtes enceinte ! ♥ Voici quelques conseils pour vous. Prenez soin de vous et de bébé !' : '$n, I see you\'re pregnant! ♥ Here are some tips for you. Take care of yourself and baby!';
  String get aiPregnancyGeneric => _isFr ? 'Symptômes de grossesse : retard de règles, nausées matinales, fatigue, seins sensibles. Faites un test de grossesse 1 semaine après le retard de règles. 👶' : 'Pregnancy symptoms: missed period, morning sickness, fatigue, tender breasts. Take a pregnancy test 1 week after a missed period. 👶';
  String get aiHivResponse => (String n) => _isFr ? '$n, vous n\'êtes pas seule. 🎗️ Avec les traitements ARV, les personnes vivant avec le VIH peuvent vivre longtemps et en bonne santé.' : '$n, you are not alone. 🎗️ With ARV treatment, people with HIV can live long and healthy lives.';
  String get aiHivGeneric => _isFr ? 'Le VIH est un virus qui attaque le système immunitaire. Avec les traitements ARV, les personnes peuvent vivre longtemps et en bonne santé. Faites le test régulièrement ! 🎗️' : 'HIV is a virus that attacks the immune system. With ARV treatment, people can live long and healthy lives. Get tested regularly! 🎗️';
  String get aiAbuseResponse => (String n) => _isFr ? '$n, vous n\'êtes pas seule. 🛡️ Vos droits sont importants. Si vous êtes en danger, appelez un numéro d\'urgence.' : '$n, you are not alone. 🛡️ Your rights matter. If you are in danger, call an emergency number.';
  String get aiAbuseGeneric => _isFr ? '🛡️ Les droits des femmes sont les droits humains. Si vous êtes en danger, appelez le 174 (Kay Fanm) ou le 118 (Ambulance).' : '🛡️ Women\'s rights are human rights. If you are in danger, call 174 (Kay Fanm) or 118 (Ambulance).';
  String get aiRightsResponse => _isFr ? 'Les droits des femmes sont les droits humains ! ✊ Autonomie corporelle, éducation, santé, liberté contre la violence. Ne laissez jamais personne vous prendre vos droits !' : 'Women\'s rights are human rights! ✊ Bodily autonomy, education, health, freedom from violence. Never let anyone take your rights away!';
  String get aiContraceptionResponse => _isFr ? 'Il existe de nombreuses méthodes : préservatifs, pilule, DIU, implant, injection, patch. Parlez-en à un médecin pour choisir la meilleure pour vous ! 💊' : 'There are many methods: condoms, pill, IUD, implant, injection, patch. Talk to a doctor to choose what\'s best for you! 💊';
  String get aiNutritionResponse => _isFr ? '🥗 Mangez équilibré, buvez 8 verres d\'eau par jour, évitez trop de sucre et de graisses. Votre santé est votre richesse !' : '🥗 Eat balanced, drink 8 glasses of water daily, avoid too much sugar and fat. Your health is your wealth!';
  String get aiMentalHealthResponse => _isFr ? '🧠 La santé mentale est très importante. Il est normal de se sentir triste, anxieuse ou effrayée. Parlez à quelqu\'un de confiance, faites de l\'exercice, prenez soin de vous. Vous n\'êtes pas seule ♥' : '🧠 Mental health is very important. It\'s normal to feel sad, anxious, or scared. Talk to someone you trust, exercise, take care of yourself. You are not alone ♥';
  String get aiEducationResponse => _isFr ? '🌱 La puberté commence entre 9-16 ans. Votre corps produit des hormones qui causent le développement des seins, des poils, la croissance et les premières règles. Tout cela est normal et beau !' : '🌱 Puberty starts between ages 9-16. Your body produces hormones that cause breast development, hair, growth, and first period. Everything is normal and beautiful!';
  String get aiHealthResponse => _isFr ? '🏥 Si vous ne vous sentez pas bien, allez à l\'hôpital ou appelez un médecin. Ne retardez pas vos soins de santé !' : '🏥 If you don\'t feel well, go to the hospital or call a doctor. Don\'t delay your healthcare!';
  String get aiPregnancyTipResponse => _isFr ? '💡 Voici un conseil pour votre grossesse. Prenez soin de vous et de bébé !' : '💡 Here\'s a tip for your pregnancy. Take care of yourself and baby!';
  String get aiHivMedResponse => _isFr ? '💊 Prenez vos médicaments comme prescrits. L\'adhérence au traitement est essentielle pour rester en bonne santé.' : '💊 Take your medications as prescribed. Treatment adherence is essential to stay healthy.';
  String get aiSafetyResponse => _isFr ? '🛡️ La sécurité est importante. Ayez un plan, gardez des numéros d\'urgence, parlez à quelqu\'un de confiance.' : '🛡️ Safety is important. Have a plan, keep emergency numbers, talk to someone you trust.';
  String get greetingMorning => (String n) => _isFr ? 'Bonjour $n ♥ Comment allez-vous aujourd\'hui ?' : "Good morning $n ♥ How are you today?";
  String get greetingPregnant => (String n) => _isFr ? "Bonjour $n ♥ Comment allez-vous avec bébé ?" : "Hello $n ♥ How are you and the baby?";
  String get greetingHiv => (String n) => _isFr ? "Bonjour $n ♥ Je suis contente de vous voir. Comment vous sentez-vous ?" : "Hello $n ♥ I'm glad to see you. How are you feeling?";
  String get greetingDefault => (String n) => _isFr ? "Bonjour $n ♥ Je suis contente de vous voir ! Comment puis-je vous aider ?" : "Hello $n ♥ Glad to see you! How can I help?";
  String get emergencyContactLabel => (String n, String p) => _isFr ? "Numéro d'urgence: $n — $p" : "Emergency number: $n — $p";

  // Cyber harassment keys
  String get cyberHarassment => _isFr ? 'Harcèlement Numérique' : 'Cyber Harassment';
  String get cyberSubtitle => _isFr ? 'Photos, menaces, chantage en ligne' : 'Photos, threats, blackmail online';
  String get cyberTypes => _isFr ? 'Types de harcèlement en ligne' : 'Types of Cyber Harassment';
  String get cyberSteps => _isFr ? 'Étapes pour agir' : 'Steps to Act';
  String get cyberHelp => _isFr ? 'Numéros d\'aide cyber' : 'Cyber Help Numbers';
  String get notYourFault => _isFr ? 'Ce n\'est pas votre faute. Des personnes peuvent vous aider.' : 'It\'s not your fault. People can help you.';

  // Hygiene Education
  String get periodEducation => _isFr ? 'Éducation Menstruelle' : 'Period Education';
  String get basics => _isFr ? 'Les Bases' : 'Basics';
  String get productsTab => _isFr ? 'Produits' : 'Products';
  String get hygieneTab => _isFr ? 'Hygiène' : 'Hygiene';
  String get foodTab => _isFr ? 'Alimentation' : 'Food';
  String get tipsTab => _isFr ? 'Conseils' : 'Tips';
  String get bloodColorTab => _isFr ? 'Couleur du Sang' : 'Blood Color';
  String get earlyLateTab => _isFr ? 'Tôt/Tard' : 'Early/Late';
  String get whenDoctorTab => _isFr ? 'Quand Aller au Médecin' : 'When to See Doctor';
  String get whatIsPeriod => _isFr ? 'Qu\'est-ce que les Règles?' : 'What is a Period?';
  String get periodBasics => _isFr ? 'Bases du Cycle Menstruel' : 'Menstrual Cycle Basics';
  String get periodHygieneTips => _isFr ? 'Conseils d\'Hygiène' : 'Period Hygiene Tips';
  String get periodFood => _isFr ? 'Aliments Bons pour les Règles' : 'Good Foods for Period';
  String get periodTips => _isFr ? 'Conseils Règles' : 'Period Tips';
  String get bloodColorTitle => _isFr ? 'Guide Couleur du Sang' : 'Period Blood Color Guide';
  String get whyIsPeriodEarly => _isFr ? 'Pourquoi mes règles sont en avance?' : 'Why is my period early?';
  String get whyIsPeriodLate => _isFr ? 'Pourquoi mes règles sont en retard?' : 'Why is my period late?';
  String get whenToSeeDoctor => _isFr ? 'Quand Aller au Médecin' : 'When to See a Doctor';

  // Contraception
  String get contraceptionTitle => _isFr ? 'Contraception' : 'Contraception';
  String get currentMethod => _isFr ? 'Votre Méthode Actuelle' : 'Your Current Method';
  String get recordToday => _isFr ? 'Enregistrer Aujourd\'hui' : 'Record Today';
  String get didYouUseProtection => _isFr ? 'Avez-vous utilisé une protection?' : 'Did you use protection today?';
  String get condom => _isFr ? 'Préservatif' : 'Condom';
  String get pill => _isFr ? 'Pilule' : 'Pill';
  String get injection => _isFr ? 'Injection' : 'Injection';
  String get iud => _isFr ? 'DIU' : 'IUD';
  String get implant => _isFr ? 'Implant' : 'Implant';
  String get protectionSummary => _isFr ? 'Résumé Protection' : 'Protection Summary';
  String get protectedLabel => _isFr ? 'Protégée' : 'Protected';
  String get unprotectedLabel => _isFr ? 'Non Protégée' : 'Unprotected';
  String get historyTab => _isFr ? 'Historique' : 'History';

  // Medical Profile
  String get cycleSummary => _isFr ? 'Résumé du Cycle' : 'Cycle Summary';
  String get phase => _isFr ? 'Phase' : 'Phase';
  String get daysLeft => _isFr ? 'Jours Restants' : 'Days Left';
  String get bodyMetrics => _isFr ? 'Métriques du Corps' : 'Body Metrics';
  String get temperature => _isFr ? 'Température' : 'Temperature';
  String get bloodPressure => _isFr ? 'Tension Artérielle' : 'Blood Pressure';
  String get moodAndSymptoms => _isFr ? 'Humeur & Symptômes' : 'Mood & Symptoms';
  String get medicalInfo => _isFr ? 'Informations Médicales' : 'Medical Information';
  String get addMedicalInfo => _isFr ? 'Ajouter Info Médicale' : 'Add Medical Information';
  String get notEntered => _isFr ? 'Non entré' : 'Not entered';
  String get enterValue => _isFr ? 'Entrez la valeur' : 'Enter value';

  // Reports
  String get reportsTitle => _isFr ? 'Rapports & Graphiques' : 'Reports & Charts';
  String get cyclePhaseBreakdown => _isFr ? 'Répartition des Phases' : 'Cycle Phase Breakdown';
  String get moodTrends => _isFr ? 'Tendances Humeur' : 'Mood Trends';
  String get noMoodData => _isFr ? 'Pas encore de données d\'humeur.' : 'No mood data yet.';
  String get contraceptionStats => _isFr ? 'Stats Contraception' : 'Contraception Stats';
  String get bodyMetricsCharts => _isFr ? 'Métriques du Corps' : 'Body Metrics Charts';
  String get cycleHistory => _isFr ? 'Historique des Cycles' : 'Cycle History';

  // Timeline
  String get dailyJournal => _isFr ? 'Votre Journal' : 'Your Journal';
  String get nutrition => _isFr ? 'Nutrition' : 'Nutrition';
  String get exerciseTrackerLabel => _isFr ? 'Exercice' : 'Exercise';
  String get sleepTrackerLabel => _isFr ? 'Sommeil' : 'Sleep';
  String get notRecorded => _isFr ? 'Pas enregistré' : 'Not recorded';
  String get notSelected => _isFr ? 'Non sélectionné' : 'Not selected';
  String get noSymptoms => _isFr ? 'Pas de symptômes' : 'No symptoms';
  String get weeklySummary => _isFr ? 'Résumé de la Semaine' : 'Weekly Summary';
  String get latestMetrics => _isFr ? 'Dernières Métriques' : 'Latest Metrics';
  String get cycleAnalysis => _isFr ? 'Analyse du Cycle' : 'Cycle Analysis';
  String get enterWeight => _isFr ? 'Entrez le poids (kg)' : 'Enter weight (kg)';

  // Medication
  String get nextDose => _isFr ? 'Prochaine dose' : 'Next dose';
  String get myMedications => _isFr ? 'Mes Médicaments' : 'My Medications';
  String get addMedication => _isFr ? 'Ajouter Médicament' : 'Add Medication';
  String get medicationName => _isFr ? 'Nom du médicament' : 'Medication name';
  String get dosage => _isFr ? 'Dosage' : 'Dosage';
  String get completed => _isFr ? 'Terminé!' : 'Completed!';
  String get pillReminderInfo => _isFr ? 'Vous recevrez un rappel quotidien à 8h.' : 'You will receive a daily reminder at 8am.';

  // Cycle history / adaptive prediction
  String get logPeriod => _isFr ? 'Enregistrer règles' : 'Log Period';
  String get spotting => _isFr ? 'Taches' : 'Spotting';
  String get lightFlow => _isFr ? 'Léger' : 'Light';
  String get mediumFlow => _isFr ? 'Moyen' : 'Medium';
  String get heavyFlow => _isFr ? 'Abondant' : 'Heavy';
  String get viewHistoryFull => _isFr ? 'Voir historique complet' : 'View Full History';
  String get adaptivePrediction => _isFr ? 'Prédiction adaptative' : 'Adaptive Prediction';
  String get basedOnLabel => _isFr ? 'Basé sur' : 'Based on';
  String get lastCyclesLabel => _isFr ? 'derniers cycles' : 'last cycles';
  String get periodLogged => _isFr ? 'Règles enregistrées!' : 'Period logged!';
  String get logFlowTooltip => _isFr ? 'Enregistrer flux' : 'Log flow';
  String get cycleHistoryTitle => _isFr ? 'Historique des Cycles' : 'Cycle History';
  String get cycleSummaryInfo => _isFr ? 'Résumé du cycle' : 'Cycle Summary';
  String get noHistoryYet => _isFr ? 'Aucun historique pour le moment. Commencez à enregistrer vos règles!' : 'No history yet. Start logging your periods!';
  String get cycleCountTitle => _isFr ? 'Cycles enregistrés' : 'Cycles Logged';
  String get avgCycleLenLabel => _isFr ? 'Moy. longueur' : 'Avg. Length';
  String get shortestLabel => _isFr ? 'Plus court' : 'Shortest';
  String get longestLabel => _isFr ? 'Plus long' : 'Longest';
  String get flowIntensityLabel => _isFr ? 'Intensité' : 'Flow Intensity';
  String get tapToLog => _isFr ? 'Tapez pour enregistrer' : 'Tap to log';
  String get startDateLabel => _isFr ? 'Début' : 'Start';
  String get endDateLabel => _isFr ? 'Fin' : 'End';
  String get cycleLengthLabel => _isFr ? 'Durée du cycle' : 'Cycle Length';
  String get yourCyclesLabel => _isFr ? 'Vos cycles' : 'Your Cycles';
  String get loggedPeriods => _isFr ? 'Règles enregistrées' : 'Logged Periods';
  String get logoutConfirmed => _isFr ? 'Déconnexion réussie' : 'Logged out successfully';
  String get predictNextPeriod => _isFr ? 'Période prévue' : 'Predicted Next Period';
  String get predictOvulationDay => _isFr ? 'Ovilaison prévue' : 'Predicted Ovulation';
  String get phaseLabel => _isFr ? 'Phase' : 'Phase';
  String get daysUntilLabel => _isFr ? 'Jours restants' : 'Days until';
  String get basedOnAdaptive => _isFr ? 'Basé sur vos données' : 'Based on your data';
  String get cycleProgressTitle => _isFr ? 'Progression du cycle' : 'Cycle Progress';
  String get cycleCompletedLabel => _isFr ? 'Cycle terminé' : 'Cycle completed';
  String get periodDaysLabel => _isFr ? 'Jours de règles' : 'Period days';
  String get flowLoggedLabel => _isFr ? 'Flux enregistré!' : 'Flow logged!';
  String get logPeriodQuestion => _isFr ? 'Enregistrer vos règles pour aujourd\'hui?' : 'Log your period for today?';
  String get predictNextPeriodLabel => _isFr ? 'Prédiction prochaine période' : 'Next Period Prediction';
  String get remove => _isFr ? 'Supprimer' : 'Remove';

  // Discharge / cervical mucus
  String get discharge => _isFr ? 'Pertes' : 'Discharge';
  String get dischargeType => _isFr ? 'Type de pertes' : 'Discharge Type';
  String get dischargeNormal => _isFr ? 'Normales' : 'Normal';
  String get dischargeCreamy => _isFr ? 'Crémeuses' : 'Creamy';
  String get dischargeEggWhite => _isFr ? 'Blanc d\'œuf' : 'Egg White';
  String get dischargeWatery => _isFr ? 'Liquides' : 'Watery';
  String get dischargeSticky => _isFr ? 'Collantes' : 'Sticky';
  String get dischargeColor => _isFr ? 'Couleur' : 'Color';
  String get clearColor => _isFr ? 'Clair' : 'Clear';
  String get whiteColor => _isFr ? 'Blanc' : 'White';
  String get yellowColor => _isFr ? 'Jaune' : 'Yellow';
  String get greenColor => _isFr ? 'Vert' : 'Green';
  String get brownColor => _isFr ? 'Brun' : 'Brown';
  String get logDischarge => _isFr ? 'Enregistrer pertes' : 'Log Discharge';

  // Mycosis / thrush
  String get mycosis => _isFr ? 'Mycose' : 'Thrush';
  String get mycosisLogLabel => _isFr ? 'Mycose / Infection' : 'Thrush / Infection';
  String get hasMycosis => _isFr ? 'Avez-vous une mycose?' : 'Do you have thrush?';
  String get yesLabel => _isFr ? 'Oui' : 'Yes';
  String get noLabel => _isFr ? 'Non' : 'No';
  String get mycosisSymptoms => _isFr ? 'Symptômes de mycose' : 'Thrush Symptoms';
  String get symptomItching => _isFr ? 'Démangeaisons' : 'Itching';
  String get symptomBurning => _isFr ? 'Brûlure' : 'Burning';
  String get symptomRedness => _isFr ? 'Rougeur' : 'Redness';
  String get symptomSwelling => _isFr ? 'Gonflement' : 'Swelling';
  String get symptomPain => _isFr ? 'Douleur' : 'Pain';
  String get logMycosis => _isFr ? 'Enregistrer mycose' : 'Log Thrush';
  String get mycosisLogged => _isFr ? 'Mycose enregistrée!' : 'Thrush logged!';
  String get dischargeLogged => _isFr ? 'Pertes enregistrées!' : 'Discharge logged!';
}
