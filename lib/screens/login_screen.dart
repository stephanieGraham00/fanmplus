import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/auth_service.dart';
import '../theme/app_theme.dart';
import '../widgets/app_icon.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> with SingleTickerProviderStateMixin {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _usernameController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isLogin = true;
  bool _obscurePassword = true;
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _usernameController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    if (_isLoading) return;

    setState(() => _isLoading = true);

    final auth = context.read<AuthService>();
    bool success;

    if (_isLogin) {
      success = await auth.signIn(
        _emailController.text.trim(),
        _passwordController.text,
      );
    } else {
      success = await auth.signUp(
        _usernameController.text.trim(),
        _emailController.text.trim(),
        _passwordController.text,
      );
    }

    if (!mounted) return;
    setState(() => _isLoading = false);

    if (!success) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(_isLogin
              ? 'Email ou mot de passe incorrect'
              : 'Inscription échouée. Veuillez réessayer.'),
          backgroundColor: Colors.red.shade400,
        ),
      );
    }
  }

  void _switchMode() {
    setState(() => _isLogin = !_isLogin);
    _formKey.currentState?.reset();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        body: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [AppTheme.rose, AppTheme.lavender],
            ),
          ),
          child: SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const AppIcon('paper', size: 72),
                      const SizedBox(height: 8),
                      const Text(
                        'Fanm+',
                        style: TextStyle(
                          fontSize: 36,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          letterSpacing: 2,
                        ),
                      ),
                      const Text(
                        'Espace sûr pour les femmes',
                        style: TextStyle(fontSize: 14, color: Colors.white70),
                      ),
                      const SizedBox(height: 40),
                      Card(
                        child: Padding(
                          padding: const EdgeInsets.all(24),
                          child: Column(
                            children: [
                              Text(
                                _isLogin ? 'Connexion' : 'Inscription',
                                style: const TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 20),
                              if (!_isLogin)
                                TextFormField(
                                  controller: _usernameController,
                                  textCapitalization: TextCapitalization.words,
                                  decoration: const InputDecoration(
                                    labelText: "Nom d'utilisateur",
                                    prefixIcon: AppIcon('community', size: 20),
                                  ),
                                  validator: (v) =>
                                      v == null || v.trim().isEmpty
                                          ? 'Champ obligatoire'
                                          : null,
                                ),
                              if (!_isLogin) const SizedBox(height: 16),
                              TextFormField(
                                controller: _emailController,
                                decoration: const InputDecoration(
                                  labelText: 'Email',
                                  prefixIcon: AppIcon('paper', size: 20),
                                ),
                                keyboardType: TextInputType.emailAddress,
                                textInputAction: TextInputAction.next,
                                validator: (v) {
                                  if (v == null || v.trim().isEmpty) {
                                    return 'Champ obligatoire';
                                  }
                                  if (!v.contains('@') || !v.contains('.')) {
                                    return 'Email invalide';
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(height: 16),
                              TextFormField(
                                controller: _passwordController,
                                decoration: InputDecoration(
                                  labelText: 'Mot de passe',
                                  prefixIcon: const AppIcon('firstAid', size: 20),
                                  suffixIcon: IconButton(
                                    icon: Icon(
                                      _obscurePassword
                                          ? Icons.visibility_off
                                          : Icons.visibility,
                                    ),
                                    onPressed: () => setState(
                                        () => _obscurePassword = !_obscurePassword),
                                  ),
                                ),
                                obscureText: _obscurePassword,
                                textInputAction: TextInputAction.done,
                                onFieldSubmitted: (_) => _submit(),
                                validator: (v) {
                                  if (v == null || v.isEmpty) return 'Champ obligatoire';
                                  if (v.length < 4) return 'Le mot de passe doit contenir au moins 4 caractères';
                                  return null;
                                },
                              ),
                              const SizedBox(height: 24),
                              SizedBox(
                                width: double.infinity,
                                height: 48,
                                child: ElevatedButton(
                                  onPressed: _isLoading ? null : _submit,
                                  child: _isLoading
                                      ? const SizedBox(
                                          height: 20,
                                          width: 20,
                                          child: CircularProgressIndicator(
                                            strokeWidth: 2,
                                            color: Colors.white,
                                          ),
                                        )
                                      : Text(
                                          _isLogin ? 'Connexion' : "S'inscrire",
                                          style: const TextStyle(fontSize: 16),
                                        ),
                                ),
                              ),
                              const SizedBox(height: 12),
                              TextButton(
                                onPressed: _isLoading ? null : _switchMode,
                                child: Text(
                                  _isLogin
                                      ? "Pas de compte ? S'inscrire"
                                      : 'Déjà un compte ? Se connecter',
                                  style: const TextStyle(color: AppTheme.rose),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}