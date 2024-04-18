import 'package:flutter/material.dart';
import 'package:gymtrack/screens/screens/calendar_page.dart';
import 'package:gymtrack/screens/screens/home_page.dart';
import 'package:gymtrack/screens/screens/profile_page.dart';
import 'package:gymtrack/screens/screens/stats_page.dart';
import 'package:gymtrack/screens/widgets/showaddworkout_widget.dart';

class BaseScreen extends StatefulWidget {
  @override
  _BaseScreenState createState() => _BaseScreenState();
}

class _BaseScreenState extends State<BaseScreen> {
  int _selectedIndex = 0;
  static List<Widget> _widgetOptions = <Widget>[
    HomeScreen(), // Historial
    CalendarScreen(),
    Text('Calendario', textAlign: TextAlign.center), // Calendario
    StatsScreen(),
    ProfileScreen(), // Perfil
  ];

   void _onItemTapped(int index) {
    if (index == 2) { // Si el índice corresponde al botón "+"
      showAddWorkoutBottomSheet(context);
    } else {
      setState(() {
        _selectedIndex = index;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomAppBar(
        color: Color.fromARGB(255, 13, 11, 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            _buildNavItem(Icons.history_rounded, 'Historial', 0),
            _buildNavItem(Icons.calendar_month_rounded, 'Calendar', 1),
            _buildUploadNavItem(), // Botón central con ícono relleno siempre visible
            _buildNavItem(Icons.query_stats_rounded, 'Stats', 3),
            _buildNavItem(Icons.person, 'Profile', 4),
          ],
        ),
      ),
    );
  }

  Widget _buildNavItem(IconData icon, String label, int index) {
    return InkWell(
      onTap: () => setState(() => _selectedIndex = index),
      splashColor: Colors.transparent, // Removes ripple effect
      highlightColor: Colors.transparent, // Removes highlight effect
      child: Container(
        width: 60, // Ancho para cada botón de icono
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Icon(icon, size: 24, color: _selectedIndex == index ? Colors.teal.shade100 : Colors.grey),
            Text(label, style: TextStyle(
              color: _selectedIndex == index ? Colors.white : Colors.grey,
              fontSize: _selectedIndex == index ? 11 : 9,
              fontWeight: _selectedIndex == index ? FontWeight.w800 : FontWeight.w600,
              fontFamily: 'Geologica',

              
              ),
              
              
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildUploadNavItem() {
  return InkWell(
    onTap: () {
      // Aquí llamas a tu función para mostrar el BottomSheet
      try {
  showAddWorkoutBottomSheet(context);
} catch (e, stack) {
  print('Error al mostrar AddWorkoutBottomSheet: $e');
  print(stack);
}

    },
    splashColor: Colors.transparent, // Esto quita el efecto de onda al tocar
    highlightColor: Colors.transparent, // Esto quita el efecto de realce al tocar
    child: Container(
      width: 60, // Ajustar el ancho si es necesario para el elemento del medio
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Container(
            padding: EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: Colors.white, // Fondo blanco para el botón de acción
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.add, size: 24, color: Colors.black), // Ícono negro siempre visible
          ),
          Text('Training', style: TextStyle(color: Colors.white, fontSize: 10)), // Texto siempre visible
        ],
      ),
    ),
  );
}

}
