import 'package:gymtrack/infrastructure/models/exercises_models.dart';

class DailyWorkout {
  final DateTime date;
  final List<Exercise> exercises;

  DailyWorkout({required this.date, required this.exercises});
}

