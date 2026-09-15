import 'dart:io';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../models/registro.dart';

class DetalhesScreen extends StatelessWidget {
  final Registro registro;

  const DetalhesScreen({super.key, required this.registro});

  Future<void> _openMap(BuildContext context) async {
    final Uri url = Uri.parse(
      'https://www.google.com/maps/search/?api=1&query=${registro.latitude},${registro.longitude}',
    );
    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    } else {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Não foi possível abrir o aplicativo de mapa.')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final File? photoFile = registro.caminhoFoto != null ? File(registro.caminhoFoto!) : null;

    return Scaffold(
      appBar: AppBar(title: const Text('Detalhes do Registro')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (photoFile != null && photoFile.existsSync())
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.file(
                  photoFile,
                  height: 250,
                  fit: BoxFit.cover,
                ),
              )
            else
              Container(
                height: 200,
                color: Colors.grey[300],
                child: const Icon(Icons.image_not_supported, size: 60),
              ),
            const SizedBox(height: 16),
            ListTile(
              leading: const Icon(Icons.access_time),
              title: const Text('Data / Hora'),
              subtitle: Text(registro.dataHora),
            ),
            ListTile(
              leading: const Icon(Icons.location_on),
              title: const Text('Coordenadas'),
              subtitle: Text('Lat: ${registro.latitude}\nLng: ${registro.longitude}'),
            ),
            ListTile(
              leading: const Icon(Icons.notes),
              title: const Text('Observação'),
              subtitle: Text(
                (registro.observacao == null || registro.observacao!.isEmpty)
                    ? 'Sem observações'
                    : registro.observacao!,
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: () => _openMap(context),
              icon: const Icon(Icons.map),
              label: const Text('Abrir no Mapa'),
            ),
          ],
        ),
      ),
    );
  }
}