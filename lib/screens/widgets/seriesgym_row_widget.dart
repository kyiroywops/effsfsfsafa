import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gymtrack/infrastructure/models/exercises_setmodels.dart';

final exerciseSetProvider =
    StateNotifierProvider<ExerciseSetListNotifier, List<ExerciseSet>>((ref) {
  return ExerciseSetListNotifier();
});

class ExerciseSetListNotifier extends StateNotifier<List<ExerciseSet>> {
  ExerciseSetListNotifier()
      : super([ExerciseSet(reps: 0, weight: 0,  assists: 0)]);

  void updateReps(int index, int reps) {
    if (index >= 0 && index < state.length) {
      var set = state[index];
      state = [
        ...state.sublist(0, index),
        ExerciseSet(
          reps: reps,
          weight: set.weight,
          assists: set.assists,
        ),
        ...state.sublist(index + 1),
      ];
    }
  }

  void addSet() {
    state = [...state, ExerciseSet(reps: 0, weight: 0, assists: 0)];
  }

  void updateSet(int index, ExerciseSet updatedSet) {
    if (index >= 0 && index < state.length) {
      var newSet = state[index].copyWith(
        reps: updatedSet.reps,
        weight: updatedSet.weight,
        assists: updatedSet.assists,
      );
      state = [
        ...state.sublist(0, index),
        newSet,
        ...state.sublist(index + 1),
      ];
    }
  }
}

class SeriesWidget extends ConsumerStatefulWidget {
  @override
  _SeriesWidgetState createState() => _SeriesWidgetState();
}

class _SeriesWidgetState extends ConsumerState<SeriesWidget> {
  List<List<bool>> series = [
    List<bool>.filled(40, false),
  ];
  List<int> weights = [0];
  List<TextEditingController> weightControllers = [];


  List<int> counts = [0]; // Un contador para cada serie que empieza en 0
  List<TextEditingController> countControllers = [];

  List<bool> isSelectedList = [
    false
  ]; // Comienza con un elemento para la serie inicial

  @override
  void initState() {
    super.initState();

    var initialSet = ref.read(exerciseSetProvider.notifier).state.first;

    weights = [initialSet.weight]; // Inicializa con el peso del primer set
    counts = [
      initialSet.assists
    ]; // Inicializa con las asistencias del primer set
    series = [
      List<bool>.filled(40, false)
    ]; // Inicializa la serie con todos falsos

for (var exerciseSet in ref.read(exerciseSetProvider)) {
    weightControllers.add(TextEditingController(text: exerciseSet.weight.toString()));
    countControllers.add(TextEditingController(text: exerciseSet.assists.toString()));
  }
    // Crea controladores de texto para el peso y las asistencias del primer set
    // Añadir listeners a los controladores existentes.
    for (int i = 0; i < weightControllers.length; i++) {
      weightControllers[i].addListener(() {
        _handleWeightControllerChanged(i);
      });
    }
    countControllers.add(TextEditingController(text: counts[0].toString()));
  }

  void _handleTap(int serieIndex, int index) {
    setState(() {
      for (int i = 0; i <= index; i++) {
        series[serieIndex][i] = true;
      }
      for (int i = index + 1; i < series[serieIndex].length; i++) {
        series[serieIndex][i] = false;
      }
    });
    // Aquí actualizamos las repeticiones en el estado de Riverpod.
    ref.read(exerciseSetProvider.notifier).updateReps(serieIndex, index + 1);
  }

  Widget _buildAssistsTextField(int serieIndex) {
  return TextFormField(
    controller: countControllers[serieIndex],
    keyboardType: TextInputType.number,
    textAlign: TextAlign.center,
    decoration: InputDecoration(
      border: InputBorder.none,
      hintText: '0',
    ),
    style: TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w800,
      fontFamily: 'Geologica',
      color: Colors.white,
    ),
    onChanged: (value) {
      int newAssists = int.tryParse(value) ?? 0;
      // Verifica si el valor actual es diferente para evitar llamadas innecesarias al estado.
      if (newAssists != ref.read(exerciseSetProvider)[serieIndex].assists) {
        ref.read(exerciseSetProvider.notifier).updateSet(
          serieIndex,
          ref.read(exerciseSetProvider)[serieIndex].copyWith(assists: newAssists),
        );
      }
    },
  );
}

