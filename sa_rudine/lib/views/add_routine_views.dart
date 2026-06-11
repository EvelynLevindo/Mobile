import 'package:flutter/material.dart';
import '../controllers/workout_controller.dart';
import '../models/routine.dart';

class AddRoutineScreen extends StatefulWidget {
  final WorkoutController controller;
  const AddRoutineScreen({Key? key, required this.controller}) : super(key: key);

  @override
  _AddRoutineScreenState createState() => _AddRoutineScreenState();
}

class _AddRoutineScreenState extends State<AddRoutineScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _goalController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Nova Rotina')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Nome da Rotina (ex: Treino A)'),
                validator: (value) => value == null || value.isEmpty ? 'Campo obrigatório' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _goalController,
                decoration: const InputDecoration(labelText: 'Objetivo (ex: Hipertrofia)'),
                validator: (value) => value == null || value.isEmpty ? 'Campo obrigatório' : null,
              ),
              const Spacer(),
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    try {
                      final routine = Routine(name: _nameController.text, goal: _goalController.text);
                      await widget.controller.addRoutine(routine);
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Rotina salva!')));
                      Navigator.pop(context);
                    } catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Erro ao salvar.')));
                    }
                  }
                },
                child: const Text('Salvar Rotina'),
              )
            ],
          ),
        ),
      ),
    );
  }
}