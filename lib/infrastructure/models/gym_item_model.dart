// gym_item.dart
class GymItem {
  final String name;
  final String iconPath;

  GymItem({required this.name, required this.iconPath});

  // Método para crear una instancia de GymItem a partir de un mapa
  factory GymItem.fromJson(Map<String, dynamic> json) {
    return GymItem(
      name: json['name'], // Asegúrate de que la llave 'name' coincide con cómo está en tu JSON
      iconPath: json['iconPath'], // Asegúrate de que la llave 'iconPath' coincide con cómo está en tu JSON
    );
  }

  // Método para convertir la instancia de GymItem a un mapa
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'iconPath': iconPath,
    };
  }
}
