import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';

class HomeScreen extends ConsumerStatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  final String userId = FirebaseAuth.instance.currentUser?.uid ?? '';
  final User? user = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Container(
        width: double.infinity,
        height: double.infinity,
        color: Colors.black, // Fondo negro
        child: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              children: [
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10.0, vertical: 0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Image.asset(
                        'assets/images/logo.png',
                        height: 50,
                      ),
                      Row(
                        children: [
                          Text(
                            'Good day, ${user?.displayName ?? 'User'}!',
                            style: GoogleFonts.manjari(
                              fontSize: 10,
                              color: Colors.grey.shade300,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          SizedBox(width: 10),
                          Padding(
                            padding: const EdgeInsets.only(right: 5),
                            child: Row(
                              children: [
                                Text(
                                  '0',
                                  style: GoogleFonts.manjari(
                                    fontSize: 15,
                                    color: Colors.white,
                                    fontWeight: FontWeight.w900,
                                  ),
                                ),
                                SizedBox(width: 5),
                                Icon(
                                  FontAwesomeIcons.fire,
                                  color: Colors.redAccent.shade200,
                                  size: 18,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Divider(
                  color: Colors.grey.shade800,
                  thickness: 1,
                ),
                SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Icon(
                            FontAwesomeIcons.arrowTurnUp,
                            color: Colors.greenAccent.shade200,
                            size: 20,
                          ),
                          SizedBox(width: 10),
                          Text(
                            '60 KG',
                            style: GoogleFonts.manjari(
                              fontSize: 25,
                              color: Colors.white,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                        ],
                      ),
                      Icon(
                        FontAwesomeIcons.plus,
                        color: Colors.white,
                        size: 25,
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 5),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Text(
                            '+ 0.00 KG (+0.00%)',
                            style: GoogleFonts.manjari(
                              fontSize: 20,
                              color: Colors.grey.shade700,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ],
                      ),
                      // Icon(
                      //   FontAwesomeIcons.plus,
                      //   color: Colors.white,
                      //   size: 20,
                      // ),
                    ],
                  ),
                ),
                SizedBox(height: 150),
                SizedBox(
                  height: 80,
                  width:
                      200, // Ancho definido para que el Stack tenga un tamaño finito
                  child: Center(
                    child: Stack(
                      children: [
                        Positioned(
                          left: 0,
                          child: Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: CircleAvatar(
                              radius: 33,
                              backgroundColor:
                                  Colors.grey.shade700, // Borde gris
                              child: CircleAvatar(
                                radius:
                                    31, // Tamaño interno para crear el borde
                                backgroundImage: AssetImage(
                                    'assets/images/icons/biceps1.png'),
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                          left: 40, // Controla cuánto se solapan
                          child: Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: CircleAvatar(
                              radius: 33,
                              backgroundColor:
                                  Colors.grey.shade700, // Borde gris
                              child: CircleAvatar(
                                radius: 31,
                                backgroundImage: AssetImage(
                                    'assets/images/icons/triceps1.png'),
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                          left: 80,
                          child: Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: CircleAvatar(
                              radius: 33,
                              backgroundColor:
                                  Colors.grey.shade700, // Borde gris
                              child: CircleAvatar(
                                radius: 31,
                                backgroundImage: AssetImage(
                                    'assets/images/icons/pecho1.png'),
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                          left: 120,
                          child: Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: CircleAvatar(
                              radius: 33,
                              backgroundColor:
                                  Colors.grey.shade700, // Borde gris
                              child: CircleAvatar(
                                radius: 31,
                                backgroundImage: AssetImage(
                                    'assets/images/icons/hombros1.png'),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: 30,
                ),
                Text(
                  'Select a muscle group to start!',
                  style: GoogleFonts.manjari(
                    fontSize: 20,
                    color: Colors.grey.shade300,
                    fontWeight: FontWeight.w800,
                  ),
                
                ),
                Text(
                  'No exercises added yet',
                  style: GoogleFonts.manjari(
                    fontSize: 20,
                    color: Colors.grey.shade800,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                SizedBox(
                  height: 30,
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    width: double.infinity,
                    height: 150,
                    decoration: BoxDecoration(
                      color: Colors.deepPurple.shade400.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: 
                    Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Container(
                                width: 200,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                        'Add your first exercise',
                                        style: GoogleFonts.manjari(
                                          fontSize: 25,
                                          color: Colors.white,
                                          fontWeight: FontWeight.w800,
                                        ),
                                        ),
                                    ),
                                    Container(
                                      decoration: BoxDecoration(
                                        color: Colors.grey.shade400.withOpacity(0.2),
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text(
                                          'Add your first exercise',
                                          style: GoogleFonts.manjari(
                                            fontSize: 15,
                                            color: Colors.white,
                                            fontWeight: FontWeight.w800,
                                          ),
                                        )
                                      )
                                    )
                                  ],
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(15.0),
                              child: Container(
                                width: 30,
                                height: 30,
                                decoration: BoxDecoration(
                                  color: Colors.deepPurple.shade400.withOpacity(0.5),
                                  borderRadius: BorderRadius.circular(50),
                                ),
                                child: Icon(
                                  FontAwesomeIcons.chevronRight,
                                  color: Colors.white,
                                  size: 15,
                                ),
                              ),
                            )
                          ],
                        )
                      ],
                    )
                  ),
                ),
                SizedBox(width: 10,),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              Expanded(
                child: Padding(
          padding: const EdgeInsets.only(right: 8.0), // Espacio a la derecha del primer container
          child: Container(
            height: 150, // Puedes ajustar la altura
            decoration: BoxDecoration(
              color: Colors.grey.shade700.withOpacity(0.3), // Color de fondo
              borderRadius: BorderRadius.circular(30), // Bordes redondeados
            ),
          ),
                ),
              ),
              Expanded(
                child: Padding(
          padding: const EdgeInsets.only(left: 8.0), // Espacio a la izquierda del segundo container
          child: Container(
            height: 150, // Ajusta la altura
            decoration: BoxDecoration(
              color: Colors.grey.shade700.withOpacity(0.3), // Color de fondo
              borderRadius: BorderRadius.circular(30), // Bordes redondeados
            ),
          ),
                ),
              ),
            ],
          ),
        ),
       
              
              ],
            ),
          ),
        ),
      ),
    );
  }
}
