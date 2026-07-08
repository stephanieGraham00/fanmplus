import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/storage_service.dart';
import '../models/doctor_model.dart';
import '../theme/app_theme.dart';

class DoctorsScreen extends StatefulWidget {
  const DoctorsScreen({super.key});

  @override
  State<DoctorsScreen> createState() => _DoctorsScreenState();
}

class _DoctorsScreenState extends State<DoctorsScreen> {
  final _nameCtrl = TextEditingController();
  final _phoneCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _addressCtrl = TextEditingController();
  final _notesCtrl = TextEditingController();
  String _specialty = 'Jinekolog';

  @override
  void dispose() {
    _nameCtrl.dispose();
    _phoneCtrl.dispose();
    _emailCtrl.dispose();
    _addressCtrl.dispose();
    _notesCtrl.dispose();
    super.dispose();
  }

  void _addDoctor() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Ajoute Doktè'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(controller: _nameCtrl, decoration: const InputDecoration(labelText: 'Non doktè')),
              const SizedBox(height: 8),
              DropdownButtonFormField<String>(
                value: _specialty,
                items: ['Jinekolog', 'Sikològ', 'Doktè jeneral', 'Dermatolog', 'Nouvològ'].map((s) => DropdownMenuItem(value: s, child: Text(s))).toList(),
                onChanged: (v) => _specialty = v ?? 'Jinekolog',
                decoration: const InputDecoration(labelText: 'Espesyalite'),
              ),
              const SizedBox(height: 8),
              TextField(controller: _phoneCtrl, decoration: const InputDecoration(labelText: 'Telefòn'), keyboardType: TextInputType.phone),
              const SizedBox(height: 8),
              TextField(controller: _emailCtrl, decoration: const InputDecoration(labelText: 'Imèl'), keyboardType: TextInputType.emailAddress),
              const SizedBox(height: 8),
              TextField(controller: _addressCtrl, decoration: const InputDecoration(labelText: 'Adrès')),
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Anile')),
          ElevatedButton(
            onPressed: () {
              if (_nameCtrl.text.trim().isEmpty) return;
              context.read<StorageService>().addDoctor(DoctorModel(
                id: DateTime.now().millisecondsSinceEpoch.toString(),
                name: _nameCtrl.text.trim(),
                specialty: _specialty,
                phone: _phoneCtrl.text.trim(),
                email: _emailCtrl.text.trim(),
                address: _addressCtrl.text.trim(),
              ));
              _nameCtrl.clear(); _phoneCtrl.clear(); _emailCtrl.clear(); _addressCtrl.clear();
              Navigator.pop(ctx);
            },
            child: const Text('Ajoute'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final storage = context.watch<StorageService>();
    final doctors = storage.doctors;

    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: [AppTheme.lavenderPale, Color(0xFFFFF0F5)]),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          title: const Text('Doktè yo'),
          actions: [IconButton(icon: const Icon(Icons.add), onPressed: _addDoctor)],
        ),
        body: doctors.isEmpty
            ? const Center(child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('👨‍⚕️', style: TextStyle(fontSize: 64)),
                  SizedBox(height: 12),
                  Text('Pa gen doktè ankò', style: TextStyle(fontSize: 18, color: Colors.grey)),
                  SizedBox(height: 4),
                  Text('Ajoute yon jinekolog oswa sikològ', style: TextStyle(fontSize: 14, color: Colors.grey)),
                ],
              ))
            : ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: doctors.length,
                itemBuilder: (_, i) {
                  final d = doctors[i];
                  return Card(
                    child: ListTile(
                      leading: CircleAvatar(backgroundColor: AppTheme.lavenderLight, child: Text(d.name[0].toUpperCase(), style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold))),
                      title: Text(d.name, style: const TextStyle(fontWeight: FontWeight.w600)),
                      subtitle: Text('${d.specialty}${d.phone.isNotEmpty ? ' • ${d.phone}' : ''}'),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () => storage.removeDoctor(d.id),
                      ),
                    ),
                  );
                },
              ),
      ),
    );
  }
}
