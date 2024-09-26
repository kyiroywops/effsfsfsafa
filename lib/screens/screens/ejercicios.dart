import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';

class EjerciciosScreen extends ConsumerStatefulWidget {
  @override
  _EjerciciosScreenState createState() => _EjerciciosScreenState();
}

class _EjerciciosScreenState extends ConsumerState<EjerciciosScreen> {
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
             
             
              
              
              ],
            ),
          ),
        ),
      ),
    );
  }
}
