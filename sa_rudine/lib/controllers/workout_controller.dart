import 'package:flutter/material.dart';
import '../database/database_helper.dart';
import '../models/routine.dart';
import '../models/exercise.dart';

class WorkoutController extends ChangeNotifier {
  List<Routine> routines = [];
  List<Exercise> currentExercises = [];

  // --- ROTINAS ---
  Future<void> loadRoutines() async {
    try {
      routines = await DatabaseHelper.instance.fetchRoutines();
      notifyListeners();
    } catch (e) {
      debugPrint("Erro ao carregar rotinas: $e");
    }
  }

  Future<void> addRoutine(Routine routine) async {
    await DatabaseHelper.instance.insertRoutine(routine);
    await loadRoutines();
  }

  Future<void> updateRoutine(Routine routine) async {
    await DatabaseHelper.instance.updateRoutine(routine);
    await loadRoutines();
  }

  Future<void> deleteRoutine(int id) async {
    await DatabaseHelper.instance.deleteRoutine(id);
    await loadRoutines();
  }

  // --- EXERCÍCIOS ---
  Future<void> loadExercises(int routineId) async {
    try {
      currentExercises = await DatabaseHelper.instance.fetchExercises(routineId);
      notifyListeners();
    } catch (e) {
      debugPrint("Erro ao carregar exercícios: $e");
    }
  }

  Future<void> addExercise(Exercise exercise) async {
    await DatabaseHelper.instance.insertExercise(exercise);
    await loadExercises(exercise.routineId);
  }

  Future<void> updateExercise(Exercise exercise) async {
    await DatabaseHelper.instance.updateExercise(exercise);
    await loadExercises(exercise.routineId);
  }

  Future<void> deleteExercise(int exerciseId, int routineId) async {
    await DatabaseHelper.instance.deleteExercise(exerciseId);
    await loadExercises(routineId);
  }
}