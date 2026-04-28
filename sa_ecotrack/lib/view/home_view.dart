import 'package:flutter/material.dart';
import 'main_layout_view.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  // Organização dos elementos de vizualização
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(30.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [ // ajustes de elementos da tela
            const CircleAvatar(radius: 60, child: Icon(Icons.eco, size: 60)),
            const SizedBox(height: 30),
            const Text("EcoTrack", style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold)),
            const SizedBox(height: 20),
            const Text( // Texto da tela inicial
              "Cada pequena ação conta. O ser humano tem o poder de ajudar a natureza através de escolhas conscientes. Ao adotar hábitos sustentáveis, você não apenas protege o meio ambiente hoje, mas garante o futuro das próximas gerações. Vamos começar?",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 40),
            ElevatedButton( // Botão para iniciar o aplicativo
              onPressed: () => Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const MainLayoutView())),
              child: const Text("Começar!"),
            )
          ],
        ),
      ),
    );
  }
}