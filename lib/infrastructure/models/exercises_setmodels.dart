class ExerciseSet {
  final int reps;
  final int weight;
  final int assists;

  ExerciseSet({
    required this.reps,
    required this.weight,
    required this.assists,
  });

 factory ExerciseSet.fromJson(Map<String, dynamic> json) {
  return ExerciseSet(
    reps: json['reps'] as int? ?? 0,
    weight: json['weight'] as int? ?? 0,
    assists: json['assists'] as int? ?? 0,
    // Asegúrate de que 'unit' ha sido removido de aquí si ya no es parte del modelo.
  );
}

  Map<String, dynamic> toJson() {
    return {
      'reps': reps,
      'weight': weight,
      'assists': assists,
    };
  }

  ExerciseSet copyWith({
    int? reps,
    int? weight,
    int? assists,
  }) {
    return ExerciseSet(
      reps: reps ?? this.reps,
      weight: weight ?? this.weight,
      assists: assists ?? this.assists,
    );
  }
}
