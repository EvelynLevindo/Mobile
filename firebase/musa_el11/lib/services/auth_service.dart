import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Stream<User?> get userStream => _auth.authStateChanges();
  User? get currentUser => _auth.currentUser;

  String get currentUserName {
    final user = _auth.currentUser;
    if (user == null) return 'Musa';
    if (user.displayName != null && user.displayName!.trim().isNotEmpty) {
      return user.displayName!.trim();
    }
    if (user.email != null && user.email!.contains('@')) {
      return user.email!.split('@').first;
    }
    return 'Musa';
  }

  Future<void> login(String email, String password) async {
    try {
      await _auth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password.trim(),
      );
    } on FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    }
  }

  Future<void> register(String name, String email, String password) async {
    try {
      final cred = await _auth.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password.trim(),
      );
      final user = cred.user!;
      final uid = user.uid;
      final cleanName = name.trim().isEmpty ? 'Musa' : name.trim();
      final cleanEmail = email.trim().toLowerCase();

      // Update auth profile
      await user.updateDisplayName(cleanName);

      // Persist to Firestore users collection
      await _db.collection('users').doc(uid).set({
        'uid': uid,
        'displayName': cleanName,
        'name': cleanName,
        'email': cleanEmail,
        'createdAt': FieldValue.serverTimestamp(),
      });

      // Persist to user_emails index for collaborator lookups
      await _db.collection('user_emails').doc(cleanEmail).set({
        'uid': uid,
        'displayName': cleanName,
        'email': cleanEmail,
      });
    } on FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    }
  }

  Future<void> logout() async {
    await _auth.signOut();
  }

  String _handleAuthException(FirebaseAuthException e) {
    switch (e.code) {
      case 'user-not-found':
      case 'wrong-password':
      case 'invalid-credential':
        return 'E-mail ou senha incorretos.';
      case 'email-already-in-use':
        return 'Este e-mail já está cadastrado em outra conta.';
      case 'invalid-email':
        return 'Por favor, insira um e-mail válido.';
      case 'weak-password':
        return 'A senha é muito fraca. Digite pelo menos 6 caracteres.';
      case 'too-many-requests':
        return 'Muitas tentativas sem sucesso. Aguarde um instante e tente novamente.';
      case 'user-disabled':
        return 'Esta conta foi desativada.';
      case 'network-request-failed':
        return 'Falha de conexão. Verifique sua internet.';
      default:
        return e.message ?? 'Ocorreu um erro na autenticação.';
    }
  }
}