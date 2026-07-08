import 'dart:math';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../services/motivation_service.dart';
import '../theme/app_theme.dart';
import '../utils/constants.dart';

class DailyMotivationScreen extends StatefulWidget {
  const DailyMotivationScreen({super.key});

  @override
  State<DailyMotivationScreen> createState() => _DailyMotivationScreenState();
}

class _DailyMotivationScreenState extends State<DailyMotivationScreen> with SingleTickerProviderStateMixin {
  late AnimationController _animCtrl;
  late Animation<double> _scaleAnim;
  late Animation<double> _fadeAnim;
  late Animation<double> _rotateAnim;
  final _rand = Random();
  late String _currentMsg;
  int _count = 0;
  final List<String> _favorites = [];

  @override
  void initState() {
    super.initState();
    _animCtrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 1000));
    _scaleAnim = Tween<double>(begin: 0.5, end: 1).animate(CurvedAnimation(parent: _animCtrl, curve: Curves.elasticOut));
    _fadeAnim = Tween<double>(begin: 0, end: 1).animate(CurvedAnimation(parent: _animCtrl, curve: Curves.easeIn));
    _rotateAnim = Tween<double>(begin: -0.05, end: 0.05).animate(CurvedAnimation(parent: _animCtrl, curve: Curves.easeInOut));
    _currentMsg = MotivationService.generate();
    _animCtrl.forward();
  }

  @override
  void dispose() {
    _animCtrl.dispose();
    super.dispose();
  }

  void _newMessage() {
    _animCtrl.reset();
    setState(() {
      _currentMsg = MotivationService.generate();
      _count++;
    });
    _animCtrl.forward();
  }

  void _toggleFavorite() {
    setState(() {
      if (_favorites.contains(_currentMsg)) {
        _favorites.remove(_currentMsg);
      } else {
        _favorites.add(_currentMsg);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFFD8B4FE), Color(0xFFF9A8D4), Color(0xFFA78BFA)],
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SafeArea(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Icon(Icons.auto_awesome, color: Colors.white, size: 24),
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text('$_count mesaj', style: const TextStyle(color: Colors.white, fontSize: 12)),
                          ),
                          const SizedBox(width: 8),
                          IconButton(
                            icon: Icon(_favorites.contains(_currentMsg) ? Icons.favorite : Icons.favorite_border, color: Colors.white),
                            onPressed: _toggleFavorite,
                          ),
                        ],
                      ),
                    ],
                  ),
                  const Spacer(),
                  AnimatedBuilder(
                    animation: _animCtrl,
                    builder: (_, child) => Transform.rotate(
                      angle: _rotateAnim.value,
                      child: Transform.scale(
                        scale: _scaleAnim.value,
                        child: Opacity(opacity: _fadeAnim.value, child: child),
                      ),
                    ),
                    child: Container(
                      padding: const EdgeInsets.all(32),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(32),
                        border: Border.all(color: Colors.white.withOpacity(0.3)),
                        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 20, offset: const Offset(0, 8))],
                      ),
                      child: Column(
                        children: [
                          TweenAnimationBuilder<double>(
                            tween: Tween(begin: 0, end: 1),
                            duration: const Duration(milliseconds: 1500),
                            builder: (_, value, __) => Transform.scale(
                              scale: value,
                              child: Text(['🌸', '💜', '✨', '🌺', '💖', '🌟', '🌷', '🦋'][_rand.nextInt(8)], style: const TextStyle(fontSize: 72)),
                            ),
                          ),
                          const SizedBox(height: 24),
                          Text(
                            _currentMsg,
                            textAlign: TextAlign.center,
                            style: const TextStyle(fontSize: 22, color: Colors.white, height: 1.6, fontWeight: FontWeight.w500),
                          ),
                          const SizedBox(height: 16),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              for (final c in ['💕', '✨', '🌺', '💜', '🌸'])
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 4),
                                  child: TweenAnimationBuilder<double>(
                                    tween: Tween(begin: 0, end: 1),
                                    duration: Duration(milliseconds: 500 + 200 * ['💕', '✨', '🌺', '💜', '🌸'].indexOf(c)),
                                    builder: (_, value, __) => Opacity(opacity: value, child: Text(c, style: const TextStyle(fontSize: 16))),
                                  ),
                                ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  const Spacer(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _kawaiiButton(
                        icon: Icons.refresh,
                        label: 'Yon lòt',
                        onTap: _newMessage,
                      ),
                      const SizedBox(width: 16),
                      _kawaiiButton(
                        icon: Icons.share,
                        label: 'Pataje',
                        onTap: _shareWhatsApp,
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Text(_favorites.isNotEmpty ? '♥ ${_favorites.length} favori' : '', style: const TextStyle(color: Colors.white54, fontSize: 12)),
                  const SizedBox(height: 8),
                  Text(AppConstants.copyright, style: const TextStyle(color: Colors.white38, fontSize: 10)),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _shareWhatsApp() async {
    final uri = Uri.parse('https://wa.me/?text=${Uri.encodeComponent("Fanm+ 💫 Motivasyon\n\n$_currentMsg\n\n${AppConstants.copyright}")}');
    if (await canLaunchUrl(uri)) await launchUrl(uri);
  }

  Widget _kawaiiButton({required IconData icon, required String label, required VoidCallback onTap}) {
    return Material(
      color: Colors.white.withOpacity(0.2),
      borderRadius: BorderRadius.circular(24),
      child: InkWell(
        borderRadius: BorderRadius.circular(24),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, color: Colors.white, size: 20),
              const SizedBox(width: 8),
              Text(label, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
            ],
          ),
        ),
      ),
    );
  }
}
