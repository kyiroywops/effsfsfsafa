import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';
import 'package:url_launcher/url_launcher.dart';

class SettingsScreen extends StatefulWidget {
  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final User? user = FirebaseAuth.instance.currentUser;
  final ImagePicker _picker = ImagePicker();
  File? _imageFile;

  @override
  void initState() {
    super.initState();
    _updateUserProfile(); // Asegura que el avatar de Google esté asignado en FirebaseAuth
  }

  Future<void> _updateUserProfile() async {
    if (user != null && user!.photoURL == null) {
      try {
        // Obtén el avatar de Google y actualiza el perfil del usuario en FirebaseAuth
        await user!.reload(); // Recarga el usuario para asegurarte de que tiene la información más reciente
        final googleProfilePic = user!.photoURL; // Esta URL viene de Google si el usuario usó Google Sign-In
        if (googleProfilePic != null) {
          await user!.updatePhotoURL(googleProfilePic);
          setState(() {});
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to update avatar: $e')));
      }
    }
  }

  Future<void> _pickImage() async {
    final XFile? pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
      _uploadImage();
    }
  }

  Future<void> _uploadImage() async {
    if (_imageFile == null || user == null) return;

    try {
      // Subir la imagen a Firebase Storage
      final storageRef = FirebaseStorage.instance.ref().child('avatars/${user!.uid}.jpg');
      await storageRef.putFile(_imageFile!);

      // Obtener la URL de la imagen subida
      final String downloadURL = await storageRef.getDownloadURL();

      // Actualizar la URL de la imagen en FirebaseAuth
      await user!.updatePhotoURL(downloadURL);

      // Actualizar la UI
      setState(() {});

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Avatar updated successfully!')));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to update avatar: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Settings',
          style: GoogleFonts.lexend(
            fontWeight: FontWeight.w600,
            fontSize: 17,
          ),
        ),
       
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
      ),
      body: Container(
        color: Colors.black,
        child: ListView(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircleAvatar(
                          radius: 30,
                          backgroundColor: Colors.grey.shade400,
                          backgroundImage: user?.photoURL != null ? NetworkImage(user!.photoURL!) : null,
                          child: user?.photoURL == null
                              ? Icon(Icons.person, size: 30, color: Colors.white)
                              : null,
                        ),
                        SizedBox(width: 40),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              user?.displayName ?? 'User',
                              style: GoogleFonts.outfit(
                                color: Colors.grey.shade300,
                                fontSize: 19,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            Text(
                              user?.email ?? 'No email available',
                              style: GoogleFonts.lexend(
                                fontSize: 10,
                                fontWeight: FontWeight.w200,
                                color: Colors.grey.shade500,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(width: 70),
                        IconButton(
                          icon: Icon(
                            FontAwesomeIcons.ellipsis, // Ícono de tres puntos
                            color: Colors.grey.shade300,
                            size: 16,
                          ),
                          onPressed: () {
                            // Navega a la ruta /editarprofile
                            context.go('/editarprofile');
                          },
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 10),
                ],
              ),
            ),
            // Support Section
            Padding(
              padding: const EdgeInsets.fromLTRB(25, 0, 20, 0),
              child: Text(
                'Profile',
                style: GoogleFonts.lexend(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey.shade300,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(

                margin: const EdgeInsets.all(15.0),
                decoration: BoxDecoration(
                  color: Colors.grey.shade900.withOpacity(0.4),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Column(
                  children: <Widget>[
                    _buildListTile(
                      FontAwesomeIcons.solidBell,
                      'Notifications',
                      context,
                      route: '/notifications',
                      subtitle: 'Manage your notification preferences',
                    ),
                    _buildListTile(
                      FontAwesomeIcons.solidUser,
                      'Account Settings',
                      context,
                      route: '/accountsettings',
                      subtitle: 'Update your account details',
                    ),
                  ],
                ),
              ),
            ),
            // Privacy Terms Section
            Padding(
              padding: const EdgeInsets.fromLTRB(25, 30, 20, 0),
              child: Text(
                'Privacy and Terms',
                style: GoogleFonts.lexend(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey.shade300,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                margin: const EdgeInsets.all(15.0),
                decoration: BoxDecoration(
                  color: Colors.grey.shade900.withOpacity(0.4),

                  borderRadius: BorderRadius.circular(15),
                ),
                child: Column(
                  children: <Widget>[
                    _buildListTile(
                      FontAwesomeIcons.userShield,
                      'Privacy Policy',
                      context,
                      url: 'https://tryagain.app/privacypolicy/piramide',
                      subtitle: 'Learn how we protect your data',
                    ),
                    _buildListTile(
                      FontAwesomeIcons.circleInfo,
                      'Terms of Service',
                      context,
                      url: 'https://tryagain.app/termsofservice/piramide',
                      subtitle: 'Review our terms and conditions',
                    ),
                  ],
                ),
              ),
            ),
            // Log Out Button
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                margin: const EdgeInsets.all(15.0),
                decoration: BoxDecoration(
                  color: Colors.grey.shade900.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: ListTile(
                  leading: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Icon(FontAwesomeIcons.signOutAlt, color: Colors.red.shade700),
                  ),
                  title: Text(
                    'Log Out',
                    style: GoogleFonts.lexend(
                      fontWeight: FontWeight.w700,
                      color: Colors.red.shade700,
                    ),
                  ),
                  trailing: Icon(
                    FontAwesomeIcons.chevronRight,
                    color: Colors.red.shade700,
                    size: 15,
                  ),
                  onTap: () async {
                    await FirebaseAuth.instance.signOut();
                    context.go('/login');
                  },
                ),
              ),
            ),
            Center(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(25, 0, 20, 0),
                child: Text(
                  'App version 1.0.4',
                  style: GoogleFonts.lexend(
                    fontSize: 8,
                    fontWeight: FontWeight.w200,
                    color: Colors.grey.shade700,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _customDivider() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 0.0),
      child: Divider(
        color: Colors.grey.shade300.withOpacity(0.2),
        thickness: 2.0,
      ),
    );
  }

  Widget _buildListTile(
    IconData icon,
    String title,
    BuildContext context, {
    String? url,
    String? route,
    String? subtitle,
  }) {
    return ListTile(
      leading: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: Colors.grey.shade900.withOpacity(0.1), // Fondo gris claro
          shape: BoxShape.circle,
          border: Border.all(
            color: Colors.grey.shade800.withOpacity(0.1), // Borde gris
            width: 2,
          ),
        ),
        child: Center(
          child: FaIcon(
            icon,
            color: Colors.grey.shade300, // Color del ícono
            size: 16,
          ),
        ),
      ),
      title: Text(
        title,
        style: GoogleFonts.lexend(
          fontWeight: FontWeight.w500,
          fontSize: 11,
          color: Colors.grey.shade300,
        ),
      ),
      subtitle: subtitle != null
          ? Text(
              subtitle,
              style: GoogleFonts.lexend(
                fontWeight: FontWeight.w100,
                fontSize: 9,
                color: Colors.grey.shade400,
              ),
            )
          : null,
      trailing: Icon(
        FontAwesomeIcons.chevronRight,
        color: Colors.grey.shade300,
        size: 12,
      ),
      onTap: () async {
        if (url != null) {
          if (await canLaunch(url)) {
            await launch(url);
          } else {
            throw 'Could not launch $url';
          }
        } else if (route != null) {
          context.go(route);
        }
      },
    );
  }
}
