import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hearth_rythm/src/core/constants/app_color.dart';
import 'package:hearth_rythm/src/widgets/gradient_container_button.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class CarouselButtonsNorth extends StatefulWidget {
  const CarouselButtonsNorth({super.key});

  @override
  _CarouselButtonsNorthState createState() => _CarouselButtonsNorthState();
}

class _CarouselButtonsNorthState extends State<CarouselButtonsNorth> {
  final PageController _pageController = PageController();

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          height: 150, // Altura del carrusel
          child: PageView(
            controller: _pageController,
            children: [
              Center(
                child: SizedBox(
                  width: 300, // Establece el ancho deseado
                  child: GradientContainerButton(
                    text: "Añadir alumno",
                    onPressed: () {
                      GoRouter.of(context)
                          .push('/north_screen/add_student_screen');
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
                    text: "Notas",
                    onPressed: () {
                      GoRouter.of(context)
                          .push('/north_screen/notas_screen');
                    },
                    textSize: 25,
                    icon: const Icon(Icons.edit_note_rounded),
                  ),
                ),
              ),
              Center(
                child: SizedBox(
                  width: 300,
                  child: GradientContainerButton(
                    text: "Porcentaje por Mes",
                    onPressed: () {
                      GoRouter.of(context)
                          .push('/north_screen/pagos_screen');
                    },
                    textSize: 20,
                    icon: const Icon(Icons.attach_money_outlined),
                  ),
                ),
              ),
            ],
          ),
        ),
        SmoothPageIndicator(
          controller: _pageController,
          count: 3,
          effect: ExpandingDotsEffect(
            dotHeight: 8,
            dotWidth: 8,
            activeDotColor: AppColors.primaryStart, // Cambia a tu color preferido
            dotColor:
                Colors.grey.withOpacity(0.5), // Cambia a tu color preferido
            expansionFactor: 2, // Expansión del punto activo
            spacing: 8, // Espacio entre los puntos
          ),
        ),
      ],
    );
  }
}
