//página de contato
//campo para nome, email, telefone e mensagem
//botão para enviar

import 'package:flutter/material.dart';

class ContatoPage extends StatefulWidget {
  const ContatoPage({super.key});

  @override
  State<ContatoPage> createState() => _ContatoPageState();
}

class _ContatoPageState extends State<ContatoPage> {
  //atributos
  final TextEditingController _nomeController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _telefoneController = TextEditingController();
  final TextEditingController _mensagemController = TextEditingController();

  //métodos
  //build da tela
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Contato"), centerTitle: true),
      body: Padding(
        padding: EdgeInsets.all(8),
        child: Column(
          children: [
            //não será usado o form
            TextField(
              controller: _nomeController,
              decoration: InputDecoration(labelText: "Nome"),
            ),
            SizedBox(height: 20),
            TextField(
              controller: _emailController,
              decoration: InputDecoration(labelText: "Email"),
            ),
            SizedBox(height: 20),
            TextField(
              controller: _telefoneController,
              decoration: InputDecoration(
                labelText: "Telefone",
                hintText: "(XX) XXXXX-XXXX",
              ),
            ),
            SizedBox(height: 20),
            //campo para mensagem com multiplas linhas
            TextField(
              controller: _mensagemController,
              decoration: InputDecoration(labelText: "Mensagem"),
              maxLines: 5, //limita o campo a 5 linhas
            ),
            SizedBox(height: 20),
            //botão para enviar mensagem
            ElevatedButton(
              onPressed: () => _enviarMensagem(),
              child: Text("Enviar Mensagem"),
            ),
          ],
        ),
      ),
    );
  }

  void _enviarMensagem() {
    //exibir um dialogo de confirmação
    showDialog(context: context, builder: (context) => AlertDialog(
      title: Text("Confirmação de Envio"),
      content: ListBody(children: [
        Text("Deseja Enviar a seguinte Mensagem ?"),
        SizedBox(height: 20,),
        Text("Nome: ${_nomeController.text}"),
        Text("Nome: ${_emailController.text}"),
        Text("Nome: ${_telefoneController.text}"),
        Text("Nome: ${_mensagemController.text}"),
      ],),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context), child: Text("Cancelar")),
        ElevatedButton(onPressed: () {
          //enviar a mensagem
          //limpar os campos
          _nomeController.clear();
          _emailController.clear();
          _telefoneController.clear();
          _mensagemController.clear();
          //fecha o dialogo
          Navigator.pop(context);
        }, child: Text("Enviar"))
      ],
    ));
  }
}