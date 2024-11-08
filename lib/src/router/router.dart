import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hearth_rythm/main.dart';
import 'package:hearth_rythm/src/features/dance_classes/events_screen.dart';
import 'package:hearth_rythm/src/features/dance_classes/north_screen.dart';
import 'package:hearth_rythm/src/features/dance_classes/salsa_screen.dart';
import 'package:hearth_rythm/src/features/home_screen.dart';
import 'package:hearth_rythm/src/features/students/add_student_screen.dart';
import 'package:hearth_rythm/src/features/students/student_detail_screen.dart';

void main() => runApp(const MainApp());

final GoRouter router = GoRouter(
  // Ruta inicial
  initialLocation: '/home',
  routes: [
    GoRoute(
      path: '/home',
      name: 'home_screen',
      builder: (context, state) {
        return const HomeScreen();
      },
    ),
    //Clase Padre de NorthScreen para anidamiento de otras clases.
    GoRoute(
      path: '/north_screen',
      name: 'north_screen',
      builder: (context, state) {
        return const NorthScreen();
      },
      //Ruta anidada para detalles de North_Screen
      routes: [
        GoRoute(
          path: 'add_student_screen',
          name: 'add_student_forms',
          builder: (context, state) {
            return const AddStudentScreen();
          },
        ),
        GoRoute(
          path: 'events_screen',
          name: 'events_screen',
          builder: (context, state) {
            return const EventsScreen();
          },
        ),
        GoRoute(
          path: 'salsa_bachata_screen',
          name: 'salsa_bachata_screen',
          builder: (context, state) {
            return const SalsaBachataScreen();
          },
        ),
        GoRoute(
          path: 'student_detail_screen',
          name: 'student_detail_screen',
          builder: (context, state) {
            return const StudentDetailScreen(studentData: {}, name: '', docId: '',);
          },
        ),
      ],
    ),
    // Clase padre de SouthScreen para anidamiento de otras clases.
  ],
);
