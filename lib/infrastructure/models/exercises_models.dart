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
final Map<String, String> translations;


  Exercise({
    this.id = '',
    required this.name,
    required this.exerciseIcon,
    required this.gymItem,
    this.unit = '', // Proporciona un valor predeterminado o hazlo required según tu caso de uso
    required this.sets,
    this.timestamp,
    this.recordSetWeightLowReps = 0,
    this.translations = const {},
  });

factory Exercise.fromJson(Map<String, dynamic> json) {
  var setsList = json['sets'] as List? ?? [];
  var sets = setsList.map((set) => ExerciseSet.fromJson(set as Map<String, dynamic>)).toList();
  var translations = json['translations'] as Map<String, dynamic>? ?? {};

  // Utiliza la clave 'icon' para obtener la ruta del ícono desde el JSON, ya que así es como está representado en tu JSON.
  var exerciseIcon = json['icon'] as String? ?? 'default_icon.png'; // Asegúrate de que 'default_icon.png' sea un valor válido por defecto.

  var gymItemJson = json['gymItem'] as Map<String, dynamic>? ?? {};

  return Exercise(
    id: json['id'] as String? ?? '',
    name: json['name'] as String? ?? 'Default Name',
    exerciseIcon: exerciseIcon, // Utiliza la variable exerciseIcon aquí.
    gymItem: GymItem.fromJson(gymItemJson),
    unit: json['unit'] as String? ?? '',
    sets: sets,
    timestamp: json['timestamp'] != null ? DateTime.parse(json['timestamp'] as String) : null,
    recordSetWeightLowReps: json['recordSetWeightLowReps'] as int? ?? 0,
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
      unit: data['unit'] ?? '', // Asume que 'unit' está presente en los datos
      sets: sets,
      timestamp: data['timestamp'] != null ? (data['timestamp'] as Timestamp).toDate() : null,
      recordSetWeightLowReps: data['recordSetWeightLowReps'] as int? ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'exerciseIcon': exerciseIcon,
      'gymItem': gymItem.toJson(),
      'unit': unit, // Incluye 'unit' al convertir a JSON
      'sets': sets.map((set) => set.toJson()).toList(),
      'timestamp': timestamp?.toIso8601String(),
      'recordSetWeightLowReps': recordSetWeightLowReps,
      'translations': translations,

    };
  }
Exercise copyWith({Map<String, String>? translations}) {
    return Exercise(
      id: this.id,
      name: this.name,
      exerciseIcon: this.exerciseIcon,
      gymItem: this.gymItem,
      unit: this.unit,
      sets: this.sets,
      timestamp: this.timestamp,
      recordSetWeightLowReps: this.recordSetWeightLowReps,
      translations: translations ?? this.translations,
    );
  }
}
