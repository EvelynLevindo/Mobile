import 'dart:io';
import 'package:flutter/material.dart';
import '../models/registro.dart';

class RegistroCard extends StatelessWidget {
  final Registro registro;
  final VoidCallback onTap;

  const RegistroCard({
    super.key,
    required this.registro,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final File? imageFile = registro.caminhoFoto != null ? File(registro.caminhoFoto!) : null;

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: ListTile(
        onTap: onTap,
        leading: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: imageFile != null && imageFile.existsSync()
              ? Image.file(
                  imageFile,
                  width: 50,
                  height: 50,
                  fit: BoxFit.cover,
                )
              : Container(
                  width: 50,
                  height: 50,
                  color: Colors.grey[300],
                  child: const Icon(Icons.image_not_supported),
                ),
        ),
        title: Text(
          registro.dataHora,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(
          'Lat: ${registro.latitude.toStringAsFixed(4)}, Lng: ${registro.longitude.toStringAsFixed(4)}',
        ),
        trailing: const Icon(Icons.chevron_right),
      ),
    );
  }
}