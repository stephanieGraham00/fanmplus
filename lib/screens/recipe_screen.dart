import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../services/recipe_service.dart';
import '../theme/app_theme.dart';
import '../utils/constants.dart';

class RecipeScreen extends StatefulWidget {
  const RecipeScreen({super.key});
  @override
  State<RecipeScreen> createState() => _RecipeScreenState();
}

class _RecipeScreenState extends State<RecipeScreen> with SingleTickerProviderStateMixin {
  late AnimationController _animCtrl;
  late Animation<double> _scaleAnim;
  late Animation<double> _fadeAnim;
  late String _recipe;

  @override
  void initState() {
    super.initState();
    _animCtrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 700));
    _scaleAnim = Tween<double>(begin: 0.8, end: 1).animate(CurvedAnimation(parent: _animCtrl, curve: Curves.easeOutBack));
    _fadeAnim = Tween<double>(begin: 0, end: 1).animate(CurvedAnimation(parent: _animCtrl, curve: Curves.easeIn));
    _recipe = RecipeService.recipe;
    _animCtrl.forward();
  }

  @override
  void dispose() { _animCtrl.dispose(); super.dispose(); }

  void _newRecipe() {
    _animCtrl.reset();
    setState(() => _recipe = RecipeService.recipe);
    _animCtrl.forward();
  }

  void _shareWhatsApp(String text) async {
    final uri = Uri.parse('https://wa.me/?text=${Uri.encodeComponent(text)}');
    if (await canLaunchUrl(uri)) await launchUrl(uri);
  }

  @override
  Widget build(BuildContext context) {
    final parts = _recipe.split('\n\n');
    final name = parts.isNotEmpty ? parts[0] : '';
    final rest = parts.length > 1 ? parts.sublist(1).join('\n\n') : '';

    return Container(
      decoration: const BoxDecoration(gradient: LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: [Color(0xFFFFF8E1), Color(0xFFFFF3E0)])),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(title: const Text('🍳 Resèt Manje Ayisyen')),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: AnimatedBuilder(
            animation: _animCtrl,
            builder: (_, child) => Transform.scale(scale: _scaleAnim.value, child: Opacity(opacity: _fadeAnim.value, child: child)),
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(colors: [Color(0xFFFFCC80), Color(0xFFFFB74D)]),
                    borderRadius: BorderRadius.circular(28),
                    boxShadow: [BoxShadow(color: Colors.orange.withOpacity(0.3), blurRadius: 20, offset: const Offset(0, 8))],
                  ),
                  child: Column(
                    children: [
                      Text(['🍲', '🍛', '🥘', '🍜', '🥗', '🍞', '🍰'][_recipe.hashCode % 7], style: const TextStyle(fontSize: 64)),
                      const SizedBox(height: 12),
                      Text(name, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white), textAlign: TextAlign.center),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20), boxShadow: [BoxShadow(color: Colors.orange.withOpacity(0.1), blurRadius: 10, offset: const Offset(0, 4))]),
                  child: Text(rest, style: const TextStyle(fontSize: 15, height: 1.6)),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Material(
                      color: Colors.orange.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(24),
                      child: InkWell(
                        borderRadius: BorderRadius.circular(24),
                        onTap: _newRecipe,
                        child: const Padding(padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12), child: Row(mainAxisSize: MainAxisSize.min, children: [Icon(Icons.refresh, color: Colors.orange), SizedBox(width: 6), Text('Yon lòt resèt', style: TextStyle(color: Colors.orange, fontWeight: FontWeight.w600))])),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Material(
                      color: const Color(0xFF25D366),
                      borderRadius: BorderRadius.circular(24),
                      child: InkWell(
                        borderRadius: BorderRadius.circular(24),
                        onTap: () => _shareWhatsApp('Fanm+ 🍳 Resèt\n\n$_recipe\n\n${AppConstants.copyright}'),
                        child: const Padding(padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12), child: Row(mainAxisSize: MainAxisSize.min, children: [Icon(Icons.share, color: Colors.white), SizedBox(width: 6), Text('WhatsApp', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600))])),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                Text(AppConstants.copyright, style: const TextStyle(color: Colors.grey, fontSize: 11)),
                const SizedBox(height: 8),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
