import 'package:flutter/material.dart';

void main() {
  runApp(const MaterialApp(
    // Configurações iniciais do app
    // Router --> Rotas de Navegação
    // Home --> Página Inicial

    home: MyApp(),
    // ThemeApp --> claro/escuro
  )); // Gosto de colocar o MaterialApp no void main
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // Estrutura da tela
  @override
  Widget build(BuildContext context) {
    return Scaffold( // Elemento principal da tela
    // appbar, drawer, bnBar, body, fabutton, snakebar
    appBar: AppBar(title: Text("Exemplos de Widgets de exibição"),),

    // Adicionar um elemento de scroll
    body: SingleChildScrollView( // Mais usado para scroll de página inteira
      child: Padding(
        padding: EdgeInsets.all(16),
        // Widget de Text
        // Adicionar um container
      
        child: Expanded( // Mais usado para scroll em partes especificas
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
                
            children: [
              Text("Explorando o Flutter", textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold
              ),
              ),
              // Ainda dentro da Column, posso adicionar uma imagem
              Image.network(
                // Link URL da imagem
                'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSziQPy45wlY5NQuOvNj-uWfM08uyFQlaLAYQ&s',
                height: 400,
                fit: BoxFit.contain,
              ),
              Image.asset("assets/img/BatGato.jpg",
              height: 400,
              fit: BoxFit.cover,
              ),
            ],
          ),
        ),
        ),
    ),
    );
  }
}