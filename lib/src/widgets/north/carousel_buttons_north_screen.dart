import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hearth_rythm/src/widgets/gradient_container_button.dart';

class CarouselButtonsNorth extends StatelessWidget {
  const CarouselButtonsNorth({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 150, // Altura del carrusel
      child: PageView(
        children: [
          Center(
            child: SizedBox(
              width: 300, // Establece el ancho deseado
              child: GradientContainerButton(
                text: "Añadir alumno",
                onPressed: () {
                   GoRouter.of(context).push('/north_screen/add_student_screen');
                },
                textSize: 20,
                icon: const Icon(Icons.group_add_outlined),
              ),
            ),
          ),
          Center(
            child: SizedBox(
              width: 300,
              child: GradientContainerButton(
                text: "Tomar asistencia",
                onPressed: () {
                  // Acción del botón 2
                },
                textSize: 20,
                icon: const Icon(Icons.check_box_outlined),
    
              ),
              
            ),
          ),
        ],
      ),
    );
  }
}