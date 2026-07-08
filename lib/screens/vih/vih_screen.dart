import 'package:flutter/material.dart';
import 'medication_reminder_screen.dart';
import 'doctors_clinics_screen.dart';
import 'education_screen.dart';
import 'psychological_support_screen.dart';
import 'nutrition_screen.dart';
import 'pharmacy_screen.dart';
import 'side_effects_screen.dart';
import 'emergency_contacts_screen.dart';
import 'test_locations_screen.dart';
import 'medical_history_screen.dart';
import 'offline_screen.dart';

class VIHScreen extends StatelessWidget {
  const VIHScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final List<_VIHMenuItem> menuItems = [
      _VIHMenuItem(
        title: 'Rapèl Pran Medikaman',
        subtitle: 'ARV chak jou • Alèt • Ki fwa ou bliye',
        icon: Icons.medication_outlined,
        color: const Color(0xFF1A5C1A),
        screen: const MedicationReminderScreen(),
      ),
      _VIHMenuItem(
        title: 'Koneksyon ak Doktè/Klinik',
        subtitle: 'GHESKIO • Zanmi Lasante • Kote jwenn tretman',
        icon: Icons.local_hospital_outlined,
        color: const Color(0xFF2D8A2D),
        screen: const DoctorsClinicsScreen(),
      ),
      _VIHMenuItem(
        title: 'Sipò Sikolojik',
        subtitle: 'Konseyè • Gwoup sipò • Sante mantal',
        icon: Icons.psychology_outlined,
        color: const Color(0xFF00695C),
        screen: const PsychologicalSupportScreen(),
      ),
      _VIHMenuItem(
        title: 'Edukasyon sou VIH',
        subtitle: 'VIH vs SIDA • U=U • Transmisyon • CD4',
        icon: Icons.menu_book_outlined,
        color: const Color(0xFF1565C0),
        screen: const EducationScreen(),
      ),
      _VIHMenuItem(
        title: 'Sipò Alimantasyon',
        subtitle: 'Manje ki bon • Resèt ba pri • Siplemen',
        icon: Icons.restaurant_outlined,
        color: const Color(0xFFE65100),
        screen: const NutritionScreen(),
      ),
      _VIHMenuItem(
        title: 'Koneksyon ak Famasi',
        subtitle: 'Ki famasi gen ARV • Telefòn • Pri',
        icon: Icons.pharmacy_outlined,
        color: const Color(0xFF6A1B9A),
        screen: const PharmacyScreen(),
      ),
      _VIHMenuItem(
        title: 'Jesyon Efè Segondè',
        subtitle: 'Maltèt • Kè plen • Dyare • Fatig',
        icon: Icons.healing_outlined,
        color: const Color(0xFFB71C1C),
        screen: const SideEffectsScreen(),
      ),
      _VIHMenuItem(
        title: 'Kontak Dijans',
        subtitle: '115 • 116 • 114 • 911 • Nimewo kle yo',
        icon: Icons.emergency_outlined,
        color: const Color(0xFFC62828),
        screen: const EmergencyContactsScreen(),
      ),
      _VIHMenuItem(
        title: 'Tès VIH Lokal',
        subtitle: 'Kote fè tès gratis • Kalite tès • Fenèt',
        icon: Icons.bloodtype_outlined,
        color: const Color(0xFF2E7D32),
        screen: const TestLocationsScreen(),
      ),
      _VIHMenuItem(
        title: 'Istorik Medikal Pèsonèl',
        subtitle: 'Swiv CD4 • Chaj viral • Randevou',
        icon: Icons.history_outlined,
        color: const Color(0xFF4527A0),
        screen: const MedicalHistoryScreen(),
      ),
      _VIHMenuItem(
        title: 'Mòd Offline',
        subtitle: 'Tout fonksyone san entènèt',
        icon: Icons.wifi_off_outlined,
        color: const Color(0xFF546E7A),
        screen: const OfflineScreen(),
      ),
    ];

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF121212) : const Color(0xFFF0F4F0),
      appBar: AppBar(
        title: const Text(
          'SANM VIH',
          style: TextStyle(
            fontWeight: FontWeight.w700,
            letterSpacing: 1,
          ),
        ),
        centerTitle: true,
        backgroundColor: const Color(0xFF1A5C1A),
        foregroundColor: Colors.white,
        elevation: 0,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(36),
          child: Container(
            margin: const EdgeInsets.only(bottom: 8),
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.wifi, size: 14, color: Colors.white),
                      SizedBox(width: 4),
                      Text(
                        'Tout enfòmasyon disponib',
                        style: TextStyle(fontSize: 11, color: Colors.white, fontWeight: FontWeight.w500),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      body: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF1A5C1A), Color(0xFF2D8A2D)],
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Sant Nasyonal pou Moun k ap Viv ak VIH',
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.9),
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 4),
                const Text(
                  'Ayiti — Mòd Offline Disponib',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: menuItems.length,
              itemBuilder: (context, index) {
                final item = menuItems[index];
                return _VIHMenuCard(
                  item: item,
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => item.screen),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _VIHMenuItem {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color color;
  final Widget screen;

  const _VIHMenuItem({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.color,
    required this.screen,
  });
}

class _VIHMenuCard extends StatelessWidget {
  final _VIHMenuItem item;
  final VoidCallback onTap;

  const _VIHMenuCard({required this.item, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: item.color.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(item.icon, color: item.color, size: 22),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.title,
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                        color: isDark ? Colors.white : const Color(0xFF1A2E1A),
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      item.subtitle,
                      style: TextStyle(
                        fontSize: 12,
                        color: isDark ? Colors.grey[400] : Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.chevron_right,
                color: isDark ? Colors.grey[500] : Colors.grey[400],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
