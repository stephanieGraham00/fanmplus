import 'package:flutter/material.dart';

class PsychologicalSupportScreen extends StatelessWidget {
  const PsychologicalSupportScreen({super.key});

  final List<Map<String, String>> _orgs = const [
    {
      'name': 'Asosyasyon Viv Pozitif',
      'location': 'Pòtoprens',
      'desc': 'Gwoup sipò pou moun k ap viv ak VIH.',
    },
    {
      'name': 'REVS+',
      'location': 'Pòtoprens',
      'desc': 'Réseau des PVVIH — rezo moun ki viv ak VIH.',
    },
    {
      'name': 'KAP (Kolektif Animasyon ak Patisipasyon)',
      'location': 'Ayiti',
      'desc': 'Sipò kominotè ak edikasyon.',
    },
    {
      'name': 'GHESKIO (Konseyè)',
      'location': 'Pòtoprens',
      'desc': 'Sèvis konseyè gratis nan sant VIH.',
    },
    {
      'name': 'Zanmi Lasante (Sante Mantal)',
      'location': 'Plato Santral',
      'desc': 'Pwogram sante mantal entegre.',
    },
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF121212) : const Color(0xFFF5F5F5),
      appBar: AppBar(
        title: const Text('Sipò Sikolojik'),
        backgroundColor: const Color(0xFF00695C),
        foregroundColor: Colors.white,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFF00695C),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Sante mantal enpòtan tou',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'VIH ka lakòz estrès, laperèz, tristès. '
                  'Moun ki resevwa sipò sikolojik viv pi byen ak VIH.',
                  style: TextStyle(color: Colors.white70, fontSize: 13),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'Òganizasyon sipò an Ayiti',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 8),
          ..._orgs.map((org) => Card(
            margin: const EdgeInsets.only(bottom: 8),
            child: ListTile(
              leading: const CircleAvatar(
                backgroundColor: Color(0xFF00695C),
                child: Icon(Icons.psychology, color: Colors.white, size: 20),
              ),
              title: Text(org['name']!),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(org['location']!),
                  Text(
                    org['desc']!,
                    style: const TextStyle(fontSize: 12),
                  ),
                ],
              ),
              isThreeLine: true,
            ),
          )),
          const SizedBox(height: 16),
          _Section(
            title: 'Kisa yon konseyè ka ede w fè?',
            items: [
              'Aksepte dyagnostik VIH la',
              'Pale ak fanmi w sou VIH',
              'Jesyon estrès ak laperèz',
              'Rezoud pwoblèm ak relasyon',
              'Pran desizyon sou sante w',
            ],
          ),
          const SizedBox(height: 12),
          _Section(
            title: 'Kijan pou jere santiman negatif?',
            items: [
              'Pran yon ti tan chak jou pou w chita epi respire',
              'Pale ak yon moun ou konfyans',
              'Ekri santiman w nan yon kaye',
              'Fè egzèsis (mache, danse, travay lakay)',
              'Patisipe nan gwoup sipò — ou pa poukont ou',
            ],
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFFB71C1C).withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFFB71C1C).withValues(alpha: 0.3)),
            ),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Siy ki montre ou bezwen èd pwofesyonèl',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: Color(0xFFB71C1C),
                    fontSize: 14,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  '• Ou pa ka dòmi tout oswa ou dòmi twòp\n'
                  '• Ou pa gen anvi manje\n'
                  '• Ou pa santi w gen espwa\n'
                  '• Ou panse sou lanmò oswa mal\n'
                  '• Ou pa vle pale ak moun\n'
                  '• Ou pa ka pran medikaman ou',
                  style: TextStyle(fontSize: 13, height: 1.5),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _Section extends StatelessWidget {
  final String title;
  final List<String> items;

  const _Section({required this.title, required this.items});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 14,
              color: Color(0xFF00695C),
            ),
          ),
          const SizedBox(height: 8),
          ...items.map((item) => Padding(
            padding: const EdgeInsets.only(bottom: 4),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('•  ', style: TextStyle(color: Color(0xFF00695C))),
                Expanded(
                  child: Text(
                    item,
                    style: TextStyle(
                      fontSize: 13,
                      color: isDark ? Colors.grey[300] : Colors.grey[700],
                    ),
                  ),
                ),
              ],
            ),
          )),
        ],
      ),
    );
  }
}
