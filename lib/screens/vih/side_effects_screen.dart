import 'package:flutter/material.dart';

class SideEffectsScreen extends StatelessWidget {
  const SideEffectsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF121212) : const Color(0xFFF5F5F5),
      appBar: AppBar(
        title: const Text('Jesyon Efè Segondè'),
        backgroundColor: const Color(0xFFB71C1C),
        foregroundColor: Colors.white,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFFB71C1C),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Text(
              'PA SISPANN MEDIKAMAN AKÒZ EFÈ SEGONDÈ\n\n'
              'Efè yo pase souvan apre 2-4 semèn. Kek efè ka jere ak remèd senp. '
              'Sispann medikaman ka fè viris la vin rezistan.',
              style: TextStyle(color: Colors.white, fontSize: 13, height: 1.5),
            ),
          ),
          const SizedBox(height: 16),
          _EffectCard(
            title: 'Maltèt',
            emoji: '🤕',
            solutions: [
              'Pran asetaminofèn (si doktè dakò)',
              'Pran ti repo',
              'Evite limyè klere',
            ],
          ),
          const SizedBox(height: 12),
          _EffectCard(
            title: 'Kè plen / Vomisman',
            emoji: '🤢',
            solutions: [
              'Manje ti repa chak 2-3 èdtan',
              'Evite manje gra',
              'Manje biskwit sale',
              'Bwè dlo ti pa ti pa',
              'Si vomisman pa sispann, pale ak doktè',
            ],
          ),
          const SizedBox(height: 12),
          _EffectCard(
            title: 'Dyare',
            emoji: '💧',
            solutions: [
              'Bwè anpil dlo',
              'Bouyi diri bwouye',
              'Manje bannann mi, pòmde tè bouyi',
              'Evite manje gra, laktoz',
            ],
          ),
          const SizedBox(height: 12),
          _EffectCard(
            title: 'Fatig',
            emoji: '😴',
            solutions: [
              'Dòmi ase (7-8 èdtan)',
              'Fè ti egzèsis',
              'Manje byen',
              'Pa twò travay',
            ],
          ),
          const SizedBox(height: 12),
          _EffectCard(
            title: 'Pwoblèm nè (doulè nan pye)',
            emoji: '🦶',
            solutions: [
              'Fè masaj pye',
              'Benyen ak dlo tyèd',
              'Mache chilyè',
              'Pale ak doktè — gen medikaman pou sa',
            ],
          ),
          const SizedBox(height: 16),
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
                  'Lè ou dwe wè doktè',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: Color(0xFFB71C1C),
                    fontSize: 14,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  '• Si ou pa ka kenbe anyen nan vant\n'
                  '• Si ou gen lafyèv pandan plizyè jou\n'
                  '• Si ou gen doulè grav\n'
                  '• Si po w tounen jòn (siy fwa)\n'
                  '• Si ou gen reyaksyon po (bouton, gratèl)',
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

class _EffectCard extends StatelessWidget {
  final String title;
  final String emoji;
  final List<String> solutions;

  const _EffectCard({
    required this.title,
    required this.emoji,
    required this.solutions,
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
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(emoji, style: const TextStyle(fontSize: 22)),
              const SizedBox(width: 8),
              Text(
                title,
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 15,
                  color: Color(0xFFB71C1C),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          ...solutions.map((s) => Padding(
            padding: const EdgeInsets.only(bottom: 4),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('•  ', style: TextStyle(color: Color(0xFFB71C1C))),
                Expanded(
                  child: Text(
                    s,
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
