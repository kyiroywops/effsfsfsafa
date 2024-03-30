import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gymtrack/infrastructure/models/exercises_models.dart';
import 'package:gymtrack/infrastructure/models/exercises_setmodels.dart';
import 'package:gymtrack/screens/providers/selectedgymitem_provider.dart';
import 'package:gymtrack/screens/widgets/itemgym_row_widget.dart';
import 'package:gymtrack/screens/widgets/seriesgym_row_widget.dart';

// Define la clase Exercise para manejar los datos de los ejercicios

void showAddWorkoutBottomSheet(BuildContext context) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    isDismissible: true,
    backgroundColor: Colors.transparent,
    builder: (BuildContext context) => AddWorkoutBottomSheet(),
  );
}

class AddWorkoutBottomSheet extends ConsumerStatefulWidget {
  @override
  _AddWorkoutBottomSheetState createState() => _AddWorkoutBottomSheetState();
}

class _AddWorkoutBottomSheetState extends ConsumerState<AddWorkoutBottomSheet> {
  Exercise? selectedExercise;
  List<Exercise>? exercises;
  TextEditingController _textEditingController = TextEditingController();
  ValueKey<int> autocompleteKey =
      ValueKey(0); // Inicializa con un valor por defecto

  @override
  void initState() {
    super.initState();
    _textEditingController =
        TextEditingController(text: ' '); // Inicializa con un espacio en blanco
    _loadExercises().then((loadedExercises) {
      setState(() {
        exercises = loadedExercises;
      });
    });
  }

