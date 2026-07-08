import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../theme/app_theme.dart';
import '../widgets/app_icon.dart';

class ViolenceSupportScreen extends StatelessWidget {
  const ViolenceSupportScreen({super.key});

  Future<void> _call(BuildContext context, String number) async {
    final uri = Uri.parse('tel:$number');
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Impossible d\'appeler $number')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: [Color(0xFFFFF0F5), Color(0xFFF3E8FF)]),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          title: const Text('Soutien contre la violence'),
          leading: IconButton(icon: const Icon(Icons.arrow_back), onPressed: () => Navigator.pop(context)),
        ),
        body: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            _heroCard(context),
            const SizedBox(height: 16),
            const Text('Numéros d\'urgence', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppTheme.lavender)),
            const SizedBox(height: 8),
            ..._emergencyNumbers.map((e) => _numberCard(context, e['icon']!, e['name']!, e['number']!)),
            const SizedBox(height: 16),
            const Text('Que faire en cas de violence', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppTheme.lavender)),
            const SizedBox(height: 8),
            ..._steps.map((s) => _stepCard(s['icon']!, s['title']!, s['desc']!)),
            const SizedBox(height: 16),
            const Text('Refuges & Soutien', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppTheme.lavender)),
            const SizedBox(height: 8),
            ..._shelters.map((s) => _shelterCard(s['name']!, s['loc']!, s['phone']!)),
            const SizedBox(height: 16),
            const Text('Vos droits', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppTheme.lavender)),
            const SizedBox(height: 8),
            ..._rights.map((r) => _rightCard(r['icon']!, r['text']!)),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _heroCard(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: const LinearGradient(colors: [Colors.red, Colors.orange]),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [BoxShadow(color: Colors.red.withOpacity(0.3), blurRadius: 15, offset: const Offset(0, 5))],
      ),
      child: Column(children: [
        const AppIcon('emergency', size: 56, color: Colors.white),
        const SizedBox(height: 12),
        const Text('Vous n\'êtes pas seul(e)', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white)),
        const SizedBox(height: 8),
        const Text('Si vous êtes en danger, appelez un numéro d\'urgence.', style: TextStyle(color: Colors.white70, fontSize: 14, textAlign: TextAlign.center)),
        const SizedBox(height: 16),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            onPressed: () => _call(context, '**133'),
            icon: const AppIcon('firstAid', size: 20, color: Colors.red),
            label: const Text('Ligne crise 24/7', style: TextStyle(fontWeight: FontWeight.bold)),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.white, foregroundColor: Colors.red, padding: const EdgeInsets.symmetric(vertical: 14), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16))),
          ),
        ),
      ]),
    );
  }

  Widget _numberCard(BuildContext context, String icon, String name, String number) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      child: ListTile(
        leading: CircleAvatar(backgroundColor: Colors.red.withOpacity(0.1), child: AppIcon('firstAid', size: 22, color: Colors.red)),
        title: Text(name, style: const TextStyle(fontWeight: FontWeight.w600)),
        subtitle: Text(number, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.red)),
        trailing: IconButton(icon: const AppIcon('firstAid', size: 22, color: Colors.green), onPressed: () => _call(context, number)),
      ),
    );
  }

  Widget _stepCard(String icon, String title, String desc) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(icon, style: const TextStyle(fontSize: 28)),
          const SizedBox(width: 12),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
            const SizedBox(height: 4),
            Text(desc, style: TextStyle(fontSize: 13, color: Colors.grey[700], height: 1.4)),
          ])),
        ]),
      ),
    );
  }

  Widget _shelterCard(String name, String loc, String phone) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      child: ListTile(
        leading: Container(
          width: 44, height: 44,
          decoration: BoxDecoration(gradient: const LinearGradient(colors: [AppTheme.lavenderPale, AppTheme.roseLight]), borderRadius: BorderRadius.circular(12)),
          child: const Center(child: AppIcon('firstAid', size: 22)),
        ),
        title: Text(name, style: const TextStyle(fontWeight: FontWeight.w600)),
        subtitle: Text('$loc\n$phone', style: TextStyle(fontSize: 12, color: Colors.grey[600])),
        trailing: IconButton(icon: const AppIcon('firstAid', size: 22, color: Colors.green), onPressed: () => _call(null, phone)),
      ),
    );
  }

  Future<void> _call(BuildContext context, String number) async {
    final uri = Uri.parse('tel:$number');
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Impossible d\'appeler $number')));
    }
  }

  static const _emergencyNumbers = [
    {'icon': '📞', 'name': 'Ligne crise 24/7', 'number': '**133'},
    {'icon': '🚓', 'name': 'Police (urgence)', 'number': '114'},
    {'icon': '🚑', 'name': 'Ambulance', 'number': '118'},
    {'icon': '🛡️', 'name': 'Protection femmes', 'number': '134'},
    {'icon': '👶', 'name': 'Enfant en danger', 'number': '116'},
    {'icon': '💜', 'name': 'Victimes violence', 'number': '135'},
    {'icon': '⚖️', 'name': 'Ligne droits femmes', 'number': '**8734'},
    {'icon': '🏥', 'name': 'Santé femmes', 'number': '115'},
  ];

  static const _steps = [
    {'icon': '1️⃣', 'title': 'Allez dans un lieu sûr', 'desc': 'Si vous êtes en danger, quittez les lieux immédiatement. Allez chez un proche, un ami, ou un refuge.'},
    {'icon': '2️⃣', 'title': 'Appelez un numéro d\'urgence', 'desc': 'Appelez **133 (Ligne Crise) ou 114 (Police). Ils sont là pour vous aider 24/7. N\'ayez pas peur, vous avez le droit d\'appeler.'},
    {'icon': '3️⃣', 'title': 'Documentez tout', 'desc': 'Prenez des photos de vos blessures, enregistrez les messages/voix, écrivez ce qui s\'est passé avec la date. Cela vous aidera au tribunal.'},
    {'icon': '4️⃣', 'title': 'Allez à l\'hôpital', 'desc': 'Si vous êtes blessé(e), allez à l\'hôpital immédiatement. Demandez un certificat médical. Ne vous lavez pas avant l\'examen.'},
    {'icon': '5️⃣', 'title': 'Portez plainte', 'desc': 'Allez au Tribunal de Grande Instance (BVDF) ou au Bureau de Protection des Femmes de votre ville. Vous avez droit à la justice.'},
    {'icon': '6️⃣', 'title': 'Contactez une organisation', 'desc': 'FAFE, SOFA, KOFANM et d\'autres organisations de femmes peuvent vous aider avec un avocat, un abri, et un soutien psychologique gratuit.'},
  ];

  static const _shelters = [
    {'name': 'Maison Femmes Solidarité', 'loc': 'Port-au-Prince, Delmas 75', 'phone': '+509 37 47 1234'},
    {'name': 'FAFE Maison Soutien', 'loc': 'Port-au-Prince, Bourdon', 'phone': '+509 29 45 6789'},
    {'name': 'SOFA Refuge', 'loc': 'Port-au-Prince, Pétionville', 'phone': '+509 37 00 1111'},
    {'name': 'KOFANM Abri', 'loc': 'Cap-Haïtien', 'phone': '+509 36 22 3344'},
    {'name': 'Femmes Avec Voix', 'loc': 'Cayes', 'phone': '+509 38 55 6677'},
  ];
}