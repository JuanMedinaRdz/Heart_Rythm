import 'package:flutter/material.dart';

class AppColors {
  // Colores para los botones primarios
  static const Color primaryStart = Color(0xFFFF8177); // Color inicial del degradado
  static const Color primaryEnd = Color(0xFFB12A5B);
  static const Color secondStart = Color.fromARGB(255, 228, 130, 228);
    static const Color secondEnd = Color.fromARGB(255, 116, 4, 82);
     // Color final del degradado
  static const Color iconColor = Colors.white;
  static const Color studentContainer = Color.fromARGB(255, 234, 221, 255);
  static const Color southGamma = Color.fromARGB(255, 109, 34, 170);
  // Degradado para botones primarios
  static const Gradient primaryGradientButton = LinearGradient(
    colors: [
      primaryStart,
      primaryEnd,
    ],
    begin: Alignment.topLeft,
    end: Alignment.topRight
    );

      static const Gradient secondGradientButton = LinearGradient(
    colors: [
      secondStart,
      secondEnd,
    ],
    begin: Alignment.topLeft,
    end: Alignment.topRight
    );

}
