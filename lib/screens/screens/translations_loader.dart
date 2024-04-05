import 'dart:convert';
import 'package:flutter/services.dart';

class TranslationsLoader {
  Future<Map<String, Map<String, String>>> loadTranslations(String path) async {
    final jsonString = await rootBundle.loadString(path);
    final List<dynamic> jsonResponse = json.decode(jsonString) as List;

    // Crear un mapa para almacenar las traducciones
    final Map<String, Map<String, String>> translationsMap = {};

    // Iterar sobre la lista para llenar el mapa de traducciones
    for (var item in jsonResponse) {
      final String name = item['name'] as String;
      final Map<String, String> translations = Map<String, String>.from(item['translations'] as Map);
      translationsMap[name] = translations;
    }

    return translationsMap;
  }
}
