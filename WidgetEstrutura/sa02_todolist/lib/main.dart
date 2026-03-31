// Função Principal (faz o aplicativo rodar)
import 'package:flutter/material.dart';

void main(List<String> args) {
  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false, // Remove a flag do debug
      home: ToDoList(),
    ),
  );
}

// st --> snipets (atalhos para código)
// Janela do aplicativvo
// 1º classe identifica a mudança de estado => chama o build
class ToDoList extends StatefulWidget {
  const ToDoList({super.key});

  @override // Chama o rebuild da tela
  State<ToDoList> createState() => _ToDoListState();
}

//2º class --> Lógica da construção da janela
class _ToDoListState extends State<ToDoList> {
  // Atributos
  // Final --> Permite a mudança de valor uma única vez (escopo da variável)
  // O uso do underLine (_), transforma a variável em private
  final TextEditingController _tarefaController =
      TextEditingController(); // Pega o valor do input
  final List<Map<String, dynamic>> _tarefas =
      []; // Lista do tipo coleção (Chave, Valor)

  // Métodos
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Lista de Tarefas"),
        centerTitle: true,
      ), // Centraliza o texto no meio da Appbar
      body: Padding(
        // Espaçamento geral de 8px
        padding: EdgeInsets.all(8),
        child: Column(
          children: [
            // Input para adicionar novas tarefas
            TextField(
              controller:
                  _tarefaController, // Passa o valor do texto para o controller
              decoration: InputDecoration(labelText: "Digite uma Tarefa"),
            ),
            SizedBox(height: 10), // Espaçamento de altura
            ElevatedButton(
              // Botão para adicioanr tarefa
              onPressed: _adicionarTarefa,
              child: Text("Adicioanr Tarefa"),
            ),
            // Campo para listar as tarefas
            Expanded(
              //Listar as Tarefas da Coleção
              child: ListView.builder(
                itemCount: _tarefas.length, // Conta o número de item na lista
                itemBuilder: (context, index) =>
                    // Exibe o elemento da lista
                    ListTile(
                      title: Text(
                        _tarefas[index]["titulo"],
                        style: TextStyle(
                          // Operador Ternário (if,else) --> se tarefa concluida, coloca um risco no texto
                          decoration: _tarefas[index]["concluida"]
                              ? TextDecoration.lineThrough
                              : null,
                        ),
                      ),
                      leading: Checkbox(
                        // Permite mudar o valor da tarefa para concluida ou o contrário
                        value: _tarefas[index]["concluida"],
                        onChanged: (bool? valor) => setState(() {
                          // Chamando a mudança de estado
                          _tarefas[index]["concluida"] = valor!;
                        }),
                      ),
                      // Coloquem um icone( de lixeira), ao ser clicado vai deletar a tarefa
                      // Usar o trailing para colocar o icone da lixeira
                      trailing: ElevatedButton(
                        onPressed: () => _deletarTarefa,
                        child: Icon(Icons.delete),
                      ),
                    ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Método para adicionar tarefa na lista
  void _adicionarTarefa() {
    if (_tarefaController.text.trim().isNotEmpty) {
      setState(() {
        // Chama a mudança de estado da janela
        // Adiciona a tarefa na lista
        _tarefas.add({"titulo": _tarefaController.text, "concluida": false});
        // Limpa o campo do input
        _tarefaController.clear();
      });
    }
  }

  void _deletarTarefa(int index) {
    if(_tarefas[index]["concluida"]){
      setState(() {
        _tarefas.removeAt(index);
      });
    }
  }
}
