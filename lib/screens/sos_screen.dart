import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../theme/app_theme.dart';
import '../utils/constants.dart';

class SosScreen extends StatelessWidget {
  const SosScreen({super.key});

  Future<void> _call(String number) async {
    final uri = Uri.parse('tel:$number');
    if (await canLaunchUrl(uri)) await launchUrl(uri);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: [Color(0xFFFFE0E0), Color(0xFFFFF0F5)]),
      ),
      child: SafeArea(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: const BoxDecoration(
                gradient: LinearGradient(colors: [Colors.red, Colors.redAccent]),
                borderRadius: BorderRadius.vertical(bottom: Radius.circular(30)),
              ),
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(color: Colors.white.withOpacity(0.2), shape: BoxShape.circle),
                    child: const Icon(Icons.emergency, size: 48, color: Colors.white),
                  ),
                  const SizedBox(height: 12),
                  const Text('IJANS - SOS', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white)),
                  const Text('Ou pa poukont ou. Rele yon nimewo.', style: TextStyle(color: Colors.white70)),
                ],
              ),
            ),
            const SizedBox(height: 20),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Text('Vyolans / Abi / Ijans', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.grey)),
            ),
            const SizedBox(height: 8),
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: AppConstants.sosContacts.length,
                itemBuilder: (_, i) {
                  final c = AppConstants.sosContacts[i];
                  return Card(
                    color: Colors.white,
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor: i == 0 ? Colors.red.withOpacity(0.15) : AppTheme.lavenderPale,
                        child: Icon(_getIcon(c['icon']!), color: i == 0 ? Colors.red : AppTheme.lavender, size: 24),
                      ),
                      title: Text(c['name']!, style: const TextStyle(fontWeight: FontWeight.w600)),
                      subtitle: Text(c['number']!, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppTheme.lavender)),
                      trailing: ElevatedButton.icon(
                        onPressed: () => _call(c['number']!),
                        icon: const Icon(Icons.phone, size: 18),
                        label: const Text('Rele'),
                        style: ElevatedButton.styleFrom(backgroundColor: Colors.green, padding: const EdgeInsets.symmetric(horizontal: 12)),
                      ),
                    ),
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Text(AppConstants.copyright, style: const TextStyle(color: Colors.grey, fontSize: 11)),
            ),
          ],
        ),
      ),
    );
  }

  IconData _getIcon(String s) {
    switch (s) {
      case 'phone': return Icons.phone;
      case 'local_police': return Icons.local_police;
      case 'local_hospital': return Icons.local_hospital;
      case 'shield': return Icons.shield;
      case 'child_care': return Icons.child_care;
      case 'healing': return Icons.healing;
      default: return Icons.phone;
    }
  }
}
