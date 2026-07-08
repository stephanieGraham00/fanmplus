import 'package:flutter/material.dart';
import 'screens/vih/vih_screen.dart';

void main() {
  runApp(const VIHTestApp());
}

class VIHTestApp extends StatelessWidget {
  const VIHTestApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SANM VIH',
      theme: ThemeData(
        primarySwatch: Colors.green,
        useMaterial3: true,
      ),
      home: const VIHScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}
