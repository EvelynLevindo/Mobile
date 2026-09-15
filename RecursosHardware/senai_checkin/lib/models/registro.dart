class Registro {
  final int? id;
  final String dataHora;
  final double latitude;
  final double longitude;
  final String? observacao;
  final String? caminhoFoto;

  Registro({
    this.id,
    required this.dataHora,
    required this.latitude,
    required this.longitude,
    this.observacao,
    this.caminhoFoto,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'data_hora': dataHora,
      'latitude': latitude,
      'longitude': longitude,
      'observacao': observacao,
      'caminho_foto': caminhoFoto,
    };
  }

  factory Registro.fromMap(Map<String, dynamic> map) {
    return Registro(
      id: map['id'] as int?,
      dataHora: map['data_hora'] as String,
      latitude: (map['latitude'] as num).toDouble(),
      longitude: (map['longitude'] as num).toDouble(),
      observacao: map['observacao'] as String?,
      caminhoFoto: map['caminho_foto'] as String?,
    );
  }
}