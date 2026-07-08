import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class TeensCornerScreen extends StatelessWidget {
  const TeensCornerScreen({super.key});

  static const _content = {
    'Puberté: Kisa k ap pase nan kò m?': [
      'Puberté se peryòd kote kò w ap grandi epi chanje.',
      'Tèt w ap grandi, lèt ap parèt, cheve ap pouse.',
      'Premye règ (menarche) rive ant 9-16 an.',
      'Se yon pwosesis natirèl, pa gen anyen wont.',
    ],
    'Premye règ: Kisa pou fè?': [
      'Premye règ ou rele menarche. Li nòmal.',
      'Sèvi ak sèvyèt ipojeyik oswa tampon.',
      'Chanje sèvyèt chak 4-6 èdtan.',
      'Si doulè twòp, pale ak manman w oswa yon doktè.',
    ],
    'Sik règ: Konprann kò ou': [
      'Yon sik règ dire 21-35 jou an mwayèn.',
      'Premye jou règ la se premye jou sik la.',
      'Ovulyasyon rive 14 jou avan pwochen règ la.',
      'Sèvi ak yon kalandriye pou swiv sik ou.',
    ],
    'Edikasyon seksyèl: Baz ou dwe konnen': [
      'Seksyalite se yon bagay nòmal men fòk ou konnen ki jan pou pwoteje tèt ou.',
      'Kontrasepsyon ede anpeche gwosès endezirab.',
      'VIP/SIDA se maladi grav. Sèvi ak kapòt pou pwoteje tèt ou.',
      'Pa janm santi w oblije fè okenn bagay ou pa vle.',
    ],
    'Relasyon sante: Jèn fi ak respè': [
      'Nan yon relasyon sante, gen respè, konfyans, ak kominikasyon.',
      'Si yon moun pa respekte w, fè w pè, oswa fòse w, se abi.',
      'Ou gen dwa di NON. Pa janm kite pèsonn fòse w.',
      'Pale ak yon granmoun ou fè konfyans si w nan pwoblèm.',
    ],
    'Kontrasepsyon: Kapòt': [
      'Kapòt pwoteje kont VIP ak gwosès.',
      'Sèvi ak yon nouvo kapòt chak fwa ou fè sèks.',
      'Tcheke dat ekspirasyon anvan ou itilize.',
      'Kapòt se sèl metòd ki pwoteje kont VIP.',
    ],
    'Kontrasepsyon: Pilil': [
      'Pilil kontraseptif dwe pran chak jou nan menm lè a.',
      'Efikasite 99% si w pran l korèkteman.',
      'Ka gen efè segondè (tèt fè mal, chanjman imè).',
      'Konsilte yon doktè anvan ou kòmanse.',
    ],
    'Kontrasepsyon: Enplantasyon': [
      'Enplantasyon mete andedan bra a.',
      'Dire 3-5 an selon mawòk la.',
      'Efikasite plis pase 99%.',
      'Dwe mete ak retire pa yon doktè.',
    ],
    'Kontrasepsyon: Enjeksyon': [
      'Enjeksyon fè chak 3 mwa.',
      'Efikasite 97% si w fè l regilyèman.',
      'Ka lakòz chanjman nan sik règ la.',
      'Konsilte yon doktè anvan w kòmanse.',
    ],
    'Kontrasepsyon: PIU (Stérilet)': [
      'PIU se yon ti aparèy mete nan matris.',
      'Dire 5-10 an selon mawòk la.',
      'Efikasite plis pase 99%.',
      'Dwe mete ak retire pa yon doktè.',
    ],
    'VIP/SIDA: Kisa ou dwe konnen': [
      'VIP transmèt pa san, sèks, ak lèt manman.',
      'Sèvi ak kapòt chak fwa ou fè sèks.',
      'Fè tès regilyèman si w aktif seksyèlman.',
      'VIP pa yon santans. Gen tretman ki ede moun viv lontan.',
    ],
    'IST (Enfeksyon Seksyèlman Transmisib)': [
      'IST gen ladan: klamidya, gonore, sifilis, HPV, èpès.',
      'Sèvi ak kapòt pou diminye risk.',
      'Fè tès regilyèman menm si w pa gen sentòm.',
      'Anpil IST ka trete si yo pran bonè.',
    ],
    'Sante mantal: Enpòtans li': [
      'Sante mantal enpòtan menm jan ak sante fizik.',
      'Si w santi w tris, enkyete, oswa poukont, pale ak yon moun.',
      'Li nòmal gen emosyon. Pa nan tèt ou poukont.',
      'Konsilte yon sikològ si w bezwen èd.',
    ],
    'Estres ak jèsyon emosyon': [
      'Estres nòmal nan laj sa a.',
      'Pratike respirasyon gwo pwofondè pou kalme.',
      'Ekri sa w santi nan yon jounal.',
      'Fè egzèsis, danse, oswa mache pou libere enèji.',
    ],
    'Imaj kò ak konfyans tèt': [
      'Kò w ap chanje pandan puberté, se nòmal.',
      'Pa konpare tèt ou ak imaj sou entènèt.',
      'Chak kò diferan ak bèl nan fason pa li.',
      'Pale byen sou tèt ou chak jou.',
    ],
    'Presyon sosyal ak medya': [
      'Pa kwè tout sa w wè sou entènèt.',
      'Medya souvan montre imaj fo.',
      'Reflechi avan w pataje foto sou WhatsApp.',
      'Ou pa bezwen swiv tout tandans.',
    ],
    'Dwa w kòm jèn fi': [
      'Ou gen dwa ale lekòl.',
      'Ou gen dwa pwoteje tèt ou kont vyolans.',
      'Ou gen dwa di NON.',
      'Ou gen dwa jwenn enfòmasyon sou sante w.',
      'Ou gen dwa konsilte yon doktè san wont.',
    ],
    'Vyolans nan relasyon jèn': [
      'Si yon moun fè w mal, rele w non, oswa kontwole w, se vyolans.',
      'Vyolans kapab fizik, emosyonèl, oswa sèksyèl.',
      'Ou pa merite vyolans. Se pa fòt ou.',
      'Pale ak yon granmoun ou fè konfyans oswa rele 133.',
    ],
    'Gwosès jèn: Anpeche li': [
      'Sèvi ak kontrasepsyon si w aktif seksyèlman.',
      'Kapòt se pi bon metòd pou jèn.',
      'Pa janm fè sèks san ou pa vle.',
      'Si w panse w genyen gwosès, fè tès san bonè.',
    ],
    'Gwosès jèn: Kisa pou fè': [
      'Si w ansent, pa pè. Gen moun kap ede w.',
      'Pale ak yon granmoun ou fè konfyans.',
      'Ale nan yon klinik pou swivi prensantal.',
      'Pa janm eseye fòse kò w pèdi pitit nan metòd danjere.',
    ],
    'Abi sèksyèl: Konnen siy yo': [
      'Pèsonn pa gen dwa manyen kò ou san pèmisyon.',
      'Si yon moun fè w santi w mal ak manyen yo, se abi.',
      'Ou gen dwa di NON fò.',
      'Pale ak yon moun ou fè konfyans imedyatman.',
    ],
    'Kijan pou di NON': [
      'Di NON ak vwa fò.',
      'Pa pè brize relasyon an.',
      'Santi w byen ak chwa w ap fè yo.',
      'Yon moun ki renmen w ap respekte w.',
    ],
    'Anvi sèks: Nòmal oswa pa?': [
      'Anvi sèks se nòmal pandan puberté.',
      'Chak moun pa gen menm anvi a.',
      'Pa janm santi w oblije fè sèks.',
      'Fè sèks se yon gwo desizyon. Pran tan ou.',
    ],
    'Masturbasyon: Ki verite a': [
      'Masturbasyon se nòmal, anpil moun fè l.',
      'Li pa danjere pou sante w.',
      'Fè l nan yon espas prive.',
      'Pa kite pèsonn fè w wont sou sa.',
    ],
    'Orientasyon seksyèl ak idantite': [
      'Ou ka renmen moun ki menm sèks ou oswa diferan.',
      'Se nòmal. Ou pa poukont ou.',
      'Gen moun ki konprann ak sipòte w.',
      'Pa kite pèsonn fè w santi w mal.',
    ],
    'Sèks ak entènèt: Pratikasan': [
      'Pa janm voye foto nid nan pèsonn.',
      'Yon foto ka gaye san pèmisyon.',
      'Pa rankontre moun sou entènèt san granmoun.',
      'Si w santi w presyon, bloke moun nan.',
    ],
    'Nitrisyon pou jèn fi': [
      'Manje fwi ak legim chak jou.',
      'Bwar dlo ase (6-8 vè pa jou).',
      'Pa sote manje. Manje maten enpòtan.',
      'Fè, fèy vèt, pwason bon pou san w.',
    ],
    'Egzèsis ak aktivite fizik': [
      'Fè egzèsis 30 minit chak jou.',
      'Danse, mache, kouri — chwazi sa w renmen.',
      'Egzèsis ede diminye estrès.',
      'Li bon pou kè, zo, ak atitid.',
    ],
    'Dòmi: Bezwen jèn yo': [
      'Jèn bezwen 8-10 èdtan dòmi chak nwit.',
      'Dòmi ede kò w grandi ak repare.',
      'Evite telefòn avan dòmi.',
      'Yon bon dòmi ede w konsantre lekòl.',
    ],
    'Lekòl: Konsantrasyon ak siksè': [
      'Fè yon orè etid chak jou.',
      'Pran ti repo chak 30 minit.',
      'Mande èd si w pa konprann.',
      'Ou kapab reyisi si w fè efò.',
    ],
    'Presyon kanmarad (peer pressure)': [
      'Pa fè anyen ou pa vle pou fè plezi lòt moun.',
      'Chwazi zanmi ki respekte w.',
      'Se pa paske tout moun ap fè l ke ou dwe fè l tou.',
      'Gen kouraj pou w di NON.',
    ],
    'Emosyon: Konprann santiman w': [
      'Santiman chanje byen vit nan laj sa a.',
      'Li nòmal santi w kontan, tris, fache.',
      'Ekri santiman w ede w konprann yo.',
      'Pale ak yon moun ou fè konfyans.',
    ],
    'Premye amou ak relasyon': [
      'Premye amou se bèl men kapab konplike.',
      'Pa prese. Pran tan ou konnen moun nan.',
      'Yon relasyon sante bati sou respè.',
      'Si w pa santi w byen, kite l.',
    ],
  };

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: [AppTheme.lavenderPale, Color(0xFFFFF0F5)]),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          title: const Text('🏫 Jèn Fanm (${_content.length})'),
        ),
        body: ListView(
          padding: const EdgeInsets.all(16),
          children: _content.entries.map((entry) {
            return Card(
              child: ExpansionTile(
                leading: CircleAvatar(
                  backgroundColor: AppTheme.lavenderPale,
                  child: const Icon(Icons.school, color: AppTheme.lavender, size: 20),
                ),
                title: Text(entry.key, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
                childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                children: entry.value.map((tip) => Padding(
                  padding: const EdgeInsets.only(bottom: 6),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(Icons.check_circle, size: 16, color: AppTheme.lavender),
                      const SizedBox(width: 8),
                      Expanded(child: Text(tip, style: const TextStyle(fontSize: 13, height: 1.4))),
                    ],
                  ),
                )).toList(),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}
