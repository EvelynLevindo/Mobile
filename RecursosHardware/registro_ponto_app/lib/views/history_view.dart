import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/punch_model.dart';
import '../services/auth_service.dart';
import '../services/database_service.dart';

class HistoryView extends StatelessWidget {
  const HistoryView({super.key});

  @override
  Widget build(BuildContext context) {
    final DatabaseService databaseService = DatabaseService();
    final String? userId = AuthService().currentUser;
    final DateFormat formatter = DateFormat('dd/MM/yyyy HH:mm:ss');

    return Scaffold(
      appBar: AppBar(title: const Text('Histórico de Pontos')),
      body: userId == null
          ? const Center(child: Text('Erro: Usuário não identificado.'))
          : FutureBuilder<List<PunchModel>>(
              future: databaseService.getUserPunches(userId),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                
                final punches = snapshot.data ?? [];
                if (punches.isEmpty) {
                  return const Center(child: Text('Nenhum ponto registrado no aparelho.'));
                }

                return ListView.separated(
                  padding: const EdgeInsets.all(16.0),
                  itemCount: punches.length,
                  separatorBuilder: (_, __) => const Divider(),
                  itemBuilder: (context, index) {
                    final punch = punches[index];
                    return ListTile(
                      leading: const CircleAvatar(child: Icon(Icons.access_time)),
                      title: Text(formatter.format(punch.timestamp), style: const TextStyle(fontWeight: FontWeight.bold)),
                      subtitle: Text('Lat: ${punch.latitude.toStringAsFixed(4)}, Lng: ${punch.longitude.toStringAsFixed(4)}'),
                    );
                  },
                );
              },
            ),
    );
  }
}