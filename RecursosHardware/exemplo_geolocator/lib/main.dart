import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

void main(List<String> args) {
  runApp(MaterialApp(
    home: MyApp(),
  ));
}


class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String mensagem = "Localização não Obtida";

  void getLocation() async{
    // Solicitar geolocalização ao apertar o botão
    bool enable;
    LocationPermission permission;

    enable = await Geolocator. isLocationServiceEnabled();
    // Se a permissão não estiver habilitada
    if(!enable){
      mensagem = "Serviço de Loclaização desabilitado";
    }

    permission = await Geolocator.checkPermission();
    if(permission == LocationPermission.denied){
      permission = await Geolocator.requestPermission(); // Vou solicitar a permissão
      if(permission == LocationPermission.denied){
        mensagem = "Acesso a Localização não Permitido pelo Usuário";
      }
    // Permissão liberada=
    }    
    // Pegando a posição atual
    Position position = await Geolocator.getCurrentPosition();
    mensagem = "Latitude ${position.latitude}, Longitude: ${position.longitude}";
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Utilizar a geolocalização para mostrar a localização do dispositivo
      appBar: AppBar(title: Text("GPS - Localização"),),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(mensagem),
            ElevatedButton(
              onPressed: () async{
                setState(() {
                  getLocation();
                });
              }, 
              child: Text("Obter Localização"))
          ],
        ),
      ),
    );
  }
}
