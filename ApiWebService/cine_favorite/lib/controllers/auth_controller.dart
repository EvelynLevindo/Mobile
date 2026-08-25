import 'package:flutter/foundation.dart';
import '../models/user.dart';
import '../services/database_service.dart';

class AuthController extends ChangeNotifier {
  final DatabaseService _dbService = DatabaseService();
  
  User? currentUser;
  bool isLoading = false;
  String? errorMessage;

  Future<bool> login(String username) async {
    if (username.trim().isEmpty) {
      errorMessage = 'O nome de usuário não pode estar vazio.';
      notifyListeners();
      return false;
    }

    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      currentUser = await _dbService.loginOrCreateUser(username.trim());
      isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      isLoading = false;
      errorMessage = 'Erro ao realizar login: $e';
      notifyListeners();
      return false;
    }
  }
}