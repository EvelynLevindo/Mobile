class Exercise {
  final int? id;
  final int routineId;
  final String name;
  final int sets;
  final int reps;
  final double weight;
  final String type;

  Exercise({
    this.id,
    required this.routineId,
    required this.name,
    required this.sets,
    required this.reps,
    required this.weight,
    required this.type,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'routineId': routineId,
      'name': name,
      'sets': sets,
      'reps': reps,
      'weight': weight,
      'type': type,
    };
  }

  factory Exercise.fromMap(Map<String, dynamic> map) {
    return Exercise(
      id: map['id'],
      routineId: map['routineId'],
      name: map['name'],
      sets: map['sets'],
      reps: map['reps'],
      weight: map['weight'],
      type: map['type'],
    );
  }
}