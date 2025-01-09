import 'package:flutter/material.dart';
import 'package:hearth_rythm/src/core/constants/app_color.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;

// Importa tu instancia de flutterLocalNotificationsPlugin
import 'package:hearth_rythm/main.dart';

class CalendarWidget extends StatefulWidget {
  const CalendarWidget({Key? key}) : super(key: key);

  @override
  CalendarWidgetState createState() => CalendarWidgetState();
}

class CalendarWidgetState extends State<CalendarWidget> {
  late Map<DateTime, List<dynamic>> _events = {};
  DateTime _selectedDay = DateTime.now();
  List<dynamic> _selectedEvents = [];

  @override
  void initState() {
    super.initState();
    loadEventsFromFirebase();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    loadEventsFromFirebase();
  }

  // Quita hora/min/seg para comparar sólo por día
  DateTime _normalizeDate(DateTime date) {
    return DateTime(date.year, date.month, date.day);
  }

  Future<void> loadEventsFromFirebase() async {
    final snapshot = await FirebaseFirestore.instance.collection('students').get();

    Map<DateTime, List<dynamic>> events = {};
    for (var doc in snapshot.docs) {
      final data = doc.data() as Map<String, dynamic>;

      if (data['classDate'] != null) {
        // Asumiendo que 'classDate' es un String ISO8601
        final DateTime eventDate = DateTime.parse(data['classDate']);
        final DateTime normalizedDate = _normalizeDate(eventDate);

        events[normalizedDate] ??= [];
        events[normalizedDate]!.add(data);

        // 1) Verifica si es Clase Muestra
        if (data['level'] == 'Clase Muestra') {
          // 2) Opcional: Verifica si la fecha es hoy (o un futuro cercano)
          final DateTime now = DateTime.now();

          // Normalizamos ambos para comparar por día
          final dayOfEvent = _normalizeDate(eventDate);
          final dayOfNow = _normalizeDate(now);

          // Opcional: Si quieres que SOLO notifique cuando sea el mismo día
          if (dayOfEvent == dayOfNow) {
            // 3) Si el horario de la clase es futuro en el día
            if (eventDate.isAfter(now)) {
              // Programar notificación para la hora EXACTA del eventDate
              _scheduleLocalNotification(eventDate, data);
            }
            // else => la hora ya pasó, no programamos notificación
          }

          // Si en cambio quieres notificar siempre que eventDate sea futuro
          /*
          if (eventDate.isAfter(now)) {
            _scheduleLocalNotification(eventDate, data);
          }
          */
        }
      }
    }

    setState(() {
      _events = events;
    });
  }

  void _scheduleLocalNotification(DateTime eventDate, Map<String, dynamic> eventData) {
    // Convertimos la DateTime a tz.TZDateTime local
    final tz.TZDateTime tzEventDate = tz.TZDateTime.from(eventDate, tz.local);

    final String title = 'Recordatorio Clase Muestra';
    final String body = 'Tienes una clase muestra con ${eventData["name"]} el ${eventDate.toLocal()}';

    const AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
      'clase_muestra_id',
      'Recordatorios de Clase Muestra',
      channelDescription: 'Notificaciones locales para Clase Muestra',
      importance: Importance.high,
      priority: Priority.high,
    );
    const DarwinNotificationDetails iosDetails = DarwinNotificationDetails();

    final NotificationDetails platformDetails =
        NotificationDetails(android: androidDetails, iOS: iosDetails);

    final int notificationId = eventDate.millisecondsSinceEpoch ~/ 1000;

    // Usar inexact para que no requiera USE_EXACT_ALARM en Android 13
    flutterLocalNotificationsPlugin.zonedSchedule(
      notificationId,
      title,
      body,
      tzEventDate,
      platformDetails,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.dateAndTime,
      androidScheduleMode: AndroidScheduleMode.inexact, 
    );
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
              final events = _events[_normalizeDate(day)] ?? [];
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
                color: AppColors.primaryStart,
                shape: BoxShape.circle,
              ),
            ),
          ),
          const SizedBox(height: 20),
          _buildEventList(),
        ],
      ),
    );
  }

  Widget _buildEventList() {
    return Expanded(
      child: ListView.builder(
        itemCount: _selectedEvents.length,
        itemBuilder: (context, index) {
          final event = _selectedEvents[index];
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
