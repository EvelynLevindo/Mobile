//Arquivo principal da aplicação 
//Sempre começa com um void main

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

void main(){
  runApp(MaterialApp(
    home: // Estrutura máxima de janela
      Scaffold(
        appBar: AppBar(title: Text("Meu Primeiro App"),),
        body: Center(
          child: ElevatedButton(
            onPressed: (){
              Fluttertoast.showToast(
                msg: "Olá, Mundo!",
                toastLength: Toast.LENGTH_LONG,
                gravity: ToastGravity.CENTER);
            }, 
            child: Text("Não entre em pânico!")),
        ),
      ),
  ));
}