import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gymtrack/infrastructure/models/exercises_setmodels.dart';
import 'package:gymtrack/infrastructure/models/gym_item_model.dart';

class Exercise {
  final String name;
  final String exerciseIcon;
  final GymItem gymItem;
  final List<ExerciseSet> sets;
  final DateTime? timestamp;

  Exercise({
    required this.name,
    required this.exerciseIcon,
    required this.gymItem,
    required this.sets,
    this.timestamp,
  });

  factory Exercise.fromJson(Map<String, dynamic> json) {
    return Exercise(
      name: json['name'] as String? ?? 'Default Name',
      exerciseIcon: json['icon'] as String? ?? 'default_icon.png',
      gymItem: GymItem(name: 'Default', iconPath: 'default_icon.png'), // Establece valores predeterminados o ajusta según sea necesario
      sets: [], // Establece valores predeterminados o ajusta según sea necesario
      timestamp: null, // Establece valores predeterminados o ajusta según sea necesario
    );
  }

  factory Exercise.fromFirestore(Map<String, dynamic> data) {
    var sets = (data['sets'] as List).map((set) => ExerciseSet.fromJson(set)).toList();
    var gymItem = GymItem.fromJson(data['gymItem']);

    return Exercise(
      name: data['exerciseName'],
      exerciseIcon: data['exerciseIcon'],
      gymItem: gymItem,
      sets: sets,
      timestamp: (data['timestamp'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'exerciseName': name,
      'exerciseIcon': exerciseIcon,
      'gymItem': gymItem.toJson(),
      'sets': sets.map((set) => set.toJson()).toList(),
      'timestamp': timestamp?.toIso8601String(),
    };
  }
}
