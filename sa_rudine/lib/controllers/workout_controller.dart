import 'package:flutter/material.dart';
import '../database/database_helper.dart';
import '../models/exercise.dart';
import '../models/routine.dart';

class WorkoutController extends ChangeNotifier {
  List<Routine> routines = [];
  List<Exercise> currentExercises = [];
  bool isLoading = false;

  void _setLoading(bool value) {
    isLoading = value;
    notifyListeners();
  }

  // --- Operações de Rotina ---
  Future<void> loadRoutines() async {
    _setLoading(true);
    try {
      routines = await DatabaseHelper.instance.fetchRoutines();
    } catch (e) {
      debugPrint("Erro ao carregar rotinas: $e");
    } finally {
      _setLoading(false);
    }
  }

  Future<void> addRoutine(Routine routine) async {
    try {
      await DatabaseHelper.instance.insertRoutine(routine);
      await loadRoutines();
    } catch (e) {
      debugPrint("Erro ao adicionar rotina: $e");
      rethrow;
    }
  }

  Future<void> updateRoutine(Routine routine) async {
    try {
      await DatabaseHelper.instance.updateRoutine(routine);
      await loadRoutines();
    } catch (e) {
      debugPrint("Erro ao atualizar rotina: $e");
      rethrow;
    }
  }

  Future<void> deleteRoutine(int id) async {
    try {
      await DatabaseHelper.instance.deleteRoutine(id);
      await loadRoutines();
    } catch (e) {
      debugPrint("Erro ao deletar rotina: $e");
      rethrow;
    }
  }

  // --- Operações de Exercício ---
  Future<void> loadExercises(int routineId) async {
    try {
      currentExercises = await DatabaseHelper.instance.fetchExercises(routineId);
      notifyListeners();
    } catch (e) {
      debugPrint("Erro ao carregar exercícios: $e");
    }
  }

  Future<void> addExercise(Exercise exercise) async {
    try {
      await DatabaseHelper.instance.insertExercise(exercise);
      await loadExercises(exercise.routineId);
    } catch (e) {
      debugPrint("Erro ao adicionar exercício: $e");
      rethrow;
    }
  }

  Future<void> updateExercise(Exercise exercise) async {
    try {
      await DatabaseHelper.instance.updateExercise(exercise);
      await loadExercises(exercise.
