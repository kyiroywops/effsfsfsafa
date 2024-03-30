import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gymtrack/infrastructure/models/exercises_setmodels.dart';
import 'package:gymtrack/infrastructure/models/gym_item_model.dart';

class Exercise {
  final String name;
  final String exerciseIcon;
  final GymItem gymItem;
  final List<ExerciseSet> sets;
  final DateTime? timestamp;
  final int recordSetWeightLowReps; // Añade esta línea para el nuevo campo


  Exercise({
    required this.name,
    required this.exerciseIcon,
    required this.gymItem,
    required this.sets,
    this.timestamp,
    this.recordSetWeightLowReps = 0, // Valor predeterminado para el nuevo campo

  });

  factory Exercise.fromJson(Map<String, dynamic> json) {
    return Exercise(
      name: json['name'] as String? ?? 'Default Name',
      exerciseIcon: json['icon'] as String? ?? 'default_icon.png',
      gymItem: GymItem(name: 'Default', iconPath: 'default_icon.png'), // Establece valores predeterminados o ajusta según sea necesario
      sets: [], // Establece valores predeterminados o ajusta según sea necesario
      timestamp: null, // Establece valores predeterminados o ajusta según sea necesario
      recordSetWeightLowReps: json['recordSetWeightLowReps'] as int? ?? 0,


    );
  }

 factory Exercise.fromFirestore(Map<String, dynamic> data) {
  List<ExerciseSet> sets = data['sets'] != null
      ? (data['sets'] as List).map((set) => ExerciseSet.fromJson(set)).toList()
      : []; // Asegúrate de manejar `null` aquí.

  // Necesitas decidir cómo manejarás gymItem si gymItemName y gymItemIconPath están separados.
  GymItem gymItem = GymItem(
    name: data['gymItemName'] ?? 'Default',
    iconPath: data['gymItemIconPath'] ?? 'default_icon.png',
  );

  return Exercise(
    name: data['exerciseName'] ?? 'Default Name',
    exerciseIcon: data['exerciseIcon'] ?? 'default_icon.png',
    gymItem: gymItem,
    sets: sets,
    timestamp: data['timestamp'] != null
        ? (data['timestamp'] as Timestamp).toDate()
        : null, // Manejo de posible `null`.,
    recordSetWeightLowReps: data['recordSetWeightLowReps'] as int? ?? 0,

  );
}
  Map<String, dynamic> toJson() {
    return {
      'exerciseName': name,
      'exerciseIcon': exerciseIcon,
      'gymItem': gymItem.toJson(),
      'sets': sets.map((set) => set.toJson()).toList(),
      'timestamp': timestamp?.toIso8601String(),
      'recordSetWeightLowReps': recordSetWeightLowReps, // Asegúrate de incluir el campo al convertir a JSON

    };
  }
}
