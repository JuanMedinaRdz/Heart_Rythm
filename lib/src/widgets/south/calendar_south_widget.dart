import 'package:flutter/material.dart';
import 'package:hearth_rythm/src/core/constants/app_color.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:table_calendar/table_calendar.dart'; // Para conectarse a Firebase

class CalendarSouthWidget extends StatefulWidget {
  const CalendarSouthWidget({Key? key}) : super(key: key);

  @override
  CalendarSouthWidgetState createState() => CalendarSouthWidgetState();
}

class CalendarSouthWidgetState extends State<CalendarSouthWidget> {
  late Map<DateTime, List<dynamic>> _events = {}; // Almacenar eventos del CalendarSouthio
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
    QuerySnapshot snapshot = await FirebaseFirestore.instance.collection('studentsSouth').get();

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
                color: AppColors.secondStart, // Color del puntito indicador
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
  if (_selectedEvents.isEmpty) {
    return const Center(
      child: Text(
        "No hay eventos para este día",
        style: TextStyle(fontSize: 16, color: Colors.grey),
      ),
    );
  }

  return Expanded(
    child: ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      itemCount: _selectedEvents.length,
      itemBuilder: (context, index) {
        final event = _selectedEvents[index];

        final String name = event['name'] ?? 'Sin nombre';
        final String phone = event['phone'] ?? 'Sin teléfono';
        final String level = event['level'] ?? 'Sin nivel';

        return GestureDetector(
          onTap: () {
            // Acción al presionar (puedes personalizar esto)
            showDialog(
              context: context,
              builder: (context) => AlertDialog(
                title: Text("Detalle de $name"),
                content: Text(
                  "Teléfono: $phone\nNivel: $level",
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text("Cerrar"),
                  ),
                ],
              ),
            );
          },
          child: Card(
            elevation: 4,
            margin: const EdgeInsets.symmetric(vertical: 8),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CircleAvatar(
                    backgroundColor: AppColors.secondStart,
                    radius: 24,
                    child: Icon(
                      Icons.person,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          name,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: Colors.white,
                          ),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            const Icon(
                              Icons.phone,
                              size: 16,
                              color: Colors.grey,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              phone,
                              style: const TextStyle(
                                fontSize: 14,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            const Icon(
                              Icons.school,
                              size: 16,
                              color: Colors.grey,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              level,
                              style: const TextStyle(
                                fontSize: 14,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    ),
  );
}

}
