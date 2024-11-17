import 'package:flutter/material.dart';
import 'package:hearth_rythm/src/core/constants/app_color.dart';
import 'package:hearth_rythm/src/core/constants/text_styles.dart';

class GradientContainerButtonSouth extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final Icon? icon;
  final double textSize;

  const GradientContainerButtonSouth({
    super.key,
    required this.text,
    required this.onPressed,
    this.icon,
    required this.textSize,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: AppColors.secondGradientButton,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(12),
          bottomRight: Radius.circular(12),
        ),
      ),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 30.0, horizontal: 20.0), // Ajusta el padding
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded( // Usa Expanded para que el texto ocupe el espacio disponible
                child: Text(
                  text,
                  style: AppTextStyles.subtitle.copyWith(fontSize: textSize), // Usa el tamaño de texto
                  textAlign: TextAlign.center, // Centra el texto
                ),
              ),
              if (icon != null)
                Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: icon,
                ),
            ],
          ),
        ),
      ),
    );
  }
}
