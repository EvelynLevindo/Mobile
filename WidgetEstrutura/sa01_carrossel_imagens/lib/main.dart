
// Situação de Aprendizagem 01 - Carrossel de Imagens no Flutter (stateless) //
// Usar uma lista de imagens para montar um carrossel no Flutter
//(usar biblioteca do Flutter Pub Get: flutter pub add carousel_slider)

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

void main(List<String> args) {
  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false, // remove a flag do debug 
      home: MyApp(),
    )
  );
}

class MyApp extends StatelessWidget {
  MyApp({super.key}); // remover o "const" -> para usar a lista de imagens

  // Lista de imagens (Array)
  List<String> imagens = [
    "https://images.unsplash.com/photo-1506748686214-e9df14d4d9d0",
    "https://images.unsplash.com/photo-1612916628677-475f676a6adf",
    "https://images.unsplash.com/photo-1504384308090-c894fdcc538d",
    "https://images.unsplash.com/photo-1518837695005-2083093ee35b",
    "https://images.unsplash.com/photo-1501594907352-04cda38ebc29",
    "https://images.unsplash.com/photo-1519681393784-d120267933ba",
    "https://images.unsplash.com/photo-1531259683007-016a7b628fc3",
    "https://images.unsplash.com/photo-1506619216599-9d16d0903dfd",
    "https://images.unsplash.com/photo-1494172961521-33799ddd43a5",
    "https://images.unsplash.com/photo-1517245386807-bb43f82c33c4",
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: AppBar(
        title: Text(
          "Galeria de Imagens"
        ),
        centerTitle: true,
      ),

      body: Padding(
        padding: const EdgeInsets.all(8),

        child: Column(
          children: [
            // Carrossel de imagens da galeria
            CarouselSlider(
              options: CarouselOptions(
                height: 300,
                autoPlay: true // pré-definição de scroll do carrossel
              ),

              items: imagens.map( // percorre meu vetor
                ((url) => Container (
                  margin: EdgeInsets.all(8),

                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.network(url, fit: BoxFit.cover, width: 1000)
                  )
                ))
              ).toList()
            ),

            // Galeria de imagens
            Expanded(
              child: GridView.builder(
                // Como vou montar meu grid (Layout do Grid)...
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3, // número de colunas
                  crossAxisSpacing: 8, // espaçamento entre colunas
                  mainAxisSpacing: 8 // espaçamento entre linhas
                ),

                itemCount: imagens.length, // quantidade de elementos da lista é a quantidade de elementos do grid
                
                // Construtor do Grid (usando foreach):
                itemBuilder: (context, index) => //arrow function
                  GestureDetector(
                    onTap: () => _mostrarImagem(context, imagens[index]), // a imagem clicada passa seu index com o conteúdo

                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8), //arredodar os cantos da imagem
                    
                    child: Image.network(imagens[index], fit: BoxFit.cover,)
                    )
                  )
              )
            )
            
          ],
      
        ),

      ),

    );
  }
  
  void _mostrarImagem(BuildContext context, String imagen) { // imagen => endereço URL da imagem clicada
    // Mostrar imagens com mais detalhe ao ser clicada
    // (precisa do index da imagem para buscar no array)

    // showDialog => Mostrar a imagem
    showDialog(
      context: context, // contexto da tela
      builder: (context) => Dialog(
        child: Image.network(imagen)
      )
    );

  }
}