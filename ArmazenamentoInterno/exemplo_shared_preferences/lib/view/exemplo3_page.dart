import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Exemplo3Page extends StatefulWidget {
  const Exemplo3Page({super.key});

  @override
  State<Exemplo3Page> createState() => _Exemplo3PageState();
}

class _Exemplo3PageState extends State<Exemplo3Page> {
  List<String> _tarefas = []; // Armazena as tarefas
  final TextEditingController _inputTarefa = TextEditingController(); // Controla o input de tarefas
  late SharedPreferences _prefs;
  String nome = "";

  // Métodos
  @override
  void initState() {
    super.initState();
    _loadTarefas();
  }

  // Carregar os dados do Shared Preferences
  Future<void> _loadTarefas() async {
    // Conectar o App ao Shared Preferences
    _prefs = await SharedPreferences.getInstance();
    nome = _prefs.getString("nome") ?? ""; // Verificação de nulidade
    setState(() {
      _tarefas = _prefs.getStringList("tarefas+$nome") ?? [];
    });
  }

  // Salvar dados no Shared Preferences
  void _savePreferences() async {
    _prefs = await SharedPreferences.getInstance();
    nome = _prefs.getString("nome") ?? "";
    // Salvar as preferências
    await _prefs.setStringList("tarefas+$nome", _tarefas);
    setState(() {
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Lista de Tarefas do $nome"),),
      body: Padding(
        padding: EdgeInsets.all(8),
        child: Column(
          children: [
            TextField(
              controller: _inputTarefa,
              decoration: InputDecoration(labelText: "Digite a Tarefa..."),
            ),
            ElevatedButton(
              onPressed: (){
                setState(() {
                  _tarefas.add(_inputTarefa.text.trim()); // Adiciona a tarefa no vetor
                  _savePreferences(); // Salva no Shared
                });
              }, 
              child: Text("Adicionar")),
              SizedBox(height: 20,),
              // Lista as tarefas
              Expanded(
                child: ListView.builder(
                  itemCount: _tarefas.length, // tamanho do vetor de tarefas
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text(_tarefas[index]),
                      onLongPress: () {
                        setState(() {
                          _tarefas.removeAt(index); // Remove a tarefa
                          _savePreferences(); // Salva no Shared Preferences
                        });
                      },
                    );
                  }))
          ],
        ),
        ),
    );
  }
}