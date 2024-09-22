import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class BottomSheetWave extends ConsumerStatefulWidget {
  final String title;
  final String subtitle;

  const BottomSheetWave({
    Key? key,
    required this.title,
    required this.subtitle,
  }) : super(key: key);

  @override
  _BottomSheetWaveState createState() => _BottomSheetWaveState();
}

class _BottomSheetWaveState extends ConsumerState<BottomSheetWave> {
  bool isPlaying = false; // Estado inicial del ícono

  void togglePlayPause() {
    setState(() {
      isPlaying = !isPlaying;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width, // Toma todo el ancho de la pantalla
      height: 270,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        color: Colors.grey.shade900,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        children: [
          const SizedBox(height: 10),
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey.shade600,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 30),
         
            CircleAvatar(
                            radius: 35,
                            backgroundImage: AssetImage('assets/images/icons/ola.webp'),
                          ),
          const SizedBox(height: 8),
           Text(
            widget.title,
            style: GoogleFonts.outfit(
              fontSize: 12,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            widget.subtitle,
            style: GoogleFonts.outfit(
              fontSize: 12,
              color: Colors.grey.shade700,
              fontWeight: FontWeight.w400,
            ),
          ),
          const SizedBox(height: 20),

          // Círculo con borde gris y botón de reproducción/pausa
          GestureDetector(
            onTap: togglePlayPause,
            child: Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: Colors.grey.shade700,
                  width: 4,
                ),
              ),
              child: Center(
                child: FaIcon(
                  isPlaying
                      ? FontAwesomeIcons.solidSquare // Ícono de pausa
                      : FontAwesomeIcons.solidCircle,  // Ícono de play
                  color: Colors.red, // Color rojo como la grabación del iPhone
                  size: 35,
                ),
              ),
            ),
          ),

          const SizedBox(height: 30),
        ],
      ),
    );
  }
}
