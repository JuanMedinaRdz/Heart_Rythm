import 'package:flutter/material.dart';

class DatePickerWidget extends StatelessWidget {
  final DateTime? selectedDate;
  final ValueChanged<DateTime?> onDateSelected;

  const DatePickerWidget({
    super.key,
    required this.selectedDate,
    required this.onDateSelected,
  });

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () async {
        final DateTime? pickedDate = await showDatePicker(
          context: context,
          initialDate: selectedDate ?? DateTime.now(),
          firstDate: DateTime(2000),
          lastDate: DateTime(2100),
        );
        onDateSelected(pickedDate);
      },
      child: Text(
        selectedDate == null
            ? 'Selecciona una fecha'
            : 'Fecha seleccionada: ${selectedDate!.toLocal()}',
      ),
    );
  }
}
