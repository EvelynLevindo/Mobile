import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../controllers/registro_controller.dart';
import 'registro_detalhes_page.dart';

class RegistroHomePage extends StatefulWidget {
  const RegistroHomePage({super.key});

  @override
  State<RegistroHomePage> createState() => _RegistroHomePageState();
}

class _RegistroHomePageState extends State<RegistroHomePage> {
  final TextEditingController _observacaoController = TextEditingController();
  final RegistroController _controller = RegistroController();

  @override
  void initState() {
    super.initState();
    _controller.carregarRegistros();
  }

  @override
  void dispose() {
    _observacaoController.dispose();
    _controller.dispose();
    super.dispose();
  }

  void _mostrarSnackBar(String mensagem, {Color? cor}) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(mensagem), backgroundColor: cor),
    );
  }

  Future<void> _capturarFoto() async {
    final erro = await _controller.capturarFoto();
    if (erro != null) _mostrarSnackBar(erro);
  }

  Future<void> _buscarLocalizacao() async {
    final erro = await _controller.buscarLocalizacao();
    if (erro != null) _mostrarSnackBar(erro);
  }

  Future<void> _salvarRegistro() async {
    final erro = await _controller.salvarRegistro(_observacaoController.text);
    if (erro != null) {
      _mostrarSnackBar(erro);
    } else {
      _observacaoController.clear();
      SystemSound.play(SystemSoundType.alert);
      _mostrarSnackBar('Registro salvo com sucesso!', cor: const Color(0xFF0B6E4F));
    }
  }

  @override
  Widget build(BuildContext context) {
    // ListenableBuilder escuta o Controller e refaz a tela quando ele muda (notifyListeners)
    return Scaffold(
      appBar: AppBar(
        title: const Text('SENAI CheckIn'),
        backgroundColor: const Color(0xFF0B6E4F),
        foregroundColor: Colors.white,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: ListenableBuilder(
            listenable: _controller,
            builder: (context, child) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Registrar ponto',
                    style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),
                  _buildFotoCard(),
                  const SizedBox(height: 16),
                  _buildLocalizacaoCard(),
                  const SizedBox(height: 16),
                  _buildObservacaoCard(),
                  const SizedBox(height: 20),
                  _buildBotaoSalvar(),
                  const SizedBox(height: 28),
                  const Text(
                    'Registros salvos',
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),
                  _buildListaRegistros(),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildFotoCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Foto do registro', style: TextStyle(fontWeight: FontWeight.w700)),
            const SizedBox(height: 12),
            if (_controller.fotoSelecionada != null)
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.file(_controller.fotoSelecionada!, fit: BoxFit.cover, height: 200, width: double.infinity),
              )
            else
              Container(
                height: 180,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.grey.shade200,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Center(child: Icon(Icons.photo_camera, size: 48, color: Colors.grey)),
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
    );
  }

  Widget _buildLocalizacaoCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Localização', style: TextStyle(fontWeight: FontWeight.w700)),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: Text(
                    _controller.posicaoAtual == null
                        ? 'GPS ainda não capturado'
                        : 'Lat: ${_controller.posicaoAtual!.latitude.toStringAsFixed(6)}',
                  ),
                ),
                TextButton.icon(
                  onPressed: _buscarLocalizacao,
                  icon: const Icon(Icons.location_on),
                  label: const Text('Obter GPS'),
                ),
              ],
            ),
            if (_controller.posicaoAtual != null)
              Text('Long: ${_controller.posicaoAtual!.longitude.toStringAsFixed(6)}'),
          ],
        ),
      ),
    );
  }

  Widget _buildObservacaoCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Observação', style: TextStyle(fontWeight: FontWeight.w700)),
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
    );
  }

  Widget _buildBotaoSalvar() {
    return SizedBox(
      width: double.infinity,
      child: FilledButton.icon(
        onPressed: _controller.carregando ? null : _salvarRegistro,
        icon: _controller.carregando
            ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2))
            : const Icon(Icons.check_circle),
        label: Text(_controller.carregando ? 'Salvando...' : 'Salvar registro'),
      ),
    );
  }

  Widget _buildListaRegistros() {
    if (_controller.registros.isEmpty) {
      return const Card(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Text('Nenhum registro encontrado. Faça o primeiro check-in.'),
        ),
      );
    }
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: _controller.registros.length,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final registro = _controller.registros[index];
        return Card(
          child: ListTile(
            contentPadding: const EdgeInsets.all(12),
            leading: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.file(
                File(registro.fotoPath), width: 70, height: 70, fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Container(
                  width: 70, height: 70, color: Colors.grey.shade300,
                  child: const Icon(Icons.image_not_supported),
                ),
              ),
            ),
            title: Text(DateTime.parse(registro.dataHora).toLocal().toString()),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 6),
                Text(registro.observacao),
                const SizedBox(height: 4),
                Text('Lat: ${registro.latitude.toStringAsFixed(6)} | Long: ${registro.longitude.toStringAsFixed(6)}'),
              ],
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => RegistroDetalhesPage(registro: registro)),
              );
            },
          ),
        );
      },
    );
  }
}