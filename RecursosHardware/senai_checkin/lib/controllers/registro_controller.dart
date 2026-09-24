import 'dart:io';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import '../models/registro_ponto.dart';
import '../models/registro_database.dart';

// Usamos ChangeNotifier para avisar a View quando o estado mudar
class RegistroController extends ChangeNotifier {
  final ImagePicker _picker = ImagePicker();

  File? fotoSelecionada;
  Position? posicaoAtual;
  bool carregando = false;
  List<RegistroPonto> registros = [];

  Future<void> carregarRegistros() async {
    registros = await RegistroDatabase.listar();
    notifyListeners();
  }

  Future<String?> capturarFoto() async {
    final cameraStatus = await Permission.camera.request();
    final locationStatus = await Permission.locationWhenInUse.request();

    if (!cameraStatus.isGranted && !cameraStatus.isLimited ||
        !locationStatus.isGranted && !locationStatus.isLimited) {
      return 'Permita acesso à câmera e à localização para continuar.';
    }

    final foto = await _picker.pickImage(
      source: ImageSource.camera,
      preferredCameraDevice: CameraDevice.rear,
    );

    if (foto != null) {
      fotoSelecionada = File(foto.path);
      notifyListeners();
    }
    return null; // Sem erros
  }

  Future<String?> buscarLocalizacao() async {
    final serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return 'Ative o GPS para capturar a localização do registro.';
    }

    var status = await Permission.locationWhenInUse.status;
    if (status.isDenied) {
      status = await Permission.locationWhenInUse.request();
    }

    if (!status.isGranted && !status.isLimited) {
      return 'A localização foi negada. Permita o uso para registrar o ponto.';
    }

    try {
      posicaoAtual = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
        timeLimit: const Duration(seconds: 15),
      );
      notifyListeners();
      return null;
    } catch (_) {
      return 'Não foi possível obter a localização. Tente novamente.';
    }
  }

  Future<String?> salvarRegistro(String observacaoTexto) async {
    if (fotoSelecionada == null || posicaoAtual == null) {
      return 'Capture a foto e a localização antes de salvar.';
    }

    carregando = true;
    notifyListeners();

    try {
      final String dataHora = DateTime.now().toIso8601String();
      final registro = RegistroPonto(
        dataHora: dataHora,
        latitude: posicaoAtual!.latitude,
        longitude: posicaoAtual!.longitude,
        observacao: observacaoTexto.trim().isEmpty
            ? 'Registro realizado em campo.'
            : observacaoTexto.trim(),
        fotoPath: fotoSelecionada!.path,
      );

      await RegistroDatabase.inserir(registro);
      await carregarRegistros();

      // Limpar o estado após salvar
      fotoSelecionada = null;
      posicaoAtual = null;
      return null; // Sucesso
    } catch (e) {
      return 'Erro ao salvar o registro: $e';
    } finally {
      carregando = false;
      notifyListeners();
    }
  }
}