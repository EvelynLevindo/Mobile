import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../provider/eco_provider.dart';
import 'habito_view.dart';
import 'dashboard_view.dart';

class MainLayoutView extends StatelessWidget {
  const MainLayoutView({super.key});

  @override
  // Ordenação dos elementos principais que moldam as tela
  Widget build(BuildContext context) {
    final provider = Provider.of<EcoProvider>(context);
    final List<Widget> telas = [const HabitsView(), const DashboardView()];
    return Scaffold( // Menu
      appBar: AppBar(title: const Text("EcoTrack")),
      drawer: Drawer(
        child: Column(
          children: [
            const DrawerHeader(child: Center(child: Text("ECOTRACK", style: TextStyle(fontSize: 24)))),
            SwitchListTile(
              title: const Text("Modo Escuro"),
              value: provider.isDarkMode,
              onChanged: (v) => provider.toggleTema(),
            ),
          ],
        ),
      ),
      // Selecão/navegação de telas
      body: telas[provider.telaSelecionada],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: provider.telaSelecionada,
        onTap: (i) => provider.alterarTela(i),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.list), label: "Hábitos"),
          BottomNavigationBarItem(icon: Icon(Icons.analytics), label: "Dashboard"),
        ],
      ),
    );
  }
}