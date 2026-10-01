import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  static final AuthService _instance = AuthService._internal();
  factory AuthService() => _instance;
  AuthService._internal();

  static const String _userKey = 'logged_user';
  String? _currentUser;

  String? get currentUser => _currentUser;

  /// Inicializa o serviço verificando se há usuário salvo
  Future<void> init() async {
    final prefs = await SharedPreferences.getInstance();
    _currentUser = prefs.getString(_userKey);
  }

  /// Realiza login simulado (aceita qualquer credencial para fins de avaliação)
  Future<bool> signInWithEmailOrNif(String input, String password) async {
    await Future.delayed(const Duration(seconds: 1)); // Simula requisição
    final prefs = await SharedPreferences.getInstance();
    
    String userId = input.trim();
    if (!userId.contains('@')) {
      userId = '$userId@empresa.com';
    }

    _currentUser = userId;
    await prefs.setString(_userKey, userId);
    return true;
  }

  /// Faz o logout e limpa a sessão local
  Future<void> signOut() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_userKey);
    _currentUser = null;
  }
}