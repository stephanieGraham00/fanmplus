import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/auth_service.dart';
import '../services/storage_service.dart';
import '../models/cycle_model.dart';
import '../services/advice_service.dart';
import '../theme/app_theme.dart';
import '../utils/constants.dart'
import '../widgets/mascot_widget.dart';
import 'feed_screen.dart';
import 'cycle_tracker_screen.dart';
import 'sex_tracker_screen.dart';
import 'wellness_screen.dart';
import 'sos_screen.dart';
import 'appointments_screen.dart';
import 'doctors_screen.dart';
import 'ai_assistant_screen.dart';
import 'teens_corner_screen.dart';
import 'womens_rights_screen.dart';
import 'daily_motivation_screen.dart';
import 'medical_record_screen.dart';
import 'horoscope_screen.dart';
import 'advice_screen.dart';
import 'violence_support_screen.dart';
import 'business_screen.dart';
import 'pregnancy_screen.dart';
import 'recipe_screen.dart';
import 'spiritual_screen.dart';
import 'beauty_screen.dart';
import 'todo_screen.dart';
import 'admin_screen.dart';
import 'profile_screen.dart';
import 'vih/vih_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _index = 0;

  final _screens = [
    const _DashboardScreen(),
    const DailyMotivationScreen(),
    const CycleTrackerScreen(),
    const AdviceScreen(),
    const ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthService>();
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: _index == 0 ? null : AppBar(
          title: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(_getTitle()),
              const SizedBox(width: 6),
              Text(_getEmoji(), style: const TextStyle(fontSize: 20)),
            ],
          ),
          actions: [
            if (auth.currentUser?.isAnonymous == true)
              Container(
                margin: const EdgeInsets.only(right: 8),
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.visibility_off, size: 16),
                    SizedBox(width: 4),
                    Text('Anonim', style: TextStyle(fontSize: 12)),
                  ],
                ),
              ),
          ],
        ),
        body: IndexedStack(index: _index, children: _screens),
        bottomNavigationBar: Container(
          decoration: BoxDecoration(
            boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 10, offset: const Offset(0, -2))],
          ),
          child: BottomNavigationBar(
            currentIndex: _index,
            selectedItemColor: AppTheme.lavender,
            unselectedItemColor: Colors.grey,
            onTap: (i) => setState(() => _index = i),
            type: BottomNavigationBarType.fixed,
            backgroundColor: Colors.white,
            items: const [
              BottomNavigationBarItem(icon: Icon(Icons.dashboard_outlined), activeIcon: Icon(Icons.dashboard), label: 'Akeyi'),
              BottomNavigationBarItem(icon: Icon(Icons.auto_stories_outlined), activeIcon: Icon(Icons.auto_stories), label: 'Motivasyon'),
              BottomNavigationBarItem(icon: Icon(Icons.favorite_outlined), activeIcon: Icon(Icons.favorite), label: 'Sik'),
              BottomNavigationBarItem(icon: Icon(Icons.lightbulb_outlined), activeIcon: Icon(Icons.lightbulb), label: 'Konsey'),
              BottomNavigationBarItem(icon: Icon(Icons.chat_outlined), activeIcon: Icon(Icons.chat), label: 'Chat'),
              BottomNavigationBarItem(icon: Icon(Icons.person_outline), activeIcon: Icon(Icons.person), label: 'Mwen'),
            ],
          ),
        ),
      ),
    );
  }

  String _getTitle() {
    const t = ['Akeyi', 'Motivasyon', 'Sik', 'Konsey', 'Mwen'];
    return t[_index];
  }

  String _getEmoji() {
    const e = ['🌸', '💫', '🩸', '💡', '👤'];
    return e[_index];
  }
}

class _DashboardScreen extends StatelessWidget {
  const _DashboardScreen();

