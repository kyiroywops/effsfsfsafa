import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gymtrack/infrastructure/models/exercises_models.dart';

class StatsRepository {
  final FirebaseFirestore _firestore;

  StatsRepository(this._firestore);

  Future<Map<String, Exercise>> getHighestWeightRecords() async {
    QuerySnapshot snapshot = await _firestore.collection('exercises').get();

    Map<String, Exercise> highestWeights = {};
    for (var doc in snapshot.docs) {
      var data = doc.data() as Map<String, dynamic>;
      Exercise exercise = Exercise.fromFirestore(data, doc.id);

      String key = "${exercise.name}_${exercise.gymItem.name}";
      if (!highestWeights.containsKey(key) || highestWeights[key]!.recordSetWeightLowReps < exercise.recordSetWeightLowReps) {
        highestWeights[key] = exercise;
      }
    }

    return highestWeights;
  }
}
