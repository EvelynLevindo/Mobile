import 'package:flutter/material.dart';
import '../database/database_helper.dart';
import '../models/registro.dart';
import '../widgets/registro_card.dart';
import 'registro_form_screen.dart';
import 'detalhes_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Registro> _registros = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadRegistros();
  }

  Future<void> _loadRegistros() async {
    setState(() => _isLoading = true);
    final list = await DatabaseHelper.instance.getAllRegistros();
    setState(() {
      _registros = list;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('SENAI CheckIn'),
        centerTitle: true,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _registros.isEmpty
              ? const Center(child: Text('Nenhum registro cadastrado.'))
              : ListView.builder(
                  itemCount: _registros.length,
                  itemBuilder: (context, index) {
                    final registro = _registros[index];
                    return RegistroCard(
                      registro: registro,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => DetalhesScreen(registro: registro),
                          ),
                        );
                      },
                    );
                  },
                ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => const RegistroFormScreen(),
            ),
          );
          if (result == true) {
            _loadRegistros();
          }
        },
        label: const Text('Novo Check-in'),
        icon: const Icon(Icons.add_location_alt),
      ),
    );
  }
}