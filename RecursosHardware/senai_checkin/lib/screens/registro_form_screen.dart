import 'dart:io';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:audioplayers/audioplayers.dart';
import '../models/registro.dart';
import '../database/database_helper.dart';
import '../services/permission_service.dart';
import '../services/location_service.dart';
import '../services/camera_service.dart';

class RegistroFormScreen extends StatefulWidget {
  const RegistroFormScreen({super.key});

  @override
  State<RegistroFormScreen> createState() => _RegistroFormScreenState();
}

class _RegistroFormScreenState extends State<RegistroFormScreen> {
  final _obsController = TextEditingController();
  final AudioPlayer _audioPlayer = AudioPlayer();

  Position? _currentPosition;
  String? _photoPath;
  bool _isLoadingLocation = false;
  bool _isSaving = false;

  @override
  void dispose() {
    _obsController.dispose();
    _audioPlayer.dispose();
    super.dispose();
  }

  Future<void> _getGpsAndPermissions() async {
    setState(() => _isLoadingLocation = true);
    try {
      bool granted = await PermissionService.requestCameraAndLocationPermissions();
      if (!granted) {
        _showSnackBar('Permissões de Câmera e GPS são necessárias.', isError: true);
        return;
      }

      Position pos = await LocationService.getCurrentLocation();
      setState(() {
        _currentPosition = pos;
      });
    } catch (e) {
      _showSnackBar(e.toString().replaceAll('Exception: ', ''), isError: true);
    } finally {
      setState(() => _isLoadingLocation = false);
    }
  }

  Future<void> _takePhoto() async {
    try {
      String? path = await CameraService.capturePhoto();
      if (path != null) {
        setState(() {
          _photoPath = path;
        });
      }
    } catch (e) {
      _showSnackBar(e.toString().replaceAll('Exception: ', ''), isError: true);
    }
  }

  Future<void> _save() async {
    if (_currentPosition == null) {
      _showSnackBar('Por favor, obtenha a localização via GPS.', isError: true);
      return;
    }

    if (_photoPath == null) {
      _showSnackBar('Por favor, tire uma foto para o registro.', isError: true);
      return;
    }

    setState(() => _isSaving = true);

    try {
      final registro = Registro(
        dataHora: DateTime.now().toString().split('.')[0],
        latitude: _currentPosition!.latitude,
        longitude: _currentPosition!.longitude,
        observacao: _obsController.text.trim(),
        caminhoFoto: _photoPath,
      );

      await DatabaseHelper.instance.insertRegistro(registro);

      try {
        await _audioPlayer.play(AssetSource('sounds/beep.mp3'));
      } catch (_) {}

      if (mounted) {
        _showSnackBar('Registro salvo com sucesso!');
        Navigator.pop(context, true);
      }
    } catch (e) {
      _showSnackBar('Erro ao salvar registro: $e', isError: true);
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  void _showSnackBar(String message, {bool isError = false}) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: isError ? Colors.red : Colors.green,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Novo Registro')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ElevatedButton.icon(
              onPressed: _isLoadingLocation ? null : _getGpsAndPermissions,
              icon: const Icon(Icons.my_location),
              label: Text(_isLoadingLocation ? 'Obtendo GPS...' : '1. Solicitar Permissões & Obter GPS'),
            ),
            if (_currentPosition != null) ...[
              const SizedBox(height: 8),
              Text(
                'Lat: ${_currentPosition!.latitude}, Lng: ${_currentPosition!.longitude}',
                textAlign: TextAlign.center,
                style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.green),
              ),
            ],
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: _takePhoto,
              icon: const Icon(Icons.camera_alt),
              label: const Text('2. Tirar Foto'),
            ),
            const SizedBox(height: 8),
            if (_photoPath != null)
              Container(
                height: 150,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Image.file(File(_photoPath!), fit: BoxFit.cover),
              ),
            const SizedBox(height: 16),
            TextField(
              controller: _obsController,
              decoration: const InputDecoration(
                labelText: 'Observação (Opcional)',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _isSaving ? null : _save,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
              ),
              child: _isSaving
                  ? const CircularProgressIndicator(color: Colors.white)
                  : const Text('SALVAR REGISTRO', style: TextStyle(fontSize: 16)),
            ),
          ],
        ),
      ),
    );
  }
}