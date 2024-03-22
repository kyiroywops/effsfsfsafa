import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';


class Exercise {
  final String name;
  final String icon;
  final String gymItemName;

  Exercise({required this.name, required this.icon, required this.gymItemName});

  factory Exercise.fromFirestore(Map<String, dynamic> data) {
    return Exercise(
      name: data['exerciseName'],
      icon: data['gymItemIconPath'], // Asumiendo que quieres usar el ícono del Gym Item aquí
      gymItemName: data['gymItemName'],
    );
  }
}

Future<List<DailyWorkout>> getExercisesGroupedByDate() async {
  final user = FirebaseAuth.instance.currentUser;
  if (user == null) throw Exception('User not logged in');

  QuerySnapshot querySnapshot = await FirebaseFirestore.instance
      .collection('exercises')
      .where('userId', isEqualTo: user.uid)
      .orderBy('timestamp', descending: true)
      .get();

  Map<DateTime, List<Exercise>> exercisesByDate = {};
  for (var doc in querySnapshot.docs) {
    var data = doc.data() as Map<String, dynamic>;
    Exercise exercise = Exercise(
      name: data['exerciseName'],
      icon: data['exerciseIcon'],
      gymItemName: data['gymItemName'],
    );

    Timestamp timestamp = data['timestamp'];
    DateTime date = DateTime(
      timestamp.toDate().year,
      timestamp.toDate().month,
      timestamp.toDate().day,
    );

    if (!exercisesByDate.containsKey(date)) {
      exercisesByDate[date] = [];
    }
    exercisesByDate[date]!.add(exercise);
  }

  return exercisesByDate.entries
      .map((entry) => DailyWorkout(date: entry.key, exercises: entry.value))
      .toList();
}

class DailyWorkout {
  final DateTime date;
  final List<Exercise> exercises;

  DailyWorkout({required this.date, required this.exercises});
}
class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[900],
      body: SafeArea(
        child: Column(
          children: [
            // ... Resto del código ...

            // Se reemplaza el Expanded con FutureBuilder
            Expanded(
              child: FutureBuilder<List<DailyWorkout>>(
                future: getExercisesGroupedByDate(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return Center(child: Text('No exercises found'));
                  }

                  // Datos están disponibles y no son vacíos
                  List<DailyWorkout> dailyWorkouts = snapshot.data!;

                  // Se construye una lista de Widgets basada en los DailyWorkout
                  List<Widget> workoutWidgets = dailyWorkouts.map((dailyWorkout) {
                    // Formatear la fecha como "Lunes 18"
                    String formattedDate = DateFormat('EEEE d').format(dailyWorkout.date).capitalize();
                    // Crea un Widget para el encabezado de la fecha
                    List<Widget> exerciseWidgets = [
                      Padding(
                        padding: const EdgeInsets.all(25.0),
                        child: Text(formattedDate, style: TextStyle(color: Colors.white, fontSize: 12, fontFamily: 'Geologica', fontWeight: FontWeight.w700)),
                      ),
                    ];
                    // Crea un listado de Widgets para los ejercicios del día
                    exerciseWidgets.addAll(dailyWorkout.exercises.map((exercise) {
                      return buildExerciseCard(exercise, exercise.gymItemName); // Asume que tienes una propiedad gymItemName en Exercise
                    }).toList());


                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: exerciseWidgets,
                    );
                  }).toList();

                  return SingleChildScrollView(
                    child: Column(
                      children: workoutWidgets,
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

extension StringExtension on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${this.substring(1)}";
  }
}


Widget buildExerciseCard(Exercise exercise, String gymItemName) {
  return Container(
    margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
    padding: const EdgeInsets.all(10),
    decoration: BoxDecoration(
      color: Colors.black,
      borderRadius: BorderRadius.circular(15),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Image.asset(
              'assets/images/icons/${exercise.icon}', // Ruta al ícono del ejercicio
              width: 30,
              height: 30,
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    exercise.name, // Nombre del ejercicio
                    style: const TextStyle(color: Colors.white, fontSize: 14, fontFamily: 'Geologica', fontWeight: FontWeight.w700),
                  ),
                  Text(
                    gymItemName, // Nombre del GymItem asociado
                    style: const TextStyle(color: Colors.grey, fontSize: 14, fontFamily: 'Geologica', fontWeight: FontWeight.w700),
                  ),
                ],
              ),
            ),
            // Agrega aquí más Widgets si necesitas más información en la fila
          ],
        ),
        // Aquí puedes agregar más información sobre el ejercicio si lo necesitas
      ],
    ),
  );
}