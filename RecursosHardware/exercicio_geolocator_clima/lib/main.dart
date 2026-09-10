import 'package:flutter/material.dart';
import 'api_service.dart';

void main() {
  runApp(const MaterialApp(
    home: MyApp(),
    debugShowCheckedModeBanner: false,
  ));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String clima = "Aguardando localização...";
  
  // Controlador para o campo de texto
  final TextEditingController _cidadeController = TextEditingController();
  final ApiService apiService = ApiService();

  void getClima() async {
    // Verifica se o usuário digitou algo
    if (_cidadeController.text.trim().isEmpty) {
      setState(() {
        clima = "Por favor, digite o nome de uma cidade.";
      });
      return;
    }

    setState(() {
      clima = "Buscando clima...";
    });

    try {
      // Chama a nova função passando o texto digitado
      final climaAtual = await apiService.getClimaCidade(_cidadeController.text.trim());
      
      if (climaAtual != null) {
        setState(() {
          final temp = climaAtual["main"]["temp"].toStringAsFixed(1);
          final cidade = climaAtual["name"];
          final descricao = climaAtual["weather"][0]["description"]; // Pega a descrição (ex: céu limpo)
          
          clima = "$cidade -- $temp°C\n$descricao";
        });
      }
    } catch (e) {
      setState(() {
        clima = "Erro ao buscar clima. Verifique o nome da cidade.";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Consulta de Clima")),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Campo de texto para digitar a localização
              TextField(
                controller: _cidadeController,
                decoration: const InputDecoration(
                  labelText: "Digite o nome da cidade",
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.location_city),
                ),
                onSubmitted: (_) => getClima(), // Permite buscar ao apertar Enter
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: getClima,
                child: const Text("Buscar Clima"),
              ),
              const SizedBox(height: 32),
              Text(
                clima, 
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
      ),
    );
  }
}