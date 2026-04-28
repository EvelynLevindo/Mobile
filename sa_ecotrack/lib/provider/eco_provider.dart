import 'package:flutter/material.dart';
import '../model/habito_model.dart';

class EcoProvider extends ChangeNotifier {
  final List<Habito> _habitos = [];
  int _telaSelecionada = 0;
  bool _isDarkMode = false;

  // Getters
  List<Habito> get habitosPendentes => _habitos.where((h) => !h.isConcluido).toList();
  List<Habito> get habitosConcluidos => _habitos.where((h) => h.isConcluido).toList();
  int get telaSelecionada => _telaSelecionada;
  bool get isDarkMode => _isDarkMode;

  // Métodos  CRUD
  void adicionarHabito(String titulo, String descricao) {
  final novoHabito = Habito( // Usando o tempo para que não tenha dois hábitos com o mesmo ID
    id: DateTime.now().millisecondsSinceEpoch.toString(), 
    titulo: titulo,
    descricao: descricao,
  );
  _habitos.add(novoHabito);
  notifyListeners();
}

  // Update (CRUD)
  void editarHabito(String id, String novoTitulo, String novaDescricao) {
    final index = _habitos.indexWhere((h) => h.id == id);
    if (index != -1) {
      _habitos[index].titulo = novoTitulo;
      _habitos[index].descricao = novaDescricao;
      notifyListeners();
    }
  }

  // Delete (CRUD)
  void excluirHabito(String id) {
    _habitos.removeWhere((h) => h.id == id);
    notifyListeners();
  }

  // Modificação de status (concluído ou pendente)
  void alternarStatusHabito(String id) {
    final index = _habitos.indexWhere((h) => h.id == id);
    if (index != -1) {
      _habitos[index].isConcluido = !_habitos[index].isConcluido;
      notifyListeners();
    }
  }

  // Navegação de tela
  void alterarTela(int index) {
    _telaSelecionada = index;
    notifyListeners();
  }

  // Modo escuro
  void toggleTema() {
    _isDarkMode = !_isDarkMode;
    notifyListeners();
  }
}