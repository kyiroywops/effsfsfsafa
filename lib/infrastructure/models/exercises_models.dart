import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gymtrack/infrastructure/models/exercises_setmodels.dart';
import 'package:gymtrack/infrastructure/models/gym_item_model.dart';

class Exercise {
  final String id;
  final String name;
  final String exerciseIcon;
  final GymItem gymItem;
  final String unit; // Nuevo campo para la unidad aplicable a todo el ejercicio
  final List<ExerciseSet> sets;
  final DateTime? timestamp;
  final int recordSetWeightLowReps;
  final int recordSetWeight; // Debes declarar esta nueva propiedad aquí
  final Map<String, String> translations;

  Exercise({
    this.id = '',
    required this.name,
    required this.exerciseIcon,
    required this.gymItem,
    this.unit = '',
    required this.sets,
    this.timestamp,
    this.recordSetWeightLowReps = 0,
    this.recordSetWeight = 0, // Inicializa el nuevo campo aquí
    this.translations = const {},
  });

  factory Exercise.fromJson(Map<String, dynamic> json) {
    var setsList = json['sets'] as List? ?? [];
    var sets = setsList.map((set) => ExerciseSet.fromJson(set as Map<String, dynamic>)).toList();
    var translations = json['translations'] as Map<String, dynamic>? ?? {};

    var exerciseIcon = json['icon'] as String? ?? 'default_icon.png';

    var gymItemJson = json['gymItem'] as Map<String, dynamic>? ?? {};

    return Exercise(
      id: json['id'] as String? ?? '',
      name: json['name'] as String? ?? 'Default Name',
      exerciseIcon: exerciseIcon,
      gymItem: GymItem.fromJson(gymItemJson),
      unit: json['unit'] as String? ?? '',
      sets: sets,
      timestamp: json['timestamp'] != null ? DateTime.parse(json['timestamp'] as String) : null,
      recordSetWeightLowReps: json['recordSetWeightLowReps'] as int? ?? 0,
      recordSetWeight: json['recordSetWeight'] as int? ?? 0, // Nuevo campo aquí
      translations: translations.map((key, value) => MapEntry(key, value.toString())),
    );
  }

  factory Exercise.fromFirestore(Map<String, dynamic> data, String documentId) {
    var sets = (data['sets'] as List).map((set) => ExerciseSet.fromJson(set)).toList();
    return Exercise(
      id: documentId,
      name: data['exerciseName'] ?? 'Default Name',
      exerciseIcon: data['exerciseIcon'] ?? 'default_icon.png',
      gymItem: GymItem(
        name: data['gymItemName'] ?? 'Default',
        iconPath: data['gymItemIconPath'] ?? 'default_icon.png',
      ),
      unit: data['unit'] ?? '',
      sets: sets,
      timestamp: data['timestamp'] != null ? (data['timestamp'] as Timestamp).toDate() : null,
      recordSetWeightLowReps: data['recordSetWeightLowReps'] as int? ?? 0,
      recordSetWeight: data['recordSetWeight'] as int? ?? 0, // Nuevo campo aquí
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'exerciseIcon': exerciseIcon,
      'gymItem': gymItem.toJson(),
      'unit': unit,
      'sets': sets.map((set) => set.toJson()).toList(),
      'timestamp': timestamp?.toIso8601String(),
      'recordSetWeightLowReps': recordSetWeightLowReps,
      'recordSetWeight': recordSetWeight, // Asegúrate de incluir el nuevo campo aquí
      'translations': translations,
    };
  }

  Exercise copyWith({
    String? id,
    String? name,
    String? exerciseIcon,
    GymItem? gymItem,
    String? unit,
    List<ExerciseSet>? sets,
    DateTime? timestamp,
    int? recordSetWeightLowReps,
    int? recordSetWeight, // Debes incluir el nuevo campo como parámetro aquí
    Map<String, String>? translations,
  }) {
    return Exercise(
      id: id ?? this.id,
      name: name ?? this.name,
      exerciseIcon: exerciseIcon ?? this.exerciseIcon,
      gymItem: gymItem ?? this.gymItem,
      unit: unit ?? this.unit,
      sets: sets ?? this.sets,
      timestamp: timestamp ?? this.timestamp,
      recordSetWeightLowReps: recordSetWeightLowReps ?? this.recordSetWeightLowReps,
      recordSetWeight: recordSetWeight ?? this.recordSetWeight, // Nuevo campo aquí
      translations: translations ?? this.translations,
    );
  }
}
