class Routine {
  final int? id;
  final String name;
  final String goal;

  Routine({this.id, required this.name, required this.goal});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'goal': goal,
    };
  }

  factory Routine.fromMap(Map<String, dynamic> map) {
    return Routine(
      id: map['id'],
      name: map['name'],
      goal: map['goal'],
    );
  }
}