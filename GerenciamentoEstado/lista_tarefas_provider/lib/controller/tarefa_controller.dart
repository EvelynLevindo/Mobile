import 'package:flutter/material.dart';
import 'package:lista_tarefas_provider/model/tarefa.dart';

class TarefaController extends ChangeNotifier{
  // ChangeNotifier --> É uma classe do Provider
  // A tarefa conroller está herdando elementos do ChangeNotifier
  // Herda o método notifierListenner()

  // Atributos
  // Lista para armazenar as atrefas criadas
  List<Tarefa> _tarefas = []; // Atributo privado

  // Getter --> Listar as tarefas
  List<Tarefa> get tarefas => _tarefas;
  // Método get para acessar os dados proivados

  // Métodos CRUD
  // Adicionar tarefa (CREATE)
  void criarTarefa(String titulo) {
    // Verifica se o texto não é vazio
    if(titulo.trim().isEmpty) return; // Interrompe o métodod
    
    _tarefas.add(Tarefa(titulo: titulo.trim()));

    // Avisa os listeners
    // Atualiza os widgets que usar esse dado
    notifyListeners();
  }

  // Alterar a tarefa (UPDATE)
  void alterarTarefa(int index) {
    // Inverter o valor da booleana "!"
    _tarefas[index].concluida = !_tarefas[index].concluida;
  notifyListeners();
  }
  
  void removerTarefa(int index){
  // Void --> Função que não tem return
  // Busca a tarefa e remove da lista
  _tarefas.removeAt(index);
  notifyListeners();
  }

  // Criar métricas para usar no DashboardPage
  // Calcular o total de tarefas
  // Calcula quantas tarefas tem no vetor
  int get totalTarefas => _tarefas.length; // Método Simplificado

  // Método Completo
  // int totalTarefas(){
  //  return _tarefas.length;
  // }

  // Total de tarefas concluídas
  int get totalTarefasConcluidas => _tarefas.where((tarefa)=>tarefa.concluida).length;

  // Total de tarefas pendentes
  int get totalTarefasPendentes => _tarefas.where((tarefa)=>!tarefa.concluida).length;

  // Porcentagem de tarefas concluídas
  double get porcentagmTarefasConcluidas {
    if(_tarefas.isEmpty) return 0;
    return (totalTarefasConcluidas/totalTarefas)*100;
  }
} 