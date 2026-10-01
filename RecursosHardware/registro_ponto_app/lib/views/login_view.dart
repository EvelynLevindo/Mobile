import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import '../services/biometric_service.dart';
import 'home_view.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final _formKey = GlobalKey<FormState>();
  final _userInputController = TextEditingController();
  final _passwordController = TextEditingController();
  
  final AuthService _authService = AuthService();
  final BiometricService _biometricService = BiometricService();

  bool _isLoading = false;
  bool _canUseBiometrics = false;

  @override
  void initState() {
    super.initState();
    _checkBiometricsAvailability();
  }

  Future<void> _checkBiometricsAvailability() async {
    bool canCheck = await _biometricService.canCheckBiometrics();
    setState(() => _canUseBiometrics = canCheck);
  }

  void _navigateToHome() {
    Navigator.pushReplacement(
      context, MaterialPageRoute(builder: (_) => const HomeView()),
    );
  }

  Future<void> _loginWithCredentials() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isLoading = true);
    
    await _authService.signInWithEmailOrNif(
      _userInputController.text,
      _passwordController.text,
    );
    
    if (mounted) _navigateToHome();
  }

  Future<void> _loginWithBiometrics() async {
    bool authenticated = await _biometricService.authenticate();
    if (authenticated) {
      if (_authService.currentUser != null) {
        _navigateToHome();
      } else {
        _showError('Faça o primeiro login com senha para vincular sua biometria.');
      }
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.red),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Icon(Icons.access_time_filled, size: 80, color: Colors.blue),
                const SizedBox(height: 16),
                const Text(
                  'Registro de Ponto (Local)',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 32),
                TextFormField(
                  controller: _userInputController,
                  decoration: const InputDecoration(labelText: 'NIF ou E-mail', border: OutlineInputBorder()),
                  validator: (value) => value == null || value.isEmpty ? 'Informe o NIF/E-mail' : null,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _passwordController,
                  obscureText: true,
                  decoration: const InputDecoration(labelText: 'Senha', border: OutlineInputBorder()),
                  validator: (value) => value == null || value.isEmpty ? 'Informe a senha' : null,
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: _isLoading ? null : _loginWithCredentials,
                  style: ElevatedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 16)),
                  child: _isLoading
                      ? const CircularProgressIndicator()
                      : const Text('ENTRAR'),
                ),
                if (_canUseBiometrics) ...[
                  const SizedBox(height: 16),
                  OutlinedButton.icon(
                    onPressed: _loginWithBiometrics,
                    icon: const Icon(Icons.fingerprint),
                    label: const Text('Entrar com Biometria'),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}