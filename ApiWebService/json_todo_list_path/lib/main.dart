import 'dart:convert'; // Para converter Map/List em JSON
import 'dart:io'; // Para manipular arquivos no dispositivo
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart'; // Para acessar diretórios do sistema

void main() {
  runApp(const MeuApp());
}

class MeuApp extends StatelessWidget {
  const MeuApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Gerenciador de Tarefas JSON',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const ListaTarefasPage(),
    );
  }
}

class ListaTarefasPage extends StatefulWidget {
  const ListaTarefasPage({super.key});

  @override
  State<ListaTarefasPage> createState() => _ListaTarefasPageState();
}

class _ListaTarefasPageState extends State<ListaTarefasPage> {
  // Lista em memória que armazena os dados das tarefas
  List<Map<String, dynamic>> tarefas = [];

  // Controlador do campo de texto para capturar o input do usuário
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    _lerTarefas(); // Carrega o JSON assim que a tela é iniciada
  }

  // Tem o caminho do arquivo .json dentro do diretório privado do app
  Future<File> _getArquivo() async {
    final diretorio = await getApplicationDocumentsDirectory();
    return File('${diretorio.path}/tarefas.json');
  }

  // Converte a lista Dart para String JSON e salva no dispositivo
  Future<void> _salvarTarefas() async {
    final arquivo = await _getArquivo();
    String jsonTarefas = json.encode(tarefas); // List/Map --> String JSON
    await arquivo.writeAsString(jsonTarefas); // Grava no disco
  }

  // Lê o arquivo JSON do dispositivo e converte de volta para lista Dart
  Future<void> _lerTarefas() async {
    try {
      final arquivo = await _getArquivo();
      if (await arquivo.exists()) {
        String conteudo = await arquivo.readAsString(); // Lê o texto puro
        List<dynamic> dados = json.decode(conteudo); // String JSON --> List
        setState(() {
          tarefas = dados.cast<Map<String, dynamic>>(); // Atualiza a tela
        });
      }
    } catch (e) {
      debugPrint("Erro ao ler arquivo local: $e");
    }
  }

  // Adiciona nova tarefa na lista e executa a gravação
  void _adicionarTarefa(String titulo) {
    if (titulo.trim().isEmpty) return;

    setState(() {
      tarefas.add({"titulo": titulo, "concluida": false});
    });
    _salvarTarefas(); // Salva as alterações no arquivo .json
    _controller.clear();
  }

  // Altera o status da tarefa e executa a gravação
  void _toggleConcluida(int index, bool? valor) {
    setState(() {
      tarefas[index]["concluida"] = valor ?? false;
    });
    _salvarTarefas(); // Salva as alterações no arquivo .json
  }

  // Remove a tarefa pelo índice e executa a gravação
  void _removerTarefa(int index) {
    setState(() {
      tarefas.removeAt(index);
    });
    _salvarTarefas(); // Salva as alterações no arquivo .json
  }

  // Exibe o diálogo com campo de texto para criar nova tarefa
  void _exibirDialogoAdicionar() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Nova Tarefa"),
          content: TextField(
            controller: _controller,
            autofocus: true,
            decoration: const InputDecoration(
              hintText: "Ex: Comprar leite",
              border: OutlineInputBorder(),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancelar"),
            ),
            ElevatedButton(
              onPressed: () {
                _adicionarTarefa(_controller.text);
                Navigator.pop(context);
              },
              child: const Text("Salvar"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Minhas Tarefas (.json)"),
        centerTitle: true,
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      // Carrega uma mensagem de lista vazia ou a lista de tarefas
      body: tarefas.isEmpty
          ? const Center(
              child: Text(
                "Nenhuma tarefa cadastrada ainda.",
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
            )
          : ListView.builder(
              itemCount: tarefas.length,
              itemBuilder: (context, index) {
                final item = tarefas[index];
                final isConcluida = item["concluida"] ?? false;

                return ListTile(
                  // Checkbox de status
                  leading: Checkbox(
                    value: isConcluida,
                    onChanged: (val) => _toggleConcluida(index, val),
                  ),
                  // Título da tarefa
                  title: Text(
                    item["titulo"] ?? "",
                    style: TextStyle(
                      decoration: isConcluida
                          ? TextDecoration.lineThrough
                          : TextDecoration.none,
                      color: isConcluida ? Colors.grey : Colors.black,
                    ),
                  ),
                  // Botão para remover tarefa
                  trailing: IconButton(
                    icon: const Icon(Icons.delete, color: Colors.redAccent),
                    onPressed: () => _removerTarefa(index),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: _exibirDialogoAdicionar,
        child: const Icon(Icons.add),
      ),
    );
  }
}