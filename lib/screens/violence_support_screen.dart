import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../theme/app_theme.dart';

class ViolenceSupportScreen extends StatelessWidget {
  const ViolenceSupportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: [Color(0xFFFFF0F5), Color(0xFFF3E8FF)]),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          title: const Text('Sipò kont Vyolans'),
          leading: IconButton(icon: const Icon(Icons.arrow_back), onPressed: () => Navigator.pop(context)),
        ),
        body: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            _heroCard(context),
            const SizedBox(height: 16),
            const Text('Nimewo Ijans', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppTheme.lavender)),
            const SizedBox(height: 8),
            ..._emergencyNumbers.map((e) => _numberCard(context, e['icon']!, e['name']!, e['number']!)),
            const SizedBox(height: 16),
            const Text('Ki sa pou fè si w sibi vyolans', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppTheme.lavender)),
            const SizedBox(height: 8),
            ..._steps.map((s) => _stepCard(s['emoji']!, s['title']!, s['desc']!)),
            const SizedBox(height: 16),
            const Text('Kay Sekirite & Sipò', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppTheme.lavender)),
            const SizedBox(height: 8),
            ..._shelters.map((s) => _shelterCard(s['name']!, s['loc']!, s['phone']!)),
            const SizedBox(height: 16),
            const Text('Dwa ou', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppTheme.lavender)),
            const SizedBox(height: 8),
            ..._rights.map((r) => _rightCard(r['emoji']!, r['text']!)),
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
        const Text('🆘', style: TextStyle(fontSize: 56)),
        const SizedBox(height: 12),
        const Text('Ou pa poukont ou', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white)),
        const SizedBox(height: 8),
        const Text('Si w an danje kounye a, rel nimewo ijans yo.', style: TextStyle(color: Colors.white70, fontSize: 14, textAlign: TextAlign.center)),
        const SizedBox(height: 16),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            onPressed: () => _call(context, '**133'),
            icon: const Icon(Icons.phone, color: Colors.red),
            label: const Text('Liy Kriz 24/7', style: TextStyle(fontWeight: FontWeight.bold)),
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
        leading: CircleAvatar(backgroundColor: Colors.red.withOpacity(0.1), child: Text(icon, style: const TextStyle(fontSize: 22))),
        title: Text(name, style: const TextStyle(fontWeight: FontWeight.w600)),
        subtitle: Text(number, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.red)),
        trailing: IconButton(
          icon: const Icon(Icons.phone, color: Colors.green),
          onPressed: () => _call(context, number),
        ),
      ),
    );
  }

  Widget _stepCard(String emoji, String title, String desc) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(emoji, style: const TextStyle(fontSize: 28)),
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
          child: const Center(child: Text('🏠', style: TextStyle(fontSize: 22))),
        ),
        title: Text(name, style: const TextStyle(fontWeight: FontWeight.w600)),
        subtitle: Text('$loc\n$phone', style: TextStyle(fontSize: 12, color: Colors.grey[600])),
        trailing: IconButton(icon: const Icon(Icons.phone, color: Colors.green), onPressed: () => _call(context, phone)),
      ),
    );
  }

  Widget _rightCard(String emoji, String text) {
    return Card(
      margin: const EdgeInsets.only(bottom: 6),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(children: [
          Text(emoji, style: const TextStyle(fontSize: 20)),
          const SizedBox(width: 12),
          Expanded(child: Text(text, style: const TextStyle(fontSize: 13, height: 1.3))),
        ]),
      ),
    );
  }

  Future<void> _call(BuildContext context, String number) async {
    final uri = Uri.parse('tel:$number');
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Pa ka rele $number')));
      }
    }
  }

  static const _emergencyNumbers = [
    {'icon': '📞', 'name': 'Liy Kriz 24/7', 'number': '**133'},
    {'icon': '🚓', 'name': 'Polis (Ijans)', 'number': '114'},
    {'icon': '🚑', 'name': 'Ambilans', 'number': '118'},
    {'icon': '🛡️', 'name': 'Pwoteksyon Fanm', 'number': '134'},
    {'icon': '👶', 'name': 'Timoun an Danje', 'number': '116'},
    {'icon': '💜', 'name': 'Viktim Vyolans', 'number': '135'},
    {'icon': '⚖️', 'name': 'Liy Dwa Fanm', 'number': '**8734'},
    {'icon': '🏥', 'name': 'Sante Fanm', 'number': '115'},
  ];

  static const _steps = [
    {'emoji': '1️⃣', 'title': 'Ale nan yon kote an sekirite', 'desc': 'Si w an danje, kite kote w la imedyatman. Ale lakay yon fanmi, yon zanmi, oswa yon kay sekirite.'},
    {'emoji': '2️⃣', 'title': 'Rele yon nimewo ijans', 'desc': 'Rele **133 (Liy Kriz) oswa 114 (Polis). Yo la pou ede w 24/7. Pa pè, ou gen dwa rele.'},
    {'emoji': '3️⃣', 'title': 'Dokimante tout bagay', 'desc': 'Pran foto blesi w yo, anrejistre mesaj/vwa, ekri sa k pase ak dat. Sa pral ede w nan tribinal.'},
    {'emoji': '4️⃣', 'title': 'Ale lopital', 'desc': 'Si w blese, ale lopital imedyatman. Mandhe yon doktè fè yon rapò medikal. Pa lave kò w avan egzamen an.'},
    {'emoji': '5️⃣', 'title': 'Pote plent nan tribinal', 'desc': 'Ale nan Tribinal Drapo a (BWDF) oswa Biwo Pwoteksyon Fanm nan vil ou a. Ou gen dwa pou lajistis.'},
    {'emoji': '6️⃣', 'title': 'Kontakte yon òganizasyon', 'desc': 'FAFE, SOFA, KOFANM, ak lòt òganizasyon fanm ka ede w ak avoka, abri, ak sipò sikolojik gratis.'},
  ];

  static const _shelters = [
    {'name': 'Kay Fanm Solidarite', 'loc': 'Pòtoprens, Delma 75', 'phone': '+509 37 47 1234'},
    {'name': 'FAFE Kay Sipò', 'loc': 'Pòtoprens, Bourdon', 'phone': '+509 29 45 6789'},
    {'name': 'SOFA Refuge', 'loc': 'Pòtoprens, Petyonvil', 'phone': '+509 37 00 1111'},
    {'name': 'KOFANM Abri', 'loc': 'Kap Ayisyen', 'phone': '+509 36 22 3344'},
    {'name': 'Fanm Ak Vwa', 'loc': 'Okay', 'phone': '+509 38 55 6677'},
  ];

  static const _rights = [
    {'emoji': '✅', 'text': 'Ou gen dwa viv san vyolans — se yon dwa imen fondamantal.'},
    {'emoji': '✅', 'text': 'Ou gen dwa di NON — nan relasyon, nan maryaj, nan sèks. Okenn moun pa ka fòse w.'},
    {'emoji': '✅', 'text': 'Lwa Ayiti (Lwa sou Vyolans Famasyal) kondane tout fòm vyolans sou fanm.'},
    {'emoji': '✅', 'text': 'Ou gen dwa ale nan tribinal ak yon avoka san yo pa jije w.'},
    {'emoji': '✅', 'text': 'Si w imigran, ou gen dwa pwoteksyon menm jan ak tout fanm.'},
    {'emoji': '✅', 'text': 'Ou gen dwa aksè a swen sante, menm san papye idantite.'},
    {'emoji': '✅', 'text': 'Vyolans seksyèl se yon krim — kit se mari w, kit se yon etranje.'},
    {'emoji': '✅', 'text': 'Ou gen dwa rete nan kay ou. Yo pa ka chase w paske w te pote plent.'},
  ];
}
