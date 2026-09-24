import 'package:flutter/material.dart';
import 'views/registro_home_page.dart';

void main() {
  runApp(const SenaiCheckinApp());
}

class SenaiCheckinApp extends StatelessWidget {
  const SenaiCheckinApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SENAI CheckIn',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF0B6E4F)),
        useMaterial3: true,
      ),
      home: const RegistroHomePage(),
    );
  }
}