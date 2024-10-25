import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gymtrack/screens/providers/voice_provider.dart'; // Importar el voice_provider

class VoiceChatWidget extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final transcript = ref.watch(speechProvider); // Observar el estado del reconocimiento de voz
    final isListening = ref.watch(speechProvider.notifier).isListening; // Saber si está escuchando

    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Text(
            'Voice Chat',
            style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 10),
          Text(
            'Transcripción:',
            style: TextStyle(color: Colors.white, fontSize: 16),
          ),
          SizedBox(height: 10),
          Container(
            padding: EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.grey.shade800,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(
              transcript.isEmpty ? "Empieza a hablar..." : transcript,
              style: TextStyle(color: Colors.white, fontSize: 18),
              textAlign: TextAlign.center,
            ),
          ),
          SizedBox(height: 20),
          ElevatedButton.icon(
            onPressed: () => ref.read(speechProvider.notifier).listen(), // Activar la escucha
            icon: Icon(isListening ? Icons.mic_off : Icons.mic),
            label: Text(isListening ? 'Stop Listening' : 'Start Listening'),
            style: ElevatedButton.styleFrom(
              backgroundColor: isListening ? Colors.red : Colors.green,
            ),
          ),
        ],
      ),
    );
  }
}
