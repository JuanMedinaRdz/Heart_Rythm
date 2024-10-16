  import 'package:flutter/material.dart';
  import 'package:hearth_rythm/src/core/constants/app_color.dart';

  class GradientButton extends StatelessWidget {
    final String text;
    final VoidCallback onPressed;


    const GradientButton({super.key, required this.text, required this.onPressed});

    @override
    Widget build(BuildContext context) {
      return Container(
        decoration: BoxDecoration(
          gradient: AppColors.primaryGradientButton,
          borderRadius: BorderRadius.circular(12)
        ),
        child: ElevatedButton(
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.transparent,
            shadowColor: Colors.transparent
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 50.0),
            child: Text(
              text,
              style: const TextStyle(
                fontSize: 25,
                color: Colors.white
              ),
            ),
          ),
        ),
      );
    }
  }