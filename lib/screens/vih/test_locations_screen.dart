import 'package:flutter/material.dart';

class TestLocationsScreen extends StatelessWidget {
  const TestLocationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF121212) : const Color(0xFFF5F5F5),
      appBar: AppBar(
        title: const Text('Tès VIH Lokal'),
        backgroundColor: const Color(0xFF2E7D32),
        foregroundColor: Colors.white,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFF2E7D32),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Text(
              'Poukisa fè tès VIH?\n\n'
              'Se sèl fason pou konnen si ou gen VIH. '
              'Pi bonè ou konnen, pi bonè ou ka trete. '
              'Avèk tretman, ou ka viv an sante pandan plizyè ane.',
              style: TextStyle(color: Colors.white, fontSize: 13, height: 1.5),
            ),
          ),
          const SizedBox(height: 16),
          const _InfoBlock(
            title: 'Kote pou fè tès VIH an Ayiti',
            items: [
              'Nan tout sant sante Leta',
              'GHESKIO (Pòtoprens) — gratis',
              'Zanmi Lasante — gratis',
              'Klinik mobil',
              'Hopital lokal ou',
              'Kek òganizasyon ofri tès nan kominote',
            ],
          ),
          const SizedBox(height: 12),
          const _InfoBlock(
            title: 'Kalite tès VIH',
            items: [
              'Tès rapid: piki dwèt, rezilta 15-30 minit (99% presizyon)',
              'Tès san (PCR): pran san nan venn, rezilta kèk jou',
              'Tès CD4: montre nivo iminite',
            ],
          ),
          const SizedBox(height: 12),
          const _InfoBlock(
            title: 'Konbyen li koute?',
            items: [
              'Nan klinik Leta: GRATIS',
              'Nan kek famasi/laboratwa: varye',
            ],
          ),
          const SizedBox(height: 12),
          const _InfoBlock(
            title: 'Ki lè pou fè tès?',
            items: [
              'Si ou te fè sèks san kapòt',
              'Si ou te pataje zegwi',
              'Si ou te blese ak yon zegwi ki gen san',
              'Lè w ansent (tout fanm ansent dwe fè tès)',
              'Chak 3-6 mwa si w gen plizyè patnè',
            ],
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFF2D8A2D).withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFF2D8A2D).withValues(alpha: 0.3)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text(
                  'Fenèt (peryòd silans)',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF2E7D32),
                    fontSize: 14,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'Apre yon moun kontamine VIH, tès la ka negatif pandan kèk tan.\n\n'
                  '• Tès rapid: 4-6 semèn pou detekte antikò\n'
                  '• Tès PCR: 10-14 jou\n\n'
                  'Pou sètifye, fè tès 3 mwa apre ekspozon an.',
                  style: TextStyle(fontSize: 13, height: 1.5),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey.shade300),
            ),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Si tès la pozitif',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                    color: Color(0xFF2E7D32),
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  '1. Pa panike — VIH se pa yon lanmò\n'
                  '2. Ale nan yon klinik pou konfime\n'
                  '3. Kòmanse tretman ARV (plis vit posib)\n'
                  '4. Pale ak yon konseyè\n'
                  '5. Kontakte gwoup sipò\n'
                  '6. Di patnè seksyèl ou (pou li ka fè tès tou)',
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

class _InfoBlock extends StatelessWidget {
  final String title;
  final List<String> items;

  const _InfoBlock({required this.title, required this.items});

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
              color: Color(0xFF2E7D32),
            ),
          ),
          const SizedBox(height: 8),
          ...items.map((item) => Padding(
            padding: const EdgeInsets.only(bottom: 4),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('•  ', style: TextStyle(color: Color(0xFF2E7D32))),
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
