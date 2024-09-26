import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
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
                        height: 55,
                      ),
                          Text(
                            'Good day, ${user?.displayName ?? 'User'}!',
                            style: GoogleFonts.manjari(
                              fontSize: 10,
                              color: Colors.grey.shade300,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                      Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(right: 5),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
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
                  color: Colors.grey.shade800.withOpacity(0.5),
                  endIndent: 20,
                  indent: 20,
                  thickness: 1,
                ),
                SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
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
                            '0 KG',
                            style: GoogleFonts.manjari(
                              fontSize: 35,
                              color: Colors.white,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                        ],
                      ),
                                          Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        GestureDetector(
                          onTap: () {
                            HapticFeedback.lightImpact();
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                vertical: 5.0, horizontal: 10.0),
                            decoration: BoxDecoration(
                              color: Colors.grey.shade100.withOpacity(0.9),
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: Row(
                              children: [
                                SvgPicture.asset(
                                  'assets/svg/timeline.svg',
                                    width: 15,
                                ),
                                SizedBox(width: 5),
                                Text(
                                  'Timeline',
                                  style: GoogleFonts.outfit(
                                    fontSize: 10,
                                    color: Colors.grey.shade900,
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(width: 10),

                        GestureDetector(
                          onTap: () {
                            HapticFeedback.lightImpact();
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                vertical: 5.0, horizontal: 10.0),
                            decoration: BoxDecoration(
                              color: Colors.grey.shade100.withOpacity(0.9),
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: Row(
                              children: [
                                SvgPicture.asset(
                                  'assets/svg/dumbell.svg',
                                  width: 15,
                                ),
                                SizedBox(width: 5),
                                Text(
                                  'Quick Exercises',
                                  style: GoogleFonts.outfit(
                                    fontSize: 10,
                                    color: Colors.grey.shade900,
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        // Botón de "Add more"

                      ],
                    ),
                    ],
                  ),
                ),
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
                                  Colors.grey.shade900.withOpacity(0.9), // Borde gris
                              child: CircleAvatar(
                                radius:
                                    30, // Tamaño interno para crear el borde
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
                                  Colors.grey.shade900.withOpacity(0.9), // Borde gris
                              child: CircleAvatar(
                                radius: 30,
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
                                  Colors.grey.shade900.withOpacity(0.9), // Borde gris
                              child: CircleAvatar(
                                radius: 30,
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
                                  Colors.grey.shade800, // Borde gris
                              child: CircleAvatar(
                                radius: 30,
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
                    fontSize: 19,
                    color: Colors.grey.shade100,
                    fontWeight: FontWeight.w700,
                  ),
                
                ),
                SizedBox(height: 10,),
                Text(
                  'No exercises added yet',
                  style: GoogleFonts.manjari(
                    fontSize: 18,
                    color: Colors.grey.shade600,
                    fontWeight: FontWeight.w700,
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
      image: DecorationImage(
        image: AssetImage('assets/images/fondo.png'),
        fit: BoxFit.cover,
      ),
      borderRadius: BorderRadius.circular(20),
    ),
    child: Column(
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
                        padding: const EdgeInsets.fromLTRB(15, 8,15, 5),
                        child: Text(
                          'Don\'t lose your strikes!',
                          style: GoogleFonts.manjari(
                            fontSize: 15,
                            color: Colors.white,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                    ),
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
                  color: Colors.grey.shade400.withOpacity(0.7),
                  borderRadius: BorderRadius.circular(50),
                ),
                child: Icon(
                  FontAwesomeIcons.chevronRight,
                  color: Colors.white,
                  size: 17,
                ),
              ),
            ),
          ],
        ),
      ],
    ),
  ),
),

                SizedBox(width: 10,),
      Padding(
  padding: const EdgeInsets.all(8.0),
  child: Row(
    children: [
       Expanded(
        child: Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: Container(
            height: 100,
            decoration: BoxDecoration(
              color: Colors.grey.shade600.withOpacity(0.2),
              borderRadius: BorderRadius.circular(15),
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 10),
                  Text(
                    'Daily PR',
                    style: GoogleFonts.manjari(
                      fontSize: 16,
                      color: Colors.grey.shade600,
                      
                      fontWeight: FontWeight.w800,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 5),
                  Text(
                    '0.00 KG',
                    style: GoogleFonts.manjari(
                      fontSize: 22,
                      color: Colors.white,
                      fontWeight: FontWeight.w800,)
                  ), 
                ],
              ),
            ),
          ),
        ),
      ),
      Expanded(
        child: Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: Container(
            height: 100,
            decoration: BoxDecoration(
              color: Colors.grey.shade600.withOpacity(0.2),
              borderRadius: BorderRadius.circular(15),
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 10),
                  Text(
                    'Record PR',
                    style: GoogleFonts.manjari(
                      fontSize: 16,
                      color: Colors.grey.shade600,
                      
                      fontWeight: FontWeight.w800,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 5),
                  Text(
                    '0.00 KG',
                    style: GoogleFonts.manjari(
                      fontSize: 22,
                      color: Colors.white,
                      fontWeight: FontWeight.w800,)
                  ), 
                ],
              ),
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
