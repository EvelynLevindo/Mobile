import 'package:flutter/material.dart';
import '../controllers/workout_controller.dart';
import '../models/routine.dart';
import 'add_exercise_screen.dart';

class RoutineDetailScreen extends StatefulWidget {
  final Routine routine;
  final WorkoutController controller;

  const RoutineDetailScreen({super.key, required this.routine, required this.controller});

  @override
  State<RoutineDetailScreen> createState() => _RoutineDetailScreenState();
}

class _RoutineDetailScreenState extends State<RoutineDetailScreen> {
  @override
  void initState() {
    super.initState();
    widget.controller.loadExercises(widget.routine.id!);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.routine.name)),
      body: ListenableBuilder(
        listenable: widget.controller,
        builder: (context, _) {
          if (widget.controller.currentExercises.isEmpty) {
            return const Center(child: Text('Nenhum exercício nesta rotina.'));
          }
          return ListView.builder(
            itemCount: widget.controller.currentExercises.length,
            itemBuilder: (context, index) {
              final exercise = widget.controller.currentExercises[index];
              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: ListTile(
                  title: Text(exercise.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Text('${exercise.sets} séries x ${exercise.reps} reps | ${exercise.weight}kg\nTipo: ${exercise.type}'),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit, color: Colors.blue),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => AddExerciseScreen(routineId: widget.routine.id!, controller: widget.controller, exercise: exercise)),
                          );
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () => widget.controller.deleteExercise(exercise.id!, widget.routine.id!),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => AddExerciseScreen(routineId: widget.routine.id!, controller: widget.controller)),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}