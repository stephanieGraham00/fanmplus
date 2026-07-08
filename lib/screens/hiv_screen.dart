import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../widgets/app_icon.dart';
import '../data/hiv_info.dart';

class HivScreen extends StatelessWidget {
  const HivScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final sections = HivInfo.sections;
    return Scaffold(
      appBar: AppBar(
        title: const Text('VIH & Santé'),
        backgroundColor: AppTheme.lavender,
      ),
      body: Container(
        decoration: const BoxDecoration(gradient: AppTheme.bgGradient),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(colors: [AppTheme.lavender, AppTheme.rose]),
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Column(children: [
                  const AppIcon('hiv', size: 48, color: Colors.white),
                  const SizedBox(height: 12),
                  const Text('Informations VIH', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white)),
                  const SizedBox(height: 8),
                  Text(HivInfo.intro, style: const TextStyle(color: Colors.white70, fontSize: 13, height: 1.5), textAlign: TextAlign.center),
                ]),
              ),
              const SizedBox(height: 16),
              ...sections.map((s) => _sectionCard(s)).toList(),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _sectionCard(HivSection s) => Container(
    width: double.infinity,
    margin: const EdgeInsets.only(bottom: 12),
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(20),
      boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10)],
    ),
    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Row(children: [
        AppIcon(s.icon, size: 26, color: AppTheme.lavender),
        const SizedBox(width: 12),
        Expanded(child: Text(s.title, style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: AppTheme.lavender))),
      ]),
      const SizedBox(height: 12),
      ...s.points.map((p) => Padding(
        padding: const EdgeInsets.only(bottom: 8),
        child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const Text('•  ', style: TextStyle(color: AppTheme.rose, fontSize: 14, fontWeight: FontWeight.bold)),
          Expanded(child: Text(p, style: const TextStyle(fontSize: 13.5, height: 1.45, color: Colors.black87))),
        ]),
      )).toList(),
    ]),
  );
}
