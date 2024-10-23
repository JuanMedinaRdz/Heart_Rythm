import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:hearth_rythm/src/widgets/north/navbar_north_screen.dart';

class EventsScreen extends StatelessWidget {
  const EventsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Eventos"),
      ),
      body: Center(
        child: Text("Pantalla de eventos"),
      ),
      bottomNavigationBar: const NavBarNorth(currentIndex: 1), // '1' para indicar que está en eventos
    );
  }
}