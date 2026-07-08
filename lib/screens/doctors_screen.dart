import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/storage_service.dart';
import '../models/doctor_model.dart';
import '../theme/app_theme.dart';
import '../widgets/app_icon.dart';

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
  String _specialty = 'Gynécologue';

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
        title: const Text('Ajouter un médecin'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(controller: _nameCtrl, decoration: const InputDecoration(labelText: "Nom du médecin")),
              const SizedBox(height: 8),
              DropdownButtonFormField<String>(
                value: _specialty,
                items: ['Gynécologue', 'Psychologue', 'Médecin généraliste', 'Dermatologue', 'Pédiatre'].map((s) => DropdownMenuItem(value: s, child: Text(s))).toList(),
                onChanged: (v) => _specialty = v ?? 'Gynécologue',
                decoration: const InputDecoration(labelText: 'Spécialité'),
              ),
              const SizedBox(height: 8),
              TextField(controller: _phoneCtrl, decoration: const InputDecoration(labelText: 'Téléphone'), keyboardType: TextInputType.phone),
              const SizedBox(height: 8),
              TextField(controller: _emailCtrl, decoration: const InputDecoration(labelText: 'Email'), keyboardType: TextInputType.emailAddress),
              const SizedBox(height: 8),
              TextField(controller: _addressCtrl, decoration: const InputDecoration(labelText: 'Adresse')),
              const SizedBox(height: 8),
              TextField(controller: _notesCtrl, decoration: const InputDecoration(labelText: 'Notes'), maxLines: 2),
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Annuler')),
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
              _nameCtrl.clear(); _phoneCtrl.clear(); _emailCtrl.clear(); _addressCtrl.clear(); _notesCtrl.clear();
              Navigator.pop(ctx);
            },
            child: const Text('Ajouter'),
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
          title: const Text('Mes médecins'),
          actions: [IconButton(icon: const AppIcon('firstAid', size: 24), onPressed: _addDoctor)],
        ),
        body: doctors.isEmpty
            ? Center(child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const AppIcon('medical', size: 64),
                  const SizedBox(height: 12),
                  const Text('Aucun médecin enregistré', style: TextStyle(fontSize: 18, color: Colors.grey)),
                  const SizedBox(height: 4),
                  const Text('Ajoutez un gynécologue ou un psychologue', style: TextStyle(fontSize: 14, color: Colors.grey)),
                ],
              ))
            : ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: doctors.length,
                itemBuilder: (_, i) {
                  final d = doctors[i];
                  return Card(
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor: AppTheme.lavenderLight,
                        child: AppIcon('medical', size: 20, color: Colors.white),
                      ),
                      title: Text(d.name, style: const TextStyle(fontWeight: FontWeight.w600)),
                      subtitle: Text('${d.specialty}${d.phone.isNotEmpty ? ' • ${d.phone}' : ''}'),
                      trailing: IconButton(
                        icon: const AppIcon('firstAid', size: 24, color: Colors.red),
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