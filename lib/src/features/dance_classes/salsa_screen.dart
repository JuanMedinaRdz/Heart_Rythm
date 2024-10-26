import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hearth_rythm/src/core/constants/app_color.dart';
import 'package:hearth_rythm/src/core/constants/text_styles.dart';

class SalsaBachataScreen extends StatefulWidget {
  const SalsaBachataScreen({super.key});

  @override
  _SalsaBachataScreenState createState() => _SalsaBachataScreenState();
}

class _SalsaBachataScreenState extends State<SalsaBachataScreen> {
  String searchTerm = "";
  String selectedLevel = ""; // Almacena el nivel seleccionado

  // Método para obtener las iniciales del nombre del alumno
  String _getInitials(String name) {
    List<String> words = name.split(" ");
    if (words.length >= 2) {
      return words[0][0] +
          words[1][0]; // Toma las primeras letras de los dos primeros nombres
    } else if (words.isNotEmpty) {
      return words[0]
          [0]; // Si solo hay un nombre, toma la inicial de ese nombre
    }
    return ""; // Retorna vacío si el nombre no está definido
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Alumnos de Salsa"),
      ),
      body: Column(
        children: [
          // Campo de búsqueda
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              decoration: const InputDecoration(
                labelText: 'Buscar por horario',
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {
                setState(() {
                  searchTerm =
                      value.toLowerCase(); // Actualiza el término de búsqueda
                });
              },
            ),
          ),
          // Filtros de nivel
         Padding(
  padding: const EdgeInsets.symmetric(horizontal: 16.0),
  child: SingleChildScrollView(
    scrollDirection: Axis.horizontal, // Desplazamiento horizontal
    child: Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        const Text("Filtrar por Nivel: "),
        Radio<String>(
          value: "Básico",
          groupValue: selectedLevel,
          onChanged: (value) {
            setState(() {
              selectedLevel = value ?? ""; // Actualiza el nivel seleccionado
            });
          },
        ),
        const Text("Básico"),
        Radio<String>(
          value: "Intermedio",
          groupValue: selectedLevel,
          onChanged: (value) {
            setState(() {
              selectedLevel = value ?? ""; // Actualiza el nivel seleccionado
            });
          },
        ),
        const Text("Intermedio"),
        Radio<String>(
          value: "Clase Muestra",
          groupValue: selectedLevel,
          onChanged: (value) {
            setState(() {
              selectedLevel = value ?? ""; // Actualiza el nivel seleccionado
            });
          },
        ),
        const Text("Clase Muestra"),
      ],
    ),
  ),
),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('students')
                  .where('danceStyle', isEqualTo: 'Salsa')
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return const Center(
                      child: Text("No hay alumnos registrados en Salsa"));
                }

                // Lista de alumnos en Salsa
                var students = snapshot.data!.docs
                    .map((doc) => doc.data() as Map<String, dynamic>)
                    .toList();

                // Filtrar los alumnos por 'schedule' según el término de búsqueda
                if (searchTerm.isNotEmpty) {
                  students = students.where((student) {
                    String schedule =
                        student['schedule']?.toString().toLowerCase() ?? '';
                    return schedule.contains(searchTerm);
                  }).toList();
                }

                // Filtrar los alumnos por 'level' según el nivel seleccionado
                if (selectedLevel.isNotEmpty) {
                  students = students.where((student) {
                    String level = student['level']?.toString() ?? '';
                    return level ==
                        selectedLevel; // Comparar con el nivel seleccionado
                  }).toList();
                }

                // Mostrar la lista de alumnos filtrados
                return ListView.builder(
                  itemCount: students.length,
                  itemBuilder: (context, index) {
                    var data = students[index];
                    String name = data['name'] ?? 'Sin Nombre';
                    String phone = data['phone'] ?? 'Sin Teléfono';
                    String level = data['level'] ?? 'Sin Nivel';
                    String schedule = data['schedule'] ?? 'Sin Nivel';

                    String initials = _getInitials(name);

                    return Container(
                      margin: const EdgeInsets.symmetric(
                          vertical: 8, horizontal: 16),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: AppColors.studentContainer,
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.3),
                            spreadRadius: 2,
                            blurRadius: 5,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          CircleAvatar(
                            radius: 25,
                            backgroundColor: AppColors.primaryStart,
                            child: Text(
                              initials,
                              style: const TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                name,
                                style: AppTextStyles.studentTextContainer,
                              ),
                              const SizedBox(height: 4),
                              Text("Teléfono: $phone",
                                  style: AppTextStyles.studentTextContainer),
                              const SizedBox(height: 4),
                              Text("Nivel: $level",
                                  style: AppTextStyles.studentTextContainer),
                              const SizedBox(height: 4),
                              Text("Día: $schedule",
                                  style: AppTextStyles.studentTextContainer),
                            ],
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
