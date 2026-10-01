import 'package:flutter/material.dart';
import '../config/app_config.dart';
import '../services/auth_service.dart';
import 'login_view.dart';

class ProfileView extends StatelessWidget {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    final String? userId = AuthService().currentUser;

    return Scaffold(
      appBar: AppBar(title: const Text('Perfil / Configurações')),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Center(child: CircleAvatar(radius: 40, child: Icon(Icons.person, size: 40))),
            const SizedBox(height: 20),
            Text('Identificação: ${userId ?? "N/A"}', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const Divider(height: 40),
            const Text('Configurações da Empresa', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: const Icon(Icons.location_on),
              title: const Text('Local de Trabalho Central'),
              subtitle: Text('Lat: ${AppConfig.workplaceLatitude}\nLng: ${AppConfig.workplaceLongitude}'),
            ),
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: const Icon(Icons.radar),
              title: const Text('Raio de Tolerância'),
              subtitle: Text('${AppConfig.maxDistanceMeters.toInt()} metros'),
            ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () async {
                  await AuthService().signOut();
                  if (context.mounted) {
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (_) => const LoginView()),
                      (route) => false,
                    );
                  }
                },
                style: ElevatedButton.styleFrom(backgroundColor: Colors.red, foregroundColor: Colors.white),
                icon: const Icon(Icons.logout),
                label: const Text('SAIR DA CONTA'),
              ),
            )
          ],
        ),
      ),
    );
  }
}