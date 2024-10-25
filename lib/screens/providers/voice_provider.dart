import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;

// Proveedor de Firestore
final firestoreProvider = Provider((ref) => FirebaseFirestore.instance);

// Proveedor de reconocimiento de voz
final speechProvider = StateNotifierProvider.autoDispose<SpeechNotifier, String>((ref) {
  return SpeechNotifier(ref);
});

// Notifier para manejar el estado del reconocimiento de voz
class SpeechNotifier extends StateNotifier<String> {
  final stt.SpeechToText _speech = stt.SpeechToText();
  bool _isListening = false;
  final Ref _ref;

  SpeechNotifier(this._ref) : super("Press the button and start speaking...");

  bool get isListening => _isListening;

  // Función para iniciar y detener la escucha
  Future<void> listen() async {
    if (!_isListening) {
      bool available = await _speech.initialize();
      if (available) {
        _isListening = true;
        _speech.listen(onResult: (val) {
          if (val.hasConfidenceRating && val.confidence > 0) {
            state = val.recognizedWords;
            _handleCommand(val.recognizedWords);
          }
        });
      }
    } else {
      _isListening = false;
      _speech.stop();
    }
  }

  // Analizar el comando y guardar en Firestore
  void _handleCommand(String command) {
    final regex = RegExp(r"hice (\d+) sets");
    final match = regex.firstMatch(command.toLowerCase());
    if (match != null) {
      final int sets = int.parse(match.group(1)!);
      _saveToFirestore(sets);
    }
  }

  // Guardar en Firestore
  Future<void> _saveToFirestore(int sets) async {
    final firestore = _ref.read(firestoreProvider);
    await firestore.collection('workout_sessions').add({
      'sets': sets,
      'timestamp': Timestamp.now(),
    });
    state = "¡Se añadieron $sets sets al registro!";
  }
}
