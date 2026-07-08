import 'package:flutter/material.dart';

class EducationScreen extends StatelessWidget {
  const EducationScreen({super.key});

  final List<Map<String, dynamic>> _topics = const [
    {
      'title': 'Ki sa VIH ye?',
      'icon': Icons.science_outlined,
      'content': 'VIH (Viris Imunodefisyans Imèn) se yon viris ki atake sistèm iminitè a — '
          'defans kò a kont maladi. San tretman, VIH febli kò a jiska li pa ka goumen kont enfeksyon.',
    },
    {
      'title': 'Ki sa SIDA ye?',
      'icon': Icons.warning_amber_outlined,
      'content': 'SIDA (Sindwòm Imunodefisyans Akeri) se dènye etap VIH. Lè yon moun rive nan etap SIDA, '
          'sistèm iminitè a gravement febli epi enfeksyon opòtinis atake kò a. '
          'Avèk ARV, yon moun ki gen VIH pa janm rive nan SIDA.',
    },
    {
      'title': 'Diferans ant VIH ak SIDA',
      'icon': Icons.compare_arrows_outlined,
      'content': 'VIH = viris la. Ou ka gen VIH san ou pa gen SIDA.\n'
          'SIDA = maladi ki rive lè VIH pa trete. Lè taks CD4 tonbe anba 200.\n'
          'Avèk ARV, yon moun ki gen VIH pa janm rive nan SIDA.',
    },
    {
      'title': 'Ki jan VIH transmèt?',
      'icon': Icons.swap_horiz_outlined,
      'content': 'VIH transmèt sèlman nan:\n'
          '1. San — pataje zegwi, sereng, materyèl pou dwòg\n'
          '2. Sèks — san kapòt nan bouch, anouch, dèyè\n'
          '3. Tete — manman bay tibebe tete (redwi ak ARV)\n'
          '4. Gwosès ak akouchman — redwi a mwens pase 2% ak ARV',
    },
    {
      'title': 'Ki jan VIH PA transmèt?',
      'icon': Icons.block_outlined,
      'content': '• Manyen, anbrase, kenbe men\n'
          '• Touse oswa estènen\n'
          '• Pataje asyèt, kwiv, rad, kabann\n'
          '• Bèl, pis moustik, chen, chat\n'
          '• Dlo, manje, twalèt, pisin\n'
          '• Swe, dlo nan je, pipi (san san)',
    },
    {
      'title': 'U=U (Endetektab = Entransmisib)',
      'icon': Icons.verified_outlined,
      'content': 'U=U vle di "Undetectable = Untransmittable". '
          'Lè chaj viral la enferyor a 200 kopi/mL pandan 6 mwa, '
          'yon moun ki gen VIH PA KA TRANSMET VIH nan sèks.',
    },
    {
      'title': 'Ki sa se chaj viral?',
      'icon': Icons.monitor_heart_outlined,
      'content': 'Chaj viral la se kantite viris VIH nan yon gout san:\n'
          '• Enferyor a 200 = enferyor (pa transmèt)\n'
          '• 200-1000 = ba (risk redwi)\n'
          '• Pi wo pase 1000 = wo (transmèt, ajiste tretman)',
    },
    {
      'title': 'Ki sa se taks CD4?',
      'icon': Icons.bloodtype_outlined,
      'content': 'CD4 se selil blanch ki ede konbat enfeksyon. VIH atake selil CD4 yo:\n'
          '• Nòmal: 500-1500\n'
          '• Febl: 200-500\n'
          '• Danjere: anba 200 (risk SIDA)',
    },
    {
      'title': 'Ki moun ki ka gen VIH?',
      'icon': Icons.people_outlined,
      'content': 'NENPÒT MOUN ka gen VIH — gason, fanm, timoun, granmoun, '
          'moun rich, moun pòv, chak ras, chak relijyon. VIH pa chwazi.',
    },
    {
      'title': 'Ki siy VIH?',
      'icon': Icons.health_and_safety_outlined,
      'content': 'Anpil moun pa gen okenn siy pandan plizyè ane. Siy ka gen:\n'
          '• Lafyèv\n'
          '• Anvwa (ganglion) anfle\n'
          '• Fatig, feblès\n'
          '• Pèdi pwa san rezon\n'
          '• Swe nan mitan lannuit\n'
          '• Dyare ki pa pase',
    },
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF121212) : const Color(0xFFF5F5F5),
      appBar: AppBar(
        title: const Text('Edukasyon sou VIH'),
        backgroundColor: const Color(0xFF1565C0),
        foregroundColor: Colors.white,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: _topics.length,
        itemBuilder: (context, index) {
          final topic = _topics[index];
          return Card(
            margin: const EdgeInsets.only(bottom: 10),
            elevation: 1,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: ExpansionTile(
              leading: CircleAvatar(
                backgroundColor: const Color(0xFF1565C0).withValues(alpha: 0.15),
                child: Icon(topic['icon'], color: const Color(0xFF1565C0), size: 20),
              ),
              title: Text(
                topic['title'],
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                ),
              ),
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                  child: Text(
                    topic['content'],
                    style: TextStyle(
                      fontSize: 13,
                      height: 1.6,
                      color: isDark ? Colors.grey[300] : Colors.grey[700],
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
