import 'package:flutter/material.dart';
import 'package:hearth_rythm/src/core/constants/app_color.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // Para conectarse a Firebase

class CalendarWidget extends StatefulWidget {
  const CalendarWidget({Key? key}) : super(key: key);

  @override
  CalendarWidgetState createState() => CalendarWidgetState();
}

class CalendarWidgetState extends State<CalendarWidget> {
  late Map<DateTime, List<dynamic>> _events = {}; // Almacenar eventos del calendario
  DateTime _selectedDay = DateTime.now();
  List<dynamic> _selectedEvents = [];

  @override
  void initState() {
    super.initState();
    loadEventsFromFirebase();
  }

  // Este método se llama cada vez que hay un cambio en las dependencias,
  // útil para refrescar los datos al regresar a la pantalla.
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    loadEventsFromFirebase(); // Recarga los eventos al regresar
  }

  // Función para normalizar las fechas (quitar la hora)
  DateTime _normalizeDate(DateTime date) {
    return DateTime(date.year, date.month, date.day);
  }

  // Cargar eventos desde Firebase y normalizar las fechas
  Future<void> loadEventsFromFirebase() async {
    QuerySnapshot snapshot = await FirebaseFirestore.instance.collection('students').get();

    Map<DateTime, List<dynamic>> events = {};
    for (var doc in snapshot.docs) {
      var data = doc.data() as Map<String, dynamic>;

      // Asegurarse de que el documento tenga la fecha y sea de una clase muestra
      if (data['classDate'] != null)  {
        DateTime eventDate = DateTime.parse(data['classDate']);
        DateTime normalizedDate = _normalizeDate(eventDate); // Normalizar fecha

        if (events[normalizedDate] == null) {
          events[normalizedDate] = [];
        }
        events[normalizedDate]!.add(data); // Almacena la información del evento (el estudiante)
      }
    }

    setState(() {
      _events = events;
      // Verificar si los eventos están siendo cargados correctamente
      print("Eventos cargados: $_events");
    });
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          TableCalendar(
            focusedDay: _selectedDay,
            firstDay: DateTime.utc(2020, 1, 1),
            lastDay: DateTime.utc(2030, 12, 31),
            eventLoader: (day) {
              // Normalizar la fecha para comparar solo el día
              var events = _events[_normalizeDate(day)] ?? [];
              return events;
            },
            onDaySelected: (selectedDay, focusedDay) {
              setState(() {
                _selectedDay = selectedDay;
                _selectedEvents = _events[_normalizeDate(selectedDay)] ?? [];
              });
            },
            selectedDayPredicate: (day) {
              return isSameDay(_selectedDay, day);
            },
            calendarStyle: const CalendarStyle(
              markerDecoration: BoxDecoration(
                color: AppColors.primaryStart, // Color del puntito indicador
                shape: BoxShape.circle,
              ),
            ),
          ),
          const SizedBox(height: 20),
          _buildEventList(), // Muestra la lista de eventos para el día seleccionado
        ],
      ),
    );
  }

  Widget _buildEventList() {
    return Expanded(
      child: ListView.builder(
        itemCount: _selectedEvents.length,
        itemBuilder: (context, index) {
          var event = _selectedEvents[index];
          return ListTile(
            title: Text('Alumno: ${event['name']}'),
            subtitle: Text('Teléfono: ${event['phone']}'),
            trailing: Text('Nivel: ${event['level']}'),
          );
        },
      ),
    );
  }
}
