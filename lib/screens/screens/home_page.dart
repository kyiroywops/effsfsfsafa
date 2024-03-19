import 'package:flutter/material.dart';
import 'dart:ui';

import 'package:gymtrack/screens/widgets/showaddworkout_widget.dart'; // Para el BackdropFilter

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

 


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
                    onPressed: () => showAddWorkoutBottomSheet(context),
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
