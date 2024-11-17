import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // Para obtener el día actual

class CheckListScreen extends StatefulWidget {
  const CheckListScreen({super.key});

  @override
  _CheckListScreenState createState() => _CheckListScreenState();
}

class _CheckListScreenState extends State<CheckListScreen> {
  Map<String, bool> attendance = {}; // Mapa para controlar el estado del checkbox

  @override
  void initState() {
    super.initState();
    _fetchStudents();
  }

  // Función para obtener el día actual
  String _getCurrentDay() {
    DateTime now = DateTime.now();
    return DateFormat('EEEE').format(now); // Obtiene el día de la semana
  }

  // Función para obtener la lista de estudiantes según el día actual
  Future<void> _fetchStudents() async {
    String currentDay = _getCurrentDay();
    String scheduleFilter = '';

    // Filtrar según el día
    if (currentDay == 'Monday' || currentDay == 'Wednesday') {
      scheduleFilter = 'Lun/Mie';
    } else if (currentDay == 'Tuesday' || currentDay == 'Thursday') {
      scheduleFilter = 'Mar/Jue'; 
    } else if (currentDay == 'Saturday') {
      scheduleFilter = 'Sabado';
    }

    // Consultar los estudiantes que coincidan con el schedule
    QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection('students')
        .where('schedule', isEqualTo: scheduleFilter)
        .get();

    // Actualizar el mapa de asistencia con los estudiantes
    setState(() {
      for (var doc in snapshot.docs) {
        var studentData = doc.data() as Map<String, dynamic>;
        attendance[studentData['name']] = false; // Inicializar como no asistido
      }
    });
  }

  // Función para actualizar la asistencia en Firebase
  Future<void> _updateAttendance(String name, bool attended) async {
    var studentDoc = await FirebaseFirestore.instance
        .collection('students')
        .where('name', isEqualTo: name)
        .get();

    if (studentDoc.docs.isNotEmpty) {
      var studentRef = studentDoc.docs.first.reference;
      await studentRef.update({
        'attendance': FieldValue.arrayUnion([DateTime.now().toIso8601String()]),
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Check List de Asistencia')),
      body: FutureBuilder(
        future: _fetchStudents(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData) {
            return const Center(child: Text("No hay estudiantes para este día"));
          }

          return ListView.builder(
            itemCount: attendance.length,
            itemBuilder: (context, index) {
              String studentName = attendance.keys.elementAt(index);
              return ListTile(
                title: Text(studentName),
                trailing: Checkbox(
                  value: attendance[studentName],
                  onChanged: (value) {
                    setState(() {
                      attendance[studentName] = value!;
                    });
                    _updateAttendance(studentName, value!);
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}
