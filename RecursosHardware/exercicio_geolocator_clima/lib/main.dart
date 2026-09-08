import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'api_service.dart';

void main() {
  runApp(const MaterialApp(
    home: MyApp(),
  ));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String mensagem = "Aguardando localização...";
  String clima = "";
  Position? position;

  final ApiService apiService = ApiService();

  // Função assíncrona que retorna true se a posição for obtida com sucesso
  Future<bool> getLocation() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      setState(() {
        mensagem = "Serviço de Localização desabilitado";
      });
      return false;
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        setState(() {
          mensagem = "Acesso à Localização negado pelo usuário";
        });
        return false;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      setState(() {
        mensagem = "Permissão negada permanentemente. Altere nas configurações.";
      });
      return false;
    }

    Position pos = await Geolocator.getCurrentPosition();
    setState(() {
      position = pos;
      mensagem = "Lat: ${pos.latitude.toStringAsFixed(4)}, Lon: ${pos.longitude.toStringAsFixed(4)}";
    });
    return true;
  }

  void getClima() async {
    // Aguarda a verificação e obtenção da localização antes de chamar a API
    bool locationOk = await getLocation();

    if (!locationOk || position == null) return;

    try {
      final climaAtual = await apiService.getClimaLocation(position!);
      if (climaAtual != null) {
        setState(() {
          final temp = climaAtual["main"]["temp"].toStringAsFixed(1);
          final cidade = climaAtual["name"];
          clima = "$cidade -- $temp°C";
        });
      }
    } catch (e) {
      setState(() {
        clima = "Erro ao buscar clima";
      });
    }
  }

  @override
  void initState() {
    super.initState();
    getLocation();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Clima e GPS")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(mensagem, textAlign: TextAlign.center),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: getClima,
              child: const Text("Buscar Clima"),
            ),
            const SizedBox(height: 16),
            Text(
              clima, 
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}