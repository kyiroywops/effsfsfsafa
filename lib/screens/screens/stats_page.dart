import 'package:flutter/material.dart';
import 'package:gymtrack/infrastructure/models/exercises_models.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gymtrack/screens/screens/translations_loader.dart';
import 'package:gymtrack/screens/widgets/stats_repository.dart';

class StatsScreen extends StatelessWidget {
  final StatsRepository _statsRepository =
      StatsRepository(FirebaseFirestore.instance);
  final Future<Map<String, Map<String, String>>> _translationsFuture;

  StatsScreen({Key? key})
      : _translationsFuture = TranslationsLoader()
            .loadTranslations('assets/jsons/exercises.json'),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    String languageCode = Localizations.localeOf(context).languageCode;

    return Scaffold(
      backgroundColor: Color.fromARGB(255, 27, 20, 18),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(30, 0, 30, 0),
          child: Column(
            children: [
              Expanded(
                child: FutureBuilder<List<dynamic>>(
                  future: Future.wait([
                    _statsRepository.getHighestWeightRecords(),
                    _translationsFuture,
                  ]),
                  builder: (context, AsyncSnapshot<List<dynamic>> snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return CircularProgressIndicator();
                    } else if (snapshot.hasError) {
                      return Text('Error: ${snapshot.error}');
                    } else if (snapshot.hasData) {
                      final exercises = snapshot.data![0] as Map<String, Exercise>;
                      final translations = snapshot.data![1] as Map<String, Map<String, String>>;
                      final translationRepository = TranslationRepository(translations);

                      return ListView.builder(
                        itemCount: exercises.length,
                        itemBuilder: (context, index) {
                          final exercise = exercises.values.elementAt(index);
                          final translatedName = translationRepository.translateExerciseName(exercise.name, languageCode);

                          return Row(
                            children: [
                              Image.asset('assets/images/icons/${exercise.exerciseIcon}', width: 30, height: 30),
                              SizedBox(width: 8),
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(exercise.name, style: TextStyle(color: Colors.white, fontFamily: 'Geologica', fontSize: 15, fontWeight: FontWeight.w900)),
                                      // Mostrar nombre traducido
                                      Text(translatedName, style: TextStyle(color: Colors.grey[200], fontFamily: 'Geologica', fontSize: 12, fontWeight: FontWeight.w600)),
                                    ],
                                  ),
                                ),
                              ),
                              // Sección para los récords de peso
                              Text(
                                '${exercise.recordSetWeightLowReps} ${exercise.unit}',
                                style: TextStyle(color: Colors.white, fontFamily: 'Geologica', fontSize: 19, fontWeight: FontWeight.w900),
                              ),
                              SizedBox(width: 4),
                              Text('PR', style: TextStyle(color: Colors.white, fontFamily: 'Geologica', fontSize: 10, fontWeight: FontWeight.w600)),
                            ],
                          );
                        },
                      );
                    } else {
                      return Text("No data available");
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class TranslationRepository {
  final Map<String, Map<String, String>> _translations;

  TranslationRepository(this._translations);

  String translateExerciseName(String exerciseName, String languageCode) {
    return _translations[exerciseName]?[languageCode] ?? exerciseName;
  }
}
