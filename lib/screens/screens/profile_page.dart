import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    User? user = FirebaseAuth.instance.currentUser;
    String displayName = user?.displayName ??
        'Jimmy'; // Si no hay nombre, muestra un placeholder

    return Scaffold(
      backgroundColor: Color.fromARGB(255, 27, 20, 18),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(30, 0, 30, 0),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 0.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Profile', // Título de la pantalla
                      style: TextStyle(
                        fontFamily: 'Geologica',
                        color: Colors.teal.shade100,
                        fontWeight: FontWeight.w700,
                        fontSize: 24, // Tamaño del texto
                      ),
                    ),
                  ),
                ),
                    
                      Row(
                        children: [
                          IconButton(
                              icon: Icon(Icons.settings, color: Colors.white),
                              onPressed: ()  {}),
                      IconButton(
                        icon: Icon(Icons.exit_to_app, color: Colors.white),
                        onPressed: () async {
                          await FirebaseAuth.instance.signOut();
                          context.go('/login'); // Usando GoRouter para navegar.
                        },
                      ),
                        ],
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 15),
                Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Column(
                    children: [
                      CircleAvatar(
                        radius: 50, // Radio del avatar
                        backgroundColor:
                            Colors.grey[200], // Color de fondo del avatar
                        child: Text(
                          displayName[0], // Mostrar la inicial del nombre
                          style: TextStyle(fontSize: 40),
                        ),
                      ),
                      SizedBox(height: 15),
                      Text(displayName, // Mostrar el nombre completo
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontFamily: 'Geologica',
                              fontWeight: FontWeight.w700)),
                    ],
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Padding(
                  padding: EdgeInsets.all(10.0),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Achievements ⭐',
                      style: TextStyle(
                        fontFamily: 'Geologica',
                        color: Colors.teal.shade100,
                        fontWeight: FontWeight.w800,
                        fontSize: 18,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 10),
                GridView.count(
                  shrinkWrap: true,
                  physics:
                      NeverScrollableScrollPhysics(), // Para evitar el scrolling dentro del GridView
                  crossAxisCount: 2,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                  children: List.generate(6, (index) {
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        height: 100,
                        decoration: BoxDecoration(
                          color: Colors.grey[700],
                          borderRadius: BorderRadius.circular(35),
                        ),
                        child: Center(),
                      ),
                    );
                  }),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
