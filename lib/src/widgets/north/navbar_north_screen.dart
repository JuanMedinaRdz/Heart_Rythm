import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hearth_rythm/src/core/constants/app_color.dart';

class NavBarNorth extends StatelessWidget {
  final int
      currentIndex; // Agregamos currentIndex para gestionar el estado de la selección

  const NavBarNorth({
    super.key,
    required this.currentIndex, // Recibe el currentIndex como parámetro
  });

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      currentIndex: currentIndex, // Actualiza el índice según el estado actual
      selectedItemColor: AppColors.primaryStart,
      unselectedItemColor: AppColors.iconColor,
      onTap: (index) {
        switch (index) {
          case 0: // Inicio
            GoRouter.of(context)
                .push('/north_screen'); // Navegar a la pantalla de inicio
            break;
          case 1: // Configuración
            // Navegar a la pantalla de configuración (si tienes una)
            GoRouter.of(context).push('/north_screen/salsa_bachata_screen');
            break;


        }
      },
      items: [
        const BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'Inicio',
        ),

        BottomNavigationBarItem(
          icon: Icon(Icons.person_search_rounded),
          label: 'Alumnos',
        ),

      ],
    );
  }
}
