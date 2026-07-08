import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../services/business_service.dart';
import '../theme/app_theme.dart';
import '../utils/constants.dart';

class BusinessScreen extends StatefulWidget {
  const BusinessScreen({super.key});
  @override
  State<BusinessScreen> createState() => _BusinessScreenState();
}

class _BusinessScreenState extends State<BusinessScreen> with SingleTickerProviderStateMixin {
  late TabController _tabCtrl;
  final _tipKey = GlobalKey<_TipWidgetState>();
  final _creditKey = GlobalKey<_TipWidgetState>();
  final _savingKey = GlobalKey<_TipWidgetState>();

  @override
  void initState() { super.initState(); _tabCtrl = TabController(length: 3, vsync: this); }
  @override
  void dispose() { _tabCtrl.dispose(); super.dispose(); }

  void _shareWhatsApp(String text) async {
    final uri = Uri.parse('https://wa.me/?text=${Uri.encodeComponent(text)}');
    if (await canLaunchUrl(uri)) await launchUrl(uri);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(gradient: LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: [Color(0xFFFFF3E0), Color(0xFFFFF8E1)])),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(title: const Text('💼 Ti Komès & Lajan')),
        body: Column(
          children: [
            TabBar(
              controller: _tabCtrl,
              labelColor: Colors.deepOrange,
              unselectedLabelColor: Colors.grey,
              indicatorColor: Colors.deepOrange,
              tabs: const [
                Tab(icon: Icon(Icons.lightbulb), text: 'Konsèy'),
                Tab(icon: Icon(Icons.account_balance), text: 'Mikro-krè'),
                Tab(icon: Icon(Icons.savings), text: 'Ekapay'),
              ],
            ),
            Expanded(
              child: TabBarView(
                controller: _tabCtrl,
                children: [
                  _TipWidget(key: _tipKey, title: '💡 Konsèy Biznis', getter: BusinessService.randomTip, onShare: _shareWhatsApp),
                  _TipWidget(key: _creditKey, title: '🏦 Opòtinite Mikro-krè', getter: BusinessService.randomMicroCredit, onShare: _shareWhatsApp),
                  _TipWidget(key: _savingKey, title: '💰 Konsey Ekapay', getter: BusinessService.randomSavingTip, onShare: _shareWhatsApp),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TipWidget extends StatefulWidget {
  final String title;
  final String Function() getter;
  final void Function(String) onShare;
  const _TipWidget({super.key, required this.title, required this.getter, required this.onShare});
  @override
  State<_TipWidget> createState() => _TipWidgetState();
}

class _TipWidgetState extends State<_TipWidget> with SingleTickerProviderStateMixin {
  late String _tip;
  late AnimationController _animCtrl;
  late Animation<double> _scaleAnim;
  late Animation<double> _fadeAnim;

  @override
  void initState() {
    super.initState();
    _tip = widget.getter();
    _animCtrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 600));
    _scaleAnim = Tween<double>(begin: 0.8, end: 1).animate(CurvedAnimation(parent: _animCtrl, curve: Curves.easeOutBack));
    _fadeAnim = Tween<double>(begin: 0, end: 1).animate(CurvedAnimation(parent: _animCtrl, curve: Curves.easeIn));
    _animCtrl.forward();
  }
  @override
  void dispose() { _animCtrl.dispose(); super.dispose(); }

  void _refresh() {
    _animCtrl.reset();
    setState(() => _tip = widget.getter());
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
              boxShadow: [BoxShadow(color: Colors.deepOrange.withOpacity(0.15), blurRadius: 20, offset: const Offset(0, 8))],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('✨', style: TextStyle(fontSize: 48)),
                const SizedBox(height: 16),
                Text(widget.title, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.deepOrange)),
                const SizedBox(height: 12),
                Text(_tip, textAlign: TextAlign.center, style: const TextStyle(fontSize: 17, height: 1.5, fontWeight: FontWeight.w500)),
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Material(
                      color: Colors.deepOrange.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20),
                      child: InkWell(
                        borderRadius: BorderRadius.circular(20),
                        onTap: _refresh,
                        child: const Padding(padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10), child: Row(mainAxisSize: MainAxisSize.min, children: [Icon(Icons.refresh, color: Colors.deepOrange, size: 20), SizedBox(width: 6), Text('Yon lòt', style: TextStyle(color: Colors.deepOrange, fontWeight: FontWeight.w600))])),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Material(
                      color: const Color(0xFF25D366).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20),
                      child: InkWell(
                        borderRadius: BorderRadius.circular(20),
                        onTap: () => widget.onShare('${widget.title}\n\n$_tip\n\n${AppConstants.copyright}'),
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
