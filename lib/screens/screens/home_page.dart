import 'package:flutter/material.dart';
import 'dart:ui'; // Para el BackdropFilter

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  void _showAddWorkoutBottomSheet(BuildContext context) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    isDismissible: true, // Permite cerrar el modal al tocar fuera de él
    backgroundColor: Colors.transparent,
    builder: (BuildContext context) {
      return DraggableScrollableSheet(
        initialChildSize: 0.6, // Ajusta la altura inicial del contenedor
        maxChildSize: 0.6, // Ajusta la altura máxima que el contenedor puede expandirse
        minChildSize: 0.6, // Ajusta la altura mínima a la que el contenedor puede contraerse
        expand: false, // Evita que el fondo oscurecido se expanda a pantalla completa
        builder: (_, controller) {
          return Container(
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.75),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(12.0),
                topRight: Radius.circular(12.0),
              ),
            ),
            child: ListView(
              controller: controller,
              children: [
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min, // Asegura que el contenido determine el tamaño del contenedor
                    children: <Widget>[
                      Text(
                        "Entrenamiento de hoy",
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: () {
                          // Aquí se añadiría la lógica para añadir el entrenamiento
                          Navigator.of(context).pop(); // Cierra el bottom sheet
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.black, // Color de fondo
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20), // Bordes redondeados
                          ),
                        ),
                        child: Text(
                          "Añadir",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      );
    },
  );
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[900],
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(30.0, 0, 30.0, 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Image.asset('assets/images/logo.png', width: 50, height: 50),
                  IconButton(
                    icon: Icon(Icons.add, color: Colors.white),
                    onPressed: () => _showAddWorkoutBottomSheet(context),
                  ),
                ],
              ),
            ),
            // Aquí va el resto de tu UI
          ],
        ),
      ),
    );
  }
}
