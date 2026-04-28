import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../provider/eco_provider.dart';

class DashboardView extends StatelessWidget {
  const DashboardView({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<EcoProvider>(context);

    return GridView.count( // cONTAGEM DO DASHBOARD
      crossAxisCount: 2,
      padding: const EdgeInsets.all(20),
      children: [
        _infoCard("Hábitos Concluídos", provider.habitosConcluidos.length.toString(), context),
        _infoCard("Hábitos Pendentes", provider.habitosPendentes.length.toString(), context),
        _infoCard("Pontuação Verde", (provider.habitosConcluidos.length * 10).toString(), context),
        _infoCard("Meta Semanal", "${provider.habitosConcluidos.length}/7", context),
      ],
    );
  }

  Widget _infoCard(String label, String valor, BuildContext context) { // Ajustes/organização dos elementos de pontuação
    return Card(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(label, textAlign: TextAlign.center),
          const SizedBox(height: 10),
          Text(valor, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}