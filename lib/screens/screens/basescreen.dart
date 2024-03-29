import 'package:flutter/material.dart';
import 'package:gymtrack/screens/screens/home_page.dart';
import 'package:gymtrack/screens/screens/profile_page.dart';
import 'package:gymtrack/screens/widgets/showaddworkout_widget.dart';

class BaseScreen extends StatefulWidget {
  @override
  _BaseScreenState createState() => _BaseScreenState();
}

class _BaseScreenState extends State<BaseScreen> {
  int _selectedIndex = 0;
  static const List<Widget> _widgetOptions = <Widget>[
    HomeScreen(), // Historial
    Text('Historial', textAlign: TextAlign.center), // Historial
    Text('Calendario', textAlign: TextAlign.center), // Calendario
    Text('Estadísticas', textAlign: TextAlign.center), // Estadísticas
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
        color: Colors.black,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            _buildNavItem(Icons.book, 'Historial', 0),
            _buildNavItem(Icons.calendar_today, 'Calendario', 1),
            _buildUploadNavItem(), // Botón central con ícono relleno siempre visible
            _buildNavItem(Icons.bar_chart, 'Estadísticas', 3),
            _buildNavItem(Icons.person, 'Perfil', 4),
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
            Icon(icon, size: 24, color: _selectedIndex == index ? Colors.white : Colors.grey),
            Text(label, style: TextStyle(color: _selectedIndex == index ? Colors.white : Colors.grey, fontSize: 10)),
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
          Text('Subir', style: TextStyle(color: Colors.white, fontSize: 10)), // Texto siempre visible
        ],
      ),
    ),
  );
}

}
