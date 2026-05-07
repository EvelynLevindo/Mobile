// Uso do Shared Preferences para armazenar o nome do usuário

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Exemplo1Page extends StatefulWidget {
  const Exemplo1Page({super.key});

  @override
  State<Exemplo1Page> createState() => _Exemplo1PageState();
}

class _Exemplo1PageState extends State<Exemplo1Page> {
  TextEditingController _nomeInput = TextEditingController();
  String _nomeSalvo = "";

  // Uso do Shared Preferences para buscar o nome no inicio do aplicativo
  // Salvar no nome nas preferências
  _salvarNomeShared() async { // Conexão async --> Permite continuar rodando o código enquanto é feito a conexão com a base de dados
  // Conectar com  o Shared Preferences
  SharedPreferences prefs = await SharedPreferences.getInstance(); // Busca as informações no Shared Preferences
  await prefs.setString("nome", _nomeInput.text.trim()); // Salvou na chave "nome", o valor colocado no input
  _nomeInput.clear(); // Limpa o input
  _carregarNomeShared(); // Atualiza o nome para a tela
  }

  // Buscar nome nas preferências
  _carregarNomeShared() async { // Função assincrona --> o progrma continua rodando sem a necessidade de parar, evitando erros
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      // Atribuindo a variável o valor relacionado a chave buscada no shared
      _nomeSalvo = prefs.getString("nome") ?? ""; // Operador de nulidade
    });
  }

  // Início da página
  @override
  void initState() { // Carrega informações do Shared Preferences antes de construir a tela pela primeira vez
    // TODO: implement initState
    super.initState();
    _carregarNomeShared();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Bem Vindo $_nomeSalvo"), centerTitle: true,),
      body: Padding(
        padding: EdgeInsets.all(8),
        child: Column(
          children: [
            TextField(
              controller: _nomeInput,
              decoration: InputDecoration(labelText: "Digite seu nome..."),
            ),
            SizedBox(height: 10,),
            ElevatedButton(
              onPressed: _salvarNomeShared, 
              child: Text("Salvar")),
              SizedBox(),
              Text("O nome atual do usuário é $_nomeSalvo", style: TextStyle(fontSize: 20)),
              SizedBox(height: 20,),
              TextButton(
                onPressed: () => Navigator.pop(context), 
                child: Text("Voltar"))
          ],
        ),),
    );
  }
}