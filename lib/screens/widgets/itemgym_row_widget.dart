import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gymtrack/infrastructure/models/gym_item_model.dart';
import 'package:gymtrack/screens/providers/selectedgymitem_provider.dart';



// Cambia a ConsumerStatefulWidget
class GymItemRow extends ConsumerStatefulWidget {
  @override
  _GymItemRowState createState() => _GymItemRowState();
}

// Extiende de ConsumerState
class _GymItemRowState extends ConsumerState<GymItemRow> {
  final List<GymItem> gymItems = [
    GymItem(name: 'Dumbbell', iconPath: 'assets/images/icons/mancuernas.png'),
    GymItem(name: 'Olympic Barbell', iconPath: 'assets/images/icons/barraolimpica.png'),
    GymItem(name: 'Machine', iconPath: 'assets/images/icons/maquina.png'),
    GymItem(name: 'Pulley', iconPath: 'assets/images/icons/maquinapolea.png'),
    GymItem(name: 'Smith Machine', iconPath: 'assets/images/icons/multipower.png'),
  ];
  
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width / gymItems.length; // Calcula el ancho para cada elemento.

    return Container(
      height: 120, // Ajusta la altura para permitir dos líneas de texto.
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: gymItems.length,
        itemBuilder: (context, index) {
          // Usa ref.watch para reaccionar a cambios en el provider.
          GymItem? selectedGymItem = ref.watch(selectedGymItemProvider);
          bool isSelected = selectedGymItem?.name == gymItems[index].name;

          return GestureDetector(
            onTap: () {
              // Usa ref.read para actualizar el estado del provider.
              ref.read(selectedGymItemProvider.notifier).state = gymItems[index];
            },
            child: Container(
              width: width, // Asigna el ancho calculado a cada contenedor.
              padding: EdgeInsets.all(8),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start, // Alinea los íconos en la parte superior.
                crossAxisAlignment: CrossAxisAlignment.center, // Centra los elementos horizontalmente.
                children: [
                  CircleAvatar(
                    radius: 25,
                    backgroundColor: Colors.white,
                    child: Image.asset(gymItems[index].iconPath),
                  ),
                  Expanded(
                    child: Center(
                      child: Text(
                        gymItems[index].name,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontFamily: 'Geologica',
                          fontSize: 11,
                          fontWeight: isSelected ? FontWeight.w900 : FontWeight.w600,
                          color: isSelected ? Colors.brown : Colors.white,
                        ),
                        maxLines: 2, // Permite hasta dos líneas de texto.
                        overflow: TextOverflow.clip, // Evita puntos suspensivos y cortes innecesarios.
                      ),
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