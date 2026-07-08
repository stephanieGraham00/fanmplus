import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/auth_service.dart';
import '../services/storage_service.dart';
import '../theme/app_theme.dart';
import '../utils/constants.dart';
import 'admin_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthService>();
    final storage = context.watch<StorageService>();
    final user = auth.currentUser;

    if (user == null) return const SizedBox();

    final userPosts = storage.posts.where((p) => p.userId == user.id).length;

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [AppTheme.rosePale, AppTheme.lavenderPale],
          ),
        ),
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            const SizedBox(height: 20),
            Center(
              child: Stack(
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundColor: AppTheme.roseLight,
                    child: Text(
                      user.isAnonymous ? 'A' : user.username[0].toUpperCase(),
                      style: const TextStyle(
                        fontSize: 36,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: CircleAvatar(
                      radius: 16,
                      backgroundColor: AppTheme.rose,
                      child: const Icon(
                        Icons.camera_alt,
                        size: 16,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Center(
              child: Text(
                user.isAnonymous ? 'Anonim' : user.username,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Center(
              child: Text(
                user.email,
                style: const TextStyle(color: Colors.grey),
              ),
            ),
            if (user.bio.isNotEmpty)
              Center(
                child: Padding(
                  padding: const EdgeInsets.only(top: 4),
                  child: Text(
                    user.bio,
                    style: const TextStyle(color: Colors.grey, fontStyle: FontStyle.italic),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            const SizedBox(height: 20),
            Card(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildStat('Pòs', '$userPosts'),
                    _buildStat('Swiv', '${user.followingCount}'),
                    _buildStat('Swivan', '${user.followerCount}'),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            Card(
              child: Column(
                children: [
                  SwitchListTile(
                    title: const Row(
                      children: [
                        Icon(Icons.visibility_off, color: AppTheme.rose),
                        SizedBox(width: 12),
                        Text('Mòd Anonim'),
                      ],
                    ),
                    subtitle: const Text('Pòs ou ap pibliye kache idantite w'),
                    value: user.isAnonymous,
                    onChanged: (v) => auth.toggleAnonymous(),
                    activeColor: AppTheme.rose,
                  ),
                  const Divider(height: 1),
                  SwitchListTile(
                    title: const Row(
                      children: [
                        Icon(Icons.fingerprint, color: AppTheme.lavender),
                        SizedBox(width: 12),
                        Text('Biometrik'),
                      ],
                    ),
                    subtitle: const Text('Ouvri app la ak anprent dwèt ou'),
                    value: auth.biometricEnabled,
                    onChanged: (v) => auth.toggleBiometric(),
                    activeColor: AppTheme.lavender,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Card(
              child: Column(
                children: [
                  ListTile(
                    leading: const Icon(Icons.edit, color: AppTheme.rose),
                    title: const Text('Modifye Pwofil'),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () => _editProfile(context, auth),
                  ),
                  const Divider(height: 1),
                  ListTile(
                    leading: const Icon(Icons.admin_panel_settings, color: Colors.indigo),
                    title: const Text('Admin'),
                    subtitle: const Text('Estatistik ak kontwòl'),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const AdminScreen())),
                  ),
                  const Divider(height: 1),
                  ListTile(
                    leading: const Icon(Icons.shield, color: Colors.green),
                    title: const Text('Sekirite'),
                    subtitle: const Text('Modpas ak pwoteksyon'),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () => _showSecurityDialog(context),
                  ),
                  const Divider(height: 1),
                  ListTile(
                    leading: const Icon(Icons.info_outline, color: AppTheme.lavender),
                    title: const Text('À propos'),
                    subtitle: const Text('Devlòpè, verèsyon & copyright'),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () => _showAboutDialog(context),
                  ),
                  const Divider(height: 1),
                  ListTile(
                    leading: const Icon(Icons.logout, color: Colors.red),
                    title: const Text('Dekonekte'),
                    onTap: () async {
                      final confirm = await showDialog<bool>(
                        context: context,
                        builder: (ctx) => AlertDialog(
                          title: const Text('Dekonekte'),
                          content: const Text('Eske w si w vle dekonekte?'),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(ctx, false),
                              child: const Text('Anile'),
                            ),
                            ElevatedButton(
                              onPressed: () => Navigator.pop(ctx, true),
                              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                              child: const Text('Wi, dekonekte'),
                            ),
                          ],
                        ),
                      );
                      if (confirm == true) {
                        auth.signOut();
                      }
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppTheme.roseLight.withOpacity(0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Column(
              children: [
                Text(
                  'Devlòpè: STEPHANIE A.G',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.rose,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  '© 2026 Fanm+. Tout dwa rezève.',
                  style: TextStyle(fontSize: 12, color: Colors.grey),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildStat(String label, String value) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: AppTheme.rose,
          ),
        ),
        Text(
          label,
          style: const TextStyle(color: Colors.grey, fontSize: 13),
        ),
      ],
    );
  }

  void _editProfile(BuildContext context, AuthService auth) {
    final bioController = TextEditingController(text: auth.currentUser?.bio ?? '');
    final usernameController =
        TextEditingController(text: auth.currentUser?.username ?? '');

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Modifye Pwofil'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: usernameController,
              decoration: const InputDecoration(
                labelText: 'Non itilizatè',
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: bioController,
              maxLines: 3,
              decoration: const InputDecoration(
                labelText: 'Biyografi',
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              bioController.dispose();
              usernameController.dispose();
              Navigator.pop(ctx);
            },
            child: const Text('Anile'),
          ),
          ElevatedButton(
            onPressed: () {
              if (usernameController.text.trim().isNotEmpty) {
                auth.updateProfile(
                  username: usernameController.text.trim(),
                  bio: bioController.text.trim(),
                );
              }
              bioController.dispose();
              usernameController.dispose();
              Navigator.pop(ctx);
            },
            child: const Text('Anrejistre'),
          ),
        ],
      ),
    );
  }

  void _showSecurityDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Row(
          children: [
            Icon(Icons.shield, color: Colors.green),
            SizedBox(width: 8),
            Text('Sekirite'),
          ],
        ),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.check_circle, color: Colors.green, size: 18),
                SizedBox(width: 8),
                Text('Modpas kode ak algorithm sekirize'),
              ],
            ),
            SizedBox(height: 8),
            Row(
              children: [
                Icon(Icons.check_circle, color: Colors.green, size: 18),
                SizedBox(width: 8),
                Text('Tout done anrejistre lokalman'),
              ],
            ),
            SizedBox(height: 8),
            Row(
              children: [
                Icon(Icons.check_circle, color: Colors.green, size: 18),
                SizedBox(width: 8),
                Text('Pwoteksyon kont pirataj (injection)'),
              ],
            ),
            SizedBox(height: 8),
            Row(
              children: [
                Icon(Icons.check_circle, color: Colors.green, size: 18),
                SizedBox(width: 8),
                Text('Mòd anonim pou pwoteksyon idantite'),
              ],
            ),
            SizedBox(height: 8),
            Row(
              children: [
                Icon(Icons.check_circle, color: Colors.green, size: 18),
                SizedBox(width: 8),
                Text('Seansyon an sekirize avèk token'),
              ],
            ),
            SizedBox(height: 16),
            Text(
              'Fanm+ pran sekirite ou oserye. '
              'Tout done yo anrejistre lokalman sou aparèy ou.',
              style: TextStyle(color: Colors.grey, fontSize: 13),
            ),
          ],
        ),
        actions: [
          ElevatedButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Fèmen'),
          ),
        ],
      ),
    );
  }

  void _showAboutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Row(children: [
          CircleAvatar(backgroundColor: AppTheme.roseLight, radius: 20, child: Text('🌸', style: TextStyle(fontSize: 20))),
          SizedBox(width: 12),
          Text('À propos Fanm+'),
        ]),
        content: SingleChildScrollView(
          child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [
            const Center(child: Text('🌸', style: TextStyle(fontSize: 48))),
            const SizedBox(height: 8),
            const Center(child: Text('Fanm+', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: AppTheme.lavender))),
            const Center(child: Text('v${AppConstants.appVersion}', style: TextStyle(color: Colors.grey))),
            const SizedBox(height: 16),
            const Text('Fanm+ se yon espas sekirize pou fanm. Yon kote pou w santi w an sekirite, pataje eksperyans, swiv sik menstruel ou, byennèt, ak chat ak lòt fanm.', style: TextStyle(fontSize: 13, height: 1.5)),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(color: AppTheme.roseLight.withOpacity(0.2), borderRadius: BorderRadius.circular(12)),
              child: const Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Row(children: [Icon(Icons.code, size: 16, color: AppTheme.rose), SizedBox(width: 8), Text('Devlòpè:', style: TextStyle(fontWeight: FontWeight.w600, color: AppTheme.rose))]),
                SizedBox(height: 4),
                Text(AppConstants.developer, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: AppTheme.rose)),
                SizedBox(height: 4),
                Text('Yon jèn fanm ayisyen kap sipòte fanm.', style: TextStyle(fontSize: 12, color: Colors.grey)),
                SizedBox(height: 8),
                Row(children: [Icon(Icons.favorite, size: 16, color: AppTheme.rose), SizedBox(width: 8), Expanded(child: Text('Fèt ak anpil lanmou pou tout fanm.', style: TextStyle(fontSize: 12, color: Colors.grey)))]),
                SizedBox(height: 4),
                Row(children: [Icon(Icons.location_on, size: 16, color: AppTheme.rose), SizedBox(width: 8), Text('Ayiti 🇭🇹', style: TextStyle(fontSize: 12, color: Colors.grey))]),
              ]),
            ),
            const SizedBox(height: 12),
            const Center(child: Text(AppConstants.copyright, style: TextStyle(color: Colors.grey, fontSize: 12))),
            const SizedBox(height: 4),
            const Center(child: Text('Tout dwa rezève.', style: TextStyle(color: Colors.grey, fontSize: 12))),
          ]),
        ),
        actions: [ElevatedButton(onPressed: () => Navigator.pop(ctx), child: const Text('Fèmen'))],
      ),
    );
  }
}
