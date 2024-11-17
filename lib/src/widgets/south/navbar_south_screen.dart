import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hearth_rythm/src/core/constants/app_color.dart';

class NavBarSouth extends StatelessWidget {
  final int
      currentIndex; // Agregamos currentIndex para gestionar el estado de la selección

  const NavBarSouth({
    super.key,
    required this.currentIndex, // Recibe el currentIndex como parámetro
  });

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      currentIndex: currentIndex, // Actualiza el índice según el estado actual
      selectedItemColor: AppColors.southGamma,
      unselectedItemColor: AppColors.iconColor,
      onTap: (index) {
        switch (index) {
          case 0: // Inicio
            GoRouter.of(context)
                .go('/south_screen'); // Navegar a la pantalla de inicio
            break;
          case 1: // Eventos
            GoRouter.of(context)
                .go('/south_screen/salsa_south_screen'); // Navegar a la pantalla de eventos
            break;
          case 2: // Configuración
            // Navegar a la pantalla de configuración (si tienes una)
            GoRouter.of(context).go('/south_screen/salsa_bachata_screen');
            break;

        }
      },
      items: [
        const BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'Inicio',
        ),
  BottomNavigationBarItem(
          icon: Image.asset('lib/src/core/assets/images/salsa.png'),
          label: 'Salsa/Bachata',
        ),
       BottomNavigationBarItem(
          icon: Image.asset('lib/src/core/assets/images/dancing.png'),
          label: 'Cumbia',
        ),
      ],
    );
  }
}
