class PunchModel {
  final int? id;
  final String userId;
  final DateTime timestamp;
  final double latitude;
  final double longitude;

  PunchModel({
    this.id,
    required this.userId,
    required this.timestamp,
    required this.latitude,
    required this.longitude,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId,
      'timestamp': timestamp.millisecondsSinceEpoch,
      'latitude': latitude,
      'longitude': longitude,
    };
  }

  factory PunchModel.fromMap(Map<String, dynamic> map) {
    return PunchModel(
      id: map['id'],
      userId: map['userId'],
      timestamp: DateTime.fromMillisecondsSinceEpoch(map['timestamp']),
      latitude: map['latitude'],
      longitude: map['longitude'],
    );
  }
}