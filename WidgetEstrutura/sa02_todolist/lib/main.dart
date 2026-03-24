// Função Principal (faz o aplicativo rodar)
import 'package:flutter/material.dart';

void main(List<String> args) {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: ToDoList(),
  ));
}

// st --> snipets (atalhos para código)
//  Janela do aplicativo
// 1ª Classe, identifica a mudança de estado --> Chama o build
class ToDoList extends StatefulWidget {
  const ToDoList({super.key});

  @override
  State<ToDoList> createState() => _ToDoListState();
}

// 2ª Classe --> Lógica da construção da janela
class _ToDoListState extends State<ToDoList> {

  // Atributos
  // Final --> Permite a mudança de valor uma única vez (escopo da variável)
  // O uso do underline (_), transforma a varável em private
  final TextEditingController _tarefaController = TextEditingController();
  final List<Map<String,dynamic>> _tarefas = []; // Uma coleção de Chave - Valor

  // Métodos
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Lista de Tarefas"), centerTitle: true,),
      body: Padding(
        // Espaçamento geral 8px
        padding: EdgeInsets.all(8),
        child: Column(
          children: [
            // Input para adicionar novas tarefas
            TextField(
              controller: _tarefaController, // Passa o valor do texto para o controller
              decoration: InputDecoration(
                labelText: "Digite uma Tarefa"
              ),
            ),
            
            SizedBox(height: 10,), // Espaçameno de altura
            ElevatedButton( // Botão para aicionar tarefa
              onPressed: _adicionarTarefa, 
              child: Text("Adicionar Tarefa")),
            // Campo para listar as tarefas
            Expanded(
              // Listar tarefas da coleção
              child: ListView.builder( // Conta o número de itens na lista
                itemCount: _tarefas.length,
                itemBuilder: (context,index)=>
                  // Exibe o elemento da lista
                  ListTile(
                    title: Text(_tarefas[index]["titulo"], style: TextStyle(
                      // Operador Ternário (if, else) --> Se a tarefa for concluída, coloca um risco no texto
                      decoration: _tarefas[index]["concluída"] ? TextDecoration.lineThrough : null
                    ),),
                    leading: Checkbox( // Permite mudar o valor da tarefa para concluída ou o contrário
                      value: _tarefas[index]["concluída"], 
                      onChanged: (bool? valor)=> setState(() {
                        _tarefas[index]["concluídas"] = valor!;
                      })),
                  )
              ),
            ),
          ],
        ),),
    );
  }
  // Método par adicionar tarefa na lista
  void _adicionarTarefa() {
    if(_tarefaController.text.trim().isNotEmpty){
      setState(() {
        // Adiciona a tarefa na lista
        _tarefas.add({"titulo":_tarefaController.text,"concluida":false});
        // Limpa o campo do input
        _tarefaController.clear();
      });
    }
  }
}