import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class EmergencyContactsScreen extends StatelessWidget {
  const EmergencyContactsScreen({super.key});

  final List<Map<String, dynamic>> _contacts = const [
    {'name': 'Anbilans', 'phone': '115', 'icon': Icons.local_hospital, 'color': Color(0xFFC62828)},
    {'name': 'Pompyè', 'phone': '116', 'icon': Icons.local_fire_department, 'color': Color(0xFFE65100)},
    {'name': 'Polis', 'phone': '114', 'icon': Icons.local_police, 'color': Color(0xFF1565C0)},
    {'name': 'IJANS NASYONAL', 'phone': '911', 'icon': Icons.emergency, 'color': Color(0xFFB71C1C)},
    {'name': 'MSPP (Ministè Sante)', 'phone': '+50944328401', 'icon': Icons.medical_services, 'color': Color(0xFF00695C)},
    {'name': 'GHESKIO', 'phone': '+50929401431', 'icon': Icons.local_hospital, 'color': Color(0xFF1A5C1A)},
    {'name': 'Zanmi Lasante', 'phone': '+50928130016', 'icon': Icons.favorite, 'color': Color(0xFF2D8A2D)},
  ];

  Future<void> _call(String phone) async {
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
        title: const Text('Kontak Dijans'),
        backgroundColor: const Color(0xFFC62828),
        foregroundColor: Colors.white,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFFC62828),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Text(
              'Nan ka dijans, RELE IMEDYATMAN. '
              'Pa ezite — lavi ou enpòtan.',
              style: TextStyle(color: Colors.white, fontSize: 14, height: 1.5),
            ),
          ),
          const SizedBox(height: 16),
          ..._contacts.map((c) => Card(
            margin: const EdgeInsets.only(bottom: 8),
            elevation: 1,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: c['color'].withValues(alpha: 0.15),
                child: Icon(c['icon'], color: c['color']),
              ),
              title: Text(
                c['name'],
                style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
              ),
              trailing: ElevatedButton.icon(
                onPressed: () => _call(c['phone']),
                icon: const Icon(Icons.call, size: 16),
                label: Text(c['phone']),
                style: ElevatedButton.styleFrom(
                  backgroundColor: c['color'],
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
              ),
            ),
          )),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey.shade300),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text(
                  'Ki lè ou dwe rele ijans?',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                    color: Color(0xFFC62828),
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  '• Si ou pa ka respire\n'
                  '• Si ou gen doulè nan pwatrin\n'
                  '• Si ou pèdi konesans\n'
                  '• Si ou gen kriz (konvilsyon)\n'
                  '• Si ou blese grav\n'
                  '• Si ou gen lafyèv ki wo (39°C+)\n'
                  '• Si ou pa ka pale oswa mache',
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
