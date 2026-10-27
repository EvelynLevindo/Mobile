import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import '../widgets/custom_widgets.dart';
import 'register_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
  bool _obscurePass = true;
  bool _isLoading = false;

  @override
  void dispose() {
    _emailCtrl.dispose();
    _passCtrl.dispose();
    super.dispose();
  }

  void _submit() async {
    final email = _emailCtrl.text.trim();
    final pass = _passCtrl.text.trim();

    if (email.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor, informe seu e-mail.')),
      );
      return;
    }

    if (pass.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor, digite sua senha.')),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      await AuthService().login(email, pass);
      // On success, AuthService.userStream will trigger in main.dart and navigate
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString())),
      );
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MusaColors.background,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Glowing Emblem / Logo
                Container(
                  width: 90,
                  height: 90,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: const LinearGradient(
                      colors: [MusaColors.primaryCyan, MusaColors.secondaryPink],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: MusaColors.primaryCyan.withValues(alpha: 0.45),
                        blurRadius: 28,
                        spreadRadius: 2,
                      ),
                      BoxShadow(
                        color: MusaColors.secondaryPink.withValues(alpha: 0.3),
                        blurRadius: 36,
                        spreadRadius: 4,
                      ),
                    ],
                  ),
                  child: const Center(
                    child: Icon(Icons.graphic_eq, color: MusaColors.background, size: 48),
                  ),
                ),
                const SizedBox(height: 24),

                // Brand Name
                const Text(
                  'MUSA',
                  style: TextStyle(
                    fontSize: 42,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 4,
                    color: MusaColors.primaryCyan,
                    shadows: [
                      Shadow(color: MusaColors.secondaryPink, blurRadius: 18),
                      Shadow(color: MusaColors.primaryCyan, blurRadius: 24),
                    ],
                  ),
                ),
                const SizedBox(height: 4),
                const Text(
                  'Harmonia Sonora & Playlists Mágicas',
                  style: TextStyle(
                    color: MusaColors.textMuted,
                    fontSize: 14,
                    letterSpacing: 0.5,
                  ),
                ),
                const SizedBox(height: 40),

                // Email Input
                Container(
                  decoration: BoxDecoration(
                    color: MusaColors.surfaceContainer,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: MusaColors.borderSubtle),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                  child: TextField(
                    controller: _emailCtrl,
                    keyboardType: TextInputType.emailAddress,
                    style: const TextStyle(color: MusaColors.textPrimary),
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      labelText: 'E-mail',
                      labelStyle: const TextStyle(color: MusaColors.textMuted, fontSize: 13),
                      hintText: 'seu.email@exemplo.com',
                      hintStyle: TextStyle(color: MusaColors.textMuted.withValues(alpha: 0.4), fontSize: 14),
                      prefixIcon: const Icon(Icons.email_outlined, color: MusaColors.primaryCyan, size: 22),
                      contentPadding: const EdgeInsets.symmetric(vertical: 8),
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Password Input
                Container(
                  decoration: BoxDecoration(
                    color: MusaColors.surfaceContainer,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: MusaColors.borderSubtle),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                  child: TextField(
                    controller: _passCtrl,
                    obscureText: _obscurePass,
                    style: const TextStyle(color: MusaColors.textPrimary),
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      labelText: 'Senha',
                      labelStyle: const TextStyle(color: MusaColors.textMuted, fontSize: 13),
                      hintText: 'Sua senha de acesso',
                      hintStyle: TextStyle(color: MusaColors.textMuted.withValues(alpha: 0.4), fontSize: 14),
                      prefixIcon: const Icon(Icons.lock_outline, color: MusaColors.primaryCyan, size: 22),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscurePass ? Icons.visibility_off : Icons.visibility,
                          color: MusaColors.textMuted,
                          size: 20,
                        ),
                        onPressed: () => setState(() => _obscurePass = !_obscurePass),
                      ),
                      contentPadding: const EdgeInsets.symmetric(vertical: 8),
                    ),
                  ),
                ),
                const SizedBox(height: 28),

                // Login Button
                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: MusaColors.primaryCyan,
                      foregroundColor: MusaColors.background,
                      elevation: 8,
                      shadowColor: MusaColors.primaryCyan.withValues(alpha: 0.6),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                    ),
                    onPressed: _isLoading ? null : _submit,
                    child: _isLoading
                        ? const SizedBox(
                            width: 24,
                            height: 24,
                            child: CircularProgressIndicator(color: MusaColors.background, strokeWidth: 2.5),
                          )
                        : const Text(
                            'Entrar',
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, letterSpacing: 0.5),
                          ),
                  ),
                ),
                const SizedBox(height: 24),

                // Link to Register Screen
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('Ainda não tem conta?', style: TextStyle(color: MusaColors.textMuted)),
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const RegisterScreen()),
                        );
                      },
                      child: const Text(
                        'Criar conta',
                        style: TextStyle(
                          color: MusaColors.secondaryPink,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}