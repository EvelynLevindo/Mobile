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