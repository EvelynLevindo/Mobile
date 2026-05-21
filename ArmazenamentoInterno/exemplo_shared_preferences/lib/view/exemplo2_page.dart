import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Exemplo2Page extends StatefulWidget {
  const Exemplo2Page({super.key});

  @override
  State<Exemplo2Page> createState() => _Exemplo2PageState();
}

class _Exemplo2PageState extends State<Exemplo2Page> {
  late SharedPreferences _prefs; // Escopo Late --> Permite criar uma variável/objeto inicialmente nula e mudar o valor depois, pode ser mudada quantas vezes forem necessárrias
  // Late --> Começa em um valor que pode ser nula, mas DEPOIS pode ter quantas mudanças forem necessárrias

  bool _darkMode = false;

  // Método de conexão com o SharedPreferences
  @override
  void initState() {
    super.initState();
    _loadPreferences();
  }

  void _loadPreferences() async {
    _prefs = await SharedPreferences.getInstance(); // Pega as informações salvas no Shared Preferences
    setState(() {
      _darkMode = _prefs.getBool("darkMode") ?? false; // Verificação de uma nulidade obrigatória, ??  se caso a chave darkMode no Shared seja nula (não tenha valor atribuido ainda) a variável _darkMode será falsa
    });
  }

  // Método para salvar dados no Shared
  void savePreferences() async {
    setState(() {
      _darkMode = !_darkMode; // Inverte o valor da booleana
    });
    await _prefs.setBool("darkMode", _darkMode); // Atribuindo o valor da variável _darMode a chave darkMode do Shared Preferences
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Modo Escuro com Shared Preferences"),),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Tema Atual: ${_darkMode ? "Escuro" : "Claro"}"),
            Switch(
              value: _darkMode, 
              onChanged: (_) => savePreferences())
          ],
        ),
      ),
    );
  }
    
}
