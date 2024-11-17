import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hearth_rythm/src/widgets/gradient_container_button_south.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class CarouselButtonsSouth extends StatefulWidget {
  const CarouselButtonsSouth({super.key});

  @override
  _CarouselButtonsSouthState createState() => _CarouselButtonsSouthState();
}

class _CarouselButtonsSouthState extends State<CarouselButtonsSouth> {
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
                  child: GradientContainerButtonSouth(
                    text: "Añadir alumno",
                    onPressed: () {
                      GoRouter.of(context)
                          .push('/south_screen/add_student_south_screen');
                    },
                    textSize: 20,
                    icon: const Icon(Icons.group_add_outlined),
                  ),
                ),
              ),
              Center(
                child: SizedBox(
                  width: 300,
                  child: GradientContainerButtonSouth(
                    text: "Tomar asistencia",
                    onPressed: () {
                      GoRouter.of(context)
                          .push('/south_screen/check_list');
                    },
                    textSize: 20,
                    icon: const Icon(Icons.check_box_outlined),
                  ),
                ),
              ),
            ],
          ),
        ),
        SmoothPageIndicator(
          controller: _pageController,
          count: 2,
          effect: ExpandingDotsEffect(
            dotHeight: 8,
            dotWidth: 8,
            activeDotColor: Colors.blue, // Cambia a tu color preferido
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
