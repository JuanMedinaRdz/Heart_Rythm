import 'package:flutter/material.dart';
import 'package:hearth_rythm/src/widgets/gradient_button.dart';
import 'package:table_calendar/table_calendar.dart';

class CalendarWidget extends StatelessWidget {
  const CalendarWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          TableCalendar(
            focusedDay: DateTime.now(),
            firstDay: DateTime.utc(2020, 1, 1),
            lastDay: DateTime.utc(2030, 12, 31),
            // Puedes personalizar el calendario según tus necesidades
          ),
          const SizedBox(
            height: 60, // Altura del botón de eventos
          ),
          GradientButton(
            text: 'Crear Evento', 
            onPressed: () {
              
            }
            )
        ],
      ),
    );
  }
}