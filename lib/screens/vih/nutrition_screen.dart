import 'package:flutter/material.dart';

class NutritionScreen extends StatelessWidget {
  const NutritionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF121212) : const Color(0xFFF5F5F5),
      appBar: AppBar(
        title: const Text('Sipò Alimantasyon'),
        backgroundColor: const Color(0xFFE65100),
        foregroundColor: Colors.white,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const _HeaderCard(),
          const SizedBox(height: 16),
          _CategoryCard(
            title: 'Manje ki bon pou sistèm iminitè a',
            color: const Color(0xFF2E7D32),
            emoji: '🥗',
            items: [
              'Fwi — zoranj, chadèk, papay, mango, bannann, chabèk (vitamin C)',
              'Legim — bren, karòt, epina, pwa vèt, pòmde tè',
              'Grenn — mayi, diri, ble, pitimi',
              'Pwoteyin — poul, pwason, ze, pwa, nwa',
              'Lèt ak dérivés — lèt, fwomaj, yaout (kalsyòm)',
              'Lwil — lwil oliv, lwil pistach (gras sante)',
            ],
          ),
          const SizedBox(height: 12),
          _CategoryCard(
            title: 'Manje pou evite',
            color: const Color(0xFFB71C1C),
            emoji: '⚠️',
            items: [
              'Twòp sik (soda, bagay dous)',
              'Twòp grès (manje fri, manje vit)',
              'Manje sal (pwason pa kwi, vyann pa kwi)',
              'Twòp alkòl',
              'Manje ki gen mwens nouriti (farín, bonbon vid)',
            ],
          ),
          const SizedBox(height: 12),
          _CategoryCard(
            title: 'Si ou pa gen anpil lajan',
            color: const Color(0xFFE65100),
            emoji: '💰',
            items: [
              'Achte legim lokal — yo mwens chè',
              'Plante yon ti jaden si ou gen tè',
              'Pwa ak grenn bay pwoteyin pou mwens lajan',
              'Ze yo se bon sous pwoteyin pou pri ba',
            ],
          ),
          const SizedBox(height: 12),
          _CategoryCard(
            title: 'Kijan pou jere lè ou pa gen anvi manje',
            color: const Color(0xFF1565C0),
            emoji: '🍲',
            items: [
              'Manje ti kantite plizyè fwa pa jou (5-6 ti repa)',
              'Chwazi manje ki gen anpil nouriti',
              'Fè soup, bouyon, legim kwit',
              'Manje bannann, farín, diri — men ajoute pwoteyin',
            ],
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFF1565C0).withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFF1565C0).withValues(alpha: 0.3)),
            ),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Dlo enpòtan',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF1565C0),
                    fontSize: 14,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'BWÈ 8 VÈ DLO PA JOU\n\n'
                  'Dlo ede medikaman mache byen. Dlo ede netwaye toksin nan kò.',
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

class _HeaderCard extends StatelessWidget {
  const _HeaderCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFE65100),
        borderRadius: BorderRadius.circular(12),
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Manje byen = Sante byen',
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 8),
          Text(
            'Yon bon alimantasyon ede sistèm iminitè a fò epi ede medikaman yo mache byen.',
            style: TextStyle(color: Colors.white70, fontSize: 13),
          ),
        ],
      ),
    );
  }
}

class _CategoryCard extends StatelessWidget {
  final String title;
  final Color color;
  final String emoji;
  final List<String> items;

  const _CategoryCard({
    required this.title,
    required this.color,
    required this.emoji,
    required this.items,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(emoji, style: const TextStyle(fontSize: 20)),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                    color: color,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          ...items.map((item) => Padding(
            padding: const EdgeInsets.only(bottom: 4),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('•  ', style: TextStyle(color: color)),
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
