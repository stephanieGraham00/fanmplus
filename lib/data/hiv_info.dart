/// Contenu éducatif VIH complet (15 sections).
/// Tout est en français, clair et utile pour les femmes haïtiennes vivant avec le VIH.
class HivInfo {
  HivInfo._();

  static const String icon = 'hiv';

  static const String intro =
      'Cette section vous donne des informations claires et utiles sur la vie avec le VIH en Haïti. '
      'Tout est confidentiel et pensé pour vous aider à rester en bonne santé.';

  static List<HivSection> get sections => const [
    HivSection(
      id: 'medication',
      title: 'Rappel médicament',
      icon: 'medical',
      points: [
        'Les ARV (antirétroviraux) sont les médicaments qui bloquent la multiplication du VIH dans le corps.',
        'Les prendre tous les jours, à la même heure, est la clé d\'une vie longue et saine.',
        'Le traitement ne guérit pas le VIH, mais il le rend indétectable : le virus ne peut plus vous rendre malade ni être transmis (U=U).',
        'Effets secondaires possibles au début : nausées, fatigue, vertiges. Ils disparaissent souvent après quelques semaines.',
        'Ne jamais arrêter les ARV sans avis médical : le virus peut devenir résistant.',
        'Un carnet ou une alarme sur le téléphone aide à ne pas oublier la prise quotidienne.',
      ],
    ),
    HivSection(
      id: 'doctors',
      title: 'Connexion avec médecin / clinique',
      icon: 'doctorBag',
      points: [
        'En Haïti, les sites de traitement VIH (TAR) se trouvent dans les hôpitaux publics et certaines cliniques comme GHESKIO, les Centres de santé communautaires.',
        'Votre médecin suit votre charge virale et votre taux de CD4 tous les 3 à 6 mois.',
        'Types de rendez-vous : consultation médicale, prise de sang, retrait d\'ARV, soutien nutritionnel.',
        'Apportez toujours votre carnet de traitement et vos anciens résultats.',
        'Si vous changez de ville, demandez un transfert de dossier pour continuer vos ARV sans interruption.',
        'Une sage-femme ou un gynécologue peut suivre votre santé reproductive en parallèle.',
      ],
    ),
    HivSection(
      id: 'psychological',
      title: 'Soutien psychologique',
      icon: 'sentiment',
      points: [
        'Vivre avec le VIH peut créer peur, tristesse ou isolement. C\'est normal et vous n\'êtes pas seule.',
        'Parler à un conseiller ou à un pair soutien aide à réduire le stress et la dépression.',
        'En Haïti, des groupes de soutien existent dans plusieurs centres VIH et via des associations communautaires.',
        'La méditation, la prière, la marche et les loisirs protègent votre santé mentale.',
        'Si vous pensez au suicide ou vous sentez débordée, parlez-en immédiatement à un proche ou à un soignant.',
        'Votre valeur ne dépend pas de votre statut VIH : vous méritez amour et respect.',
      ],
    ),
    HivSection(
      id: 'education',
      title: 'Éducation sur le VIH',
      icon: 'hiv',
      points: [
        'VIH = Virus de l\'Immunodéficience Humaine. SIDA = stade avancé non traité du VIH.',
        'Transmission : rapports sexuels sans préservatif, partage de seringues, de la mère à l\'enfant à la naissance ou l\'allaitement.',
        'U=U (Undetectable = Untransmittable) : une charge virale indétectable signifie zéro transmission sexuelle.',
        'Charge virale : quantité de virus dans le sang. Plus elle est basse, mieux vous êtes protégée.',
        'CD4 : globules blancs qui défendent le corps. Un taux bas (<200) augmente le risque d\'infections.',
        'Le VIH ne se transmet pas par la toux, les ustensiles, les câlins ou les moustiques.',
      ],
    ),
    HivSection(
      id: 'transport',
      title: 'Coordination transport',
      icon: 'ambulance',
      points: [
        'Défi : les centres VIH sont souvent loin, les transports coûtent cher et les routes sont difficiles.',
        'Solution : demandez aux centres s\'ils ont un système de navette ou de distribution communautaire des ARV.',
        'Certaines associations livrent les médicaments via des pairs relais dans les quartiers.',
        'Planifiez le trajet la veille et partez tôt pour ne pas manquer la prise du matin.',
        'Ressources : mairies, groupes de femmes, associations locales peuvent aider pour le transport.',
        'En zone rurale, renseignez-vous sur les journées de consultation mobiles.',
      ],
    ),
    HivSection(
      id: 'nutrition',
      title: 'Soutien alimentation',
      icon: 'nutrition',
      points: [
        'Une bonne alimentation renforce votre système immunitaire à côté des ARV.',
        'À manger : riz, haricots, banane, patate, légumes verts, œufs, arachides, poisson frais.',
        'À limiter : alcool, fritures, sucreries en excès, boissons gazeuses.',
        'Recettes à bas prix : bouillon de légumes, riz haricots, mais bouilli, banane plantain.',
        'En cas de diarrhée ou perte d\'appétit, mangez en petites quantités plusieurs fois par jour.',
        'Certains centres VIH offrent une aide nutritionnelle ou des coupons alimentaires.',
      ],
    ),
    HivSection(
      id: 'anonymity',
      title: 'Anonymat',
      icon: 'hacking',
      points: [
        'Votre statut VIH est une information strictement privée et confidentielle.',
        'Aucun membre de la famille ou employeur ne doit y avoir accès sans votre accord.',
        'La loi en Haïti protège la confidentialité des personnes vivant avec le VIH.',
        'Le test peut être fait anonymement dans plusieurs centres et laboratoires.',
        'Si vous subissez une discrimination (travail, école, famille), vous pouvez signaler et demander aide.',
        'Partager votre statut ne regarde que vous : faites-le à votre rythme et en sécurité.',
      ],
    ),
    HivSection(
      id: 'pharmacy',
      title: 'Connexion avec pharmacie',
      icon: 'bottle',
      points: [
        'Les ARV sont disponibles gratuitement dans les sites de traitement agréés (programme national).',
        'Les pharmacies privées les vendent mais ils sont chers : préférez toujours le site TAR gratuit.',
        'Demandez à la pharmacie de vous expliquer l\'heure et le mode de prise exacts.',
        'Gardez vos médicaments au frais et au sec, jamais en plein soleil.',
        'Si un médicament manque, prévenez le centre immédiatement pour éviter une rupture.',
        'Certaines pharmacies proposent un service de rappel par SMS ou téléphone.',
      ],
    ),
    HivSection(
      id: 'sideEffects',
      title: 'Gestion effets secondaires',
      icon: 'pain',
      points: [
        'Fatigue : reposez-vous, mangez équilibré, marchez doucement chaque jour.',
        'Nausées : prenez les ARV avec un peu de nourriture, buvez de l\'eau, évitez les graisses.',
        'Vertiges : levez-vous lentement, évitez de conduire après la prise.',
        'Éruption cutanée : signalez-la au médecin, elle peut être bénigne ou sérieuse.',
        'Rêves bizarres ou insomnie : parlez-en à votre soignant, un ajustement est possible.',
        'Consultez immédiatement si : fièvre forte, jaunisse, essoufflement, gonflement du visage.',
      ],
    ),
    HivSection(
      id: 'digestion',
      title: 'Soutien digestif / infections opportunistes',
      icon: 'firstAid',
      points: [
        'Les infections opportunistes surgissent quand le système immunitaire est faible (CD4 bas).',
        'Tuberculose (TB) : toux durable, fièvre, perte de poids. Très fréquente, dépistage recommandé.',
        'Mycose (candidosique) : démangeaisons, pertes blanches, maux de bouche. Traitable.',
        'PCP (pneumonie) : essoufflement, toux sèche. Urgence si CD4 très bas.',
        'Prévention : prendre les ARV régulièrement, éviter la foule en période d\'épidémie, se laver les mains.',
        'Signalez tout symptôme nouveau à votre médecin rapidement, ne vous soignez pas seule.',
      ],
    ),
    HivSection(
      id: 'emergency',
      title: 'Contacts urgence',
      icon: 'emergency',
      points: [
        'Appelez immédiatement si : malaise grave, difficulté à respirer, évanouissement, fièvre >39°.',
        'Ligne SOS nationale : composez le 114 (police) ou 118 (ambulance) en urgence.',
        'Gardez toujours sur vous : votre carnet VIH, un numéro de proche, le nom de votre centre.',
        'Sac d\'urgence : ARV pour 1 semaine, copie des résultats, une bouteille d\'eau, une carte d\'identité.',
        'Enfants sous ARV : ne jamais interrompre, prévenez l\'école et un proche.',
        'En cas de rupture de médicament, contactez le centre avant d\'arrêter.',
      ],
    ),
    HivSection(
      id: 'localTest',
      title: 'Test VIH local',
      icon: 'medicalTeam',
      points: [
        'Deux types : test rapide (goutte de sang au doigt, résultat en 15-20 min) et test labo (prise de sang).',
        'Où : centres de dépistage volontaire (CDV), hôpitaux, laboratoires,某些 cliniques mobiles.',
        'Prix : souvent gratuit en centre public, sinon 300-1000 gourdes en laboratoire privé.',
        'Fenêtre : attendez 3 semaines après un risque avant de tester pour un résultat fiable.',
        'Après le test : un conseiller explique le résultat et oriente vers le traitement si besoin.',
        'Le test est confidentiel et le conseil avant/après est obligatoire.',
      ],
    ),
    HivSection(
      id: 'medicalHistory',
      title: 'Historique médical personnel',
      icon: 'paper',
      points: [
        'À suivre : dates de prise de sang, charge virale, taux de CD4, changements d\'ARV.',
        'Charge virale indétectable = traitement efficace, continuez sans relâche.',
        'CD4 bas (<200) = renforcer la prévention des infections opportunistes.',
        'Notez aussi les effets secondaires et les maladies pour en parler au médecin.',
        'Ce carnet est à vous : gardez-le précieusement et mettez-le à jour à chaque visite.',
        'En cas de grossesse, le suivi renforcé évite la transmission à l\'enfant (PTME).',
      ],
    ),
    HivSection(
      id: 'futurePlan',
      title: 'Plan d\'avenir',
      icon: 'bow',
      points: [
        'Court terme : prendre ses ARV chaque jour, dormir assez, manger équilibré.',
        'Moyen terme : stabiliser la charge virale indétectable, suivre les rendez-vous.',
        'Long terme : vivre pleinement, travailler, fonder une famille, rester indétectable.',
        'Plan d\'action : fixer une alarme médicament, choisir un proche de confiance, noter ses objectifs.',
        'Parlez de votre projet de vie (études, famille) à votre équipe soignante : ils vous aideront.',
        'Vous pouvez vieillir en bonne santé avec le VIH grâce au traitement continu.',
      ],
    ),
    HivSection(
      id: 'offline',
      title: 'Mode hors-ligne',
      icon: 'community',
      points: [
        'Le mode hors-ligne permet de lire ces informations sans internet, même en zone rurale.',
        'Tout le contenu VIH est stocké dans l\'application : pas besoin de réseau pour le consulter.',
        'Pratique en cas de coupure, de voyage ou de batterie limitée.',
        'Vos notes et rappels fonctionnent aussi sans connexion.',
        'Reconnectez-vous pour synchroniser vos rendez-vous ou contacter un centre.',
        'L\'essentiel est d\'avoir les bons réflexes même sans internet : cette app vous accompagne.',
      ],
    ),
  ];
}

class HivSection {
  final String id;
  final String title;
  final String icon;
  final List<String> points;

  const HivSection({
    required this.id,
    required this.title,
    required this.icon,
    required this.points,
  });
}
