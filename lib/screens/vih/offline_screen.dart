import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OfflineScreen extends StatefulWidget {
  const OfflineScreen({super.key});

  @override
  State<OfflineScreen> createState() => _OfflineScreenState();
}

class _OfflineScreenState extends State<OfflineScreen> {
  bool _offlineMode = true;

  @override
  void initState() {
    super.initState();
    _loadPref();
  }

  Future<void> _loadPref() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _offlineMode = prefs.getBool('offline_mode') ?? true;
    });
  }

  Future<void> _toggle(bool val) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('offline_mode', val);
    setState(() => _offlineMode = val);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF121212) : const Color(0xFFF5F5F5),
      appBar: AppBar(
        title: const Text('Mòd Offline'),
        backgroundColor: const Color(0xFF546E7A),
        foregroundColor: Colors.white,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFF546E7A),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(Icons.wifi_off, color: Colors.white, size: 28),
                    const SizedBox(width: 12),
                    const Expanded(
                      child: Text(
                        'Koneksyon pa disponib? Pa pwoblèm.',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                const Text(
                  'Mòd offline pèmèt app la mache menm san entènèt. '
                  'Tout done w rete sou telefòn w.',
                  style: TextStyle(color: Colors.white70, fontSize: 13),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Card(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: SwitchListTile(
              value: _offlineMode,
              onChanged: _toggle,
              title: const Text(
                'Aktive Mòd Offline',
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
              subtitle: Text(
                _offlineMode ? 'Aktive — tout done sou aparèy' : 'Pouse — bezwen entènèt',
              ),
              secondary: Icon(
                _offlineMode ? Icons.wifi_off : Icons.wifi,
                color: const Color(0xFF546E7A),
              ),
              activeColor: const Color(0xFF546E7A),
            ),
          ),
          const SizedBox(height: 16),
          const _FeatureCard(
            title: 'Ki sa mòd offline pèmèt',
            emoji: '✅',
            items: [
              'Li tout enfòmasyon sou VIH',
              'Jere rapèl medikaman',
              'Swiv istorik medikal ou',
              'Konsilte enfòmasyon famasi ak klinik',
              'Jere plan pwennvi ou',
            ],
          ),
          const SizedBox(height: 12),
          const _FeatureCard(
            title: 'Ki sa ki bezwen entènèt',
            emoji: '🌐',
            items: [
              'Telechaje nouvo enfòmasyon oswa mizajou',
              'Kontakte doktè (tèlmedsin)',
              'Kontakte liy dijans (si app rele dirèkteman)',
              'Kek fonksyonalite kat',
            ],
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey.shade300),
            ),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Konsèy pou itilize san entènèt',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                    color: Color(0xFF546E7A),
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  '• Telechaje app la lè w gen Wi-Fi oswa done\n'
                  '• Mete tout enfòmasyon ou (medikaman, randevou) lè w konekte\n'
                  '• Verifye chak 2-3 semèn si gen mizajou disponib',
                  style: TextStyle(fontSize: 13, height: 1.5),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _FeatureCard extends StatelessWidget {
  final String title;
  final String emoji;
  final List<String> items;

  const _FeatureCard({
    required this.title,
    required this.emoji,
    required this.items,
  });

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
          Row(
            children: [
              Text(emoji, style: const TextStyle(fontSize: 20)),
              const SizedBox(width: 8),
              Text(
                title,
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                  color: Color(0xFF546E7A),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          ...items.map((item) => Padding(
            padding: const EdgeInsets.only(bottom: 4),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('•  ', style: TextStyle(color: Color(0xFF546E7A))),
                Expanded(
                  child: Text(
                    item,
                    style: TextStyle(
                      fontSize: 13,
                      color: isDark ? Colors.grey[300] : Colors.grey[700],
                    ),
                  ),
                ),
              ],
            ),
          )),
        ],
      ),
    );
  }
}
