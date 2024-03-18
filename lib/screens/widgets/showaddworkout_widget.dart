import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;

// Define la clase Exercise para manejar los datos de los ejercicios
class Exercise {
  final String name;
  final String icon;
  Exercise({required this.name, required this.icon});
  factory Exercise.fromJson(Map<String, dynamic> json) {
    return Exercise(
      name: json['name'],
      icon: json['icon'],
    );
  }
}

void showAddWorkoutBottomSheet(BuildContext context) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    isDismissible: true,
    backgroundColor: Colors.transparent,
    builder: (BuildContext context) => AddWorkoutBottomSheet(),
  );
}

class AddWorkoutBottomSheet extends StatefulWidget {
  @override
  _AddWorkoutBottomSheetState createState() => _AddWorkoutBottomSheetState();
}

class _AddWorkoutBottomSheetState extends State<AddWorkoutBottomSheet> {
  Exercise? selectedExercise;
  List<Exercise>? exercises;
 TextEditingController _textEditingController = TextEditingController();
  ValueKey<int> autocompleteKey = ValueKey(0); // Inicializa con un valor por defecto

  @override
void initState() {
  super.initState();
  _textEditingController = TextEditingController(text: ' '); // Inicializa con un espacio en blanco
  _loadExercises().then((loadedExercises) {
    setState(() {
      exercises = loadedExercises;
    });
  });
}
  Future<List<Exercise>> _loadExercises() async {
    final jsonString = await rootBundle.loadString('assets/jsons/exercises.json');
    final jsonResponse = json.decode(jsonString) as List;
    return jsonResponse.map((json) => Exercise.fromJson(json)).toList();
  }

  void _clearSelection() {
    setState(() {
      selectedExercise = null;
      _textEditingController.clear();
      autocompleteKey = ValueKey(DateTime.now().millisecondsSinceEpoch);
    });
  }

  void _selectExercise(Exercise selection) {
    setState(() {
      selectedExercise = selection;
    });
  }






  @override
  Widget build(BuildContext context) {

    return exercises == null
        ? Center(child: CircularProgressIndicator())
        : DraggableScrollableSheet(
            initialChildSize: 0.6,
            maxChildSize: 0.6,
            minChildSize: 0.6,
            expand: false,
            builder: (_, controller) {
              return Container(
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.75),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(12.0),
                    topRight: Radius.circular(12.0),
                  ),
                ),
                child: ListView(
                  controller: controller,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                           Text("Selecciona el ejercicio", /* Estilo */),
                SizedBox(height: 20),
            Autocomplete<Exercise>(
        key: autocompleteKey, // Usa la key que se reinicia con _clearSelection

optionsBuilder: (TextEditingValue textEditingValue) {
  if (textEditingValue.text.isEmpty) {
    return exercises ?? const Iterable<Exercise>.empty(); // Retorna todas las opciones si no hay texto ingresado
  } else {
    return exercises!.where((Exercise option) {
      return option.name.toLowerCase().contains(textEditingValue.text.toLowerCase());
    });
  }
},
fieldViewBuilder: (
  BuildContext context,
  TextEditingController textEditingController,
  FocusNode focusNode,
  VoidCallback onFieldSubmitted
) {
  return Container(
    height: 60.0, // Define la altura del contenedor del TextField.
    child: Stack(
      alignment: Alignment.centerLeft,
      children: [
        TextField(
  controller: textEditingController,
  focusNode: focusNode,
  decoration: InputDecoration(
    border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
    filled: true,
    fillColor: Colors.white,
    hintText: 'Escribe para buscar...',
    prefixIcon: Icon(Icons.search),
  ),
  // El campo debe ser de solo lectura únicamente si hay una selección
  readOnly: selectedExercise != null,
),
        // Coloca el Chip encima del TextField solo si hay una selección.
        if (selectedExercise != null)
          Padding(
            padding: const EdgeInsets.fromLTRB(48.0, 8.0, 8.0, 8.0), // Ajustar los valores para posicionar correctamente el Chip.
            child: Chip(
              backgroundColor: Colors.grey[900],
              deleteIconColor: Colors.white,
              labelStyle: TextStyle(color: Colors.white),
              label: Text(selectedExercise!.name),
              avatar: Image.asset('assets/images/icons/${selectedExercise!.icon}', width: 24, height: 24),
              onDeleted: _clearSelection,
            ),
          ),
      ],
    ),
  );
},
optionsViewBuilder: (
  BuildContext context, 
  AutocompleteOnSelected<Exercise> onSelected, 
  Iterable<Exercise> options
) {
  return Padding(
    padding: const EdgeInsets.all(8.0),
    child: Align(
      alignment: Alignment.topCenter,
      child: Material(
        elevation: 4.0, // Añade algo de sombra
        borderRadius: BorderRadius.circular(10.0), // Esquinas redondeadas
        color: Colors.transparent, // Evita el fondo por defecto
        child: Container(
          width: 300, // Ajusta esto según sea necesario para tu diseño
          decoration: BoxDecoration(
            color: Colors.black, // Color de fondo del contenedor
            borderRadius: BorderRadius.circular(10.0), // Esquinas redondeadas
          ),
          child: Scrollbar(
            
            thickness: 6.0, // Grosor de la barra de desplazamiento
            radius: Radius.circular(5.0), // Esquinas redondeadas para la barra de desplazamiento
            child: ListView(
              padding: EdgeInsets.zero,
              shrinkWrap: true,
              children: options.map((Exercise option) => GestureDetector(
                onTap: () => onSelected(option),
                child: ListTile(
                  title: Text(
                    option.name,
                    style: TextStyle(color: Colors.white), // Texto claro
                  ),
                  leading: Image.asset('assets/images/icons/${option.icon}', width: 30, height: 30),
                ),
              )).toList(),
            ),
          ),
        ),
      ),
    ),
  );
},

 onSelected: (Exercise selection) {
  setState(() {
    selectedExercise = selection;
    // No hay necesidad de actualizar el textEditingController aquí.
  });
},
  displayStringForOption: (Exercise option) => option.name, // Define cómo se muestra el objeto Exercise
),

                          SizedBox(height: 20),
                          ElevatedButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.black,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                            ),
                            child: Text(
                              "Añadir",
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          );
          
  }

  
}

