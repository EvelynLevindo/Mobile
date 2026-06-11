import 'package:flutter/material.dart';
import '../database/database_helper.dart';
import '../models/routine.dart';
import '../models/exercise.dart';

class WorkoutController extends ChangeNotifier {
  List<Routine> routines = [];
  List<Exercise> currentExercises = [];

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
}