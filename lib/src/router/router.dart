import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hearth_rythm/main.dart';
import 'package:hearth_rythm/src/features/dance_classes/cumbia_screen.dart';
import 'package:hearth_rythm/src/features/dance_classes/events_screen.dart';
import 'package:hearth_rythm/src/features/dance_classes/north_screen.dart';
import 'package:hearth_rythm/src/features/dance_classes/salsa_screen.dart';
import 'package:hearth_rythm/src/features/dance_classes_south/alumnos_list_screen.dart';
import 'package:hearth_rythm/src/features/dance_classes_south/south_screen.dart';
import 'package:hearth_rythm/src/features/home_screen.dart';
import 'package:hearth_rythm/src/features/students/add_student_screen.dart';
import 'package:hearth_rythm/src/features/students/add_student_south_screen.dart';
import 'package:hearth_rythm/src/features/students/student_detail_screen.dart';
import 'package:hearth_rythm/src/features/students/student_detail_south_screen.dart';
import 'package:hearth_rythm/src/widgets/north/mensualidades.dart';
import 'package:hearth_rythm/src/widgets/notas.dart';
import 'package:hearth_rythm/src/widgets/south/mensualidades_south.dart';

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
          path: 'notas_screen',
          name: 'notas_screen',
          builder: (context, state) {
            return const NotasScreen();
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
          path: 'cumbia_screen',
          name: 'cumbia_screen',
          builder: (context, state) {
            return const CumbiaScreen();
          },
        ),
        GoRoute(
          path: 'pagos_screen',
          name: 'pagos_screen',
          builder: (context, state) {
            return const MensualidadScreen();
          },
        ),
        GoRoute(
          path: 'student_detail_screen',
          name: 'student_detail_screen',
          builder: (context, state) {
            return const StudentDetailScreen(
              studentData: {},
              name: '',
              docId: '',
            );
          },
        ),
      ],
    ),
    // Clase padre de SouthScreen para anidamiento de otras clases.
    GoRoute(
      path: '/south_screen',
      name: 'south_screen',
      builder: (context, state) {
        return const SouthScreen();
      },
      routes: [
        GoRoute(
          path: 'add_student_south_screen',
          name: 'add_student_south_forms',
          builder: (context, state) {
            return const AddStudentScreenSouth();
          },
        ),
                GoRoute(
          path: 'mensualidades_south_screen',
          name: 'mensualidades_south_screen',
          builder: (context, state) {
            return const MensualidadesSouthScreen();
          },
        ),
        GoRoute(
          path: 'salsa_south_screen',
          name: 'salsa_south_screen',
          builder: (context, state) {
            return const AlumnosListScreen();
          },
        ),
        GoRoute(
          path: 'student_detail_screen',
          name: 'student_detail_screen2',
          builder: (context, state) {
            return const StudentDetailSouthScreen(
              studentData: {},
              name: '',
              docId: '',
            );
          },
        ),
      ],
    ),
  ],
);