 Future<List<Exercise>> _loadExercises() async {
    final jsonString =
        await rootBundle.loadString('assets/jsons/exercises.json');
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

  void _addExerciseToFirestore(WidgetRef ref, Exercise selectedExercise) async {
    final FirebaseAuth auth = FirebaseAuth.instance;
    final User? user = auth.currentUser; // Obtiene el usuario actual
    final selectedGymItem = ref.read(selectedGymItemProvider.state).state;

    if (selectedGymItem != null && user != null) {
      List<ExerciseSet> sets = ref.read(exerciseSetProvider);
      List<ExerciseSet> validSets = sets
          .where((set) => set.reps != 0 || set.weight != 0 || set.assists != 0)
          .toList();

    List<Map<String, dynamic>> firestoreSets = validSets.map((set) {
        return {
          'reps': set.reps,
          'weight': set.weight,
          'unit': set.unit,
          'assists': set.assists,
        };
      }).toList();

    
      CollectionReference exercises =
          FirebaseFirestore.instance.collection('exercises');

      await exercises.add({
        'userId': user.uid, // Agrega el ID del usuario
        'exerciseName': selectedExercise.name,
        'exerciseIcon': selectedExercise.exerciseIcon,
        'gymItemName': selectedGymItem.name,
        'gymItemIconPath': selectedGymItem.iconPath,
        'sets': firestoreSets,
        'timestamp': FieldValue.serverTimestamp(), // Agrega la fecha actual
      }).then((documentReference) {
        print("Exercise Added with ID: ${documentReference.id}");
      }).catchError((e) {
        print("Error adding document: $e");
      });
    } else {
      print("No exercise or gym item selected or user is not logged in.");
    }
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
                  color: Colors.black.withOpacity(0.8),
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
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text("Cancel",
                                  style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w700,
                                      color: Colors.blue.shade700,
                                      fontFamily: 'Geologica')),
                              Text("Add quick exercise",
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w800,
                                      color: Colors.white,
                                      fontFamily: 'Geologica')),
                              ElevatedButton(
                                 onPressed: () {
    if (selectedExercise != null) {
      _addExerciseToFirestore(ref, selectedExercise!); // Usa el operador '!' para asegurar que no es null
    } else {
      // Manejar el caso en que selectedExercise sea null
      print('No exercise has been selected.');
    }
  },
                                child: Text(
                                  'Add',
                                  style: TextStyle(
                                    fontFamily: 'Geologica',
                                    fontWeight: FontWeight.w800,
                                    fontSize: 12,
                                    color: Colors.black,
                                  ),
                                ),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.white,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(18.0),
                                  ),
                                ),
                              ),
                            ],
                          ),

                          SizedBox(height: 20),
                          Autocomplete<Exercise>(
                            key:
                                autocompleteKey, // Usa la key que se reinicia con _clearSelection

                          optionsBuilder: (TextEditingValue textEditingValue) {
  print("Búsqueda de texto: '${textEditingValue.text}'"); // Impresión de depuración

  if (textEditingValue.text.isEmpty) {
    print("Mostrando todos los ejercicios");
    return exercises ?? const Iterable<Exercise>.empty();
  } else {
    final filteredExercises = exercises!.where((Exercise option) {
      final match = option.name.toLowerCase().contains(textEditingValue.text.toLowerCase());
      print("Filtrado por '${option.name}': $match"); // Impresión de depuración
      return match;
    });
    return filteredExercises;
  }
},
                            fieldViewBuilder: (BuildContext context,
                                TextEditingController textEditingController,
                                FocusNode focusNode,
                                VoidCallback onFieldSubmitted) {
                              return Container(
                                height: 60.0,
                                child: Stack(
                                  alignment: Alignment.centerLeft,
                                  children: [
                                    TextField(
                                      controller: textEditingController,
                                      focusNode: focusNode,
                                      decoration: InputDecoration(
                                        border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(20)),
                                        filled: true,
                                        fillColor: Colors.white,
                                        hintText:
                                            '', // Eliminamos el hintText del InputDecoration
                                        prefixIcon: Icon(Icons.search),
                                        contentPadding: EdgeInsets.only(
                                            left:
                                                8.0), // Ajustamos el padding del contenido
                                      ),
                                      // El campo debe ser de solo lectura únicamente si hay una selección
                                      readOnly: selectedExercise != null,
                                    ),
                                    // Texto de sugerencia en la esquina superior izquierda
                                    Positioned(
                                      left: 50.0,
                                      top: 12.0,
                                      child: Text(
                                        'Name of the exercise',
                                        style: TextStyle(
                                          color: Colors.grey.shade600,
                                          fontFamily: 'Geologica',
                                          fontWeight: FontWeight.w400,

                                          fontSize:
                                              11.0, // Tamaño del texto de sugerencia
                                        ),
                                      ),
                                    ),
                                    // Coloca el Chip encima del TextField solo si hay una selección
                                    if (selectedExercise != null)
                                      Padding(
                                        padding: const EdgeInsets.fromLTRB(
                                            48.0, 8.0, 8.0, 8.0),
                                        child: Chip(
                                          backgroundColor: Colors.grey[900],
                                          deleteIconColor: Colors.white,
                                          labelStyle: TextStyle(
                                            color: Colors.white,
                                            fontFamily: 'Geologica',
                                            fontWeight: FontWeight.w600,
                                          ),
                                          label: Text(selectedExercise!.name),
                                          avatar: Image.asset(
                                              'assets/images/icons/${selectedExercise!.exerciseIcon}',
                                              width: 24,
                                              height: 24),
                                          onDeleted: _clearSelection,
                                        ),
                                      ),
                                  ],
                                ),
                              );
                            },
                            optionsViewBuilder: (BuildContext context,
                                AutocompleteOnSelected<Exercise> onSelected,
                                Iterable<Exercise> options) {
                              return Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Align(
                                  alignment: Alignment.topCenter,
                                  child: Material(
                                    elevation: 4.0, // Añade algo de sombra
                                    borderRadius: BorderRadius.circular(
                                        10.0), // Esquinas redondeadas
                                    color: Colors
                                        .transparent, // Evita el fondo por defecto
                                    child: Container(
                                      width:
                                          300, // Ajusta esto según sea necesario para tu diseño
                                      decoration: BoxDecoration(
                                        color: Colors
                                            .black, // Color de fondo del contenedor
                                        borderRadius: BorderRadius.circular(
                                            10.0), // Esquinas redondeadas
                                      ),
                                      child: Scrollbar(
                                        thickness:
                                            6.0, // Grosor de la barra de desplazamiento
                                        radius: Radius.circular(
                                            5.0), // Esquinas redondeadas para la barra de desplazamiento
                                        child: ListView(
                                          padding: EdgeInsets.zero,
                                          shrinkWrap: true,
                                          children: options
                                              .map((Exercise option) =>
                                                  GestureDetector(
                                                    onTap: () =>
                                                        onSelected(option),
                                                    child: ListTile(
                                                      title: Text(
                                                        option.name,
                                                        style: TextStyle(
                                                          color: Colors.white,
                                                          fontFamily:
                                                              'Geologica',
                                                          fontWeight:
                                                              FontWeight.w600,
                                                        ), // Texto claro
                                                      ),
                                                      leading: Image.asset(
                                                          'assets/images/icons/${option.exerciseIcon}',
                                                          width: 30,
                                                          height: 30),
                                                    ),
                                                  ))
                                              .toList(),
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
                            displayStringForOption: (Exercise option) => option
                                .name, // Define cómo se muestra el objeto Exercise
                          ),

                          SizedBox(height: 20),
                          // Dentro de tu widget, reemplaza el Row por un ListView horizontal
                          GymItemRow(),
                          SeriesWidget(),
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
