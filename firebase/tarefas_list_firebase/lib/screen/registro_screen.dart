import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class RegistroScreen extends StatefulWidget {
  const RegistroScreen({super.key});

  @override
  State<RegistroScreen> createState() => _RegistroScreenState();
}

class _RegistroScreenState extends State<RegistroScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance; //classe do firebase => autenticação
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  // Método para registrar usuário
  Future<void> _registro() async{
    try {
      await _auth.createUserWithEmailAndPassword(
        email: _emailController.text, 
        password: _passwordController.text);
      // Após o registro do usuário, fechamos a tela de login e automaticamente o usuário é direcionado para a tela de tarefas
      Navigator.pop(context); // Volta para a tela de AthScreen --> Redirecionamento
    } on FirebaseAuthException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Falha ao Registrar: ${e.message}")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Registro')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _emailController,
              decoration: InputDecoration(labelText: 'Email'),
              keyboardType: TextInputType.emailAddress,
            ),
            TextField(
              controller: _passwordController,
              decoration: InputDecoration(labelText: 'Senha'),
              obscureText: true,
            ),
            SizedBox(height: 20),
            ElevatedButton(onPressed: _registro, child: Text('Registrar')),
          ],
        ),
      ),
    );
  }
}