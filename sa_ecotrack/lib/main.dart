import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'provider/eco_provider.dart';
import 'view/home_view.dart';

void main() => runApp(const EcoTrackApp());

class EcoTrackApp extends StatelessWidget {
  const EcoTrackApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => EcoProvider(),
      child: Consumer<EcoProvider>(
        builder: (context, provider, _) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: ThemeData(brightness: Brightness.light, primarySwatch: Colors.green),
            darkTheme: ThemeData(brightness: Brightness.dark, primarySwatch: Colors.green),
            themeMode: provider.isDarkMode ? ThemeMode.dark : ThemeMode.light,
            home: const HomeView(),
          );
        },
      ),
    );
  }
}