// Actualiza _addSerie para manejar el nuevo estado de selección para la serie agregada
 void _addSerie() {
  setState(() {
    series.add(List<bool>.filled(40, false));
    weights.add(0);
    counts.add(0);
    isSelectedList.add(false);
    
    // Asegúrate de añadir nuevos controladores a las listas
    weightControllers.add(TextEditingController(text: '0'));
    countControllers.add(TextEditingController(text: '0'));
  });

  ref.read(exerciseSetProvider.notifier).addSet();
}

 void _updateWeight(int serieIndex, int delta) {
  final newWeight = (weights[serieIndex] + delta).clamp(0, 999);
  if (newWeight != weights[serieIndex]) {
    weights[serieIndex] = newWeight;
    weightControllers[serieIndex].text = newWeight.toString(); // Asegúrate de que esto se hace
    ref.read(exerciseSetProvider.notifier).updateSet(
      serieIndex,
      ref.read(exerciseSetProvider)[serieIndex].copyWith(weight: newWeight),
    );
  }
}

  void _handleWeightControllerChanged(int index) {
    if (index < weightControllers.length) {
      int newWeight = int.tryParse(weightControllers[index].text) ?? 0;
      var currentSet = ref.read(exerciseSetProvider)[index];
      if (newWeight != currentSet.weight) {
        // Solo actualiza si el peso ha cambiado.
        ref
            .read(exerciseSetProvider.notifier)
            .updateSet(index, currentSet.copyWith(weight: newWeight));
      }
    }
  }

  void _updateCount(int serieIndex, int delta) {
    var currentSets = ref.read(exerciseSetProvider);
    if (serieIndex < currentSets.length) {
      int newCount = (counts[serieIndex] + delta).clamp(0, 40);
      setState(() {
        counts[serieIndex] = newCount;
        countControllers[serieIndex].text = newCount.toString();
      });
      ref.read(exerciseSetProvider.notifier).updateSet(
          serieIndex, currentSets[serieIndex].copyWith(assists: newCount));
    }
  }

