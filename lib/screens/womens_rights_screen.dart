import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class WomensRightsScreen extends StatelessWidget {
  const WomensRightsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final rights = [
      _Right(icon: Icons.gavel, title: 'Dwa Fanm an Ayiti', articles: [
        'Fèm gen menm dwa ak gason dapre konstitisyon ayisyèn.',
        'Vyolans sou fanm se yon krim. Denonse li.',
        'Fanm gen dwa travay, ale lekòl, epi patisipe nan politik.',
      ]),
      _Right(icon: Icons.family_restroom, title: 'Dwa Fanm ansent', articles: [
        'Fanm ansent gen dwa kongje matènite (3 mwa).',
        'Yo pa ka revoke w paske w ansent.',
        'Gen dwa swivi medikal gratis nan lopital piblik.',
      ]),
      _Right(icon: Icons.shield, title: 'Pwoteksyon kont vyolans', articles: [
        'Lwa sancione vyolans sou fanm (Lwa 2014).',
        'Vyolans domestik se yon krim piblik.',
        'Ou ka depoze yon plent nan komisarya.',
        'Nimewo SOS: **133 (Liy Kriz), 114 (Polis).',
      ]),
      _Right(icon: Icons.school, title: 'Dwa Edikasyon', articles: [
        'Tout timoun gen dwa ale lekòl, garçons ak fi.',
        'Lekòl piblik la gratis an Ayiti.',
        'Gen dwa aprann li ak ekri.',
      ]),
      _Right(icon: Icons.health_and_safety, title: 'Dwa Sante', articles: [
        'Fanm gen dwa jwenn swen sante san diskriminasyon.',
        'Planin familyal ak kontrasepsyon disponib.',
        'Tès VIP ak tès gwosès disponib nan lopital.',
      ]),
      _Right(icon: Icons.work, title: 'Dwa Travay', articles: [
        'Fanm gen dwa travay nan nenpòt domèn.',
        'Yo dwe resevwa menm salè ak gason pou menm travay.',
        'Yo pa ka refize anboche w paske w se yon fanm.',
      ]),
    ];

    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: [AppTheme.lavenderPale, Color(0xFFFFF0F5)]),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(title: const Text('⚖️ Dwa Fanm')),
        body: ListView(
          padding: const EdgeInsets.all(16),
          children: rights.map((r) => Card(
            child: ExpansionTile(
              leading: CircleAvatar(backgroundColor: AppTheme.lavenderPale, child: Icon(r.icon, color: AppTheme.lavender, size: 22)),
              title: Text(r.title, style: const TextStyle(fontWeight: FontWeight.w600)),
              childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              children: r.articles.map((a) => Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  const Icon(Icons.check_circle, size: 16, color: AppTheme.lavender),
                  const SizedBox(width: 8),
                  Expanded(child: Text(a, style: const TextStyle(fontSize: 13, height: 1.4))),
                ]),
              )).toList(),
            ),
          )).toList(),
        ),
      ),
    );
  }
}

class _Right {
  final IconData icon;
  final String title;
  final List<String> articles;
  const _Right({required this.icon, required this.title, required this.articles});
}
