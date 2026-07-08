import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../services/storage_service.dart';
import '../models/appointment_model.dart';
import '../models/doctor_model.dart';
import '../theme/app_theme.dart';

class AppointmentsScreen extends StatefulWidget {
  const AppointmentsScreen({super.key});

  @override
  State<AppointmentsScreen> createState() => _AppointmentsScreenState();
}

class _AppointmentsScreenState extends State<AppointmentsScreen> {
  final _notesCtrl = TextEditingController();
  DoctorModel? _selectedDoctor;
  DateTime _selectedDate = DateTime.now().add(const Duration(days: 1));

  @override
  void dispose() {
    _notesCtrl.dispose();
    super.dispose();
  }

  void _addAppointment() {
    final storage = context.read<StorageService>();
    final doctors = storage.doctors;
    if (doctors.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Ajoute yon doktè anvan!')));
      return;
    }
    _selectedDoctor ??= doctors.first;
    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setDialogState) => AlertDialog(
          title: const Text('Nouvo Rendez-vous'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              DropdownButtonFormField<DoctorModel>(
                value: _selectedDoctor,
                items: doctors.map((d) => DropdownMenuItem(value: d, child: Text('${d.name} (${d.specialty})'))).toList(),
                onChanged: (v) => setDialogState(() => _selectedDoctor = v),
                decoration: const InputDecoration(labelText: 'Doktè'),
              ),
              const SizedBox(height: 12),
              ListTile(
                leading: const Icon(Icons.calendar_today),
                title: Text(DateFormat('dd/MM/yyyy').format(_selectedDate)),
                trailing: const Icon(Icons.edit),
                onTap: () async {
                  final picked = await showDatePicker(context: ctx, initialDate: _selectedDate, firstDate: DateTime.now(), lastDate: DateTime.now().add(const Duration(days: 365)));
                  if (picked != null) setDialogState(() => _selectedDate = picked);
                },
              ),
              TextField(controller: _notesCtrl, maxLines: 2, decoration: const InputDecoration(labelText: 'Nòt')),
            ],
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Anile')),
            ElevatedButton(
              onPressed: () {
                if (_selectedDoctor == null) return;
                storage.addAppointment(AppointmentModel(
                  id: DateTime.now().millisecondsSinceEpoch.toString(),
                  doctorId: _selectedDoctor!.id,
                  doctorName: _selectedDoctor!.name,
                  doctorSpecialty: _selectedDoctor!.specialty,
                  date: _selectedDate,
                  notes: _notesCtrl.text.trim(),
                ));
                _notesCtrl.clear();
                Navigator.pop(ctx);
              },
              child: const Text('Konfime'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final storage = context.watch<StorageService>();
    final appointments = storage.appointments;

    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: [AppTheme.lavenderPale, Color(0xFFFFF0F5)]),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          title: const Text('Rendez-vous'),
          actions: [IconButton(icon: const Icon(Icons.add), onPressed: _addAppointment)],
        ),
        body: appointments.isEmpty
            ? const Center(child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('📅', style: TextStyle(fontSize: 64)),
                  SizedBox(height: 12),
                  Text('Pa gen randevou ankò', style: TextStyle(fontSize: 18, color: Colors.grey)),
                  SizedBox(height: 4),
                  Text('Pran randevou ak yon doktè', style: TextStyle(fontSize: 14, color: Colors.grey)),
                ],
              ))
            : ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: appointments.length,
                itemBuilder: (_, i) {
                  final a = appointments[i];
                  final isPast = a.date.isBefore(DateTime.now());
                  return Card(
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor: isPast ? Colors.grey.shade200 : AppTheme.lavenderLight,
                        child: Icon(isPast ? Icons.check : Icons.event, color: isPast ? Colors.grey : Colors.white),
                      ),
                      title: Text(a.doctorName, style: const TextStyle(fontWeight: FontWeight.w600)),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('${a.doctorSpecialty} • ${DateFormat('dd/MM/yyyy').format(a.date)}'),
                          if (a.notes.isNotEmpty) Text(a.notes, style: const TextStyle(fontSize: 12, color: Colors.grey), maxLines: 1),
                        ],
                      ),
                      trailing: Chip(label: Text(isPast ? 'Fini' : 'Konfime', style: TextStyle(fontSize: 11, color: Colors.white)), backgroundColor: isPast ? Colors.grey : Colors.green),
                    ),
                  );
                },
              ),
      ),
    );
  }
}
