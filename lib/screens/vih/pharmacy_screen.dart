import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class PharmacyScreen extends StatelessWidget {
  const PharmacyScreen({super.key});

  final List<Map<String, dynamic>> _pharmacies = const [
    {
      'name': 'GHESKIO Famasi',
      'location': '33 Blvd Harry Truman, Pòtoprens',
      'phone': '+50929401431',
      'free': true,
    },
    {
      'name': 'Zanmi Lasante Famasi',
      'location': 'Santo 18A, Croix-des-Bouquets',
      'phone': '+50928130016',
      'free': true,
    },
    {
      'name': 'MSPP (Direksyon Sant Sante)',
      'location': 'Pòtoprens',
      'phone': '+50944328401',
      'free': true,
    },
    {
      'name': 'Hopital Justinien Famasi',
      'location': 'Kap Ayisyen',
      'phone': '',
      'free': true,
    },
    {
      'name': 'Hopital Immaculée Conception',
      'location': 'Les Cayes',
      'phone': '',
      'free': true,
    },
    {
      'name': 'Lopital Inivèsitè Mibalè (HUM)',
      'location': 'Mibalè, Santral',
      'phone': '',
      'free': true,
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
        title: const Text('Koneksyon ak Famasi'),
        backgroundColor: const Color(0xFF6A1B9A),
        foregroundColor: Colors.white,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFF6A1B9A),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Kote jwenn ARV gratis',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'ARV nan klinik Leta se GRATIS. Pa janm sispann pran medikaman '
                  'menm si famasi pa genyen — ale nan klinik la.',
                  style: TextStyle(color: Colors.white70, fontSize: 13),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          ..._pharmacies.map((pharmacy) => Card(
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
                        backgroundColor: const Color(0xFF6A1B9A).withValues(alpha: 0.15),
                        child: const Icon(Icons.pharmacy, color: Color(0xFF6A1B9A)),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          pharmacy['name'],
                          style: const TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 15,
                          ),
                        ),
                      ),
                      if (pharmacy['free'])
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: const Color(0xFF2E7D32),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Text(
                            'GRATIS',
                            style: TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w600),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    pharmacy['location'],
                    style: TextStyle(color: Colors.grey[600], fontSize: 13),
                  ),
                  const SizedBox(height: 8),
                  if (pharmacy['phone'].isNotEmpty)
                    InkWell(
                      onTap: () => _call(pharmacy['phone']),
                      child: Row(
                        children: [
                          const Icon(Icons.phone, size: 16, color: Color(0xFF6A1B9A)),
                          const SizedBox(width: 6),
                          Text(
                            pharmacy['phone'],
                            style: const TextStyle(
                              color: Color(0xFF6A1B9A),
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
                  'Medikaman ARV yo bay an Ayiti',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                    color: Color(0xFF6A1B9A),
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  '• Ténofovir (TDF) + Lamivudine (3TC) + Dolutégravir (DTG)\n'
                  '• Ténofovir (TDF) + Lamivudine (3TC) + Efavirenz (EFV)\n'
                  '• Zidovudine (AZT) + Lamivudine (3TC) + Névirapine (NVP)',
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
