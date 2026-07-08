import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MedicalHistoryScreen extends StatefulWidget {
  const MedicalHistoryScreen({super.key});

  @override
  State<MedicalHistoryScreen> createState() => _MedicalHistoryScreenState();
}

class _MedicalHistoryScreenState extends State<MedicalHistoryScreen> {
  final List<Map<String, dynamic>> _records = [];
  final _typeController = TextEditingController();
  final _valueController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadRecords();
  }

  Future<void> _loadRecords() async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getString('vih_medical_records');
    if (data != null) {
      try {
        final decoded = json.decode(data) as List;
        setState(() {
          _records.addAll(decoded.cast<Map<String, dynamic>>());
        });
      } catch (_) {}
    }
  }

  Future<void> _saveRecords() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('vih_medical_records', json.encode(_records));
  }

  void _addRecord() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Ajoute yon Dosye'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            DropdownButtonFormField<String>(
              items: const [
                DropdownMenuItem(value: 'CD4', child: Text('Taks CD4')),
                DropdownMenuItem(value: 'Chaj Viral', child: Text('Chaj Viral')),
                DropdownMenuItem(value: 'Pwa', child: Text('Pwa (kg)')),
                DropdownMenuItem(value: 'Randevou', child: Text('Randevou')),
                DropdownMenuItem(value: 'Tès', child: Text('Tès Labo')),
              ],
              onChanged: (v) => _typeController.text = v ?? '',
              decoration: const InputDecoration(labelText: 'Tip'),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _valueController,
              decoration: const InputDecoration(
                labelText: 'Valè (eg. 450, 200, 65kg)',
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Anile'),
          ),
          ElevatedButton(
            onPressed: () {
              if (_typeController.text.isNotEmpty && _valueController.text.isNotEmpty) {
                setState(() {
                  _records.add({
                    'type': _typeController.text,
                    'value': _valueController.text,
                    'date': DateTime.now().toString().substring(0, 10),
                  });
                });
                _saveRecords();
                _typeController.clear();
                _valueController.clear();
                Navigator.pop(context);
              }
            },
            child: const Text('Ajoute'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF121212) : const Color(0xFFF5F5F5),
      appBar: AppBar(
        title: const Text('Istorik Medikal Pèsonèl'),
        backgroundColor: const Color(0xFF4527A0),
        foregroundColor: Colors.white,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFF4527A0),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Text(
              'Swiv pwogrè sante w. Enfòmasyon sa a rete sou aparèy ou '
              '(mòd offline). Pa pataje li san pèmisyon w.',
              style: TextStyle(color: Colors.white70, fontSize: 13, height: 1.5),
            ),
          ),
          const SizedBox(height: 16),
          if (_records.isEmpty)
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: const Center(
                child: Text(
                  'Ou poko ajoute okenn dosye.\nPeze + pou ajoute youn.',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.grey),
                ),
              ),
            )
          else
            ..._records.map((r) => Card(
              margin: const EdgeInsets.only(bottom: 8),
              child: ListTile(
                leading: const CircleAvatar(
                  backgroundColor: Color(0xFF4527A0),
                  child: Icon(Icons.history, color: Colors.white, size: 18),
                ),
                title: Text(r['type'] ?? ''),
                subtitle: Text('Dat: ${r['date']}'),
                trailing: Text(
                  r['value'] ?? '',
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                    color: Color(0xFF4527A0),
                  ),
                ),
              ),
            )),
          const SizedBox(height: 16),
          const _InfoBlock(
            title: 'Kisa vle di CD4 monte?',
            body: 'Bon siy — iminite w ap ranfòse. ARV la ap mache byen.',
          ),
          const SizedBox(height: 12),
          const _InfoBlock(
            title: 'Kasa vle di chaj viral bese?',
            body: 'Bon siy — medikaman an ap travay. Objektif: enferyor (undetectable).',
          ),
          const SizedBox(height: 12),
          const _InfoBlock(
            title: 'Kasa vle di chaj viral monte?',
            body: 'Ka vle di medikaman an pa ap mache. Ou pa t ap pran medikaman '
                'regilyèman. Pale ak doktè imedyatman.',
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addRecord,
        backgroundColor: const Color(0xFF4527A0),
        child: const Icon(Icons.add),
      ),
    );
  }
}

class _InfoBlock extends StatelessWidget {
  final String title;
  final String body;

  const _InfoBlock({required this.title, required this.body});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 14,
              color: Color(0xFF4527A0),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            body,
            style: TextStyle(
              fontSize: 13,
              height: 1.5,
              color: isDark ? Colors.grey[300] : Colors.grey[700],
            ),
          ),
        ],
      ),
    );
  }
}
