import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gymtrack/infrastructure/models/gym_item_model.dart';

final selectedGymItemProvider = StateProvider<GymItem?>((ref) {
  return null; // Valor inicial, ningún ítem seleccionado.
});