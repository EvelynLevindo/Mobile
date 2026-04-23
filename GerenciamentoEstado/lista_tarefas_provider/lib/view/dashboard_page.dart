import 'package:flutter/material.dart';
import 'package:lista_tarefas_provider/controller/tarefa_controller.dart';
import 'package:provider/provider.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Dash de Tarefas"),centerTitle: true,),
      // Costrução dos dash
      // Escuta as mudanças de estado do controller
      body: Consumer<TarefaController>(
        builder: (context, controller, child) {
          return Padding(padding: EdgeInsets.all(8),
          child: Column(
            children: [
              // Lista de cards (informações do controller)
              _construtorCard(
                titulo: "Total de Tarefas", 
                value: controller.totalTarefas.toString(), 
                icon: Icons.list_alt, 
                color: Colors.blue),
              _construtorCard(
                titulo: "Tarefas Concluídas", 
                value: controller.totalTarefasConcluidas.toString(), 
                icon: Icons.check_circle, 
                color: Colors.green),
              _construtorCard(
                titulo: "Tarefas Pendentes", 
                value: controller.totalTarefasPendente.toString(), 
                icon: Icons.pending_actions, 
                color: Colors.orange),
              _construtorCard(
                titulo: "Porcentagem de Tarefas Concluídas", 
                value: controller.porcentagemTarefasConcluidas.toString(), 
                icon: Icons.percent, 
                color: Colors.yellow)
            ],
          ),
          );
        },
      ),
    );
  }
}

// Criar um widgets para acilitar a criação do CRUD

Widget _construtorCard({
  required String titulo,
  required String value,
  required IconData icon,
  required Color color
}) {
  return Card(
    elevation: 4,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadiusGeometry.circular(12)
    ),
    child: ListTile(
      leading: CircleAvatar(
        backgroundColor: color.withOpacity(0.15),
        child: Icon(icon, color: color),
      ),
    title: Text(titulo,style: TextStyle(fontWeight: FontWeight.bold)),
    trailing: Text(value,style: TextStyle(
      fontSize: 24,
      fontWeight: FontWeight.bold,
      color: color
    ),),
    ),
  );
}
