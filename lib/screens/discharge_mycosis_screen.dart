import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/discharge_model.dart';
import '../models/mycosis_model.dart';
import '../services/hive_service.dart';
import '../theme/app_theme.dart';
import '../widgets/app_icon.dart';

class DischargeMycosisScreen extends StatefulWidget {
  const DischargeMycosisScreen({super.key});

  @override
  State<DischargeMycosisScreen> createState() => _DischargeMycosisScreenState();
}

class _DischargeMycosisScreenState extends State<DischargeMycosisScreen> {
  DateTime _selectedDate = DateTime.now();
  String _dischargeType = 'normal';
  List<DischargeLog> _discharges = [];
  List<MycosisLog> _mycoses = [];

  final _dischargeTypes = [
    {'key': 'normal', 'label': 'Normal', 'icon': 'pad'},
    {'key': 'creamy', 'label': 'Crémeux', 'icon': 'bottle'},
    {'key': 'eggWhite', 'label': 'Blanc d\'œuf', 'icon': 'paper'},
    {'key': 'watery', 'label': 'Liquide', 'icon': 'bottle'},
    {'key': 'sticky', 'label': 'Collant', 'icon': 'paper'},
  ];

  final _mycosisSymptoms = [
    {'key': 'itching', 'label': 'Démangeaisons'},
    {'key': 'burning', 'label': 'Brûlure'},
    {'key': 'redness', 'label': 'Rougeur'},
    {'key': 'swelling', 'label': 'Gonflement'},
    {'key': 'pain', 'label': 'Douleur'},
  ];

  @override
  void initState() {
    super.initState();
    _load();
  }

  void _load() {
    final d = HiveService.load('discharges');
    final m = HiveService.load('mycoses');
    if (d != null) {
      _discharges = (json.decode(d) as List).map((e) => DischargeLog.fromJson(e)).toList();
    }
    if (m != null) {
      _mycoses = (json.decode(m) as List).map((e) => MycosisLog.fromJson(e)).toList();
    }
    setState(() {});
  }

  void _save() {
    HiveService.save('discharges', json.encode(_discharges.map((e) => e.toJson()).toList()));
    HiveService.save('mycoses', json.encode(_mycoses.map((e) => e.toJson()).toList()));
  }

