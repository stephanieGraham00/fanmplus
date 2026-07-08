import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../widgets/app_icon.dart';

class WomensRightsScreen extends StatelessWidget {
  const WomensRightsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final rights = [
      _Right(icon: 'firstAid', title: 'Droits des femmes en Haïti', articles: [
        'Les femmes ont les mêmes droits que les hommes selon la constitution haïtienne.',
        'La violence contre les femmes est un crime. Dénoncez-la.',
        'Les femmes ont le droit de travailler, d\'aller à l\'école, et de participer à la politique.',
      ]),
      _Right(icon: 'firstAid', title: 'Droits des femmes enceintes', articles: [
        'Les femmes enceintes ont droit au congé maternité (3 mois).',
        'On ne peut pas vous licencier parce que vous êtes enceinte.',
        'Droit au suivi médical gratuit dans les hôpitaux publics.',
      ]),
      _Right(icon: 'firstAid', title: 'Protection contre la violence', articles: [
        'La loi sanctionne la violence contre les femmes (Loi 2014).',
        'La violence domestique est un crime public.',
        'Vous pouvez déposer plainte au commissariat.',
        'Numéros d\'urgence : **133 (Ligne Crise), 114 (Police).',
      ]),
      _Right(icon: 'firstAid', title: 'Droit à l\'éducation', articles: [
        'Tous les enfants ont le droit d\'aller à l\'école, garçons et filles.',
        'L\'école publique est gratuite en Haïti.',
        'Droit d\'apprendre à lire et à écrire.',
      ]),
      _Right(icon: 'firstAid', title: 'Droit à la santé', articles: [
        'Les femmes ont droit aux soins de santé sans discrimination.',
        'Planning familial et contraception disponibles.',
        'Tests VIH et tests de grossesse disponibles à l\'hôpital.',
      ]),
      _Right(icon: 'firstAid', title: 'Droit au travail', articles: [
        'Les femmes ont le droit de travailler dans tous les domaines.',
        'Elles doivent recevoir le même salaire que les hommes pour le même travail.',
        'On ne peut pas refuser de vous embaucher parce que vous êtes une femme.',
      ]),
    ];

    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: [AppTheme.lavenderPale, Color(0xFFFFF0F5)]),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(title: const Text('Droits des femmes')),
        body: ListView(
          padding: const EdgeInsets.all(16),
          children: rights.map((r) => Card(
            child: ExpansionTile(
              leading: CircleAvatar(backgroundColor: AppTheme.lavenderPale, child: AppIcon(r.icon, size: 22, color: AppTheme.lavender)),
              title: Text(r.title, style: const TextStyle(fontWeight: FontWeight.w600)),
              childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              children: r.articles.map((a) => Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  const AppIcon('firstAid', size: 16, color: AppTheme.lavender),
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
  final String icon;
  final String title;
  final List<String> articles;
  const _Right({required this.icon, required this.title, required this.articles});
}