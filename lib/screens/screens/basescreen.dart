import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gymtrack/screens/screens/calendar_page.dart';
import 'package:gymtrack/screens/screens/home_page.dart';
import 'package:gymtrack/screens/screens/settings_screen.dart';
import 'package:gymtrack/screens/widgets/showbottomsheetwave.dart';

class BaseScreen extends StatefulWidget {
  @override
  _BaseScreenState createState() => _BaseScreenState();
}

class _BaseScreenState extends State<BaseScreen> {
  int _selectedIndex = 0;
  final User? user = FirebaseAuth.instance.currentUser;
  static List<Widget> _widgetOptions = <Widget>[
    HomeScreen(), // Historial
    Ejercicios(),
    Text('Calendario', textAlign: TextAlign.center), // Calendario
    Text('Calendario', textAlign: TextAlign.center), // Calend
    SettingsScreen(), // Perfil
  ];

 
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
            _buildNavItem('assets/svg/home.svg', 'Home', 0),
            _buildNavItem('assets/svg/biceps.svg', 'Exercises', 1),
            _buildUploadNavItem(), // Botón central con ícono relleno siempre visible
            _buildNavItem('assets/svg/message.svg', 'Message', 3),
            _buildNavItem(
              null, // No icono, solo la foto del usuario
              'Profile',
              4,
              user?.photoURL, // Pasar la URL de la foto de perfil
            ),
          ],
        ),
      ),
    );
  }

  // Método para construir elementos de navegación con SVG
  Widget _buildNavItem(String? svgAsset, String label, int index, [String? photoURL]) {
    return InkWell(
      onTap: () => setState(() => _selectedIndex = index),
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      child: Container(
        width: 60, // Ancho para cada botón de icono
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            if (photoURL != null) // Si se pasa la URL de la foto de perfil, mostrar la foto
              CircleAvatar(
                radius: 12, // Radio del avatar
                backgroundImage: NetworkImage(photoURL),
              )
           else if (svgAsset != null) // Si no hay foto, mostrar el icono
            SvgPicture.asset(
              svgAsset,
              height: 24,
              color: _selectedIndex == index ? Colors.teal.shade100 : Colors.grey,
            ),
            Text(
              label,
              style: TextStyle(
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

  // Método para el ícono del perfil (mantienes el ícono predeterminado)
  Widget _buildNavItemWithIcon(IconData icon, String label, int index) {
    return InkWell(
      onTap: () => setState(() => _selectedIndex = index),
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      child: Container(
        width: 60, // Ancho para cada botón de icono
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Icon(icon, size: 24, color: _selectedIndex == index ? Colors.teal.shade100 : Colors.grey),
            Text(label, style: TextStyle(
              color: _selectedIndex == index ? Colors.white : Colors.grey,
              fontSize: _selectedIndex == index ? 10 : 8,
              fontWeight: _selectedIndex == index ? FontWeight.w700 : FontWeight.w400,
              fontFamily: 'Geologica',
            )),
          ],
        ),
      ),
    );
  }

  // Método para el botón de subir entrenamientos con SVG
Widget _buildUploadNavItem() {
  return InkWell(
    onTap: () {
      showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return BottomSheetWave(
            title: 'Timmy',
            subtitle: 'Tell me what you want to train today',
          );
        },
      );
    },
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      child: Container(
        width: 60,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Container(
              padding: EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: Colors.grey.shade300.withOpacity(0.8), // Fondo blanco para el botón de acción
                shape: BoxShape.circle,
              ),
              child: SvgPicture.asset(
                'assets/svg/wave.svg', // Cambiado a imagen SVG
                height: 24,
              ),
            ),
            Text('Training', style: TextStyle(color: Colors.white, fontSize: 10)), // Texto siempre visible
          ],
        ),
      ),
    );
  }
}
