import 'package:flutter/material.dart';
import '../services/advice_service.dart';
import '../theme/app_theme.dart';

class AdviceScreen extends StatefulWidget {
  const AdviceScreen({super.key});

  @override
  State<AdviceScreen> createState() => _AdviceScreenState();
}

class _AdviceScreenState extends State<AdviceScreen> with SingleTickerProviderStateMixin {
  late TabController _tabCtrl;
  String _selectedCat = 'Sante';

  @override
  void initState() {
    super.initState();
    _tabCtrl = TabController(length: AdviceService.categories.length, vsync: this);
    _tabCtrl.addListener(() {
      if (!_tabCtrl.indexIsChanging) {
        setState(() => _selectedCat = AdviceService.categories[_tabCtrl.index]);
      }
    });
  }

  @override
  void dispose() {
    _tabCtrl.dispose();
    super.dispose();
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
          title: const Text('Konsey Fanm+'),
          bottom: TabBar(
            controller: _tabCtrl,
            isScrollable: true,
            indicatorColor: Colors.white,
            labelColor: Colors.white,
            unselectedLabelColor: Colors.white60,
            tabs: AdviceService.categories.map((c) => Tab(text: c)).toList(),
          ),
        ),
        body: TabBarView(
          controller: _tabCtrl,
          children: AdviceService.categories.map((cat) {
            final conseys = AdviceService.conseysByCategory(cat);
            return ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: conseys.length,
              itemBuilder: (_, i) => _adviceCard(cat, conseys[i], i),
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _adviceCard(String category, String text, int index) {
    final emojis = {
      'Sante': ['💊', '🏥', '❤️', '🩺', '💪', '🧬', '🌿', '🥗', '🧘', '💉'],
      'Relasyon': ['💕', '🤝', '💌', '💑', '💞', '🌹', '💗', '🫂', '💛', '💋'],
      'Sikolojik': ['🧠', '💭', '🌱', '🎀', '🧘', '🌈', '💫', '🌟', '🕊️', '🌸'],
      'Edikasyon': ['📚', '✏️', '🎓', '📖', '💡', '📝', '🔬', '🌍', '📊', '🏆'],
      'Dwa Fanm': ['⚖️', '✊', '👩‍⚖️', '📜', '🔍', '🗳️', '💜', '🌍', '🛡️', '📢'],
      'Byennèt': ['🛁', '🌿', '🧴', '✨', '🎵', '💆', '🌸', '🕯️', '🧖', '🌺'],
    };
    final catEmojis = emojis[category] ?? ['💜'];
    final emoji = catEmojis[index % catEmojis.length];

    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            gradient: LinearGradient(colors: [AppTheme.lavenderPale, AppTheme.roseLight]),
            borderRadius: BorderRadius.circular(14),
          ),
          child: Center(child: Text(emoji, style: const TextStyle(fontSize: 22))),
        ),
        title: Text(
          'Konsey #${index + 1}',
          style: TextStyle(fontSize: 12, color: AppTheme.lavender, fontWeight: FontWeight.w600),
        ),
        subtitle: Text(text, style: const TextStyle(fontSize: 14, height: 1.4)),
        trailing: Container(
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: AppTheme.lavenderPale,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(Icons.favorite_border, size: 16, color: AppTheme.rose),
        ),
      ),
    );
  }
}
