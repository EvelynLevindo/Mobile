import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../provider/eco_provider.dart';
import '../model/habito_model.dart';

class HabitsView extends StatelessWidget {
  const HabitsView({super.key});

  void _abrirFormulario(BuildContext context, {Habito? habito}) { // Formulário sobre os hábitos
    final tituloController = TextEditingController(text: habito?.titulo);
    final descController = TextEditingController(text: habito?.descricao);

    showModalBottomSheet( // Disposição das informações dos hábitos
      context: context,
      isScrollControlled: true,
      builder: (_) => Padding(
        padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom, left: 20, right: 20, top: 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(controller: tituloController, decoration: const InputDecoration(labelText: "Hábito")),
            TextField(controller: descController, decoration: const InputDecoration(labelText: "Descrição")),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                if (habito == null) { // VErificação das informações
                  context.read<EcoProvider>().adicionarHabito(tituloController.text, descController.text);
                } else {
                  context.read<EcoProvider>().editarHabito(habito.id, tituloController.text, descController.text);
                }
                Navigator.pop(context);
              },
              child: Text(habito == null ? "Adicionar" : "Salvar"),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<EcoProvider>(context);

    return DefaultTabController( // Organização dos elementos de adição de hábitos
      length: 2,
      child: Column(
        children: [
          const TabBar(tabs: [Tab(text: "Pendentes"), Tab(text: "Concluídos")]),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton.icon(
              onPressed: () => _abrirFormulario(context),
              icon: const Icon(Icons.add),
              label: const Text("Novo Hábito Sustentável"),
            ),
          ),
          Expanded( // Separação do que é pendente ou concluído
            child: TabBarView(
              children: [
                _buildLista(context, provider.habitosPendentes, false),
                _buildLista(context, provider.habitosConcluidos, true),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLista(BuildContext context, List<Habito> lista, bool concluido) { // Organização dos elementos
    return ListView.builder(
      itemCount: lista.length,
      itemBuilder: (context, index) {
        final h = lista[index];
        return Card(
          margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
          child: ListTile(
            leading: IconButton(
              icon: Icon(concluido ? Icons.undo : Icons.check_circle_outline, color: concluido ? Colors.orange : Colors.green),
              onPressed: () => context.read<EcoProvider>().alternarStatusHabito(h.id),
            ),
            title: Text(h.titulo, style: TextStyle(decoration: concluido ? TextDecoration.lineThrough : null)),
            subtitle: Text(h.descricao),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(icon: const Icon(Icons.edit, size: 20), onPressed: () => _abrirFormulario(context, habito: h)),
                IconButton(icon: const Icon(Icons.delete, color: Colors.red, size: 20), onPressed: () => context.read<EcoProvider>().excluirHabito(h.id)),
              ],
            ),
          ),
        );
      },
    );
  }
}