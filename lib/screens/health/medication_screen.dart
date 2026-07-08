import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';
import '../../widgets/glass_card.dart';
import '../../widgets/pam_icon.dart';
import '../../providers/language_provider.dart';

class MedicationItem {
  final String name;
  final String dosage;
  final String time;
  final bool taken;
  final String? icon;

  MedicationItem({
    required this.name,
    required this.dosage,
    required this.time,
    this.taken = false,
    this.icon,
  });

  MedicationItem copyWith({bool? taken}) {
    return MedicationItem(
      name: name,
      dosage: dosage,
      time: time,
      taken: taken ?? this.taken,
      icon: icon,
    );
  }
}

class MedicationState {
  final List<MedicationItem> medications;
  final bool isLoading;

  const MedicationState({
    this.medications = const [],
    this.isLoading = false,
  });

  MedicationState copyWith({List<MedicationItem>? medications, bool? isLoading}) {
    return MedicationState(
      medications: medications ?? this.medications,
      isLoading: isLoading ?? this.isLoading,
    );
  }

  int get takenCount => medications.where((m) => m.taken).length;
  int get totalCount => medications.length;
  double get progress => totalCount == 0 ? 0 : takenCount / totalCount;

  MedicationItem? get nextDose {
    final untaken = medications.where((m) => !m.taken).toList();
    if (untaken.isEmpty) return null;
    untaken.sort((a, b) => a.time.compareTo(b.time));
    return untaken.first;
  }
}

class MedicationNotifier extends StateNotifier<MedicationState> {
  MedicationNotifier() : super(const MedicationState(
    medications: [
      MedicationItem(name: 'Pilil Kontraseptif', dosage: '1 pyès', time: '08:00 AM', icon: '💊'),
      MedicationItem(name: 'Vitamin D3', dosage: '1 kapsil', time: '08:30 AM', icon: '☀️'),
      MedicationItem(name: 'Omega 3', dosage: '1 softgel', time: '01:00 PM', icon: '🐟'),
      MedicationItem(name: 'Magnèzyòm', dosage: '1 pyès', time: '06:30 PM', icon: '🌙'),
    ],
  ));

  void toggleTaken(int index) {
    final updated = [...state.medications];
    updated[index] = updated[index].copyWith(taken: !updated[index].taken);
    state = state.copyWith(medications: updated);
  }

  void addMedication(MedicationItem med) {
    state = state.copyWith(medications: [...state.medications, med]);
  }

  void removeMedication(int index) {
    final updated = [...state.medications];
    updated.removeAt(index);
    state = state.copyWith(medications: updated);
  }
}

final medicationProvider = StateNotifierProvider<MedicationNotifier, MedicationState>((ref) {
  return MedicationNotifier();
});

class MedicationScreen extends ConsumerStatefulWidget {
  const MedicationScreen({super.key});

  @override
  ConsumerState<MedicationScreen> createState() => _MedicationScreenState();
}

