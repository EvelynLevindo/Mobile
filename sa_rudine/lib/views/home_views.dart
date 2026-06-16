import 'package:flutter/material.dart';
import '../controllers/workout_controller.dart';
import 'add_routine_screen.dart';
import 'routine_detail_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final WorkoutController _controller = WorkoutController();

  @override
  void initState() {
    super.initState();
    _controller.loadRoutines();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Minhas Rotinas')),
      body: ListenableBuilder(
        listenable: _controller,
        builder: (context, _) {
          if (_controller.routines.isEmpty) {
            return const Center(child: Text('Nenhuma rotina cadastrada.'));
          }
          return ListView.builder(
            itemCount: _controller.routines.length,
            itemBuilder: (context, index) {
              final routine = _controller.routines[index];
              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: ListTile(
                  title: Text(routine.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Text('Objetivo: ${routine.goal}'),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit, color: Colors.blue),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => AddRoutineScreen(controller: _controller, routine: routine)),
                          );
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () => _controller.deleteRoutine(routine.id!),
                      ),
                    ],
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => RoutineDetailScreen(routine: routine, controller: _controller),
                      ),
                    );
                  },
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
            MaterialPageRoute(builder: (_) => AddRoutineScreen(controller: _controller)),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}