@override
void dispose() {
  // Simplemente dispone los controladores de texto.
  // Esto automáticamente removerá los listeners asociados.
  for (var controller in weightControllers) {
    controller.dispose();
  }

  for (var controller in countControllers) {
    controller.dispose();
  }

  super.dispose();
}


  @override
  Widget build(BuildContext context) {


    return Column(
      children: [
        ...series.asMap().entries.map((entry) {
          int serieIndex = entry.key;
          return Column(
            children: [
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Container(
                  child: Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          'Set ${serieIndex + 1} ',
                          style: TextStyle(
                            fontFamily: 'Geologica',
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      ...entry.value.asMap().entries.map((innerEntry) {
                        int index = innerEntry.key;
                        bool isActive = innerEntry.value;
                        return GestureDetector(
                       
                        onPanUpdate: (details) {
                      // Aquí, calcula el índice del cuadrado basado en la posición del gesto
                      final index = calculateSquareIndex(details.localPosition);
                      if (index != -1) {
                      // Esto asume que tienes una lista de índices y solo quieres agregar índices nuevos
                    final currentIndexList = ref.read(squareSelectionProvider.state).state;
                    if (!currentIndexList.contains(index)) {
                      ref.read(squareSelectionProvider.state).state = [...currentIndexList, index];
                    }
                      }
                    },

                          onTap: () => _handleTap(serieIndex, index),
                          child: Container(
                            width: 30,
                            height: 30,
                            margin: EdgeInsets.symmetric(horizontal: 2),
                            decoration: BoxDecoration(
                              color: isActive
                                  ? (index < counts[serieIndex]
                                      ? Colors.blue
                                      : Colors.brown)
                                  : Colors.grey,
                              shape: BoxShape.rectangle,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Center(
                                child: Text(
                              '${index + 1}',
                              style: TextStyle(
                                fontFamily: 'Geologica',
                                fontWeight: FontWeight.w400,
                                color: Colors.white,
                              ),
                            )),
                          ),
                        );
                      }).toList(),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                     Padding(
  padding: const EdgeInsets.all(8.0),
  child: Container(
    
    height: 65,
    decoration: BoxDecoration(
      color: Colors.brown.shade900,
      
      borderRadius: BorderRadius.circular(10),
    ),
    child: Row(
      children: <Widget>[
        IconButton(
          icon: Icon(Icons.remove, size: 20, color: Colors.grey.shade200),
          onPressed: () => _updateWeight(serieIndex, -1),
          padding: EdgeInsets.zero, // Elimina padding adicional
          constraints: BoxConstraints(minWidth: 10, minHeight: 10), // Menores restricciones
        ),
        Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 12),
              child: Text(
                "Weight",
                style: TextStyle(
                  fontSize: 10,
                  fontFamily: 'Geologica',
                  fontWeight: FontWeight.w800,
                  color: Colors.grey.shade200,
                ),
              ),
            ),
            Container(
              width: 45,
              height: 35, // Altura fija para el TextField
              child: TextField(
                textAlign: TextAlign.center,
                controller: weightControllers[serieIndex],
                keyboardType: TextInputType.numberWithOptions(decimal: false),
                decoration: InputDecoration(
                  
                  border: InputBorder.none,
                  hintText: '0',
                ),
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                    fontFamily: 'Geologica',
                    color: Colors.grey.shade200),
                onChanged: (value) {
                  // Actualiza el estado cuando se ingresa un valor manualmente
                  int newWeight = int.tryParse(value) ?? weights[serieIndex];
                  _updateWeight(serieIndex, newWeight - weights[serieIndex]);
                },
              ),
            ),
          ],
        ),
        IconButton(
          icon: Icon(Icons.add, size: 20, color: Colors.white),
          onPressed: () => _updateWeight(serieIndex, 1),
          padding: EdgeInsets.zero, // Elimina padding adicional
          constraints: BoxConstraints(minWidth: 10, minHeight: 10), // Menores restricciones
        ),
      ],
    ),
  ),
),

               
                  Padding(
  padding: const EdgeInsets.all(8.0),
  child: Container(
    decoration: BoxDecoration(
      color: Colors.blueGrey.shade400,
      
      borderRadius: BorderRadius.circular(10),
    ),
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        IconButton(
          icon: Icon(Icons.remove, size: 20, color: Colors.white),
          onPressed: () => _updateCount(serieIndex, -1),
        ),
        Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 12),
              child: Text(
                "Assists",
                style: TextStyle(
                  fontSize: 10,
                  fontFamily: 'Geologica',
                  fontWeight: FontWeight.w800,
                  color: Colors.white,
                ),
              ),
            ),
            
            Container(
              width: 35,
              height: 33,
              // Reemplaza el TextField por el método _buildAssistsTextField
              child: _buildAssistsTextField(serieIndex),
            ),
          ],
        ),
        IconButton(
          icon: Icon(Icons.add, size: 20, color: Colors.white),
          onPressed: () => _updateCount(serieIndex, 1),
        ),
      ],
    ),
  ),
)
                    ],
                  ),
                ),
              ),
            ],
          );
        }).toList(),
        ElevatedButton(
          onPressed: () {
            // Cuando se presiona el botón, agregas un nuevo set utilizando Riverpod
            ref.read(exerciseSetProvider.notifier).addSet();
            // Además, agregas la lógica de la UI para actualizar la interfaz de usuario localmente
            _addSerie();
          },
          child: Text(
            'Add set',
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
    );
  }
}


final squareSelectionProvider = StateProvider<List<int>>((ref) => []);

int calculateSquareIndex(Offset localPosition) {
  double squareWidth = 30; // Asumiendo cada cuadrado tiene 30 pixels de ancho + margen
  int index = (localPosition.dx / squareWidth).floor();
  return index;
}