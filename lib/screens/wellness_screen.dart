import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class WellnessScreen extends StatelessWidget {
  const WellnessScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final activities = [
      _WellnessActivity(
        icon: Icons.self_improvement,
        title: 'Yoga',
        description: 'Pran 10 minit pou detann kò w ak lespri w',
        color: Colors.purple,
        tips: [
          'Kòmanse ak respire pwofondman',
          'Fè pozasyon timoun pou 5 minit',
          'Fè etire kò w dousman',
          'Fè 3-4 sik respirasyon chak maten',
        ],
      ),
      _WellnessActivity(
        icon: Icons.fitness_center,
        title: 'Gym',
        description: 'Fè egzèsis pou kenbe fòm',
        color: Colors.orange,
        tips: [
          'Kòmanse ak 10 minit chak jou',
          'Fè egzèsis kadyo (mache, kouri)',
          'Pran dlo regilyèman',
          'Pa blije fè ekstrèm - konsistans se kle',
        ],
      ),
      _WellnessActivity(
        icon: Icons.water_drop,
        title: 'Idratasyon',
        description: 'Bwè ase dlo chak jou',
        color: Colors.blue,
        tips: [
          'Bwè 8 vè dlo pa jou (1.5 - 2 lit)',
          'Met rakèl dlo ak ou toutan',
          'Ajoute sitwon oswa mant pou gou',
          'Evite twòp bwason sikre',
        ],
      ),
      _WellnessActivity(
        icon: Icons.nightlight_round,
        title: 'Meditasyon',
        description: 'Medite pou lapè enteryè',
        color: Colors.teal,
        tips: [
          'Jwenn yon kote trankil',
          'Fèmen je w epi respire pwofondman',
          'Konsantre sou moman prezan an',
          'Kòmanse ak 5 minit, ogmante piti piti',
        ],
      ),
      _WellnessActivity(
        icon: Icons.breakfast_dining,
        title: 'Manje Sante',
        description: 'Manje balanse ak nitritif',
        color: Colors.green,
        tips: [
          'Manje fwi ak legim chak jou',
          'Evite twòp sik ak manje rafine',
          'Manje pòsyon kontwole',
          'Pran tan pou manje - pa prese',
        ],
      ),
      _WellnessActivity(
        icon: Icons.favorite,
        title: 'Swen Pèsonèl',
        description: 'Pran swen tèt ou chak jou',
        color: AppTheme.rose,
        tips: [
          'Pran 5 minit chak maten pou tèt ou',
          'Fè bagay ki fè w kontan',
          'Di non lè w bezwen - fwontyè se enpòtan',
          'Pa bliye dòmi ase (7-8 èdtan)',
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
                child: Icon(activity.icon, color: activity.color, size: 24),
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
                const Row(
                  children: [
                    Icon(Icons.lightbulb, size: 16, color: AppTheme.rose),
                    SizedBox(width: 6),
                    Text(
                      'Konsèy pratik',
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
                        const Icon(Icons.check_circle,
                            size: 16, color: AppTheme.rose),
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
  final IconData icon;
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
