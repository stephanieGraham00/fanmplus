import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';
import '../../widgets/glass_card.dart';
import '../../providers/theme_provider.dart';
import '../../providers/auth_provider.dart';
import '../../providers/language_provider.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  bool _pinLock = false;
  bool _notifications = true;
  final bool _canUseBiometrics = !kIsWeb;

  @override
  Widget build(BuildContext context) {
    final tr = ref.watch(translationsProvider);
    final locale = ref.watch(localeProvider);
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(tr.profile, style: AppTextStyles.headlineLarge),
              const SizedBox(height: 24),

              GlassCard(
                padding: const EdgeInsets.all(24),
                child: Column(
                  children: [
                    Container(
                      width: 80, height: 80,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: AppColors.primaryGradient,
                        boxShadow: [BoxShadow(color: AppColors.primary.withOpacity(0.3), blurRadius: 20)],
                      ),
                      child: const Center(child: Text('♥', style: TextStyle(fontSize: 36, color: AppColors.white))),
                    ),
                    const SizedBox(height: 16),
                    Text('Fanm+ Sè', style: AppTextStyles.headlineMedium),
                    const SizedBox(height: 4),
                    Text(tr.strongBeautiful, style: AppTextStyles.bodyMedium),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _ProfileStat('12', tr.posts),
                        const SizedBox(width: 32),
                        _ProfileStat('45', tr.followers),
                        const SizedBox(width: 32),
                        _ProfileStat('28', tr.following),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              Text(tr.settings, style: AppTextStyles.headlineLarge),
              const SizedBox(height: 12),

              _SettingItem(
                icon: '🌐',
                title: tr.language,
                value: locale.languageCode == 'fr' ? 'Français' : 'English',
                onTap: () => _showLanguagePicker(tr),
              ),
              _SettingItem(
                icon: '🔔',
                title: tr.notifications,
                value: _notifications ? tr.enabled : tr.disabled,
                trailing: Switch(
                  value: _notifications,
                  activeColor: AppColors.primary,
                  onChanged: (v) => setState(() => _notifications = v),
                ),
              ),
              _SettingItem(
                icon: '🔒',
                title: tr.pinLock,
                value: _pinLock ? tr.enabled : tr.disabled,
                trailing: Switch(
                  value: _pinLock,
                  activeColor: AppColors.primary,
                  onChanged: (v) => setState(() => _pinLock = v),
                ),
              ),
              _SettingItem(
                icon: '🌙',
                title: tr.darkMode,
                value: '',
                trailing: Switch(
                  value: ref.watch(themeProvider) == ThemeMode.dark,
                  activeColor: AppColors.primary,
                  onChanged: (v) => ref.read(themeProvider.notifier).toggleTheme(),
                ),
              ),
              const SizedBox(height: 24),

              Text(tr.account, style: AppTextStyles.headlineLarge),
              const SizedBox(height: 12),

              GlassCard(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    _MenuRow(Icons.person_outline, tr.editProfile, () {}),
                    const Divider(),
                    _MenuRow(Icons.star_border, tr.premium, () => context.go('/premium')),
                    const Divider(),
                    _MenuRow(Icons.cloud_outlined, tr.backupSync, () {}),
                    const Divider(),
                    _MenuRow(Icons.description_outlined, tr.healthReport, () {}),
                    const Divider(),
                    _MenuRow(Icons.logout, tr.logout, () {
                      ref.read(authServiceProvider).signOut();
                      context.go('/login');
                    }, color: AppColors.error),
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

  void _showLanguagePicker(AppTranslations tr) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
      ),
      builder: (ctx) => Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(width: 40, height: 4, decoration: BoxDecoration(color: AppColors.secondaryLight, borderRadius: BorderRadius.circular(2))),
            const SizedBox(height: 20),
            Text(tr.selectLanguage, style: AppTextStyles.headlineMedium),
            const SizedBox(height: 16),
            ListTile(
              title: const Text('English', style: AppTextStyles.bodyLarge),
              trailing: ref.read(localeProvider).languageCode == 'en' ? const Icon(Icons.check, color: AppColors.primary) : null,
              onTap: () {
                ref.read(localeProvider.notifier).setLocale(const Locale('en'));
                Navigator.pop(ctx);
              },
            ),
            ListTile(
              title: const Text('Français', style: AppTextStyles.bodyLarge),
              trailing: ref.read(localeProvider).languageCode == 'fr' ? const Icon(Icons.check, color: AppColors.primary) : null,
              onTap: () {
                ref.read(localeProvider.notifier).setLocale(const Locale('fr'));
                Navigator.pop(ctx);
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _ProfileStat extends StatelessWidget {
  final String value, label;
  const _ProfileStat(this.value, this.label);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(value, style: AppTextStyles.headlineMedium.copyWith(color: AppColors.primary)),
        Text(label, style: AppTextStyles.labelSmall),
      ],
    );
  }
}

class _SettingItem extends StatelessWidget {
  final String icon, title, value;
  final Widget? trailing;
  final VoidCallback? onTap;

  const _SettingItem({required this.icon, required this.title, required this.value, this.trailing, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      onTap: onTap,
      child: Row(
        children: [
          Text(icon, style: const TextStyle(fontSize: 20)),
          const SizedBox(width: 12),
          Expanded(child: Text(title, style: AppTextStyles.titleMedium)),
          if (value.isNotEmpty) Text(value, style: AppTextStyles.bodySmall),
          if (trailing != null) trailing!,
        ],
      ),
    );
  }
}

class _MenuRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final Color? color;

  const _MenuRow(this.icon, this.label, this.onTap, {this.color});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: color ?? AppColors.textPrimary),
      title: Text(label, style: AppTextStyles.bodyLarge.copyWith(color: color)),
      trailing: const Icon(Icons.chevron_right, color: AppColors.textHint),
      onTap: onTap,
      contentPadding: EdgeInsets.zero,
    );
  }
}
