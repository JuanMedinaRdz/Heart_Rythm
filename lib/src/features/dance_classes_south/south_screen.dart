import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hearth_rythm/src/widgets/south/calendar_south_widget.dart';
import 'package:hearth_rythm/src/widgets/south/carousel_buttons_south_screen.dart';
import 'package:hearth_rythm/src/widgets/south/navbar_south_screen.dart';

class SouthScreen extends StatelessWidget {
  const SouthScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("South Screen"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => GoRouter.of(context).push('/home'),
        ),
      ),
      body:  const Column(
        children: [
          // Carrusel de botones
          CarouselButtonsSouth(),
          // Calendario
          CalendarSouthWidget(),
        ],
      ),
      bottomNavigationBar: const NavBarSouth(currentIndex: 0,),
    );
  }
}




