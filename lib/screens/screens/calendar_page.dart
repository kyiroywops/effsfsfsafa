import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';

class CalendarScreen extends StatelessWidget {
  const CalendarScreen({Key? key}) : super(key: key);

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
              Expanded(
                child: GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 7, // One week
                    childAspectRatio: 1, // Square boxes
                    crossAxisSpacing: 4,
                    mainAxisSpacing: 4,
                  ),
                  itemCount: daysInMonth,
                  itemBuilder: (context, index) {
                    DateTime day = startOfMonth.add(Duration(days: index));

                    return Container(
                      margin: const EdgeInsets.all(2),
                      decoration: BoxDecoration(
                        color: hasWorkout(day) ? Colors.green : Colors.grey[300],
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Center(
                        child: Text(
                          DateFormat('d').format(day),
                          style: TextStyle(
                            color: hasWorkout(day) ? Colors.white : Colors.black,
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
