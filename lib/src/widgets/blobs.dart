import 'package:flutter/material.dart';
import 'package:hearth_rythm/src/core/constants/app_color.dart';

class BlobDecoration extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 200,
      height: 200,
      decoration: BoxDecoration(
        color: AppColors.primaryEnd.withOpacity(0.3), // Blob semitransparente
        borderRadius: BorderRadius.circular(150),
      ),
    );
  }
}