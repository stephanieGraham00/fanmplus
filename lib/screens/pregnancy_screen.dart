import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';
import '../services/pregnancy_service.dart';
import '../theme/app_theme.dart';
import '../utils/constants.dart';

class PregnancyScreen extends StatefulWidget {
  const PregnancyScreen({super.key});
  @override
  State<PregnancyScreen> createState() => _PregnancyScreenState();
}

class _PregnancyScreenState extends State<PregnancyScreen> {
  DateTime? _lmp;
  int _week = 1;
  int _trimester = 1;
  DateTime _dueDate = DateTime.now();
  String _babySize = '';
  String _tip = '';

  @override
  void initState() {
    super.initState();
    _lmp = DateTime.now().subtract(const Duration(days: 14 * 7));
    _update();
  }

  void _update() {
    if (_lmp == null) return;
    setState(() {
      _week = PregnancyService.currentWeek(_lmp!);
      _trimester = PregnancyService.trimester(_week);
      _dueDate = PregnancyService.dueDate(_lmp!);
      _babySize = PregnancyService.babySize(_week);
      _tip = PregnancyService.tip(_week);
    });
  }

  Future<void> _pickDate() async {
    final d = await showDatePicker(context: context, initialDate: _lmp ?? DateTime.now(), firstDate: DateTime(2020), lastDate: DateTime.now());
    if (d != null) { _lmp = d; _update(); }
  }

  void _shareWhatsApp(String text) async {
    final uri = Uri.parse('https://wa.me/?text=${Uri.encodeComponent(text)}');
    if (await canLaunchUrl(uri)) await launchUrl(uri);
  }

  @override
  Widget build(BuildContext context) {
    final dateFmt = DateFormat('dd/MM/yyyy');
    final trimesterEmoji = ['🌸', '🌺', '👶'][_trimester - 1];
    final trimesterName = ['1ye Trimès', '2yèm Trimès', '3yèm Trimès'][_trimester - 1];

    return Container(
      decoration: const BoxDecoration(gradient: LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: [Color(0xFFFCE4EC), Color(0xFFFFF0F5)])),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(title: const Text('🤰 Swivi Gwosès')),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Card(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                elevation: 4,
                child: Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(gradient: const LinearGradient(colors: [Color(0xFFF8BBD0), Color(0xFFF48FB1)]), borderRadius: BorderRadius.circular(24)),
                  child: Column(
                    children: [
                      Text(trimesterEmoji, style: const TextStyle(fontSize: 64)),
                      const SizedBox(height: 8),
                      Text('Semèn $trimesterEmoji', style: const TextStyle(fontSize: 16, color: Colors.white70)),
                      Text('$_week', style: const TextStyle(fontSize: 56, fontWeight: FontWeight.bold, color: Colors.white)),
                      const SizedBox(height: 4),
                      Text(trimesterName, style: const TextStyle(fontSize: 14, color: Colors.white70)),
                      const SizedBox(height: 12),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: _infoCard('📅 Dènye règ', dateFmt.format(_lmp!), Icons.calendar_today, () => _pickDate()),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _infoCard('👶 Dat akouchman', dateFmt.format(_dueDate), Icons.child_care, null),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              _infoCard('📏 Taille bebe a', _babySize, Icons.straighten, null),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20), boxShadow: [BoxShadow(color: Colors.pink.withOpacity(0.1), blurRadius: 10, offset: const Offset(0, 4))]),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Row(children: [Icon(Icons.lightbulb, color: Colors.pink, size: 20), SizedBox(width: 8), Text('💡 Konsèy pou semèn sa a', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14))]),
                    const SizedBox(height: 8),
                    Text(_tip, style: const TextStyle(fontSize: 15, height: 1.5)),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20), boxShadow: [BoxShadow(color: Colors.orange.withOpacity(0.1), blurRadius: 10, offset: const Offset(0, 4))]),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Row(children: [Icon(Icons.warning_amber, color: Colors.orange, size: 20), SizedBox(width: 8), Text('⚠️ Siy danje', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14))]),
                    const SizedBox(height: 8),
                    Text(PregnancyService.randomDangerSign(), style: const TextStyle(fontSize: 15, height: 1.5)),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              Material(
                color: const Color(0xFF25D366),
                borderRadius: BorderRadius.circular(24),
                child: InkWell(
                  borderRadius: BorderRadius.circular(24),
                  onTap: () => _shareWhatsApp('Fanm+ 🤰 Swivi Gwosès\n\nSemèn: $_week\nTrimès: $trimesterName\nTaille bebe: $_babySize\nDat akouchman: ${dateFmt.format(_dueDate)}\n\nKonsèy: $_tip\n\n${AppConstants.copyright}'),
                  child: const Padding(padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12), child: Row(mainAxisSize: MainAxisSize.min, children: [Icon(Icons.share, color: Colors.white), SizedBox(width: 8), Text('Pataje sou WhatsApp', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600))])),
                ),
              ),
              const SizedBox(height: 24),
              Text(AppConstants.copyright, style: const TextStyle(color: Colors.grey, fontSize: 11)),
              const SizedBox(height: 8),
            ],
          ),
        ),
      ),
    );
  }

  Widget _infoCard(String label, String value, IconData icon, VoidCallback? onTap) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Icon(icon, color: Colors.pink, size: 24),
              const SizedBox(height: 8),
              Text(value, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15), textAlign: TextAlign.center),
              const SizedBox(height: 4),
              Text(label, style: const TextStyle(color: Colors.grey, fontSize: 11), textAlign: TextAlign.center),
            ],
          ),
        ),
      ),
    );
  }
}
