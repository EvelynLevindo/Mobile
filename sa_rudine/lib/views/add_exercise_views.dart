import 'package:flutter/material.dart';
import '../controllers/workout_controller.dart';
import '../models/exercise.dart';

class AddExerciseScreen extends StatefulWidget {
  final int routineId;
  final WorkoutController controller;

  const AddExerciseScreen({Key? key, required this.routineId, required this.controller}) : super(key: key);

  @override
  _AddExerciseScreenState createState() => _AddExerciseScreenState();
}

class _AddExerciseScreenState extends State<AddExerciseScreen> {
  final _formKey = GlobalKey<FormState>();
  
  final _nameController = TextEditingController();
  final _setsController = TextEditingController();
  final _repsController = TextEditingController();
  final _weightController = TextEditingController();
  final _typeController = TextEditingController();

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
    return Scaffold(
      appBar: AppBar(title: const Text('Novo Exercício')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Nome do Exercício (ex: Supino Reto)'),
                validator: (value) => value == null || value.isEmpty ? 'Campo obrigatório' : null,
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
                        if (value == null || value.isEmpty) return 'Obrigatório';
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
                        if (value == null || value.isEmpty) return 'Obrigatório';
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
                        if (value == null || value.isEmpty) return 'Obrigatório';
                        // Troca vírgula por ponto para evitar erros de parse
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
                      validator: (value) => value == null || value.isEmpty ? 'Obrigatório' : null,
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
                        routineId: widget.routineId,
                        name: _nameController.text,
                        sets: int.parse(_setsController.text),
                        reps: int.parse(_repsController.text),
                        weight: double.parse(_weightController.text.replaceAll(',', '.')),
                        type: _typeController.text,
                      );
                      
                      await widget.controller.addExercise(exercise);
                      
                      if (mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Exercício salvo com sucesso!'), backgroundColor: Colors.green),
                        );
                        Navigator.pop(context); // Retorna para a tela de detalhes
                      }
                    } catch (e) {
                      if (mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Erro ao salvar o exercício.'), backgroundColor: Colors.red),
                        );
                      }
                    }
                  }
                },
                child: const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Text('Salvar Exercício', style: TextStyle(fontSize: 16)),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}