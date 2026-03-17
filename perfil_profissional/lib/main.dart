import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: const Color(0xFFF8F9FA),
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF1A365D),
          primary: const Color(0xFF1A365D),
        ),
      ),
      home: const ProfilePage(),
    );
  }
}

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  static const Color azulPrimario = Color(0xFF1A365D); 
  static const Color azulDestaque = Color(0xFF3182CE);
  static const Color azulFundoCard = Color(0xFFEDF2F7);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const Icon(Icons.arrow_back, color: azulPrimario),
        actions: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.share, color: azulPrimario)),
        ],
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Column(
        children: [
          // Seção do Perfil
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              children: [
                const CircleAvatar(
                  radius: 50,
                  backgroundColor: azulDestaque,
                  child: Icon(Icons.person, size: 55, color: Colors.white),
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Evelyn Levindo",
                        style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: azulPrimario),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _buildBadge("Postagens"),
                          _buildBadge("Seguidores"),
                          _buildBadge("Seguindo"),
                        ],
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),

          const SizedBox(height: 30),

          _buildInfoBox("Objetivos"),
          _buildInfoBox("Habilidades"),
          _buildInfoBox("Experiências"),

          const Spacer(),

          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildContactIcon(Icons.email_outlined, "Email"),
              const SizedBox(width: 40),
              _buildContactIcon(Icons.phone_outlined, "Telefone"),
            ],
          ),
          const SizedBox(height: 25),
        ],
      ),
      
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.white,
        selectedItemColor: azulDestaque,
        unselectedItemColor: azulPrimario.withOpacity(0.5),
        showSelectedLabels: false,
        showUnselectedLabels: false,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.menu), label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.mail_outline), label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.star_border), label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.account_circle_outlined), label: ''),
        ],
      ),
    );
  }

  // Widget das caixas de texto com Título e Corpo
  Widget _buildInfoBox(String titulo) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      padding: const EdgeInsets.all(18),
      width: double.infinity,
      decoration: BoxDecoration(
        color: azulFundoCard,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            titulo,
            style: const TextStyle(
              color: azulPrimario,
              fontWeight: FontWeight.bold,
              fontSize: 15,
            ),
          ),
          const SizedBox(height: 6),
          const Text(
            "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s.",
            style: TextStyle(color: azulPrimario, fontSize: 13, height: 1.4),
          ),
        ],
      ),
    );
  }

  // MODIFICADO: Agora aceita título e alinha no topo/centro
  Widget _buildBadge(String titulo) {
    return Container(
      width: 70, // Aumentei um pouco a largura para caber os textos
      height: 50,
      padding: const EdgeInsets.only(top: 4), // Espaçamento para não colar na borda
      decoration: BoxDecoration(
        color: azulPrimario,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start, // Alinha no alto
        children: [
          Text(
            titulo, 
            textAlign: TextAlign.center, // Centraliza o texto
            style: const TextStyle(
              fontSize: 9, 
              color: Colors.white, 
              fontWeight: FontWeight.bold
            )
          ),
          const Spacer(), // Empurra o conteúdo de baixo (se houvesse) para a base
        ],
      ),
    );
  }

  Widget _buildContactIcon(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 22, color: azulDestaque),
        const SizedBox(width: 8),
        Text(text, style: const TextStyle(fontWeight: FontWeight.bold, color: azulPrimario)),
      ],
    );
  }
}