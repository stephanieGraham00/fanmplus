import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';
import '../../providers/auth_provider.dart';
import '../../providers/language_provider.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _emailController = TextEditingController(text: 'admin@fanmplus.com');
  final _passwordController = TextEditingController(text: 'admin123');
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  bool _obscurePassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isLoading = true);
    try {
      await ref.read(loginProvider).login(
        _emailController.text.trim(),
        _passwordController.text,
      );
      if (mounted) context.go('/home');
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('❌ ${e.toString()}')),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final tr = ref.watch(translationsProvider);
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                const SizedBox(height: 60),
                Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: AppColors.primaryGradient,
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primary.withOpacity(0.3),
                        blurRadius: 30,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  child: const Center(
                    child: Text('🌸', style: TextStyle(fontSize: 44)),
                  ),
                ),
                const SizedBox(height: 24),
                Text(tr.appName, style: AppTextStyles.displayLarge),
                const SizedBox(height: 8),
                Text(
                  tr.tagline,
                  style: AppTextStyles.bodyLarge.copyWith(color: AppColors.textSecondary),
                ),
                const SizedBox(height: 48),
                TextFormField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    hintText: tr.email,
                    prefixIcon: const Icon(Icons.email_outlined),
                  ),
                  validator: (v) {
                    if (v == null || v.isEmpty) return tr.enterEmail;
                    if (!v.contains('@')) return 'Invalid email';
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _passwordController,
                  obscureText: _obscurePassword,
                  decoration: InputDecoration(
                    hintText: tr.password,
                    prefixIcon: const Icon(Icons.lock_outlined),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscurePassword ? Icons.visibility_off : Icons.visibility,
                      ),
                      onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                    ),
                  ),
                  validator: (v) {
                    if (v == null || v.isEmpty) return tr.enterPassword;
                    if (v.length < 4) return 'Min 4 characters';
                    return null;
                  },
                ),
                const SizedBox(height: 8),
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () {},
                    child: Text(tr.forgotPassword, style: AppTextStyles.bodySmall.copyWith(color: AppColors.primary)),
                  ),
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _login,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: AppColors.white,
                      disabledBackgroundColor: AppColors.primary.withOpacity(0.5),
                    ),
                    child: _isLoading
                        ? const SizedBox(height: 24, width: 24, child: CircularProgressIndicator(strokeWidth: 2, color: AppColors.white))
                        : Text(tr.login, style: AppTextStyles.buttonText),
                  ),
                ),
                const SizedBox(height: 24),
                Row(
                  children: [
                    const Expanded(child: Divider()),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Text(tr.or, style: AppTextStyles.bodySmall.copyWith(color: AppColors.textHint)),
                    ),
                    const Expanded(child: Divider()),
                  ],
                ),
                const SizedBox(height: 24),
                _SocialButton(
                  icon: 'G',
                  label: 'Google',
                  onTap: () async {
                    try {
                      await ref.read(loginProvider).signInWithGoogle();
                      if (mounted) context.go('/home');
                    } catch (e) {
                      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('❌ $e')));
                    }
                  },
                  tr: tr,
                ),
                const SizedBox(height: 12),
                _SocialButton(
                  icon: '🍎',
                  label: 'Apple',
                  onTap: () async {
                    try {
                      await ref.read(loginProvider).signInWithApple();
                      if (mounted) context.go('/home');
                    } catch (e) {
                      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('❌ $e')));
                    }
                  },
                  tr: tr,
                ),
                const SizedBox(height: 32),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(tr.noAccount, style: AppTextStyles.bodyMedium),
                    GestureDetector(
                      onTap: () => context.go('/register'),
                      child: Text(tr.createAccount, style: AppTextStyles.titleMedium.copyWith(color: AppColors.primary)),
                    ),
                  ],
                ),
                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _SocialButton extends StatelessWidget {
  final String icon;
  final String label;
  final VoidCallback onTap;
  final AppTranslations tr;

  const _SocialButton({required this.icon, required this.label, required this.onTap, required this.tr});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 52,
      child: OutlinedButton(
        onPressed: onTap,
        style: OutlinedButton.styleFrom(
          side: BorderSide(color: AppColors.secondaryLight),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 24, height: 24,
              decoration: const BoxDecoration(shape: BoxShape.circle, color: AppColors.secondaryLight),
              child: Center(child: Text(icon, style: AppTextStyles.titleSmall.copyWith(color: AppColors.textSecondary))),
            ),
            const SizedBox(width: 12),
            Text(tr.continueWith(label), style: AppTextStyles.titleMedium.copyWith(color: AppColors.textPrimary)),
          ],
        ),
      ),
    );
  }
}
