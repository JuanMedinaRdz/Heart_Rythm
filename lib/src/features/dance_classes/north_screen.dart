import 'package:flutter/material.dart';
import 'package:hearth_rythm/src/widgets/north/calendar_widget.dart';
import 'package:hearth_rythm/src/widgets/north/carousel_buttons_north_screen.dart';
import 'package:hearth_rythm/src/widgets/north/navbar_north_screen.dart';

class NorthScreen extends StatelessWidget {
  const NorthScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("North Screen"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body:  const Column(
        children: [
          // Carrusel de botones
          CarouselButtonsNorth(),
          // Calendario
          CalendarWidget(),
        ],
      ),
      bottomNavigationBar: const NavBarNorth(currentIndex: 0,),
    );
  }
}




