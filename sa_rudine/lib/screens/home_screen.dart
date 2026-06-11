import 'package:flutter/material.dart';
import '../controllers/workout_controller.dart';
import '../models/routine.dart';
import 'add_routine_screen.dart';
import 'routine_detail_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final WorkoutController _controller = WorkoutController();

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    await _controller.loadRoutines();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Minhas Rotinas')),
      body: _controller.routines.isEmpty
          ? const Center(child: Text('Nenhuma rotina cadastrada.'))
          : ListView.builder(
              itemCount: _controller.routines.length,
              itemBuilder: (context, index) {
                final routine = _controller.routines[index];
                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: ListTile(
                    title: Text(routine.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Text('Objetivo: ${routine.goal}'),
                    trailing: const Icon(Icons.arrow_forward_ios),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => RoutineDetailScreen(routine: routine, controller: _controller),
                        ),
                      ).then((_) => _loadData());
                    },
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => AddRoutineScreen(controller: _controller)),
          );
          _loadData();
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}