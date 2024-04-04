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
    backgroundColor: Colors.blueAccent.shade100.withOpacity(0.75),
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
  String selectedUnit = 'KG'; // Asegúrate de que esta variable esté definida aquí


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

    int recordSetWeight = validSets
        .where((set) => set.reps >= 6)
        .fold<int>(0, (max, set) => set.weight > max ? set.weight : max);

    int recordSetWeightLowReps = validSets
        .fold<int>(0, (max, set) => set.weight > max ? set.weight : max);

    List<Map<String, dynamic>> firestoreSets = validSets.map((set) {
      return {
        'reps': set.reps,
        'weight': set.weight,
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
      'recordSetWeight': recordSetWeight,
      'recordSetWeightLowReps': recordSetWeightLowReps,
      'timestamp': FieldValue.serverTimestamp(), // Agrega la fecha actual
      'unit': selectedUnit, // Opcional: añadir la unidad a nivel de ejercicio si es necesario

    }).then((documentReference) {
      print("Exercise Added with ID: ${documentReference.id}");
        // Muestra el snackbar aquí
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Exercise has been added successfully!"),
        backgroundColor: Colors.green,
      ));

      // Cierra el diálogo después de un breve retraso para que el snackbar sea visible
      
        Navigator.pop(context);
      
    }).catchError((e) {
      print("Error adding document: $e");
    });
  } else {
    print("No exercise or gym item selected or user is not logged in.");
  }
}

  @override
  Widget build(BuildContext context) {

    return 
    GestureDetector(
    onTap: () {
      // Esto esconde el teclado al tocar fuera del TextField
      FocusScope.of(context).requestFocus(FocusNode());
    },
      child: exercises == null
          ? Center(child: CircularProgressIndicator())
          : DraggableScrollableSheet(
              initialChildSize: 0.9,
              maxChildSize: 0.9,
              minChildSize: 0.1,
              expand: false,
              builder: (_, controller) {
                return Padding(
                        padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),

                  child: Container(
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 17, 12, 12).withOpacity(0.8),
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
                                  InkWell(
                                    onTap: () {
                                      Navigator.pop(context); // Cierra el BottomSheet cuando se toque "Cancel"
                                    },
                                    child: Text("Cancel",
                                        style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w700,
                                            color: Colors.blue.shade700,
                                            fontFamily: 'Geologica')),
                                  ),
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
                                        fontWeight: FontWeight.w900,
                                        fontSize: 14,
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
                              Row(

                                children: [
                                  Flexible(
                                    flex:2,
                                    child: Autocomplete<Exercise>(
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
                                          Iterable<Exercise> options) 
                                          {

                                         String languageCode = Localizations.localeOf(context).languageCode;
                                          
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
                                                child: ListView.builder(
                                                  padding: EdgeInsets.all(10),
                                                  itemCount: options.length,
                                                  itemBuilder: (BuildContext context, int index) {
                                                    final Exercise option = options.elementAt(index);

                                                    // Obtiene la traducción basada en el idioma del dispositivo, default a inglés si no hay traducción
                                                    String translatedName = option.translations[languageCode] ?? option.name;

                                                    return GestureDetector(
                                                      onTap: () => onSelected(option),
                                                      child: ListTile(

                                                        title: Text(option.name, style: TextStyle(color: Colors.white, fontFamily: 'Geologica', fontWeight: FontWeight.w600, fontSize: 14)), // Nombre en inglés
                                                        subtitle: Text(translatedName, style: TextStyle(color: Colors.grey[200], fontFamily: 'Geologica', fontWeight: FontWeight.w400, fontSize: 12)), // Nombre traducido
                                                        leading: Image.asset('assets/images/icons/${option.exerciseIcon}', width: 30, height: 30),
                                                      ),
                                                    );
                                                  },
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
                                  ),
                                  SizedBox(width: 20),
            Flexible(
              flex:1,
              child: Padding(
                            padding: const EdgeInsets.all(5.0),
                            child: InkWell(
                             onTap: () {
                              setState(() {
                                selectedUnit = selectedUnit == 'KG' ? 'LB' : 'KG'; // Cambia la unidad seleccionada
                                // No necesitas actualizar el exerciseSetProvider aquí.
                              });
                            },
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 4.0, vertical: 4.0),
                                decoration: BoxDecoration(
                                  color: Colors.grey.shade500,
                                  border: Border.all(color: Colors.grey),
                                  borderRadius: BorderRadius.circular(12.0),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    // Icono a la izquierda
                                    Icon(
                                      Icons.chevron_left,
                                      size: 20.0,
                                      color: Colors.white,
                                    ),
                                    // Espacio entre el icono y el texto
                                    SizedBox(width: 4.0),
                                    // Columna para el texto "Medida" y el valor de la unidad
                                    Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Text(
                                          "Unit", // Título encima del valor de la unidad
                                          style: TextStyle(
                                              fontSize: 12.0,
                                              fontWeight: FontWeight.w600,
                                              fontFamily: 'Geologica',
                                              color: Colors.white),
                                        ),
                                        Text(
                                          selectedUnit,
                                          style: TextStyle(
                                            fontSize: 16.0,
                                            fontWeight: FontWeight.w800,
                                            fontFamily: 'Geologica',
                                            color: Colors.white,
                                          ),
                                        ),
                                      ],
                                    ),
                                    // Espacio entre el texto y el icono
                                    SizedBox(width: 4.0),
                                    // Icono a la derecha
                                    Icon(
                                      Icons.chevron_right,
                                      color: Colors.white,
                                      size: 20.0,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
            ),

                                ],
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
                  ),
                );
              },
            ),
    );
  }
}
