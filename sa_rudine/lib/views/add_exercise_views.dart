import 'package:flutter/material.dart';
import '../controllers/workout_controller.dart';
import '../models/exercise.dart';

class AddExerciseScreen extends StatefulWidget {
  final int routineId;
  final WorkoutController controller;
  final Exercise? exercise; // Se for nulo, é cadastro. Se não, é edição.

  const AddExerciseScreen({super.key, required this.routineId, required this.controller, this.exercise});

  @override
  State<AddExerciseScreen> createState() => _AddExerciseScreenState();
}

class _AddExerciseScreenState extends State<AddExerciseScreen> {
  final _formKey = GlobalKey<FormState>();
  
  late final TextEditingController _nameController;
  late final TextEditingController _setsController;
  late final TextEditingController _repsController;
  late final TextEditingController _weightController;
  late final TextEditingController _typeController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.exercise?.name ?? '');
    _setsController = TextEditingController(text: widget.exercise?.sets.toString() ?? '');
    _repsController = TextEditingController(text: widget.exercise?.reps.toString() ?? '');
    _weightController = TextEditingController(text: widget.exercise?.weight.toString() ?? '');
    _typeController = TextEditingController(text: widget.exercise?.type ?? '');
  }

  @override
  void dispose() {
    _nameController.dispose();
    _setsController.dispose();
    _repsController.dispose();
    _weightController.dispose();
    _typeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.exercise != null;

    return Scaffold(
      appBar: AppBar(title: Text(isEditing ? 'Editar Exercício' : 'Novo Exercício')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Nome do Exercício (ex: Supino Reto)'),
                validator: (value) => value == null || value.trim().isEmpty ? 'Campo obrigatório' : null,
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _setsController,
                      decoration: const InputDecoration(labelText: 'Séries (ex: 3)'),
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) return 'Obrigatório';
                        if (int.tryParse(value) == null) return 'Apenas inteiros';
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: TextFormField(
                      controller: _repsController,
                      decoration: const InputDecoration(labelText: 'Repetições (ex: 12)'),
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) return 'Obrigatório';
                        if (int.tryParse(value) == null) return 'Apenas inteiros';
                        return null;
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _weightController,
                      decoration: const InputDecoration(labelText: 'Carga em kg (ex: 20.5)'),
                      keyboardType: const TextInputType.numberWithOptions(decimal: true),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) return 'Obrigatório';
                        final normalizedValue = value.replaceAll(',', '.');
                        if (double.tryParse(normalizedValue) == null) return 'Apenas números';
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: TextFormField(
                      controller: _typeController,
                      decoration: const InputDecoration(labelText: 'Tipo (ex: Força, Cardio)'),
                      validator: (value) => value == null || value.trim().isEmpty ? 'Obrigatório' : null,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    try {
                      final exercise = Exercise(
                        id: widget.exercise?.id,
                        routineId: widget.routineId,
                        name: _nameController.text.trim(),
                        sets: int.parse(_setsController.text.trim()),
                        reps: int.parse(_repsController.text.trim()),
                        weight: double.parse(_weightController.text.replaceAll(',', '.').trim()),
                        type: _typeController.text.trim(),
                      );
                      
                      if (isEditing) {
                        await widget.controller.updateExercise(exercise);
                      } else {
                        await widget.controller.addExercise(exercise);
                      }
                      
                      if (!mounted) return;
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Exercício salvo com sucesso!'), backgroundColor: Colors.green),
                      );
                      Navigator.pop(context);
                    } catch (e) {
                      if (!mounted) return;
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Erro ao salvar o exercício.'), backgroundColor: Colors.red),
                      );
                    }
                  }
                },
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(isEditing ? 'Atualizar Exercício' : 'Salvar Exercício', style: const TextStyle(fontSize: 16)),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}