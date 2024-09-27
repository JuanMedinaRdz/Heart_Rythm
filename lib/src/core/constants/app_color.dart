import 'package:flutter/material.dart';

class AppColors {
  // Colores para los botones primarios
  static const Color primaryStart = Color(0xFFFF8177); // Color inicial del degradado
  static const Color primaryEnd = Color(0xFFB12A5B);   // Color final del degradado

  // Degradado para botones primarios
  static const Gradient primaryGradientButton = LinearGradient(
    colors: [
      primaryStart,
      primaryEnd,
    ],
    begin: Alignment.topLeft,
    end: Alignment.topRight
    );

}