class _MedicationScreenState extends ConsumerState<MedicationScreen> {
  @override
  Widget build(BuildContext context) {
    final tr = ref.watch(translationsProvider);
    final medState = ref.watch(medicationProvider);
    final now = DateTime.now();

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                children: [
                  const PamIcon(name: 'med', size: 28, color: AppColors.primary),
                  const SizedBox(width: 8),
                  Text(tr.medicationsWord, style: AppTextStyles.headlineLarge),
                ],
              ),
              const SizedBox(height: 4),
              Text(
                DateFormat('EEEE, dd MMMM yyyy').format(now),
                style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSecondary),
              ),
              const SizedBox(height: 20),

              // Next dose card
              GlassCard(
                gradient: LinearGradient(
                  colors: [AppColors.primary, AppColors.secondary],
                ),
                padding: const EdgeInsets.all(24),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(tr.nextDose, style: TextStyle(color: Colors.white70, fontSize: 13)),
                            const SizedBox(height: 4),
                            Text(
                              medState.nextDose?.time ?? tr.completed,
                              style: const TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.notifications_active, color: Colors.white, size: 28),
                        ),
                      ],
                    ),
                    if (medState.nextDose != null) ...[
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Text(medState.nextDose!.icon ?? '💊', style: const TextStyle(fontSize: 20)),
                          const SizedBox(width: 8),
                          Text(
                            '${medState.nextDose!.name} — ${medState.nextDose!.dosage}',
                            style: const TextStyle(color: Colors.white, fontSize: 14),
                          ),
                        ],
                      ),
                    ],
                    const SizedBox(height: 16),
                    // Progress bar
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: LinearProgressIndicator(
                        value: medState.progress,
                        backgroundColor: Colors.white24,
                        valueColor: const AlwaysStoppedAnimation(Colors.white),
                        minHeight: 8,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '${medState.takenCount}/${medState.totalCount} pran',
                      style: TextStyle(color: Colors.white70, fontSize: 12),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Medications list
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(tr.myMedications, style: AppTextStyles.headlineMedium),
                  GestureDetector(
                    onTap: () => _showAddMedDialog(),
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withOpacity(0.1),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.add, color: AppColors.primary, size: 20),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              ...medState.medications.asMap().entries.map((entry) {
                final index = entry.key;
                final med = entry.value;
                return Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: GlassCard(
                    onTap: () => ref.read(medicationProvider.notifier).toggleTaken(index),
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: med.taken
                                ? AppColors.success.withOpacity(0.1)
                                : AppColors.primary.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: Text(med.icon ?? '💊', style: const TextStyle(fontSize: 22)),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                med.name,
                                style: AppTextStyles.titleMedium.copyWith(
                                  decoration: med.taken ? TextDecoration.lineThrough : null,
                                  color: med.taken ? AppColors.textHint : AppColors.textPrimary,
                                ),
                              ),
                              Text(
                                '${med.dosage} — ${med.time}',
                                style: AppTextStyles.bodySmall.copyWith(color: AppColors.textSecondary),
                              ),
                            ],
                          ),
                        ),
                        AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          width: 32,
                          height: 32,
                          decoration: BoxDecoration(
                            color: med.taken ? AppColors.success : Colors.transparent,
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: med.taken ? AppColors.success : AppColors.textHint,
                              width: 2,
                            ),
                          ),
                          child: med.taken
                              ? const Icon(Icons.check, color: Colors.white, size: 18)
                              : null,
                        ),
                      ],
                    ),
                  ),
                );
              }),
              const SizedBox(height: 24),

              // Reminder info
              GlassCard(
                gradient: LinearGradient(
                  colors: [AppColors.info.withOpacity(0.08), AppColors.info.withOpacity(0.03)],
                ),
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    const Icon(Icons.info_outline, color: AppColors.info, size: 24),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        tr.pillReminderInfo,
                        style: AppTextStyles.bodySmall.copyWith(color: AppColors.info),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  void _showAddMedDialog() {
    final nameController = TextEditingController();
    final dosageController = TextEditingController();
    final timeController = TextEditingController();

    showDialog(
      context: context,
      builder: (ctx) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(tr.addMedication, style: AppTextStyles.headlineMedium),
              const SizedBox(height: 16),
              TextField(
                controller: nameController,
                decoration: InputDecoration(
                  hintText: tr.medicationName,
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: dosageController,
                decoration: InputDecoration(
                  hintText: tr.dosage,
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: timeController,
                decoration: InputDecoration(
                  hintText: 'Lè (eg: 08:00 AM)',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  onPressed: () {
                    if (nameController.text.isNotEmpty) {
                      ref.read(medicationProvider.notifier).addMedication(
                        MedicationItem(
                          name: nameController.text,
                          dosage: dosageController.text.isNotEmpty ? dosageController.text : '1 pyès',
                          time: timeController.text.isNotEmpty ? timeController.text : '08:00 AM',
                          icon: '💊',
                        ),
                      );
                      Navigator.pop(ctx);
                    }
                  },
                  style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary),
                  child: Text(tr.confirm, style: TextStyle(color: Colors.white)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
