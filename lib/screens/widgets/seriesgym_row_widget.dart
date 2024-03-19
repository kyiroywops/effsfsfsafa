import 'package:flutter/material.dart';

class SeriesWidget extends StatefulWidget {
  @override
  _SeriesWidgetState createState() => _SeriesWidgetState();
}

class _SeriesWidgetState extends State<SeriesWidget> {
  List<List<bool>> series = [[false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false]];

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

  void _addSerie() {
    setState(() {
      series.add(List<bool>.filled(20, false));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ...series.asMap().entries.map((entry) {
          int serieIndex = entry.key;
          List<bool> serie = entry.value;
          // Envolver el Row en un SingleChildScrollView
          return SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                Text('Serie ${serieIndex + 1}: '),
                ...serie.asMap().entries.map((innerEntry) {
                  int index = innerEntry.key;
                  bool isActive = innerEntry.value;
                  return GestureDetector(
                    onTap: () => _handleTap(serieIndex, index),
                    child: Container(
                      width: 20,
                      height: 20,
                      margin: EdgeInsets.symmetric(horizontal: 2), // Añadir un pequeño espacio entre cada círculo
                      decoration: BoxDecoration(
                        color: isActive ? Colors.green : Colors.grey,
                        shape: BoxShape.circle,
                      ),
                      child: Center(child: Text('${index + 1}')),
                    ),
                  );
                }).toList(),
              ],
            ),
          );
        }).toList(),
        ElevatedButton(
          onPressed: _addSerie,
          child: Icon(Icons.add),
        ),
      ],
    );
  }
}
