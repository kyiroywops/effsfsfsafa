// gym_item.dart
class GymItem {
  final String name;
  final String iconPath;

  GymItem({required this.name, required this.iconPath});

  // Método para crear una instancia de GymItem a partir de un mapa
  factory GymItem.fromJson(Map<String, dynamic> json) {
    return GymItem(
      name: json['name'] as String? ?? 'Default Name', // Proporciona 'Default Name' si json['name'] es null
      iconPath: json['icon'] as String? ?? 'assets/images/icons/hombros1.png', // Asegúrate de que la clave sea 'icon' y no 'iconPath'
    );
  }

  // Método para convertir la instancia de GymItem a un mapa
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'iconPath': iconPath, // Aquí también puedes cambiar 'iconPath' a 'icon' si lo deseas para ser coherente con el JSON
    };
  }
}
