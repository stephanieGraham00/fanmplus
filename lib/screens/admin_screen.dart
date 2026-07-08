import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/auth_service.dart';
import '../services/storage_service.dart';
import '../theme/app_theme.dart';
import '../utils/constants.dart';

class AdminScreen extends StatelessWidget {
  const AdminScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthService>();
    final storage = context.watch<StorageService>();

    final totalUsers = storage.users.length + 1;
    final totalPosts = storage.posts.length;
    final totalDoctors = storage.doctors.length;
    final totalAppts = storage.appointments.length;
    final totalRecords = storage.medicalRecords.length;

    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: [Color(0xFFF3E8FF), Color(0xFFFFF0F5)]),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(title: const Text('Admin Fanm+')),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
                  _adminStat(Icons.people, 'Itilizatè', '$totalUsers', Colors.blue),
                  _adminStat(Icons.article, 'Pòs', '$totalPosts', Colors.orange),
                ]),
              ),
            ),
            const SizedBox(height: 12),
            const Text('Estatistik', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Card(
              child: Column(children: [
                _adminTile(Icons.local_hospital, 'Doktè', '$totalDoctors', AppTheme.lavender),
                const Divider(height: 1),
                _adminTile(Icons.event, 'Randevou', '$totalAppts', Colors.teal),
                const Divider(height: 1),
                _adminTile(Icons.folder, 'Dosye medikal', '$totalRecords', Colors.brown),
              ]),
            ),
            const SizedBox(height: 16),
            const Text('Sekirite & Kontwòl', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Card(
              child: Column(children: [
                SwitchListTile(
                  title: const Row(children: [Icon(Icons.visibility_off, color: AppTheme.rose, size: 20), SizedBox(width: 12), Text('Mòd Anonim')]),
                  subtitle: const Text('Kache idantite itilizatè yo'),
                  value: auth.currentUser?.isAnonymous ?? false,
                  onChanged: (v) => auth.toggleAnonymous(),
                  activeColor: AppTheme.rose,
                ),
                const Divider(height: 1),
                SwitchListTile(
                  title: const Row(children: [Icon(Icons.fingerprint, color: AppTheme.lavender, size: 20), SizedBox(width: 12), Text('Biometrik')]),
                  subtitle: const Text('Ouvri app la ak anprent dwèt'),
                  value: auth.biometricEnabled,
                  onChanged: (v) => auth.toggleBiometric(),
                  activeColor: AppTheme.lavender,
                ),
              ]),
            ),
            const SizedBox(height: 16),
            const Text('Devlòpè', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(color: AppTheme.roseLight.withOpacity(0.2), borderRadius: BorderRadius.circular(12)),
              child: Column(children: [
                const CircleAvatar(
                  radius: 30,
                  backgroundColor: AppTheme.roseLight,
                  child: Text('🌸', style: TextStyle(fontSize: 28)),
                ),
                const SizedBox(height: 12),
                const Text(AppConstants.developer, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppTheme.rose)),
                const SizedBox(height: 4),
                const Text('Yon jèn fanm ayisyen kap sipòte fanm', style: TextStyle(fontSize: 13, color: Colors.grey)),
                const SizedBox(height: 8),
                const Text(AppConstants.copyright, style: TextStyle(fontSize: 12, color: Colors.grey)),
                const SizedBox(height: 8),
                Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  const Icon(Icons.favorite, size: 16, color: AppTheme.rose),
                  const SizedBox(width: 6),
                  const Text('Fèt ak anpil lanmou pou tout fanm.', style: TextStyle(fontSize: 13, color: Colors.grey, fontStyle: FontStyle.italic)),
                ]),
              ]),
            ),
            const SizedBox(height: 24),
          ]),
        ),
      ),
    );
  }

  Widget _adminStat(IconData icon, String label, String value, Color color) {
    return Column(children: [
      Container(padding: const EdgeInsets.all(10), decoration: BoxDecoration(color: color.withOpacity(0.15), shape: BoxShape.circle), child: Icon(icon, color: color, size: 28)),
      const SizedBox(height: 8),
      Text(value, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: color)),
      Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey)),
    ]);
  }

  Widget _adminTile(IconData icon, String label, String value, Color color) {
    return ListTile(
      leading: Icon(icon, color: color),
      title: Text(label),
      trailing: Text(value, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: color)),
    );
  }
}
