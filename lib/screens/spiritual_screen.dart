import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../services/spiritual_service.dart';
import '../theme/app_theme.dart';
import '../utils/constants.dart';

class SpiritualScreen extends StatefulWidget {
  const SpiritualScreen({super.key});
  @override
  State<SpiritualScreen> createState() => _SpiritualScreenState();
}

class _SpiritualScreenState extends State<SpiritualScreen> with SingleTickerProviderStateMixin {
  late TabController _tabCtrl;
  final _verseKey = GlobalKey<_ContentState>();
  final _prayerKey = GlobalKey<_ContentState>();

  @override
  void initState() { super.initState(); _tabCtrl = TabController(length: 2, vsync: this); }
  @override
  void dispose() { _tabCtrl.dispose(); super.dispose(); }

  void _shareWhatsApp(String text) async {
    final uri = Uri.parse('https://wa.me/?text=${Uri.encodeComponent(text)}');
    if (await canLaunchUrl(uri)) await launchUrl(uri);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(gradient: LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: [Color(0xFFF3E8FF), Color(0xFFFFF0F5)])),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(title: const Text('🙏 Sipò Spirityèl')),
        body: Column(
          children: [
            TabBar(
              controller: _tabCtrl,
              labelColor: Colors.deepPurple,
              unselectedLabelColor: Colors.grey,
              indicatorColor: Colors.deepPurple,
              tabs: const [
                Tab(icon: Icon(Icons.menu_book), text: 'Bib la'),
                Tab(icon: Icon(Icons.self_improvement), text: 'Lapriyè'),
              ],
            ),
            Expanded(
              child: TabBarView(
                controller: _tabCtrl,
                children: [
                  _ContentWidget(
                    key: _verseKey,
                    icon: '📖',
                    title: 'Vèsè Biblik',
                    getter: () {
                      final v = SpiritualService.randomVerse();
                      return '${v['text']}\n\n— ${v['ref']}';
                    },
                    onShare: _shareWhatsApp,
                  ),
                  _ContentWidget(
                    key: _prayerKey,
                    icon: '🙏',
                    title: 'Lapriyè Jodi a',
                    getter: () => SpiritualService.randomPrayer(),
                    onShare: _shareWhatsApp,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ContentWidget extends StatefulWidget {
  final String icon;
  final String title;
  final String Function() getter;
  final void Function(String) onShare;
  const _ContentWidget({super.key, required this.icon, required this.title, required this.getter, required this.onShare});
  @override
  State<_ContentWidget> createState() => _ContentState();
}

class _ContentState extends State<_ContentWidget> with SingleTickerProviderStateMixin {
  late String _content;
  late AnimationController _animCtrl;
  late Animation<double> _scaleAnim;
  late Animation<double> _fadeAnim;

  @override
  void initState() {
    super.initState();
    _content = widget.getter();
    _animCtrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 600));
    _scaleAnim = Tween<double>(begin: 0.8, end: 1).animate(CurvedAnimation(parent: _animCtrl, curve: Curves.easeOutBack));
    _fadeAnim = Tween<double>(begin: 0, end: 1).animate(CurvedAnimation(parent: _animCtrl, curve: Curves.easeIn));
    _animCtrl.forward();
  }
  @override
  void dispose() { _animCtrl.dispose(); super.dispose(); }

  void _refresh() {
    _animCtrl.reset();
    setState(() => _content = widget.getter());
    _animCtrl.forward();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Center(
        child: AnimatedBuilder(
          animation: _animCtrl,
          builder: (_, child) => Transform.scale(scale: _scaleAnim.value, child: Opacity(opacity: _fadeAnim.value, child: child)),
          child: Container(
            padding: const EdgeInsets.all(28),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(28),
              boxShadow: [BoxShadow(color: Colors.deepPurple.withOpacity(0.15), blurRadius: 20, offset: const Offset(0, 8))],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(widget.icon, style: const TextStyle(fontSize: 56)),
                const SizedBox(height: 12),
                Text(widget.title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.deepPurple)),
                const SizedBox(height: 16),
                Text(_content, textAlign: TextAlign.center, style: const TextStyle(fontSize: 17, height: 1.7, fontWeight: FontWeight.w500)),
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Material(
                      color: Colors.deepPurple.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20),
                      child: InkWell(
                        borderRadius: BorderRadius.circular(20),
                        onTap: _refresh,
                        child: const Padding(padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10), child: Row(mainAxisSize: MainAxisSize.min, children: [Icon(Icons.refresh, color: Colors.deepPurple, size: 20), SizedBox(width: 6), Text('Yon lòt', style: TextStyle(color: Colors.deepPurple, fontWeight: FontWeight.w600))])),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Material(
                      color: const Color(0xFF25D366).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20),
                      child: InkWell(
                        borderRadius: BorderRadius.circular(20),
                        onTap: () => widget.onShare('Fanm+ ${widget.icon}\n\n$_content\n\n${AppConstants.copyright}'),
                        child: const Padding(padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10), child: Row(mainAxisSize: MainAxisSize.min, children: [Icon(Icons.share, color: Color(0xFF25D366), size: 20), SizedBox(width: 6), Text('WhatsApp', style: TextStyle(color: Color(0xFF25D366), fontWeight: FontWeight.w600))])),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
