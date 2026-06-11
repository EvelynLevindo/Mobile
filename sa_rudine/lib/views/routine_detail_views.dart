import 'package:flutter/material.dart';
import '../controllers/workout_controller.dart';
import '../models/routine.dart';
import 'add_exercise_views.dart';

class RoutineDetailScreen extends StatefulWidget {
  final Routine routine;
  final WorkoutController controller;

  const RoutineDetailScreen({Key? key, required this.routine, required this.controller}) : super(key: key);

  @override
  _RoutineDetailScreenState createState() => _RoutineDetailScreenState();
}

class _RoutineDetailScreenState extends State<RoutineDetailScreen> {
  @override
  void initState() {
    super.initState();
    _loadExercises();
  }

  Future<void> _loadExercises() async {
    if (widget.routine.id != null) {
      await widget.controller.loadExercises(widget.routine.id!);
      // Atualiza a interface após os exercícios serem carregados do banco de dados
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.routine.name)),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'Objetivo: ${widget.routine.goal}',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          const Divider(),
          Expanded(
            child: widget.controller.currentExercises.isEmpty
                ? const Center(child: Text('Nenhum exercício cadastrado nesta rotina.'))
                : ListView.builder(
                    itemCount: widget.controller.currentExercises.length,
                    itemBuilder: (context, index) {
                      final exercise = widget.controller.currentExercises[index];
                      return Card(
                        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                        child: ListTile(
                          leading: const Icon(Icons.fitness_center, color: Colors.blue),
                          title: Text(exercise.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                          subtitle: Text(
                            '${exercise.sets} séries x ${exercise.reps} reps | ${exercise.weight}kg\nTipo: ${exercise.type}',
                          ),
                          isThreeLine: true,
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          // Navega para a tela de adicionar exercício e aguarda o retorno
          await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => AddExerciseScreen(
                routineId: widget.routine.id!,
                controller: widget.controller,
              ),
            ),
          );
          // Recarrega a lista de exercícios quando o usuário voltar
          _loadExercises();
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}