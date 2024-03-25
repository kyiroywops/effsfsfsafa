class ExerciseSet {
  final int reps;
  final int weight;
  final String unit;
  final int assists;

  ExerciseSet({
    required this.reps,
    required this.weight,
    required this.unit,
    required this.assists,
  });

  factory ExerciseSet.fromJson(Map<String, dynamic> json) {
    return ExerciseSet(
      reps: json['reps'],
      weight: json['weight'],
      unit: json['unit'],
      assists: json['assists'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'reps': reps,
      'weight': weight,
      'unit': unit,
      'assists': assists,
    };
  }

  ExerciseSet copyWith({
    int? reps,
    int? weight,
    String? unit,
    int? assists,
  }) {
    return ExerciseSet(
      reps: reps ?? this.reps,
      weight: weight ?? this.weight,
      unit: unit ?? this.unit,
      assists: assists ?? this.assists,
    );
  }
}