  static const _quickActions = <_DashAction>[
    _DashAction(icon: Icons.emergency, label: 'SOS', color: Color(0xFFE53935), emoji: '🚨'),
    _DashAction(icon: Icons.shield, label: 'Vyolans', color: Color(0xFFFF6D00), emoji: '🛡️'),
    _DashAction(icon: Icons.auto_stories, label: 'Motivasyon', color: Color(0xFFFFA000), emoji: '💫'),
    _DashAction(icon: Icons.lightbulb, label: 'Konsey', color: Color(0xFFFF9800), emoji: '💡'),
    _DashAction(icon: Icons.calendar_month, label: 'Sik', color: Color(0xFFE91E63), emoji: '🌸'),
    _DashAction(icon: Icons.favorite, label: 'Seks', color: Color(0xFFF06292), emoji: '💋'),
    _DashAction(icon: Icons.water_drop, label: 'Pt & Mykz', color: Color(0xFF7C4DFF), emoji: '💧'),
    _DashAction(icon: Icons.history, label: 'Istorik', color: Color(0xFF26A69A), emoji: '📊'),
    _DashAction(icon: Icons.health_and_safety, label: 'VIH', color: Color(0xFF9C27B0), emoji: '📊'),
    _DashAction(icon: Icons.school, label: 'Jèn', color: Color(0xFF00ACC1), emoji: '🌱'),
    _DashAction(icon: Icons.local_hospital, label: 'Doktè', color: Color(0xFF9C27B0), emoji: '👩‍⚕️'),
    _DashAction(icon: Icons.pregnant_woman, label: 'Gwosès', color: Color(0xFFF48FB1), emoji: '🤰'),
    _DashAction(icon: Icons.work, label: 'Biznis', color: Color(0xFFFF7043), emoji: '💼'),
    _DashAction(icon: Icons.restaurant, label: 'Resèt', color: Color(0xFFFF8A65), emoji: '🍳'),
    _DashAction(icon: Icons.self_improvement, label: 'Spirityèl', color: Color(0xFF7B1FA2), emoji: '🙏'),
    _DashAction(icon: Icons.spa, label: 'Bote', color: Color(0xFFEC407A), emoji: '🌸'),
    _DashAction(icon: Icons.checklist, label: 'Edit', color: Color(0xFF26A69A), emoji: '📝'),
    _DashAction(icon: Icons.event, label: 'Randevou', color: Color(0xFF00897B), emoji: '📅'),
    _DashAction(icon: Icons.gavel, label: 'Dwa', color: Color(0xFF5E35B1), emoji: '✊'),
    _DashAction(icon: Icons.smart_toy, label: 'AI', color: Color(0xFF3949AB), emoji: '🤖'),
    _DashAction(icon: Icons.folder, label: 'Dosye', color: Color(0xFF6D4C41), emoji: '📋'),
    _DashAction(icon: Icons.spa, label: 'Byennèt', color: Color(0xFF43A047), emoji: '🧘'),
    _DashAction(icon: Icons.auto_awesome, label: 'Oròskòp', color: Color(0xFF8E24AA), emoji: '⭐'),
  _DashAction(icon: Icons.admin_panel_settings, label: 'Admin', color: Color(0xFF37474F), emoji: '🛡️'),
  _DashAction(icon: Icons.medical_services, label: 'VIH', color: Color(0xFF1A5C1A), emoji: '🩺'),
];

  @override
  Widget build(BuildContext context) {
    final storage = context.watch<StorageService>();
    final cycle = storage.cycle;
    final consey = AdviceService.randomConsey();

    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFFF3E8FF), Color(0xFFFFF0F5)],
        ),
      ),
      child: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              // Header with cycle status
              _CycleHeader(cycle: cycle),
              const SizedBox(height: 16),

              // Daily advice card
              _AdviceCard(consey: consey),
              const SizedBox(height: 16),

              // Quick actions grid
              _ActionsGrid(),
              const SizedBox(height: 16),

              // Mascot message
              const FanmCat(
                size: 60,
                message: 'Kontinye klere! ♥',
              ),
              const SizedBox(height: 12),

              Text(AppConstants.copyright, style: const TextStyle(color: Colors.grey, fontSize: 11)),
              const SizedBox(height: 8),
            ],
          ),
        ),
      ),
    );
  }
}

class _CycleHeader extends StatelessWidget {
  final CycleModel cycle;
  const _CycleHeader({required this.cycle});

