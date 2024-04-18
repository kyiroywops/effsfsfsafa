import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gymtrack/infrastructure/models/exercises_models.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gymtrack/screens/screens/translations_loader.dart';
import 'package:gymtrack/screens/widgets/stats_ejemplo2.dart';
import 'package:gymtrack/screens/widgets/stats_repository.dart';
import 'package:firebase_auth/firebase_auth.dart'; // Importa FirebaseAuth si no está ya importado


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
     String userId = FirebaseAuth.instance.currentUser?.uid ?? ''; // Obtiene el ID del usuario actual


    return Scaffold(
      backgroundColor: Color.fromARGB(255, 27, 20, 18),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(30, 0, 30, 0),
            child: Column(
              children: [
            
                 Padding(
                  padding: EdgeInsets.all(10.0),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Records', // Título de la pantalla
                      style: TextStyle(
                        fontFamily: 'Geologica',
                        color: Colors.teal.shade100,
                        fontWeight: FontWeight.w700,
                        fontSize: 24, // Tamaño del texto
                      ),
                    ),
                  ),
                ),
           SizedBox(height: 10,),

           Container(
                              height: 200, // Asigna un tamaño adecuado para el gráfico

            child: LineChart1(isShowingMainData: true,)),

         SizedBox(height: 30),
            
                  Expanded(
                    child: FutureBuilder<List<dynamic>>(
                      future: Future.wait([
                        _statsRepository.getHighestWeightRecords(userId),
                        _translationsFuture,
                      ]),
                      builder: (context, AsyncSnapshot<List<dynamic>> snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return Center(
                            child: Container(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                
                              ),
                            ),
                          );
                        } else if (snapshot.hasError) {
                          return Text('Error: ${snapshot.error}');
                        } else if (snapshot.hasData) {
                          final exercises =
                              snapshot.data![0] as Map<String, Exercise>;
                          final translations =
                              snapshot.data![1] as Map<String, Map<String, String>>;
                          final translationRepository =
                              TranslationRepository(translations);
                                
                          return ListView.builder(
                            itemCount: exercises.length,
                            itemBuilder: (context, index) {
                              final exercise = exercises.values.elementAt(index);
                              final translatedName =
                                  translationRepository.translateExerciseName(
                                      exercise.name, languageCode);
                                
                              return Padding(
                                padding: const EdgeInsets.all(5.0),
                                child: Container(
                                   decoration: BoxDecoration(
                                    color: Colors.grey[900],
                                    borderRadius: BorderRadius.circular(20.0), // Si quieres bordes redondeados
                                    // Puedes añadir más propiedades a la decoración como gradientes, sombras, etc.
                                  ),
                                  
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Row(
                                      children: [
                                        SizedBox(width: 8),
                                        Expanded(
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(exercise.name,
                                                    style: TextStyle(
                                                        color: Colors.grey[200],
                                                        fontFamily: 'Geologica',
                                                        fontSize: 15,
                                                        fontWeight: FontWeight.w900)),
                                                // Mostrar nombre traducido
                                                Text(translatedName,
                                                    style: TextStyle(
                                                        color: Colors.grey[200],
                                                        fontFamily: 'Geologica',
                                                        fontSize: 11,
                                                        fontWeight: FontWeight.w500)),
                                                          SizedBox(height: 5),
                                                Row(
                                                  children: [
                                                    Text(exercise.gymItem.name,  style: TextStyle(
                                                            color: Colors.grey[200],
                                                            fontFamily: 'Geologica',
                                                            fontSize: 12,
                                                            fontWeight: FontWeight.w900)),
                                                SizedBox(width: 10),
                                
                                                 CircleAvatar(
                                                  radius: 10,
                                                  backgroundColor: Colors.white,
                                                   // Color de fondo del avatar
                                                  child: Image.asset(
                                                    exercise.gymItem.iconPath,
                                                    width: 30,
                                                    height: 30,
                                                  ),
                                                ),
                                                SizedBox(width: 10),
                                        Image.asset(
                                            'assets/images/icons/${exercise.exerciseIcon}',
                                            width: 20,
                                            height: 20),
                                
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                        // Sección para los récords de peso
                                        Row(
                                          children: [
                                            Column(
                                              children: [
                                            Text(
                                              '${exercise.recordSetWeightLowReps} ${exercise.unit}',
                                              style: TextStyle(
                                                  color: Colors.greenAccent.shade100,
                                                  fontFamily: 'Geologica',
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.w900),
                                            ),
                                                   Text('PR',
                                                      style: TextStyle(
                                                          color: Colors.grey[200],
                                                          fontFamily: 'Geologica',
                                                          fontSize: 12,
                                                          fontWeight: FontWeight.w800)),
                                            
                                                Text('Low Reps',
                                                      style: TextStyle(
                                                          color: Colors.grey[200],
                                                          fontFamily: 'Geologica',
                                                          fontSize: 10,
                                                          fontWeight: FontWeight.w600)),
                                              ],
                                            ),
                                            SizedBox(width: 20,),
                                    
                                              Column(
                                              children: [
                                            Text(
                                               '${exercise.recordSetWeight} ${exercise.unit}',
                                              style: TextStyle(
                                                  color: Colors.greenAccent.shade100,
                                                  fontFamily: 'Geologica',
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.w900),
                                            ),
                                                   Text('PR',
                                                      style: TextStyle(
                                                          color: Colors.grey[200],
                                                          fontFamily: 'Geologica',
                                                          fontSize: 12,
                                                          fontWeight: FontWeight.w800)),
                                            
                                                Text('+6 Reps',
                                                      style: TextStyle(
                                                          color: Colors.grey[200],
                                                          fontFamily: 'Geologica',
                                                          fontSize: 10,
                                                          fontWeight: FontWeight.w600)),
                                              ],
                                            ),
                                    
                                            // otra wea
                                            
                                          ],
                                        ),
                                        
                                                  ],
                                    ),
                                  ),
                                ),
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