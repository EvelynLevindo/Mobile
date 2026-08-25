import 'package:flutter/material.dart';
import 'views/login_page.dart';

void main() {
  runApp(const CineFavoriteApp());
}

class CineFavoriteApp extends StatelessWidget {
  const CineFavoriteApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CineFavorite',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => LoginPage(),
      },
    );
  }
}