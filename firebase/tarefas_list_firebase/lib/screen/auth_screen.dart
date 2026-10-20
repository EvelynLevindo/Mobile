import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/widgets.dart';

class AuthScreen extends StatelessWidget {
  const AuthScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      //vai verificar o estado da autenticação e redirecionar 
      //para tarefas se ja estiver logado ou login se não estiver logado
      stream: FirebaseAuth.instance.authStateChanges(), 
      builder: (context, snapshot){
        if (snapshot.hasData){
          return TarefaScreen();
        }
        return LoginScreen();
      });
  }
}