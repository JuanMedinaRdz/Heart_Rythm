import 'package:flutter/widgets.dart';
import 'package:hearth_rythm/src/widgets/north/custom_text_field.dart';

class PhoneTextField extends StatelessWidget {
  final TextEditingController controller;

  const PhoneTextField({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return CustomTextField(
      hintText: 'Ingresa tu número telefónico',
      controller: controller,
      keyboardType: TextInputType.phone,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Por favor ingresa un valor';
        }
        final phoneRegex = RegExp(r'^[0-9]{10}$'); // Valida un número de 10 dígitos
        if (!phoneRegex.hasMatch(value)) {
          return 'Ingresa un número telefónico válido (10 dígitos)';
        }
        return null;
      },
    );
  }
}