  @override
  Widget build(BuildContext context) {
    final phaseColors = {
      'Peryòd': const Color(0xFFE91E63),
      'Fenèt Fetil': const Color(0xFFFF9800),
      'Ovilasyon': const Color(0xFFFF5722),
      'San Risk': const Color(0xFF4CAF50),
    };
    final phaseColor = phaseColors[cycle.phaseName] ?? const Color(0xFF9C27B0);

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [phaseColor.withOpacity(0.7), phaseColor.withOpacity(0.9)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [BoxShadow(color: phaseColor.withOpacity(0.3), blurRadius: 20, offset: const Offset(0, 8))],
      ),
      child: Row(
        children: [
          // Cycle progress
          SizedBox(
            width: 80,
            height: 80,
            child: Stack(
              alignment: Alignment.center,
              children: [
                CircularProgressIndicator(
                  value: cycle.day / cycle.cycleLength,
                  strokeWidth: 6,
                  backgroundColor: Colors.white.withOpacity(0.2),
                  valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
                ),
                Text('${cycle.day}', style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white)),
              ],
            ),
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Row(
                  children: [
                    FanmCat(size: 32),
                    SizedBox(width: 8),
                    Text('Fanm+', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text('${cycle.phaseName}', style: const TextStyle(fontSize: 12, color: Colors.white, fontWeight: FontWeight.w600)),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text('Jou ${cycle.day}/${cycle.cycleLength}', style: const TextStyle(fontSize: 12, color: Colors.white, fontWeight: FontWeight.w600)),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _AdviceCard extends StatelessWidget {
  final String consey;
  const _AdviceCard({required this.consey});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 4))],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              gradient: const LinearGradient(colors: [Color(0xFFD8B4FE), Color(0xFFF9A8D4)]),
              borderRadius: BorderRadius.circular(14),
            ),
            child: const Text('💡', style: TextStyle(fontSize: 24)),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Konsey jodi a', style: TextStyle(fontSize: 11, color: Colors.grey, fontWeight: FontWeight.w600)),
                const SizedBox(height: 4),
                Text(consey, style: const TextStyle(fontSize: 13, height: 1.3), maxLines: 2, overflow: TextOverflow.ellipsis),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ActionsGrid extends StatelessWidget {
  const _ActionsGrid();

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
        childAspectRatio: 0.8,
      ),
      itemCount: _DashboardScreen._quickActions.length,
      itemBuilder: (_, i) {
        final a = _DashboardScreen._quickActions[i];
        return _ActionCard(action: a);
      },
    );
  }
}

class _ActionCard extends StatelessWidget {
  final _DashAction action;
  const _ActionCard({required this.action});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
      elevation: 1,
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () {
          Widget screen;
          switch (action.label) {
            case 'SOS': screen = const SosScreen(); break;
            case 'Vyolans': screen = const ViolenceSupportScreen(); break;
            case 'Motivasyon': screen = const DailyMotivationScreen(); break;
            case 'Konsey': screen = const AdviceScreen(); break;
            case 'Sik': screen = const CycleTrackerScreen(); break;
            case 'Pt & Mykz': screen = const DischargeMycosisScreen(); break;
            case 'Istorik': screen = const CycleHistoryScreen(); break;
            case 'VIH': screen = const HivScreen(); break;
            case 'Seks': screen = const SexTrackerScreen(); break;
            case 'Jèn': screen = const TeensCornerScreen(); break;
            case 'Doktè': screen = const DoctorsScreen(); break;
            case 'Gwosès': screen = const PregnancyScreen(); break;
            case 'Biznis': screen = const BusinessScreen(); break;
            case 'Resèt': screen = const RecipeScreen(); break;
            case 'Spirityèl': screen = const SpiritualScreen(); break;
            case 'Bote': screen = const BeautyScreen(); break;
            case 'Edit': screen = const TodoScreen(); break;
            case 'Randevou': screen = const AppointmentsScreen(); break;
            case 'Dwa': screen = const WomensRightsScreen(); break;
            case 'AI': screen = const AiAssistantScreen(); break;
            case 'Dosye': screen = const MedicalRecordScreen(); break;
            case 'Byennèt': screen = const WellnessScreen(); break;
            case 'Oròskòp': screen = const HoroscopeScreen(); break;
            case 'Admin': screen = const AdminScreen(); break;
        case 'VIH': screen = const VIHScreen(); break;
            default: screen = const SizedBox();
          }
          Navigator.push(context, MaterialPageRoute(builder: (_) => screen));
        },
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  gradient: LinearGradient(colors: [action.color.withOpacity(0.15), action.color.withOpacity(0.25)]),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(action.emoji, style: const TextStyle(fontSize: 22)),
              ),
              const SizedBox(height: 6),
              Text(action.label, style: TextStyle(fontSize: 10, fontWeight: FontWeight.w600, color: action.color), textAlign: TextAlign.center, maxLines: 1),
            ],
          ),
        ),
      ),
    );
  }
}

class _DashAction {
  final IconData icon;
  final String label;
  final Color color;
  final String emoji;
  const _DashAction({required this.icon, required this.label, required this.color, required this.emoji});
}
