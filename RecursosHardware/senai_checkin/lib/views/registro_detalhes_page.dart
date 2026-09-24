import 'dart:io';
import 'package:flutter/material.dart';
import '../models/registro_ponto.dart';

class RegistroDetalhesPage extends StatelessWidget {
  final RegistroPonto registro;

  const RegistroDetalhesPage({super.key, required this.registro});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detalhes do registro'),
        backgroundColor: const Color(0xFF0B6E4F),
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Image.file(
                File(registro.fotoPath),
                fit: BoxFit.cover,
                width: double.infinity,
                height: 260,
                errorBuilder: (_, __, ___) => Container(
                  height: 260,
                  color: Colors.grey.shade300,
                  child: const Center(child: Icon(Icons.broken_image, size: 48)),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              DateTime.parse(registro.dataHora).toLocal().toString(),
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            _InfoItem(label: 'Latitude', value: registro.latitude.toStringAsFixed(6)),
            _InfoItem(label: 'Longitude', value: registro.longitude.toStringAsFixed(6)),
            _InfoItem(label: 'Observação', value: registro.observacao),
          ],
        ),
      ),
    );
  }
}

class _InfoItem extends StatelessWidget {
  final String label;
  final String value;

  const _InfoItem({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(fontWeight: FontWeight.w700)),
          const SizedBox(height: 4),
          Text(value),
        ],
      ),
    );
  }
}