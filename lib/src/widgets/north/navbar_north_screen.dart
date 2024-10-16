import 'package:flutter/material.dart';
import 'package:hearth_rythm/src/core/constants/app_color.dart';

class NavBarNorth extends StatelessWidget {
  const NavBarNorth({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'Inicio',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.event),
          label: 'Eventos',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.settings),
          label: 'Configuración',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person),
          label: 'Perfil',
        ),
      ],
      currentIndex: 0, // Cambia esto según el estado actual
      selectedItemColor: AppColors.primaryStart,
      unselectedItemColor: AppColors.iconColor,
      onTap: (index) {
        // Maneja la navegación aquí
      },
    );
  }
}
