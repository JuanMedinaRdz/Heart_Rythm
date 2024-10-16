import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class BlobDecoration extends StatelessWidget {
  const BlobDecoration({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 300,
      height: 300,
      child: Lottie.asset(
        'lib/src/core/assets/animations/blob_animation.json',
        fit: BoxFit.cover, //Ajusta el tamaño del Lottie
      ),
    );
  }
}