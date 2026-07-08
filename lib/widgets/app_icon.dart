import 'package:flutter/material.dart';

/// Loads a PNG icon from assets/icons/.
/// Usage: AppIcon('yoga')  ->  assets/icons/yoga.png
class AppIcon extends StatelessWidget {
  final String name;
  final double size;
  final Color? color;
  final BoxFit fit;

  const AppIcon(this.name, {super.key, this.size = 24, this.color, this.fit = BoxFit.contain});

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      'assets/icons/$name.png',
      width: size,
      height: size,
      fit: fit,
      color: color,
      errorBuilder: (_, __, ___) => Icon(Icons.circle, size: size, color: Colors.grey),
    );
  }
}

/// Central registry mapping feature keys to icon asset names.
class AppIcons {
  AppIcons._();
  static const Map<String, String> map = {
    'yoga': 'yoga',
    'bottle': 'bottle',
    'firstAid': 'first-aid-kit',
    'weightLoss': 'weight-loss',
    'emergency': 'emergency-call',
    'sentiment': 'sentiment-analysis',
    'migraine': 'migraine',
    'pain': 'pain',
    'pad': 'sanitary-pad',
    'pad1': 'sanitary-pad1',
    'hacking': 'hacking',
    'community': 'community',
    'community1': 'community1',
    'ambulance': 'ambulance',
    'doctorBag': 'doctor-bag',
    'medical': 'medical',
    'medicalTeam': 'medical-team',
    'hiv': 'hiv',
    'nutrients': 'nutrients',
    'nutrition': 'nutrition',
    'pregnancyTest': 'pregnancy-test',
    'pregnant': 'pregnant',
    'cyberbullying': 'cyberbullying',
    'ribbon': 'ribbon',
    'pregnancy': 'pregnancy',
    'condom': 'condom',
    'vibrator': 'vibrator',
    'bedroom': 'bedroom',
    'fertilization': 'fertilization',
    'paper': 'paper',
    'bow': 'bow',
  };

  static String? of(String key) => map[key];
}
