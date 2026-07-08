import 'dart:math';
import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class HoroscopeScreen extends StatefulWidget {
  const HoroscopeScreen({super.key});

  @override
  State<HoroscopeScreen> createState() => _HoroscopeScreenState();
}

class _HoroscopeScreenState extends State<HoroscopeScreen> {
  int _selectedSign = -1;
  final _rand = Random();

  static const _signs = [
    'Belye (Aries)', 'Towo (Taurus)', 'Jemo (Gemini)', 'Kansè (Cancer)',
    'Lyon (Leo)', 'Vyèj (Virgo)', 'Balans (Libra)', 'Eskòpyon (Scorpio)',
    'Sajitè (Sagittarius)', 'Kaprikòn (Capricorn)', 'Vèso (Aquarius)', 'Pwason (Pisces)',
  ];

  static const _emoji = [
    '🐏', '🐂', '👯', '🦀', '🦁', '👩‍⚕️', '⚖️', '🦂', '🏹', '🐐', '💧', '🐟',
  ];

  static const _elements = ['Dife', 'Tè', 'Lè', 'Dlo', 'Dife', 'Tè', 'Lè', 'Dlo', 'Dife', 'Tè', 'Lè', 'Dlo'];

  static const _dates = [
    '21 Mas - 19 Avril', '20 Avril - 20 Me', '21 Me - 20 Jen', '21 Jen - 22 Jiyè',
    '23 Jiyè - 22 Out', '23 Out - 22 Septanm', '23 Septanm - 22 Oktòb', '23 Oktòb - 21 Novanm',
    '22 Novanm - 21 Desanm', '22 Desanm - 19 Janvye', '20 Janvye - 18 Fevrye', '19 Fevrye - 20 Mas',
  ];

  String _getHoroscope(int index) {
    final today = DateTime.now();
    final msgs = [
      'Jodi a se yon bon jou pou w konsantre sou objektif w. Enèji pozitif ap vin nan direksyon ou.',
      'Lanmou ak relasyon yo ap favè ou jodi a. Pran tan pou w kominike ak moun w renmen yo.',
      'Atansyon sou sante w. Pran yon ti detant epi respire pwofondman.',
      'Lajan ap antre jodi a. Yon bon nouvel ap rive konsènan finans ou.',
      'Se yon jou kreyatif. Eksprime tèt ou atravè atizay, ekriti, oswa mizik.',
      'Pran prekosyon nan desizyon enpòtan. Reflechi anvan w aji.',
      'Yon ansyen zanmi ap kontakte w. Se yon bon moman pou renouvèlè koneksyon.',
      'Fòs ou se pasyans. Tout bagay ap vini nan bon moman. Pa prese.',
      'Vwayaj oswa deplasman pozitif ap fèt. Louvri lespri w pou nouvo eksperyans.',
      'Fanm nan bò kote w ap sipòte w. Kominote Fanm+ la la pou ou.',
      'Jodi a pran yon desizyon pou byennèt ou. Ou merite sa ki pi bon.',
      'Lespri w klè. Se moman pou w pran yon gran desizyon. Konte sou entwisyon w.',
    ];
    return '${msgs[index]} ${_emoji[index % _emoji.length]}';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: [Color(0xFF1A0033), Color(0xFF4A0080)]),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          title: const Text('🔮 Oròskòp'),
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        body: _selectedSign == -1 ? _buildSignList() : _buildHoroscopeDetail(),
      ),
    );
  }

  Widget _buildSignList() {
    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3, crossAxisSpacing: 12, mainAxisSpacing: 12, childAspectRatio: 0.9),
      itemCount: _signs.length,
      itemBuilder: (_, i) {
        return Material(
          color: Colors.white.withOpacity(0.12),
          borderRadius: BorderRadius.circular(16),
          child: InkWell(
            borderRadius: BorderRadius.circular(16),
            onTap: () => setState(() => _selectedSign = i),
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                Text(_emoji[i], style: const TextStyle(fontSize: 36)),
                const SizedBox(height: 6),
                Text(_signs[i].split(' ')[0], style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w600), textAlign: TextAlign.center),
                Text(_elements[i], style: const TextStyle(color: Colors.white60, fontSize: 10)),
              ]),
            ),
          ),
        );
      },
    );
  }

  Widget _buildHoroscopeDetail() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(children: [
        Text(_emoji[_selectedSign], style: const TextStyle(fontSize: 72)),
        const SizedBox(height: 12),
        Text(_signs[_selectedSign], style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white)),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          margin: const EdgeInsets.only(top: 8),
          decoration: BoxDecoration(color: AppTheme.lavenderLight.withOpacity(0.3), borderRadius: BorderRadius.circular(20)),
          child: Text(_elements[_selectedSign], style: const TextStyle(color: AppTheme.lavenderLight)),
        ),
        const SizedBox(height: 8),
        Text(_dates[_selectedSign], style: const TextStyle(color: Colors.white60, fontSize: 13)),
        const SizedBox(height: 32),
        Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.1),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.white.withOpacity(0.15)),
          ),
          child: Column(children: [
            const Text('🔮 Oròskòp jodi a', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
            const SizedBox(height: 16),
            Text(_getHoroscope(_selectedSign), style: const TextStyle(fontSize: 16, color: Colors.white, height: 1.6)),
            const SizedBox(height: 24),
            Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
              _miniStat('🍀', 'Bòn chans'),
              _miniStat('💜', 'Lanmou'),
              _miniStat('💰', 'Lajan'),
            ]),
          ]),
        ),
        const SizedBox(height: 24),
        ElevatedButton(
          onPressed: () => setState(() => _selectedSign = -1),
          style: ElevatedButton.styleFrom(backgroundColor: Colors.white, foregroundColor: AppTheme.lavender),
          child: const Text('Chwazi yon lòt siy'),
        ),
        const SizedBox(height: 40),
      ]),
    );
  }

  Widget _miniStat(String emoji, String label) {
    return Column(children: [
      Text(emoji, style: const TextStyle(fontSize: 28)),
      const SizedBox(height: 4),
      Text(label, style: const TextStyle(color: Colors.white60, fontSize: 12)),
    ]);
  }
}
