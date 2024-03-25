import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gymtrack/infrastructure/models/exercises_models.dart';
import 'package:gymtrack/infrastructure/models/exercises_setmodels.dart';
import 'package:gymtrack/infrastructure/models/gym_item_model.dart';
import 'package:intl/intl.dart';


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
     print('Datos del ejercicio: $data');
    List<ExerciseSet> sets = (data['sets'] as List).map((set) => ExerciseSet.fromJson(set)).toList();
    GymItem gymItem = GymItem.fromJson(data['gymItem']); // Asegúrate de tener esta estructura en tus datos
    
    Exercise exercise = Exercise(
      name: data['exerciseName'],
      exerciseIcon: data['exerciseIcon'],
      gymItem: gymItem,
      sets: sets,
      timestamp: (data['timestamp'] as Timestamp).toDate(), // Convierte Timestamp a DateTime

    );

    // Extrae solo la fecha del timestamp del ejercicio para la agrupación
      DateTime date = DateTime(
        exercise.timestamp!.year,
        exercise.timestamp!.month,
        exercise.timestamp!.day,
      );

    // Agrupa los ejercicios por la fecha normalizada
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

                      print('Daily workouts: $dailyWorkouts'); // Agregar esta línea para depurar


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
                      return buildExerciseCard(exercise, exercise.gymItem); // Asume que tienes una propiedad gymItemName en Exercise
                    }).toList());




                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: exerciseWidgets,
                    );
                  }).toList();

    print('Workout widgets: $workoutWidgets'); // Agregar esta línea para depurar

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


Widget buildExerciseCard(Exercise exercise, GymItem gymItem) {
  try {
      print('Construyendo tarjeta para: ${exercise.name}'); // Imprimir para verificar que se entre aquí

    // Aquí devolvemos el Container directamente.
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
                'assets/images/icons/${exercise.exerciseIcon}', // Ruta al ícono del ejercicio
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
                      gymItem.name, // Nombre del GymItem asociado
                      style: const TextStyle(color: Colors.grey, fontSize: 14, fontFamily: 'Geologica', fontWeight: FontWeight.w700),
                    ),
                  ],
                ),
              ),
              // Puedes añadir más widgets aquí si necesitas mostrar más información en la tarjeta
            ],
          ),
          // Aquí puedes añadir más información sobre el ejercicio si es necesario
        ],
      ),
    );
  } catch (e) {
    print('Error al construir la tarjeta de ejercicio: $e');
    return SizedBox(); // Devuelve un widget vacío si hay un error
  }
}