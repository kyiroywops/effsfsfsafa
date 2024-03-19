import 'package:flutter/material.dart';

class GymItem {
  final String name;
  final String iconPath;

  GymItem({required this.name, required this.iconPath});
}

class GymItemRow extends StatefulWidget {
  @override
  _GymItemRowState createState() => _GymItemRowState();
}

class _GymItemRowState extends State<GymItemRow> {
  int selectedIndex = -1; // Inicialmente, ningún ítem está seleccionado

  // Lista de elementos del gimnasio
  final List<GymItem> gymItems = [
    GymItem(name: 'Mancuerna', iconPath: 'assets/images/icons/mancuernas.png'),
    GymItem(name: 'Barra', iconPath: 'assets/images/icons/mancuernas.png'),
    GymItem(name: 'Máquina', iconPath: 'assets/images/icons/mariposa.png'),
    GymItem(name: 'Polea', iconPath: 'assets/images/icons/mancuernas.png'),
    GymItem(name: 'Multipower', iconPath: 'assets/images/icons/mancuernas.png'),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100, // Ajusta según necesidad
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: gymItems.length,
        itemBuilder: (context, index) {
          bool isSelected = index == selectedIndex;
          GymItem gymItem = gymItems[index];

          return GestureDetector(
            onTap: () {
              setState(() {
                selectedIndex = index; // Marca el ítem como seleccionado
              });
            },
            child: Container(
              padding: EdgeInsets.all(8),
              child: Column(
                children: [
                  CircleAvatar(
                    backgroundColor: isSelected ? Colors.grey[900] : Colors.grey,
                    child: Image.asset(gymItem.iconPath), // Usa la imagen específica de cada elemento del gimnasio
                  ),
                  SizedBox(height: 5), // Agrega un poco de espacio entre el ícono y el texto
                  Text(gymItem.name), // Usa el nombre específico de cada elemento del gimnasio
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
