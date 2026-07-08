import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/storage_service.dart';
import '../models/medical_record_model.dart';
import '../theme/app_theme.dart';

class MedicalRecordScreen extends StatefulWidget {
  const MedicalRecordScreen({super.key});

  @override
  State<MedicalRecordScreen> createState() => _MedicalRecordScreenState();
}

class _MedicalRecordScreenState extends State<MedicalRecordScreen> {
  final _nameCtrl = TextEditingController();
  final _ageCtrl = TextEditingController();
  final _bloodCtrl = TextEditingController();
  final _allergiesCtrl = TextEditingController();
  final _medsCtrl = TextEditingController();
  final _historyCtrl = TextEditingController();
  final _emergencyContactCtrl = TextEditingController();
  final _emergencyPhoneCtrl = TextEditingController();
  final _notesCtrl = TextEditingController();
  String? _editingId;

  @override
  void dispose() {
    _nameCtrl.dispose();
    _ageCtrl.dispose();
    _bloodCtrl.dispose();
    _allergiesCtrl.dispose();
    _medsCtrl.dispose();
    _historyCtrl.dispose();
    _emergencyContactCtrl.dispose();
    _emergencyPhoneCtrl.dispose();
    _notesCtrl.dispose();
    super.dispose();
  }

  void _clearFields() {
    _nameCtrl.clear();
    _ageCtrl.clear();
    _bloodCtrl.clear();
    _allergiesCtrl.clear();
    _medsCtrl.clear();
    _historyCtrl.clear();
    _emergencyContactCtrl.clear();
    _emergencyPhoneCtrl.clear();
    _notesCtrl.clear();
    _editingId = null;
  }

  void _save() {
    if (_nameCtrl.text.trim().isEmpty) return;
    final storage = context.read<StorageService>();
    storage.saveMedicalRecord(MedicalRecordModel(
      id: _editingId ?? DateTime.now().millisecondsSinceEpoch.toString(),
      fullName: _nameCtrl.text.trim(),
      age: _ageCtrl.text.trim(),
      bloodType: _bloodCtrl.text.trim(),
      allergies: _allergiesCtrl.text.trim(),
      medications: _medsCtrl.text.trim(),
      medicalHistory: _historyCtrl.text.trim(),
      emergencyContact: _emergencyContactCtrl.text.trim(),
      emergencyPhone: _emergencyPhoneCtrl.text.trim(),
      notes: _notesCtrl.text.trim(),
    ));
    _clearFields();
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Dosye anrejistre!')));
  }

  void _editRecord(MedicalRecordModel r) {
    _nameCtrl.text = r.fullName;
    _ageCtrl.text = r.age;
    _bloodCtrl.text = r.bloodType;
    _allergiesCtrl.text = r.allergies;
    _medsCtrl.text = r.medications;
    _historyCtrl.text = r.medicalHistory;
    _emergencyContactCtrl.text = r.emergencyContact;
    _emergencyPhoneCtrl.text = r.emergencyPhone;
    _notesCtrl.text = r.notes;
    _editingId = r.id;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final storage = context.watch<StorageService>();
    final records = storage.medicalRecords;

    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: [AppTheme.lavenderPale, Color(0xFFFFF0F5)]),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(title: const Text('📋 Dosye Medikal')),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(_editingId != null ? 'Modifye dosye' : 'Nouvo dosye', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                      const SizedBox(height: 12),
                      TextField(controller: _nameCtrl, decoration: const InputDecoration(labelText: 'Non & prenon')),
                      const SizedBox(height: 8),
                      Row(children: [
                        Expanded(child: TextField(controller: _ageCtrl, decoration: const InputDecoration(labelText: 'Laj'), keyboardType: TextInputType.number)),
                        const SizedBox(width: 12),
                        Expanded(child: TextField(controller: _bloodCtrl, decoration: const InputDecoration(labelText: 'Gwoup san'))),
                      ]),
                      const SizedBox(height: 8),
                      TextField(controller: _allergiesCtrl, decoration: const InputDecoration(labelText: 'Alèji'), maxLines: 2),
                      const SizedBox(height: 8),
                      TextField(controller: _medsCtrl, decoration: const InputDecoration(labelText: 'Medsidin w ap pran'), maxLines: 2),
                      const SizedBox(height: 8),
                      TextField(controller: _historyCtrl, decoration: const InputDecoration(labelText: 'Istorik medikal'), maxLines: 3),
                      const SizedBox(height: 8),
                      TextField(controller: _emergencyContactCtrl, decoration: const InputDecoration(labelText: 'Kontak ijans (non)')),
                      const SizedBox(height: 8),
                      TextField(controller: _emergencyPhoneCtrl, decoration: const InputDecoration(labelText: 'Telefòn ijans'), keyboardType: TextInputType.phone),
                      const SizedBox(height: 8),
                      TextField(controller: _notesCtrl, decoration: const InputDecoration(labelText: 'Nòt'), maxLines: 2),
                      const SizedBox(height: 16),
                      Row(children: [
                        Expanded(child: ElevatedButton(onPressed: _save, child: const Text('Anrejistre'))),
                        if (_editingId != null) ...[
                          const SizedBox(width: 12),
                          Expanded(child: OutlinedButton(onPressed: _clearFields, child: const Text('Anile'))),
                        ],
                      ]),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              if (records.isEmpty)
                const Card(child: Padding(padding: EdgeInsets.all(20), child: Center(child: Text('Pa gen dosye medikal ankò', style: TextStyle(color: Colors.grey)))))
              else
                ...records.reversed.map((r) => Card(
                  child: ListTile(
                    leading: const CircleAvatar(backgroundColor: AppTheme.lavenderLight, child: Icon(Icons.folder, color: Colors.white)),
                    title: Text(r.fullName.isNotEmpty ? r.fullName : 'Dosye medikal', style: const TextStyle(fontWeight: FontWeight.w600)),
                    subtitle: Text('${r.bloodType.isNotEmpty ? '${r.bloodType} • ' : ''}${r.createdAt.day}/${r.createdAt.month}/${r.createdAt.year}'),
                    trailing: IconButton(icon: const Icon(Icons.edit, color: AppTheme.lavender), onPressed: () => _editRecord(r)),
                    onTap: () => _showRecordDetail(r),
                  ),
                )),
            ],
          ),
        ),
      ),
    );
  }

  void _showRecordDetail(MedicalRecordModel r) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(r.fullName.isNotEmpty ? r.fullName : 'Dosye medikal'),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              if (r.age.isNotEmpty) _detail('Laj', r.age),
              if (r.bloodType.isNotEmpty) _detail('Gwoup san', r.bloodType),
              if (r.allergies.isNotEmpty) _detail('Alèji', r.allergies),
              if (r.medications.isNotEmpty) _detail('Medsin', r.medications),
              if (r.medicalHistory.isNotEmpty) _detail('Istorik', r.medicalHistory),
              if (r.emergencyContact.isNotEmpty) _detail('Kontak ijans', r.emergencyContact),
              if (r.emergencyPhone.isNotEmpty) _detail('Telefòn ijans', r.emergencyPhone),
              if (r.notes.isNotEmpty) _detail('Nòt', r.notes),
            ],
          ),
        ),
        actions: [ElevatedButton(onPressed: () => Navigator.pop(ctx), child: const Text('Fèmen'))],
      ),
    );
  }

  Widget _detail(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 12, color: Colors.grey)),
          Text(value, style: const TextStyle(fontSize: 14)),
        ],
      ),
    );
  }
}
