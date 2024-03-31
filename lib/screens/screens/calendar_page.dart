import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CalendarScreen extends StatefulWidget {
  const CalendarScreen({Key? key}) : super(key: key);

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> 
{ 
    late DateTime _visibleMonth;
    final FirebaseFirestore _firestore = FirebaseFirestore.instance;
     Map<DateTime, bool> _workoutDays = {};

 @override
void initState() {
  super.initState();
  _visibleMonth = DateTime.now();
  _loadWorkoutDaysForTwoMonths(_visibleMonth);
}

 void _loadWorkoutDaysForTwoMonths(DateTime visibleMonth) {
  DateTime previousMonth = DateTime(visibleMonth.year, visibleMonth.month - 1, 1);
  DateTime startOfPreviousMonth = DateTime(previousMonth.year, previousMonth.month, 1);
  DateTime endOfNextMonth = DateTime(visibleMonth.year, visibleMonth.month + 1, 0);

  FirebaseFirestore.instance
    .collection('exercises')
    .where('userId', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
    .where('timestamp', isGreaterThanOrEqualTo: startOfPreviousMonth)
    .where('timestamp', isLessThanOrEqualTo: endOfNextMonth)
    .get()
    .then((snapshot) {
      Map<DateTime, bool> workoutDays = {};
      for (var doc in snapshot.docs) {
        DateTime date = (doc['timestamp'] as Timestamp).toDate();
        date = DateTime(date.year, date.month, date.day); // Normalize the time
        workoutDays[date] = true;
      }
      print("Loaded workout days: $workoutDays");
      setState(() {
        _workoutDays = workoutDays;
      });
    });
}


  Future<Map<DateTime, bool>> _getWorkoutDaysForMonth(DateTime month) async {
    DateTime startOfMonth = DateTime(month.year, month.month, 1);
    DateTime endOfMonth = DateTime(month.year, month.month + 1, 0);

    var snapshots = await _firestore
        .collection('exercises')
        .where('timestamp', isGreaterThanOrEqualTo: startOfMonth, isLessThanOrEqualTo: endOfMonth)
        .get();

    Map<DateTime, bool> workoutDays = {};
    for (var doc in snapshots.docs) {
      DateTime date = (doc['timestamp'] as Timestamp).toDate();
      // Aquí asumimos que tus registros de entrenamiento tienen un campo timestamp
      workoutDays[date] = true;
    }

    return workoutDays;
  }


   List<DateTime> getMonthDates(DateTime month) {
    DateTime firstOfMonth = DateTime(month.year, month.month, 1);
    DateTime lastOfMonth = DateTime(month.year, month.month + 1, 0);
    List<DateTime> days = [];
    for (int i = 0; i < lastOfMonth.day; i++) {
      days.add(firstOfMonth.add(Duration(days: i)));
    }
    return days;
  }
   
 bool hasWorkout(DateTime date) {
    // Eliminar la hora para comparar solo la fecha
    date = DateTime(date.year, date.month, date.day);
    return _workoutDays[date] ?? false;
  }

  @override
  Widget build(BuildContext context) {
    DateTime previousMonth = DateTime(_visibleMonth.year, _visibleMonth.month - 1, 1);
  List<DateTime> previousMonthDates = getMonthDates(previousMonth);
  List<DateTime> currentMonthDates = getMonthDates(_visibleMonth);
   List<DateTime> combinedMonthDates = previousMonthDates + currentMonthDates;

    // Obtén el mes anterior y el mes actual
  DateTime currentMonth = _visibleMonth;

  // Formatea los nombres de los meses
  String previousMonthName = DateFormat('MMMM').format(previousMonth); // Solo mes para el mes anterior
  String currentMonthName = DateFormat('MMMM yyyy').format(currentMonth); // Mes y año para el mes actual

  // Combina los nombres de los meses para el título
  String title = "$previousMonthName - $currentMonthName";


  

    List<DateTime> nextWeekDates = List.generate(7, (index) {
      DateTime today = DateTime.now();
      return today.add(Duration(days: index));
    });
      DateTime now = DateTime.now();
       DateTime startOfMonth = DateTime(now.year, now.month, 1);
       int daysInMonth = DateTime(now.year, now.month + 1, 0).day;
    
    return Scaffold(

     backgroundColor: Color.fromARGB(255, 27, 20, 18),
    
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(30, 0, 30, 0),
          child: Column(
            children: [
               Padding(
                padding: const EdgeInsets.symmetric(horizontal: 0.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Image.asset(
                      'assets/images/logo.png', // Reemplaza con la ruta de tu logo.
                      height: 50, // Ajusta la altura según sea necesario.
                    ),
                   
                  ],
                ),
              ),
          
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Next week training', // Título de la pantalla
                    style: TextStyle(
                      fontFamily: 'Geologica',
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                      fontSize: 24, // Tamaño del texto
                    ),
                  ),
                ),
              ),
          
              
                
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 30.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: nextWeekDates.map((date) {
                      return Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            DateFormat('EEEE').format(date), // Nombre del día
                            style: TextStyle(
                              fontFamily: 'Geologica',
                              color: Colors.white,
                              fontWeight: FontWeight.w700,
                              fontSize: 10, // Tamaño más pequeño para el texto
                            ),
                          ),
                          Text(
                            DateFormat('MMM d').format(date), // Fecha 'Mes día'
                            style: TextStyle(
                              fontFamily: 'Geologica',
                              color: Colors.white,
                              fontWeight: FontWeight.w500,
                              fontSize: 10, // Tamaño más pequeño para el texto
                            ),
                          ),
                          SizedBox(height: 8),
                          Container(
                            width: 30, // Contenedor más pequeño para el cuadrado
                            height: 30, // Contenedor más pequeño para el cuadrado
                            decoration: BoxDecoration(
                              color: Colors.grey[300], // Ajusta el color según tu tema
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        ],
                      );
                    }).toList(),
                  ),
                ),
              
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Calendar', // Título de la pantalla
                    style: TextStyle(
                      fontFamily: 'Geologica',
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                      fontSize: 24, // Tamaño del texto
                    ),
                  ),
                ),
              ),
              SizedBox(height: 15),
              Row(
              children: [
              IconButton(
  icon: Icon(Icons.chevron_left, color: Colors.white),
  onPressed: () {
    setState(() {
      _visibleMonth = DateTime(_visibleMonth.year, _visibleMonth.month - 1, 1);
      _loadWorkoutDaysForTwoMonths(_visibleMonth);
    });
  },
),
                Expanded(
                  child: Center(
                    child: Text(
                      title,
                      style: TextStyle(
                        fontFamily: 'Geologica',
                        color: Colors.white,
                        fontWeight: FontWeight.w800,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
     IconButton(
  icon: Icon(Icons.chevron_right, color: Colors.white),
  onPressed: () {
    setState(() {
      _visibleMonth = DateTime(_visibleMonth.year, _visibleMonth.month + 1, 1);
      _loadWorkoutDaysForTwoMonths(_visibleMonth);
    });
  },
),
              ],
            ),
          Expanded(
  child: GridView.builder(
          itemCount: combinedMonthDates.length, // Usa la lista combinada para itemCount
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 9, // Cambia esto según tu diseño
            childAspectRatio: 1,
            crossAxisSpacing: 8,
            mainAxisSpacing: 8,
          ),
          itemBuilder: (context, index) {
            // Usa la lista combinada para obtener el día
            DateTime day = combinedMonthDates[index];
            
            // Normaliza la fecha para comparar solo la fecha
            day = DateTime(day.year, day.month, day.day);

            // Verifica si el día tiene un entrenamiento
            bool hasWorkoutFlag = _workoutDays[day] ?? false;

            // Establece el color de fondo basado en si hay un entrenamiento
            Color bgColor = hasWorkoutFlag ? Colors.green : (day.month == _visibleMonth.month ? Colors.grey[300]! : Colors.grey[200]!);
            Color textColor = hasWorkoutFlag ? Colors.white : (day.month == _visibleMonth.month ? Colors.black : Colors.grey);

          return Container(
            margin: EdgeInsets.all(2),
            decoration: BoxDecoration(
              color: bgColor,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Center(
              child: Text(
                DateFormat('d').format(day),
                style: TextStyle(
                  color: textColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          );
        
      
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
