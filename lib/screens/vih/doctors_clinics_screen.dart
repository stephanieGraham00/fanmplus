import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class DoctorsClinicsScreen extends StatelessWidget {
  const DoctorsClinicsScreen({super.key});

  final List<Map<String, dynamic>> _clinics = const [
    {
      'name': 'GHESKIO',
      'location': '33 Boulevard Harry Truman, Pòtoprens',
      'phone': '+50929401431',
      'desc': 'Sant tretman VIH, rechèch, ak fòmasyon.',
      'color': Color(0xFF1A5C1A),
    },
    {
      'name': 'Zanmi Lasante (PIH)',
      'location': 'Santo 18A, Croix-des-Bouquets',
      'phone': '+50928130016',
      'desc': 'Sant sante nan Plato Santral ak Latibonit.',
      'color': Color(0xFF2D8A2D),
    },
    {
      'name': 'MSPP - Ministè Sante',
      'location': '1 Angle Maïs Gaté, Pòtoprens',
      'phone': '+50944328401',
      'desc': 'Direksyon nasyonal sante piblik.',
      'color': Color(0xFF00695C),
    },
    {
      'name': 'Hopital Justinien',
      'location': 'Kap Ayisyen',
      'phone': '',
      'desc': 'Lopital nasyonal nan Nòdès.',
      'color': Color(0xFF1565C0),
    },
    {
      'name': 'Hopital Immaculée Conception',
      'location': 'Les Cayes',
      'phone': '',
      'desc': 'Lopital nasyonal nan Sid.',
      'color': Color(0xFFE65100),
    },
    {
      'name': 'Lopital Inivèsitè Mibalè (HUM)',
      'location': 'Mibalè, Santral',
      'phone': '',
      'desc': 'Lopital Zanmi Lasante nan Plato Santral.',
      'color': Color(0xFF6A1B9A),
    },
  ];

  Future<void> _call(String phone) async {
    if (phone.isEmpty) return;
    final uri = Uri.parse('tel:$phone');
    if (await canLaunchUrl(uri)) await launchUrl(uri);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF121212) : const Color(0xFFF5F5F5),
      appBar: AppBar(
        title: const Text('Koneksyon ak Doktè/Klinik'),
        backgroundColor: const Color(0xFF1A5C1A),
        foregroundColor: Colors.white,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFF1A5C1A),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Kote pou jwenn tretman VIH an Ayiti',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'Pran randevou ou chak mwa. Tretman ARV gratis nan klinik Leta.',
                  style: TextStyle(color: Colors.white70, fontSize: 13),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          ..._clinics.map((clinic) => Card(
            margin: const EdgeInsets.only(bottom: 10),
            elevation: 1,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      CircleAvatar(
                        backgroundColor: clinic['color'].withValues(alpha: 0.15),
                        child: Icon(Icons.local_hospital, color: clinic['color']),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          clinic['name'],
                          style: const TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 15,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    clinic['location'],
                    style: TextStyle(color: Colors.grey[600], fontSize: 13),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    clinic['desc'],
                    style: TextStyle(color: Colors.grey[700], fontSize: 13),
                  ),
                  const SizedBox(height: 8),
                  if (clinic['phone'].isNotEmpty)
                    InkWell(
                      onTap: () => _call(clinic['phone']),
                      child: Row(
                        children: [
                          const Icon(Icons.phone, size: 16, color: Color(0xFF1A5C1A)),
                          const SizedBox(width: 6),
                          Text(
                            clinic['phone'],
                            style: const TextStyle(
                              color: Color(0xFF1A5C1A),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            ),
          )),
          const SizedBox(height: 12),
          _InfoBlock(
            title: 'Ki sa m bezwen pote lè m ale nan klinik?',
            items: [
              'Kat idantifikasyon',
              'Dosye medikal (si ou genyen)',
              'Lis medikaman w ap pran yo',
              'Lis kesyon ou vle poze doktè a',
            ],
          ),
          const SizedBox(height: 12),
          _InfoBlock(
            title: 'Ki tès doktè a ka fè?',
            items: [
              'Chaj viral (kantite VIH nan san)',
              'Taks CD4 (nivo selil iminitè)',
              'Tès rezistans (si medikaman an pa mache)',
              'Tès enfeksyon opòtinis (TB, chanpiyon)',
              'Tès gwosès (pou fanm)',
            ],
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
              color: Color(0xFF1A5C1A),
            ),
          ),
          const SizedBox(height: 8),
          ...items.map((item) => Padding(
            padding: const EdgeInsets.only(bottom: 4),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('•  ', style: TextStyle(color: Color(0xFF1A5C1A))),
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
