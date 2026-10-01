import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
import '../config/app_config.dart';
import '../models/punch_model.dart';
import '../services/auth_service.dart';
import '../services/database_service.dart';
import '../services/location_service.dart';
import 'history_view.dart';
import 'profile_view.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  final LocationService _locationService = LocationService();
  final DatabaseService _databaseService = DatabaseService();
  final AuthService _authService = AuthService();

  Position? _currentPosition;
  double? _distanceInMeters;
  bool _isLoadingLocation = false;
  bool _isSavingPunch = false;
  PunchModel? _lastPunch;
  String? _locationError;

  @override
  void initState() {
    super.initState();
    _checkLocationAndDistance();
    _loadLastPunch();
  }

  Future<void> _checkLocationAndDistance() async {
    setState(() {
      _isLoadingLocation = true;
      _locationError = null;
    });

    try {
      Position pos = await _locationService.getCurrentLocation();
      double dist = _locationService.calculateDistance(pos.latitude, pos.longitude);

      setState(() {
        _currentPosition = pos;
        _distanceInMeters = dist;
      });
    } catch (e) {
      setState(() => _locationError = e.toString().replaceAll('Exception: ', ''));
    } finally {
      if (mounted) setState(() => _isLoadingLocation = false);
    }
  }

  Future<void> _loadLastPunch() async {
    final userId = _authService.currentUser;
    if (userId != null) {
      PunchModel? last = await _databaseService.getLastPunch(userId);
      if (mounted) setState(() => _lastPunch = last);
    }
  }

  bool get _isInRange =>
      _distanceInMeters != null && _distanceInMeters! <= AppConfig.maxDistanceMeters;

  Future<void> _registerPunch() async {
    if (!_isInRange || _currentPosition == null) return;
    
    final userId = _authService.currentUser;
    if (userId == null) return;

    setState(() => _isSavingPunch = true);

    try {
      PunchModel punch = PunchModel(
        userId: userId,
        timestamp: DateTime.now(),
        latitude: _currentPosition!.latitude,
        longitude: _currentPosition!.longitude,
      );

      await _databaseService.addPunch(punch);
      setState(() => _lastPunch = punch);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Ponto registrado com sucesso!'), backgroundColor: Colors.green),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro: $e'), backgroundColor: Colors.red),
        );
      }
    } finally {
      if (mounted) setState(() => _isSavingPunch = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final userId = _authService.currentUser;
    final formatter = DateFormat('dd/MM/yyyy HH:mm:ss');

    return Scaffold(
      appBar: AppBar(
        title: const Text('Painel de Ponto'),
        actions: [
          IconButton(
            icon: const Icon(Icons.history),
            onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const HistoryView())),
          ),
          IconButton(
            icon: const Icon(Icons.person),
            onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const ProfileView())),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          await _checkLocationAndDistance();
          await _loadLastPunch();
        },
        child: ListView(
          padding: const EdgeInsets.all(20.0),
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Usuário Logado:', style: TextStyle(color: Colors.grey)),
                    Text(userId ?? 'Desconhecido', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Icon(_isInRange ? Icons.check_circle : Icons.warning, color: _isInRange ? Colors.green : Colors.orange, size: 32),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                _isInRange ? 'Dentro da Área Permitida' : 'Fora do Local de Trabalho',
                                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: _isInRange ? Colors.green : Colors.orange),
                              ),
                              if (_distanceInMeters != null)
                                Text('Distância: ${_distanceInMeters!.toStringAsFixed(1)}m (Máx: ${AppConfig.maxDistanceMeters.toInt()}m)', style: const TextStyle(fontSize: 13)),
                            ],
                          ),
                        ),
                      ],
                    ),
                    if (_locationError != null) ...[
                      const SizedBox(height: 8),
                      Text(_locationError!, style: const TextStyle(color: Colors.red, fontSize: 12)),
                    ],
                    const SizedBox(height: 12),
                    OutlinedButton.icon(
                      onPressed: _isLoadingLocation ? null : _checkLocationAndDistance,
                      icon: const Icon(Icons.refresh),
                      label: const Text('Atualizar Localização'),
                    )
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              height: 56,
              child: ElevatedButton.icon(
                onPressed: (_isInRange && !_isSavingPunch) ? _registerPunch : null,
                style: ElevatedButton.styleFrom(backgroundColor: Colors.green, foregroundColor: Colors.white),
                icon: _isSavingPunch ? const CircularProgressIndicator(color: Colors.white) : const Icon(Icons.touch_app, size: 28),
                label: Text(_isSavingPunch ? 'Registrando...' : 'REGISTRAR PONTO', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              ),
            ),
            const SizedBox(height: 24),
            Card(
              color: Colors.blue.shade50,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Último Registro:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                    const SizedBox(height: 8),
                    _lastPunch != null
                        ? Text(formatter.format(_lastPunch!.timestamp), style: const TextStyle(fontSize: 16, color: Colors.blueAccent))
                        : const Text('Nenhum registro encontrado localmente.', style: TextStyle(color: Colors.grey)),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}