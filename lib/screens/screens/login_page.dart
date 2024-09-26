import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'dart:ui';

import 'package:url_launcher/url_launcher.dart';

class LoginScreen extends StatefulWidget {
  LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController rePasswordController = TextEditingController();

  bool isEmailEntered = false;
  bool _isAgreeChecked = false;
  bool isSignUp = false;
  bool _passwordVisible = false;
  bool isEmailValid = true;

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    nameController.dispose();
    rePasswordController.dispose();
    super.dispose();
  }

  void _validateEmail() {
    setState(() {
      isEmailValid = emailController.text.contains('@');
    });

    if (!isEmailValid) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please enter a valid email address.'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _resetPassword(String email) async {
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('A password reset link has been sent to your email.'),
          backgroundColor: Colors.green,
        ),
      );
    } on FirebaseAuthException catch (e) {
      String message;
      if (e.code == 'user-not-found') {
        message = 'No user found for that email.';
      } else {
        message = 'An error occurred while trying to reset the password.';
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      if (googleUser == null) {
        return;
      }

      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      UserCredential userCredential = await FirebaseAuth.instance.signInWithCredential(credential);

      if (userCredential.user != null) {
        String? name = userCredential.user?.displayName;
        String? photoUrl = userCredential.user?.photoURL;
        String uid = userCredential.user!.uid;

        await FirebaseFirestore.instance.collection('users').doc(uid).set({
          'name': name,
          'photoUrl': photoUrl,
          'email': userCredential.user?.email,
        });

        context.go('/home');
      }
    } on FirebaseAuthException catch (e) {
      print('Error de FirebaseAuth: ${e.message}');
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to sign in with Google: ${e.message}')));
    } catch (e) {
      print('Error desconocido: $e');
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to sign in with Google')));
    }
  }

  @override
  Widget build(BuildContext context) {
    double frostedContainerTopPosition = MediaQuery.of(context).size.height * 0.32;
    double paddingVertical = 20; // El padding vertical de tu contenedor
    double titleTopPosition = frostedContainerTopPosition - 60; // Sube el título más arriba

    return Scaffold(
      body: Stack(
        children: <Widget>[
          // Fondo con imagen
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/background.png'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          // Botón para retroceder
          
          Positioned(
            top: titleTopPosition - 150, // Ajusta la posición vertical según sea necesario
            left: 0,
            right: 0,
            child: Center(
              child: Image.asset(
                'assets/images/logo.png', // Ruta del logo
                height: 130, // Ajusta el tamaño según tus necesidades
              ),
            ),
          ),
          Positioned(
            top: titleTopPosition,
            left: 25,
            child: isEmailEntered || isSignUp
                ? Row(
                    children: [
                      IconButton(
                        icon: Icon(FontAwesomeIcons.circleChevronLeft, color: Colors.grey.shade100),
                        onPressed: () {
                          setState(() {
                            isEmailEntered = false; // Esto permitirá al usuario volver al estado anterior
                            isSignUp = false; // Regresa al estado inicial
                          });
                        },
                      ),
                      Text(
                        isSignUp ? 'Sign Up' : 'Log in',
                        style: GoogleFonts.outfit(
                            color: Colors.white,
                            fontSize: 40,
                            fontWeight: FontWeight.w900),
                      ),
                    ],
                  )
                : Text('Hello!',
                    style: GoogleFonts.outfit(
                        color: Colors.white,
                        fontSize: 40,
                         shadows: 
                            [
                              Shadow(
                                color: Colors.black,
                                offset: Offset(2, 2),
                                blurRadius: 2,
                              ),
                            ],
                        fontWeight: FontWeight.w900)),
          ),
          // Container con efecto "frosted"
          Positioned(
              top: frostedContainerTopPosition, // Posición calculada para el contenedor
              left: 20,
              right: 20, // Agrega esto para tener un margen en ambos lados

              child: ClipRRect(
                borderRadius: BorderRadius.circular(25),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                  child: Container(
                    padding: EdgeInsets.fromLTRB(30, 25, 30, 20),
                    decoration: BoxDecoration(
                      color: Colors.grey.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(25),
                    ),
                    child: Column(
                      children: <Widget>[
                        if (isSignUp) ...[
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Text('Name', 
                                style: GoogleFonts.outfit(
                                  color: Colors.grey.shade200,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                )
                              
                              )),
                          ),
                          TextFormField(
                            controller: nameController,
                            keyboardType: TextInputType.text,
                            cursorColor: Colors.black,
                            style: GoogleFonts.outfit(
                              fontSize: 12,
                              color: Colors.grey.shade900,
                              fontWeight: FontWeight.w600,
                            ),
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: Colors.grey[200],
                              hintText: 'Name',
                              contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8.0),
                                borderSide: BorderSide(
                                  color: Colors.black,
                                  width: 3.0,
                                ),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8.0),
                                borderSide: BorderSide(
                                  color: Colors.grey[200]!,
                                  width: 1.0,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: 5),
                           Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Text('Email', 
                                style: GoogleFonts.outfit(
                                  color: Colors.grey.shade200,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                )
                              
                              )),
                          ),
                          TextFormField(
                            validator: (value) {
                              if (value == null || value.isEmpty || !value.contains('@')) {
                                return 'Please enter a valid email address.';
                              }
                              return null;
                            },
                            controller: emailController,
                            keyboardType: TextInputType.emailAddress,
                            cursorColor: Colors.black,
                            style: GoogleFonts.outfit(
                              fontSize: 12,
                              color: Colors.grey.shade900,
                              fontWeight: FontWeight.w600,
                            ),
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: Colors.grey[200],
                              hintText: 'Email',
                              contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8.0),
                                borderSide: BorderSide(
                                  color: Colors.black,
                                  width: 3.0,
                                ),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8.0),
                                borderSide: BorderSide(
                                  color: Colors.grey[200]!,
                                  width: 1.0,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: 5),
                           Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Text('Password', 
                                style: GoogleFonts.outfit(
                                  color: Colors.grey.shade200,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                )
                              
                              )),
                          ),
                          TextField(
                            style: GoogleFonts.outfit(
                              fontSize: 12,
                              color: Colors.grey.shade900,
                              fontWeight: FontWeight.w600,
                            ),
                            controller: passwordController,
                            keyboardType: TextInputType.text,
                            obscureText: true,
                            cursorColor: Colors.black,
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: Colors.grey[200],
                              hintText: 'Password',
                              contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8.0),
                                borderSide: BorderSide(
                                  color: Colors.black,
                                  width: 3.0,
                                ),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8.0),
                                borderSide: BorderSide(
                                  color: Colors.grey[200]!,
                                  width: 1.0,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: 5),
                           Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Text('Re-enter Password', 
                                style: GoogleFonts.outfit(
                                  color: Colors.grey.shade200,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                )
                              
                              )),
                          ),
                          TextField(
                            controller: rePasswordController,
                            keyboardType: TextInputType.text,
                            obscureText: true,
                            cursorColor: Colors.black,
                            style: GoogleFonts.outfit(
                              fontSize: 12,
                              color: Colors.grey.shade900,
                              fontWeight: FontWeight.w600,
                            ),
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: Colors.grey[200],
                              hintText: 'Re-enter Password',
                              contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8.0),
                                borderSide: BorderSide(
                                  color: Colors.black,
                                  width: 3.0,
                                ),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8.0),
                                borderSide: BorderSide(
                                  color: Colors.grey[200]!,
                                  width: 1.0,
                                ),
                              ),
                            ),
                          ),
                       
                          SizedBox(height: 20),
                          Row(
                            children: [
                              Checkbox(

                                activeColor: Colors.green,
                                checkColor: Colors.grey.shade400,
                                value: _isAgreeChecked,
                                onChanged: (bool? value) {
                                  setState(() {
                                    _isAgreeChecked = value ?? false;
                                  });
                                },
                              ),
                              Expanded(
                                child: RichText(
                                  text: TextSpan(
                                    style: GoogleFonts.outfit(
                                      fontSize: 12,
                                      color: Colors.grey.shade400,
                                    ),
                                    children: [
                                      TextSpan(text: "By selecting Sign Up, you accept our "),
                                      TextSpan(
                                        text: "Terms of Service",
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.blue,
                                        ),
                                        recognizer: TapGestureRecognizer()
                                          ..onTap = () {
                                            launch('https://www.tryagain.app/termsofservice/morehabits');
                                          },
                                      ),
                                      TextSpan(text: " and confirm that you have reviewed our "),
                                      TextSpan(
                                        text: "Privacy Policy,",
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.blue,
                                        ),
                                        recognizer: TapGestureRecognizer()
                                          ..onTap = () {
                                            launch('https://www.tryagain.app/privacypolicy/morehabits');
                                          },
                                      ),
                                      TextSpan(text: " which details how to manage your preferences."),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 20),

                        ElevatedButton(
                          child: Text(
                            'Sign Up',
                            style: GoogleFonts.outfit(
                                color: Colors.grey[200],
                                fontSize: 12,
                                
                                fontWeight: FontWeight.w700),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.grey.shade600,
                            minimumSize: Size(double.infinity, 40),
                            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 18),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                          ),
                          onPressed: () async {
                            if (!_isAgreeChecked) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('Please agree to the terms and conditions.')),
                              );
                              return;
                            }

                            if (passwordController.text.isEmpty || rePasswordController.text.isEmpty) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('Password fields cannot be empty')),
                              );
                              return;
                            }

                            if (passwordController.text != rePasswordController.text) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('Passwords do not match')),
                              );
                              return;
                            }

                            try {
                              UserCredential userCredential = await FirebaseAuth.instance
                                  .createUserWithEmailAndPassword(
                                email: emailController.text,
                                password: passwordController.text,
                              );

                              // Aquí solo almacenamos los campos necesarios sin la contraseña.
                              await FirebaseFirestore.instance
                                  .collection('users')
                                  .doc(userCredential.user!.uid)
                                  .set({
                                'name': nameController.text,
                                'email': emailController.text,
                                'checkdelterms': _isAgreeChecked,
                                // 'photoUrl': null,  // Puedes agregar este campo si es necesario
                              });

                              if (mounted) {
                                context.go('/home');
                              }
                            } on FirebaseAuthException catch (e) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('Failed to sign up: ${e.message}')),
                              );
                            } catch (e) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('An unknown error occurred: $e')),
                              );
                            }
                          },
                        ),
                        ] else if (!isEmailEntered) ...[
                          TextFormField(
                            maxLength: 50, // Limita los caracteres a 50
                            controller: emailController,
                            keyboardType: TextInputType.emailAddress,
                            cursorColor: Colors.black,
                            style: GoogleFonts.outfit(
                              fontSize: 12,
                              color: Colors.grey.shade900,
                              fontWeight: FontWeight.w600,
                            ),
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: Colors.grey[200],
                              hintText: 'Email',
                              contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8.0),
                                borderSide: BorderSide(
                                  color: isEmailValid ? Colors.black : Colors.red,
                                  width: 3.0,
                                ),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8.0),
                                borderSide: BorderSide(
                                  color: isEmailValid ? Colors.grey[200]! : Colors.red,
                                  width: 1.0,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: 20),
                          ElevatedButton(
                            child: Text(
                              'Continue',
                              style: GoogleFonts.outfit(
                                  color: Colors.grey[200],
                                  fontSize: 12,
                                  fontWeight: FontWeight.w700),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.grey.shade900,
                              minimumSize: Size(double.infinity, 40),
                              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 18),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                            ),
                            onPressed: () {
                              _validateEmail();
                              if (isEmailValid) {
                                setState(() {
                                  isEmailEntered = true;
                                });
                              }
                            },
                          ),
                        ] else ...[
                          TextField(
                            style: GoogleFonts.outfit(
                              fontSize: 12,
                              color: Colors.grey.shade900,
                              fontWeight: FontWeight.w600,
                            ),
                            controller: passwordController,
                            keyboardType: TextInputType.text,
                            obscureText: !_passwordVisible,
                            obscuringCharacter: '●',
                            cursorColor: Colors.black,
                            decoration: InputDecoration(
                              suffixIcon: Padding(
                                padding: const EdgeInsets.fromLTRB(0, 15, 20, 0),
                                child: GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      _passwordVisible = !_passwordVisible;
                                    });
                                  },
                                  child: Text(
                                    _passwordVisible ? "Hide" : "View",
                                    style: GoogleFonts.outfit(
                                      fontSize: 12,
                                      color: Colors.grey.shade900,
                                      fontWeight: FontWeight.w800,
                                    ),
                                  ),
                                ),
                              ),
                              filled: true,
                              fillColor: Colors.grey[300],
                              hintText: 'Password',
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8.0),
                                borderSide: BorderSide(
                                  color: Colors.black,
                                  width: 3.0,
                                ),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8.0),
                                borderSide: BorderSide(
                                  color: Colors.grey[200]!,
                                  width: 1.0,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: 20),
                          ElevatedButton(
                            child: Text(
                              'Login',
                              style: GoogleFonts.outfit(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.grey[200]),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.grey.shade900,
                              minimumSize: Size(double.infinity, 52),
                              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 0),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                            ),
                            onPressed: () async {
                              if (emailController.text.contains('@')) {
                                try {
                                  UserCredential userCredential = await FirebaseAuth.instance
                                      .signInWithEmailAndPassword(
                                    email: emailController.text,
                                    password: passwordController.text,
                                  );
                                  if (mounted) {
                                    context.go('/home');
                                  }
                                } on FirebaseAuthException catch (e) {
                                  if (e.code == 'user-not-found') {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(content: Text('No user found for that email.')));
                                  } else if (e.code == 'wrong-password') {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(content: Text('Wrong password provided for that user.')));
                                  }
                                }
                              }
                            },
                          ),
                         Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: TextButton(
                              onPressed: () {
                                if (emailController.text.isNotEmpty && emailController.text.contains('@')) {
                                  _resetPassword(emailController.text);
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: const Text('Please enter a valid email address.'),
                                      backgroundColor: Colors.red,
                                    ),
                                  );
                                }
                              },
                              child: Text(
                                "Forgot your password?",
                                style: GoogleFonts.outfit(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey[200],
                                  fontSize: 12,
                                ),
                              ),
                              style: TextButton.styleFrom(
                                padding: EdgeInsets.zero,
                                alignment: Alignment.centerLeft,
                              ),
                            ),
                          ),
                        ),
                        ],
                        if (!isSignUp && !isEmailEntered) ...[
                          SizedBox(height: 20),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 80.0),
                            child: Center(
                              child: Text(
                                'or',
                                style: GoogleFonts.outfit(
                                  fontSize: 14,
                                   shadows: 
                            [
                              Shadow(
                                color: Colors.black,
                                offset: Offset(2, 2),
                                blurRadius: 2,
                              ),
                            ],
                                  fontWeight: FontWeight.w900,
                                  color: Colors.grey.shade300,
                                  
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: 20),
                          SizedBox(
                            width: double.infinity,
                            child: TextButton.icon(
                              icon: SvgPicture.asset(
                                'assets/icons/facebook.svg',
                                width: 24.0,
                                height: 24.0,
                              ),
                              label: Text(
                                'Continue with Facebook',
                                style: GoogleFonts.outfit(
                                  color: Colors.grey[200],
                                  fontWeight: FontWeight.w700,
                                  fontSize: 12,
                                ),
                              ),
                              style: TextButton.styleFrom(
                                foregroundColor: Colors.white,
                                backgroundColor: Colors.blue,
                                padding: EdgeInsets.symmetric(vertical: 15.0),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8.0),
                                ),
                              ),
                              onPressed: () {
                                // Tu lógica de autenticación con Facebook aquí
                              },
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 20),
                            child: SizedBox(
                              width: double.infinity,
                              child: TextButton.icon(
                                icon: SvgPicture.asset(
                                  'assets/icons/google.svg',
                                  width: 24.0,
                                  height: 24.0,
                                ),
                                label: Text(
                                  'Continue with Google',
                                  style: GoogleFonts.outfit(
                                    color: Colors.grey[900],
                                    fontWeight: FontWeight.w800,
                                    fontSize: 12,
                                  ),
                                ),
                                style: TextButton.styleFrom(
                                  foregroundColor: Colors.black,
                                  backgroundColor: Colors.grey[200],
                                  padding: EdgeInsets.symmetric(vertical: 15.0),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8.0),
                                  ),
                                ),
                                onPressed: _signInWithGoogle,
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(top: 10),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        "Don't have an account? ",
                                        style: GoogleFonts.outfit(
                                          color: Colors.grey.shade300,
                                          fontWeight: FontWeight.w400,
                                          fontSize: 12,
                                        ),
                                      ),
                                      SizedBox(width: 2),
                                      GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            isSignUp = true;
                                          });
                                        },
                                        child: Text(
                                          "Sign up",
                                          style: GoogleFonts.outfit(
                                            fontSize: 13,
                                             shadows: 
                            [
                              Shadow(
                                color: Colors.black,
                                offset: Offset(2, 2),
                                blurRadius: 2,
                              ),
                            ],
                                            fontWeight: FontWeight.w900,
                                            color: Colors.grey.shade300,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 10),
                                  child: Center(
                                    child: RichText(
                                      textAlign: TextAlign.center,
                                      text: TextSpan(
                                        style: GoogleFonts.outfit(
                                          fontSize: 12,
                                          color: Colors.grey.shade400,
                                        ),
                                        children: [
                                          TextSpan(text: "By selecting Continue, you accept our "),
                                          TextSpan(
                                            text: "Terms of Service",
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: Colors.blue,
                                            ),
                                            recognizer: TapGestureRecognizer()
                                              ..onTap = () {
                                                launch(
                                                    'https://www.tryagain.app/termsofservice/morehabits');
                                              },
                                          ),
                                          TextSpan(
                                              text: " and confirm that you have reviewed our "),
                                          TextSpan(
                                            text: "Privacy Policy,",
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: Colors.blue,
                                            ),
                                            recognizer: TapGestureRecognizer()
                                              ..onTap = () {
                                                launch(
                                                    'https://www.tryagain.app/privacypolicy/morehabits');
                                              },
                                          ),
                                          TextSpan(
                                              text: " which details how to manage your preferences."),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ]
                      ],
                    ),
                  ),
                ),
              ))
        ],
      ),
    );
  }
}