  void _logDischarge() {
    _discharges.removeWhere((x) =>
      DateTime(x.date.year, x.date.month, x.date.day) ==
      DateTime(_selectedDate.year, _selectedDate.month, _selectedDate.day));
    _discharges.add(DischargeLog(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      date: _selectedDate,
      type: _dischargeType,
    ));
    _save();
    _load();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Perte enregistrée ✅'), behavior: SnackBarBehavior.floating),
    );
  }

  void _logMycosis(bool has, List<String> symptoms) {
    _mycoses.removeWhere((x) =>
      DateTime(x.date.year, x.date.month, x.date.day) ==
      DateTime(_selectedDate.year, _selectedDate.month, _selectedDate.day));
    _mycoses.add(MycosisLog(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      date: _selectedDate,
      hasMycosis: has,
      symptoms: symptoms,
    ));
    _save();
    _load();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(has ? 'Mycose enregistrée ⚠️' : 'Mycose non enregistrée ✅'), behavior: SnackBarBehavior.floating),
    );
  }

  String _dischargeLabel(String type) =>
      _dischargeTypes.firstWhere((e) => e['key'] == type, orElse: () => {'label': type})['label']!;

  @override
  Widget build(BuildContext context) {
    final dayDischarge = _discharges.where((d) =>
      DateTime(d.date.year, d.date.month, d.date.day) ==
      DateTime(_selectedDate.year, _selectedDate.month, _selectedDate.day)).toList();
    final dayMycosis = _mycoses.where((m) =>
      DateTime(m.date.year, m.date.month, m.date.day) ==
      DateTime(_selectedDate.year, _selectedDate.month, _selectedDate.day)).toList();

    return Scaffold(
      appBar: AppBar(title: const Text('Perte & Mycose'), backgroundColor: AppTheme.rose),
      body: Container(
        decoration: const BoxDecoration(gradient: AppTheme.bgGradient),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _card(
                child: Row(children: [
                  const AppIcon('bottle', size: 22, color: AppTheme.lavender),
                  const SizedBox(width: 12),
                  Expanded(child: Text(DateFormat('dd MMMM yyyy', 'fr').format(_selectedDate), style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold))),
                  TextButton(
                    onPressed: () async {
                      final picked = await showDatePicker(
                        context: context,
                        initialDate: _selectedDate,
                        firstDate: DateTime(2024),
                        lastDate: DateTime.now(),
                      );
                      if (picked != null) setState(() => _selectedDate = picked);
                    },
                    child: const Text('Changer'),
                  ),
                ]),
              ),
              const SizedBox(height: 16),

              _sectionTitle('Perte (écoulement)', AppTheme.lavender),
              _card(
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  const Text('Type de perte :', style: TextStyle(fontSize: 14, color: Colors.grey)),
                  const SizedBox(height: 8),
                  Wrap(spacing: 8, runSpacing: 8, children: _dischargeTypes.map((t) {
                    final sel = _dischargeType == t['key'];
                    return ChoiceChip(
                      avatar: AppIcon(t['icon']!, size: 18),
                      label: Text(t['label']!),
                      selected: sel,
                      selectedColor: AppTheme.roseLight,
                      onSelected: (_) => setState(() => _dischargeType = t['key']!),
                    );
                  }).toList()),
                  const SizedBox(height: 12),
                  SizedBox(width: double.infinity, height: 46,
                    child: ElevatedButton(
                      onPressed: _logDischarge,
                      style: ElevatedButton.styleFrom(backgroundColor: AppTheme.rose, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14))),
                      child: const Text('Enregistrer la perte'),
                    )),
                ]),
              ),
              if (dayDischarge.isNotEmpty) ...[
                const SizedBox(height: 8),
                Text('Aujourd\'hui : ${_dischargeLabel(dayDischarge.first.type)}', style: const TextStyle(fontSize: 13, color: AppTheme.lavender)),
              ],

              const SizedBox(height: 16),

              _sectionTitle('Mycose (muguet)', Colors.red),
              _card(
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  const Text('Avez-vous une mycose aujourd\'hui ?', style: TextStyle(fontSize: 14)),
                  const SizedBox(height: 8),
                  Row(children: [
                    Expanded(child: OutlinedButton(onPressed: () => _logMycosis(true, []), child: const Text('Oui'))),
                    const SizedBox(width: 12),
                    Expanded(child: OutlinedButton(onPressed: () => _logMycosis(false, []), child: const Text('Non'))),
                  ]),
                  const SizedBox(height: 12),
                  const Text('Symptômes possibles :', style: TextStyle(fontSize: 13, color: Colors.grey)),
                  const SizedBox(height: 6),
                  Wrap(spacing: 8, runSpacing: 8, children: _mycosisSymptoms.map((s) {
                    return FilterChip(
                      avatar: const AppIcon('pain', size: 16),
                      label: Text(s['label']!),
                      onSelected: (v) {
                        final syms = dayMycosis.isNotEmpty ? List<String>.from(dayMycosis.first.symptoms) : <String>[];
                        v ? syms.add(s['key']!) : syms.remove(s['key']!);
                        _logMycosis(true, syms);
                      },
                      selected: dayMycosis.isNotEmpty && dayMycosis.first.symptoms.contains(s['key']),
                      selectedColor: Colors.red.shade100,
                    );
                  }).toList()),
                ]),
              ),

              const SizedBox(height: 20),

              _sectionTitle('Historique', AppTheme.lavender),
              ..._discharges.reversed.take(5).map((d) => _card(child:
                Row(children: [
                  const AppIcon('bottle', size: 18, color: AppTheme.lavender),
                  const SizedBox(width: 10),
                  Text(DateFormat('dd MMM', 'fr').format(d.date)),
                  const SizedBox(width: 8),
                  Text(_dischargeLabel(d.type), style: const TextStyle(color: Colors.grey)),
                ]))).toList(),
              ..._mycoses.reversed.take(5).map((m) => _card(child:
                Row(children: [
                  AppIcon('pain', size: 18, color: m.hasMycosis ? Colors.red : Colors.green),
                  const SizedBox(width: 10),
                  Text(DateFormat('dd MMM', 'fr').format(m.date)),
                  const SizedBox(width: 8),
                  Text(m.hasMycosis ? 'Mycose' : 'Pas de mycose', style: const TextStyle(color: Colors.grey)),
                ]))).toList(),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _sectionTitle(String text, Color color) => Padding(
    padding: const EdgeInsets.only(bottom: 8, left: 4),
    child: Text(text, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: color)),
  );

  Widget _card({required Widget child}) => Container(
    width: double.infinity,
    margin: const EdgeInsets.only(bottom: 8),
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(20),
      boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10)],
    ),
    child: child,
  );
}
