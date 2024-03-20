import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class SeriesWidget extends StatefulWidget {
  @override
  _SeriesWidgetState createState() => _SeriesWidgetState();
}

class _SeriesWidgetState extends State<SeriesWidget> {
  List<List<bool>> series = [
    List<bool>.filled(20, false),
  ];
  List<int> weights = [0];
  List<TextEditingController> weightControllers = [];

   String selectedUnit = 'KG'; // Valor inicial para el dropdown
  List<String> units = ['KG', 'LB']; // Las opciones para el dropdown

  List<int> counts = [0];  // Un contador para cada serie que empieza en 0
  List<TextEditingController> countControllers = [];

List<bool> isSelectedList = [false]; // Comienza con un elemento para la serie inicial

 @override
void initState() {
  super.initState();
  weightControllers.add(TextEditingController(text: weights[0].toString()));
  countControllers.add(TextEditingController(text: counts[0].toString())); // Nuevo controlador para el contador
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
  }

// Actualiza _addSerie para manejar el nuevo estado de selección para la serie agregada
void _addSerie() {
  setState(() {
    series.add(List<bool>.filled(20, false));
    weights.add(0);
    counts.add(0);
    isSelectedList.add(false); // Añadir estado de selección por defecto para la nueva serie

    weightControllers.add(TextEditingController(text: weights.last.toString()));
    countControllers.add(TextEditingController(text: counts.last.toString()));
  });
}


  void _updateWeight(int serieIndex, int delta) {
    setState(() {
      weights[serieIndex] = (weights[serieIndex] + delta).clamp(0, 999);
      weightControllers[serieIndex].text = weights[serieIndex].toString();
    });
  }

void _updateCount(int serieIndex, int delta) {
  setState(() {
    counts[serieIndex] = (counts[serieIndex] + delta).clamp(0, 20); // Asumiendo un máximo de 20
    countControllers[serieIndex].text = counts[serieIndex].toString();
  });
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
                child: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text('Set ${serieIndex + 1} ', style: TextStyle(
                        fontFamily: 'Geologica', fontWeight: FontWeight.w600,
                        color: Colors.white,
                        
                      ),),
                    ),
                    ...entry.value.asMap().entries.map((innerEntry) {
                      int index = innerEntry.key;
                      bool isActive = innerEntry.value;
                     return GestureDetector(
                      onTap: () => _handleTap(serieIndex, index),
                      child: Container(
                        width: 30,
                        height: 30,
                        margin: EdgeInsets.symmetric(horizontal: 2),
                        decoration: BoxDecoration(
                          color: isActive ? (index < counts[serieIndex] ? Colors.blue : Colors.brown) : Colors.grey,
                          shape: BoxShape.rectangle,
                          borderRadius: BorderRadius.circular(12),
                          
                        ),
                        child: Center(child: Text('${index + 1}', style: TextStyle(
                          fontFamily: 'Geologica',
                          fontWeight: FontWeight.w400,
                          color: Colors.white,

                        ),)),
                      ),
                    );
                    }).toList(),
                  ],
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
                              
                              
                              decoration: BoxDecoration(
                                border: Border.all(
                  color: isSelectedList[serieIndex] ? Colors.blue : Colors.grey,
                  width: 1.0,
                                ),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Row(
                                children: <Widget>[
                  IconButton(
                            icon: Icon(Icons.remove, size: 10,
                            color:  Colors.white,
                            
                            ),
                            onPressed: () => _updateWeight(serieIndex, -1),
                               padding: EdgeInsets.zero, // Elimina padding adicional
                            constraints: BoxConstraints(minWidth: 10, minHeight: 10), // Menores restricciones
                  ),
                  Column(
                            children: [
                              Text(
                                "Weight",
                                style: TextStyle(fontSize: 10
                                ,
                                fontFamily: 'Geologica',
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                                ),
                              ),
                              Container(
                                width: 35,
                                height: 35, // Altura fija para el TextField
                                child: TextField(
                  textAlign: TextAlign.center,
                  controller: weightControllers[serieIndex],
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    
                    border: InputBorder.none,
                    hintText: '0',
                  ),
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800, fontFamily: 'Geologica', color: Colors.white),
                                ),
                              ),
                            ],
                  ),
                  IconButton(
                            icon: Icon(Icons.add, size: 20
                            ,
                            color:  Colors.white,),
                               padding: EdgeInsets.zero, // Elimina padding adicional
                            constraints: BoxConstraints(minWidth: 10, minHeight: 10), // Menores restricciones
                            
                            onPressed: () => _updateWeight(serieIndex, 1),
                  ),
                                ],
                              ),
                            ),
                          ),
                  
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: InkWell(
                          onTap: () {
                            setState(() {
                              // Cambia entre KG y LB cuando se toca
                              selectedUnit = (selectedUnit == 'KG') ? 'LB' : 'KG';
                            });
                          },
                          child: Container(
                            padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                            decoration: BoxDecoration(
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
                                        color: Colors.white
                                        
                                      ),
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
                  
                  
                  
                  
                  
                  
                  
                  
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                              decoration: BoxDecoration(
                                border: Border.all(
                  color: Colors.grey,
                  width: 1.0,
                                ),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                  IconButton(
                            icon: Icon(Icons.remove, size: 20, 
                            color:  Colors.white),
                            onPressed: () => _updateCount(serieIndex, -1),
                  ),
                  Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                "Assists", // Puedes cambiar este texto por lo que corresponda (ej. "Reps" para repeticiones)
                                style: TextStyle(fontSize: 10,
                                fontFamily: 'Geologica',
                                fontWeight: FontWeight.w600,
                                color: Colors.white,),
                              ),
                              Container(
                                width: 35,
                                height: 35,
                                child: TextField(
                  controller: countControllers[serieIndex],
                  keyboardType: TextInputType.number,
                  textAlign: TextAlign.center,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: '0',
                  ),
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800, fontFamily: 'Geologica', color: Colors.white),
                                ),
                              ),
                            ],
                  ),
                  IconButton(
                            icon: Icon(Icons.add, size: 20, color: Colors.white,),
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
          onPressed: _addSerie,
          child: Text('Add set', style: TextStyle(
            fontFamily: 'Geologica',
            fontWeight: FontWeight.w800,
            fontSize: 12,
            color: Colors.black,
          ),),
          
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

  @override
  void dispose() {
    for (var controller in weightControllers) {
      controller.dispose();
    }
    super.dispose();
  }

}

