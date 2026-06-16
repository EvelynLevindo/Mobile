import 'package:flutter/material.dart';
import '../controllers/workout_controller.dart';
import '../models/routine.dart';

class AddRoutineScreen extends StatefulWidget {
  final WorkoutController controller;
  final Routine? routine; // Se for nulo, é cadastro. Se não, é edição.

  const AddRoutineScreen({super.key, required this.controller, this.routine});

  @override
  State<AddRoutineScreen> createState() => _AddRoutineScreenState();
}

class _AddRoutineScreenState extends State<AddRoutineScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late final TextEditingController _goalController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.routine?.name ?? '');
    _goalController = TextEditingController(text: widget.routine?.goal ?? '');
  }

  @override
  void dispose() {
    _nameController.dispose();
    _goalController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.routine != null;

    return Scaffold(
      appBar: AppBar(title: Text(isEditing ? 'Editar Rotina' : 'Nova Rotina')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Nome da Rotina (ex: Treino A)'),
                validator: (value) => value == null || value.trim().isEmpty ? 'Campo obrigatório' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _goalController,
                decoration: const InputDecoration(labelText: 'Objetivo (ex: Hipertrofia)'),
                validator: (value) => value == null || value.trim().isEmpty ? 'Campo obrigatório' : null,
              ),
              const Spacer(),
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    try {
                      final routine = Routine(
                        id: widget.routine?.id,
                        name: _nameController.text.trim(),
                        goal: _goalController.text.trim(),
                      );
                      
                      if (isEditing) {
                        await widget.controller.updateRoutine(routine);
                      } else {
                        await widget.controller.addRoutine(routine);
                      }
                      
                      if (!mounted) return;
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Rotina salva com sucesso!'), backgroundColor: Colors.green),
                      );
                      Navigator.pop(context);
                    } catch (e) {
                      if (!mounted) return;
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Erro ao salvar rotina.'), backgroundColor: Colors.red),
                      );
                    }
                  }
                },
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(isEditing ? 'Atualizar Rotina' : 'Salvar Rotina', style: const TextStyle(fontSize: 16)),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}