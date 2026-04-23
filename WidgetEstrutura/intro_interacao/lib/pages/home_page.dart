// tela inicial 
// vai ter botões de navegação para outras telas

import 'package:flutter/material.dart';

//Tela inicial -> logo do Aplicativo e Botões de Navegação 
//logo com SplashScreen -> Tela de Carregamnto
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Meu Aplicativo Interativo"),),
      body: Padding(
        padding: EdgeInsets.all(8),
        child: Center(
          child: Column(
            //alinhamento do eixo principal(vertical)
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              //logo do aplicativo com atraso de carregamento de 2 segundos
              Image.network("https://upload.wikimedia.org/wikipedia/en/9/96/SatoruGojomanga.png",
              width: 150,
              height: 150,),
              //bloco de espaçamento entre objetos
              SizedBox(height: 20,),
              //botões de navegação
              ElevatedButton(
                //método de navegação para a tela de formualário
                onPressed: ()=> Navigator.pushNamed(context, "/form"),
                //texto do botão
                child: Text("Formulário")),
              SizedBox(height: 10,),
              ElevatedButton(
                //método de navegação para a tela de formualário
                onPressed: ()=> Navigator.pushNamed(context, "/contato"),
                //texto do botão
                child: Text("Contato")),
            ],
          ),
        ),),
    );
  }
}