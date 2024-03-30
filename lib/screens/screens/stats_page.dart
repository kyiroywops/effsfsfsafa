import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';

class StatsScreen extends StatelessWidget {
  const StatsScreen({Key? key}) : super(key: key);

    bool hasWorkout(DateTime date) {
    // Aquí debes implementar tu lógica para saber si hay un entrenamiento
    // Por ejemplo, puedes comprobar si en tu base de datos hay un registro para `date`.
    // La siguiente línea es solo un marcador de posición y siempre devuelve falso.
    // Deberás reemplazarlo con tu lógica real de comprobación.
    return false;
  }


  @override
  Widget build(BuildContext context) {
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
                    'My stats', // Título de la pantalla
                    style: TextStyle(
                      fontFamily: 'Geologica',
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                      fontSize: 24, // Tamaño del texto
                    ),
                  ),
                ),
              ),
          
              
                
           
            ],
          ),
        
        ),
      ),

    );
  }
}
