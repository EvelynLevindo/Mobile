import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sqflite/sqflite.dart';

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

class RegistroPonto {
  final int? id;
  final String dataHora;
  final double latitude;
  final double longitude;
  final String observacao;
  final String fotoPath;

  const RegistroPonto({
    this.id,
    required this.dataHora,
    required this.latitude,
    required this.longitude,
    required this.observacao,
    required this.fotoPath,
  });

  RegistroPonto copyWith({
    int? id,
    String? dataHora,
    double? latitude,
    double? longitude,
    String? observacao,
    String? fotoPath,
  }) {
    return RegistroPonto(
      id: id ?? this.id,
      dataHora: dataHora ?? this.dataHora,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      observacao: observacao ?? this.observacao,
      fotoPath: fotoPath ?? this.fotoPath,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'data_hora': dataHora,
      'latitude': latitude,
      'longitude': longitude,
      'observacao': observacao,
      'foto_path': fotoPath,
    };
  }

  factory RegistroPonto.fromMap(Map<String, dynamic> map) {
    return RegistroPonto(
      id: map['id'] as int?,
      dataHora: map['data_hora'] as String,
      latitude: (map['latitude'] as num).toDouble(),
      longitude: (map['longitude'] as num).toDouble(),
      observacao: map['observacao'] as String,
      fotoPath: map['foto_path'] as String,
    );
  }
}

class RegistroDatabase {
  static Database? _database;
  static const String _tableName = 'registros';

