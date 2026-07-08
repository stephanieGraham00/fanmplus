import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../widgets/app_icon.dart';

class WellnessScreen extends StatelessWidget {
  const WellnessScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final activities = [
      _WellnessActivity(
        icon: 'firstAid',
        title: 'Yoga',
        description: 'Prenez 10 minutes pour détendre votre corps et votre esprit',
        color: Colors.purple,
        tips: [
          'Commenceintez à la respiration profonde',
          'Faites la posture de l\'enfant pendant 5 minutes',
          'Étirez votre corps doucement',
          'Faites 3-4 cycles de respiration chaque matin',
        ],
      ),
      _WellnessActivity(
        icon: 'firstAid',
        title: 'Gym',
        description: 'Faites de l\'exercice pour garder la forme',
        color: Colors.orange,
        tips: [
          'Commencez par 10 minutes chaque jour',
          'Faites des exercices cardio (marche, course)',
          'Buvez de l\'eau régulièrement',
          'Ne faites pas d\'excès - la régularité est la clé',
        ],
      ),
      _WellnessActivity(
        icon: 'firstAid',
        title: 'Hydratation',
        description: 'Buvez suffisamment d\'eau chaque jour',
        color: Colors.blue,
        tips: [
          'Buvez 8 verres d\'eau par jour (1,5 - 2 litres)',
          'Gardez une bouteille d\'eau avec vous',
          'Ajoutez du citron ou de la menthe pour le goût',
          'Évitez les boissons trop sucrées',
        ],
      ),
      _WellnessActivity(
        icon: 'firstAid',
        title: 'Méditation',
        description: 'Méditez pour la paix intérieure',
        color: Colors.teal,
        tips: [
          'Trouvez un endroit calme',
          'Fermez les yeux et respirez profondément',
          'Concentrez-vous sur le moment présent',
          'Commencez par 5 minutes, augmentez progressivement',
        ],
      ),
      _WellnessActivity(
        icon: 'firstAid',
        title: 'Alimentation saine',
        description: 'Mangez équilibré et nutritif',
        color: Colors.green,
        tips: [
          'Mangez des fruits et légumes chaque jour',
          'Évitez l\'excès de sucre et d\'aliments transformés',
          'Mangez des portions contrôlées',
          'Prenez le temps de manger - ne vous précipitez pas',
        ],
      ),
      _WellnessActivity(
        icon: 'firstAid',
        title: 'Soins personnels',
        description: 'Prenez soin de vous chaque jour',
        color: AppTheme.rose,
        tips: [
          'Prenez 5 minutes chaque matin pour vous',
          'Faites quelque chose qui vous fait du bien',
          'Dites non quand c\'est nécessaire - les limites sont importantes',
          'N\'oubliez pas de bien dormir (7-8 heures)',
        ],
      ),
    ];

    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [AppTheme.rosePale, AppTheme.lavenderPale],
        ),
      ),
      child: ListView.builder(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
        itemCount: activities.length,
        itemBuilder: (context, index) {
          final activity = activities[index];
          return Card(
            margin: const EdgeInsets.only(bottom: 12),
            child: ExpansionTile(
              leading: CircleAvatar(
                backgroundColor: activity.color.withOpacity(0.15),
                child: AppIcon('firstAid', size: 24, color: activity.color),
              ),
              title: Text(
                activity.title,
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              subtitle: Text(
                activity.description,
                style: const TextStyle(fontSize: 13),
              ),
              childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              expandedCrossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Divider(),
                const SizedBox(height: 4),
                Row(
                  children: [
                    const AppIcon('firstAid', size: 16, color: AppTheme.rose),
                    const SizedBox(width: 6),
                    Text(
                      'Conseils pratiques',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: AppTheme.rose,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                ...activity.tips.map(
                  (tip) => Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const AppIcon('firstAid', size: 16, color: AppTheme.rose),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            tip,
                            style: const TextStyle(fontSize: 14, height: 1.3),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _WellnessActivity {
  final String icon;
  final String title;
  final String description;
  final Color color;
  final List<String> tips;

  const _WellnessActivity({
    required this.icon,
    required this.title,
    required this.description,
    required this.color,
    required this.tips,
  });
}