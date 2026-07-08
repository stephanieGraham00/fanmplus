import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/auth_service.dart';
import '../services/storage_service.dart'
import '../theme/app_theme.dart';
import '../utils/constants.dart';
import '../widgets/app_icon.dart';

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
                      child: const AppIcon('firstAid', size: 16, color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Center(
              child: Text(
                user.isAnonymous ? 'Anonyme' : user.username,
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
                    _buildStat('Posts', '$userPosts'),
                    _buildStat('Suivi', '${user.followingCount}'),
                    _buildStat('Suiveurs', '${user.followerCount}'),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            Card(
              child: Column(
                children: [
                  SwitchListTile(
                    title: Row(
                      children: [
                        const AppIcon('firstAid', size: 22, color: AppTheme.rose),
                        const SizedBox(width: 12),
                        const Text('Mode anonyme'),
                      ],
                    ),
                    subtitle: const Text('Vos publications seront anonymes'),
                    value: user.isAnonymous,
                    onChanged: (v) => auth.toggleAnonymous(),
                    activeColor: AppTheme.rose,
                  ),
                  const Divider(height: 1),
                  SwitchListTile(
                    title: Row(
                      children: [
                        const AppIcon('firstAid', size: 22, color: AppTheme.lavender),
                        const SizedBox(width: 12),
                        const Text('Biométrie'),
                      ],
                    ),
                    subtitle: const Text('Ouvrir l\'app avec votre empreinte'),
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
                    leading: const AppIcon('firstAid', size: 22, color: AppTheme.rose),
                    title: const Text('Modifier le profil'),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () => _editProfile(context, auth),
                  ),
                  const Divider(height: 1),
                  ListTile(
                    leading: const AppIcon('firstAid', size: 22, color: Colors.indigo),
                    title: const Text('Administration'),
                    subtitle: const Text('Statistiques et contrôles'),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const AdminScreen())),
                  ),
                  const Divider(height: 1),
                  ListTile(
                    leading: const AppIcon('firstAid', size: 22, color: Colors.green),
                    title: const Text('Sécurité'),
                    subtitle: const Text('Mot de passe et protection'),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () => _showSecurityDialog(context),
                  ),
                  const Divider(height: 1),
                  ListTile(
                    leading: const AppIcon('firstAid', size: 22, color: AppTheme.lavender),
                    title: const Text('À propos'),
                    subtitle: const Text('Développeur, version & copyright'),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () => _showAboutDialog(context),
                  ),
                  const Divider(height: 1),
                  ListTile(
                    leading: const AppIcon('firstAid', size: 22, color: Colors.red),
                    title: const Text('Déconnexion'),
                    onTap: () async {
                      final confirm = await showDialog<bool>(
                        context: context,
                        builder: (ctx) => AlertDialog(
                          title: const Text('Déconnexion'),
                          content: const Text('Êtes-vous sûr de vouloir vous déconnecter ?'),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(ctx, false),
                              child: const Text('Annuler'),
                            ),
                            ElevatedButton(
                              onPressed: () => Navigator.pop(ctx, true),
                              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                              child: const Text('Oui, déconnecter'),
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
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppTheme.roseLight.withOpacity(0.2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  Text(
                    'Développeur: ${AppConstants.developer}',
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: AppTheme.rose,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Tél: ${AppConstants.developerPhone}',
                    style: const TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    AppConstants.copyright,
                    style: const TextStyle(fontSize: 12, color: Colors.grey),
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
        title: const Text('Modifier le profil'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: usernameController,
              decoration: const InputDecoration(
                labelText: "Nom d'utilisateur",
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: bioController,
              maxLines: 3,
              decoration: const InputDecoration(
                labelText: 'Biographie',
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
            child: const Text('Annuler'),
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
            child: const Text('Enregistrer'),
          ),
        ],
      ),
    );
  }

  void _showSecurityDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Row(
          children: [
            const AppIcon('firstAid', size: 22, color: Colors.green),
            const SizedBox(width: 8),
            const Text('Sécurité'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const AppIcon('firstAid', size: 18, color: Colors.green),
                const SizedBox(width: 8),
                const Text('Mot de passe chiffré avec algorithme sécurisé'),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const AppIcon('firstAid', size: 18, color: Colors.green),
                const SizedBox(width: 8),
                const Text('Toutes les données stockées localement'),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const AppIcon('firstAid', size: 18, color: Colors.green),
                const SizedBox(width: 8),
                const Text('Protection contre les injections'),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const AppIcon('firstAid', size: 18, color: Colors.green),
                const SizedBox(width: 8),
                const Text('Mode anonyme pour protéger l\'identité'),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const AppIcon('firstAid', size: 18, color: Colors.green),
                const SizedBox(width: 8),
                const Text('Session sécurisée avec token'),
              ],
            ),
            const SizedBox(height: 16),
            const Text(
              'Fanm+ prend votre sécurité au sérieux. '
              'Toutes les données sont stockées localement sur votre appareil.',
              style: TextStyle(color: Colors.grey, fontSize: 13),
            ),
          ],
        ),
        actions: [
          ElevatedButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Fermer'),
          ),
        ],
      ),
    );
  }

  void _showAboutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Row(children: [
          CircleAvatar(backgroundColor: AppTheme.roseLight, radius: 20, child: const AppIcon('paper', size: 20)),
          const SizedBox(width: 12),
          const Text('À propos de Fanm+'),
        ]),
        content: SingleChildScrollView(
          child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [
            Center(child: const AppIcon('paper', size: 48)),
            const SizedBox(height: 8),
            const Center(child: Text('Fanm+', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: AppTheme.lavender))),
            const Center(child: Text('v${AppConstants.appVersion}', style: TextStyle(color: Colors.grey))),
            const SizedBox(height: 16),
            const Text('Fanm+ est un espace sûr pour les femmes. Un lieu pour vous sentir en sécurité, partager des expériences, suivre votre cycle menstruel, votre bien-être, et discuter avec d\'autres femmes.', style: TextStyle(fontSize: 13, height: 1.5)),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(color: AppTheme.roseLight.withOpacity(0.2), borderRadius: BorderRadius.circular(12)),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Row(children: [const AppIcon('firstAid', size: 16, color: AppTheme.rose), const SizedBox(width: 8), const Text('Développeur:', style: TextStyle(fontWeight: FontWeight.w600, color: AppTheme.rose))]),
                const SizedBox(height: 4),
                Text(AppConstants.developer, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: AppTheme.rose)),
                const SizedBox(height: 4),
                Row(children: [
                  const Icon(Icons.phone, size: 14, color: AppTheme.rose),
                  const SizedBox(width: 6),
                  Text(AppConstants.developerPhone, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppTheme.lavender)),
                ]),
                const SizedBox(height: 4),
                const Text('Jeune femme haïtienne au service des femmes.', style: TextStyle(fontSize: 12, color: Colors.grey)),
                const SizedBox(height: 8),
                Row(children: [const AppIcon('firstAid', size: 16, color: AppTheme.rose), const SizedBox(width: 8), const Expanded(child: Text('Fait avec beaucoup d\'amour pour toutes les femmes.', style: TextStyle(fontSize: 12, color: Colors.grey)))]),
                const SizedBox(height: 4),
                Row(children: [const Icon(Icons.location_on, size: 16, color: AppTheme.rose), const SizedBox(width: 8), const Text('Haïti 🇭🇹', style: TextStyle(fontSize: 12, color: Colors.grey))]),
              ]),
            ),
            const SizedBox(height: 12),
            const Center(child: Text(AppConstants.copyright, style: TextStyle(color: Colors.grey, fontSize: 12))),
            const SizedBox(height: 4),
            const Center(child: Text('Tous droits réservés.', style: TextStyle(color: Colors.grey, fontSize: 12))),
          ]),
        ),
        actions: [ElevatedButton(onPressed: () => Navigator.pop(ctx), child: const Text('Fermer'))],
      ),
    );
  }
}