import 'package:flutter/material.dart';
import '../controllers/auth_controller.dart';
import 'home_page.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _usernameController = TextEditingController();
  final AuthController _authController = AuthController();

  void _doLogin() async {
    final success = await _authController.login(_usernameController.text);
    if (success && mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => HomePage(user: _authController.currentUser!),
        ),
      );
    } else if (_authController.errorMessage != null && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(_authController.errorMessage!)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('CineFavorite - Entrar')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.movie, size: 80, color: Colors.blue),
            const SizedBox(height: 20),
            TextField(
              controller: _usernameController,
              decoration: const InputDecoration(
                labelText: 'Username',
                border: OutlineInputBorder(),
                hintText: 'Digite seu nome de usuário',
              ),
            ),
            const SizedBox(height: 20),
            AnimatedBuilder(
              animation: _authController,
              builder: (context, child) {
                if (_authController.isLoading) {
                  return const CircularProgressIndicator();
                }
                return ElevatedButton(
                  onPressed: _doLogin,
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size.fromHeight(50),
                  ),
                  child: const Text('Entrar / Cadastrar'),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}