  static Future<Database> get database async {
    if (_database != null) {
      return _database!;
    }

    final documentsDirectory = await getApplicationDocumentsDirectory();
    final dbPath = path.join(documentsDirectory.path, 'senai_checkin.db');

    _database = await openDatabase(
      dbPath,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE $_tableName (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            data_hora TEXT NOT NULL,
            latitude REAL NOT NULL,
            longitude REAL NOT NULL,
            observacao TEXT NOT NULL,
            foto_path TEXT NOT NULL
          )
        ''');
      },
    );

    return _database!;
  }

  static Future<int> inserir(RegistroPonto registro) async {
    final db = await database;
    return db.insert(_tableName, registro.toMap());
  }

  static Future<List<RegistroPonto>> listar() async {
    final db = await database;
    final maps = await db.query(
      _tableName,
      orderBy: 'data_hora DESC',
    );

    return maps.map(RegistroPonto.fromMap).toList();
  }
}

class RegistroHomePage extends StatefulWidget {
  const RegistroHomePage({super.key});

  @override
  State<RegistroHomePage> createState() => _RegistroHomePageState();
}

class _RegistroHomePageState extends State<RegistroHomePage> {
  final TextEditingController _observacaoController = TextEditingController();
  final ImagePicker _picker = ImagePicker();

  File? _fotoSelecionada;
  Position? _posicaoAtual;
  bool _carregando = false;
  List<RegistroPonto> _registros = [];

  @override
  void initState() {
    super.initState();
    _carregarRegistros();
  }

  Future<void> _carregarRegistros() async {
    final registros = await RegistroDatabase.listar();
    if (!mounted) return;
    setState(() {
      _registros = registros;
    });
  }

  Future<bool> _solicitarPermissoes() async {
    final cameraStatus = await Permission.camera.request();
    final locationStatus = await Permission.locationWhenInUse.request();

    final cameraOk = cameraStatus.isGranted || cameraStatus.isLimited;
    final locationOk = locationStatus.isGranted || locationStatus.isLimited;

    if (!cameraOk || !locationOk) {
      if (!mounted) return false;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Permita acesso à câmera e à localização para continuar.'),
        ),
      );
      return false;
    }

    return true;
  }

  Future<void> _capturarFoto() async {
    final podeContinuar = await _solicitarPermissoes();
    if (!podeContinuar) return;

    final foto = await _picker.pickImage(
      source: ImageSource.camera,
      preferredCameraDevice: CameraDevice.rear,
    );

    if (foto == null) return;

    setState(() {
      _fotoSelecionada = File(foto.path);
    });
  }

  Future<void> _buscarLocalizacao() async {
    final serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Ative o GPS para capturar a localização do registro.'),
        ),
      );
      return;
    }

    var status = await Permission.locationWhenInUse.status;
    if (status.isDenied) {
      status = await Permission.locationWhenInUse.request();
    }

    if (!status.isGranted && !status.isLimited) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('A localização foi negada. Permita o uso para registrar o ponto.'),
        ),
      );
      return;
    }

    try {
      final posicao = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
        timeLimit: const Duration(seconds: 15),
      );

      setState(() {
        _posicaoAtual = posicao;
      });
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Não foi possível obter a localização. Tente novamente.'),
        ),
      );
    }
  }

  Future<void> _salvarRegistro() async {
    if (_fotoSelecionada == null || _posicaoAtual == null) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Capture a foto e a localização antes de salvar.'),
        ),
      );
      return;
    }

    setState(() {
      _carregando = true;
    });

    try {
      final String dataHora = DateTime.now().toIso8601String();
      final registro = RegistroPonto(
        dataHora: dataHora,
        latitude: _posicaoAtual!.latitude,
        longitude: _posicaoAtual!.longitude,
        observacao: _observacaoController.text.trim().isEmpty
            ? 'Registro realizado em campo.'
            : _observacaoController.text.trim(),
        fotoPath: _fotoSelecionada!.path,
      );

      await RegistroDatabase.inserir(registro);
      await _carregarRegistros();

      if (!mounted) return;
      SystemSound.play(SystemSoundType.alert);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Registro salvo com sucesso!'),
          backgroundColor: Color(0xFF0B6E4F),
        ),
      );

      setState(() {
        _fotoSelecionada = null;
        _posicaoAtual = null;
        _observacaoController.clear();
      });
    } finally {
      if (mounted) {
        setState(() {
          _carregando = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('SENAI CheckIn'),
        backgroundColor: const Color(0xFF0B6E4F),
        foregroundColor: Colors.white,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Registrar ponto',
                style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Foto do registro',
                        style: TextStyle(fontWeight: FontWeight.w700),
                      ),
                      const SizedBox(height: 12),
                      if (_fotoSelecionada != null)
                        ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.file(
                            _fotoSelecionada!,
                            fit: BoxFit.cover,
                            height: 200,
                            width: double.infinity,
                          ),
                        )
                      else
                        Container(
                          height: 180,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: Colors.grey.shade200,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Center(
                            child: Icon(Icons.photo_camera, size: 48, color: Colors.grey),
                          ),
                        ),
                      const SizedBox(height: 12),
                      ElevatedButton.icon(
                        onPressed: _capturarFoto,
                        icon: const Icon(Icons.camera_alt),
                        label: const Text('Capturar foto'),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Localização',
                        style: TextStyle(fontWeight: FontWeight.w700),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              _posicaoAtual == null
                                  ? 'GPS ainda não capturado'
                                  : 'Lat: ${_posicaoAtual!.latitude.toStringAsFixed(6)}',
                            ),
                          ),
                          TextButton.icon(
                            onPressed: _buscarLocalizacao,
                            icon: const Icon(Icons.location_on),
                            label: const Text('Obter GPS'),
                          ),
                        ],
                      ),
                      if (_posicaoAtual != null)
                        Text(
                          'Long: ${_posicaoAtual!.longitude.toStringAsFixed(6)}',
                        ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Observação',
                        style: TextStyle(fontWeight: FontWeight.w700),
                      ),
                      const SizedBox(height: 8),
                      TextField(
                        controller: _observacaoController,
                        maxLines: 3,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          hintText: 'Descreva a visita, inspeção ou atividade.',
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: FilledButton.icon(
                  onPressed: _carregando ? null : _salvarRegistro,
                  icon: _carregando
                      ? const SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Icon(Icons.check_circle),
                  label: Text(_carregando ? 'Salvando...' : 'Salvar registro'),
                ),
              ),
              const SizedBox(height: 28),
              const Text(
                'Registros salvos',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              if (_registros.isEmpty)
                const Card(
                  child: Padding(
                    padding: EdgeInsets.all(16),
                    child: Text('Nenhum registro encontrado. Faça o primeiro check-in.'),
                  ),
                )
              else
                ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: _registros.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    final registro = _registros[index];
                    return Card(
                      child: ListTile(
                        contentPadding: const EdgeInsets.all(12),
                        leading: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.file(
                            File(registro.fotoPath),
                            width: 70,
                            height: 70,
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) => Container(
                              width: 70,
                              height: 70,
                              color: Colors.grey.shade300,
                              child: const Icon(Icons.image_not_supported),
                            ),
                          ),
                        ),
                        title: Text(
                          DateTime.parse(registro.dataHora).toLocal().toString(),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 6),
                            Text(registro.observacao),
                            const SizedBox(height: 4),
                            Text(
                              'Lat: ${registro.latitude.toStringAsFixed(6)} | Long: ${registro.longitude.toStringAsFixed(6)}',
                            ),
                          ],
                        ),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => RegistroDetalhesPage(registro: registro),
                            ),
                          );
                        },
                      ),
                    );
                  },
                ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _observacaoController.dispose();
    super.dispose();
  }
}

class RegistroDetalhesPage extends StatelessWidget {
  final RegistroPonto registro;

  const RegistroDetalhesPage({super.key, required this.registro});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detalhes do registro'),
        backgroundColor: const Color(0xFF0B6E4F),
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Image.file(
                File(registro.fotoPath),
                fit: BoxFit.cover,
                width: double.infinity,
                height: 260,
                errorBuilder: (_, __, ___) => Container(
                  height: 260,
                  color: Colors.grey.shade300,
                  child: const Center(child: Icon(Icons.broken_image, size: 48)),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              DateTime.parse(registro.dataHora).toLocal().toString(),
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            _InfoItem(label: 'Latitude', value: registro.latitude.toStringAsFixed(6)),
            _InfoItem(label: 'Longitude', value: registro.longitude.toStringAsFixed(6)),
            _InfoItem(label: 'Observação', value: registro.observacao),
          ],
        ),
      ),
    );
  }
}

class _InfoItem extends StatelessWidget {
  final String label;
  final String value;

  const _InfoItem({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(fontWeight: FontWeight.w700)),
          const SizedBox(height: 4),
          Text(value),
        ],
      ),
    );
  }
}
