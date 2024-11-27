import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hearth_rythm/src/core/constants/app_color.dart';
import 'package:hearth_rythm/src/core/constants/text_styles.dart';
import 'package:hearth_rythm/src/features/students/student_detail_screen.dart';
import 'package:hearth_rythm/src/widgets/north/filter_widget.dart';
import 'package:hearth_rythm/src/widgets/north/navbar_north_screen.dart';

class CumbiaScreen extends StatefulWidget {
  const CumbiaScreen({super.key});

  @override
  _CumbiaScreenState createState() => _CumbiaScreenState();
}

class _CumbiaScreenState extends State<CumbiaScreen> {
  String searchTerm = "";
  String selectedLevel = "";
  String selectedSchedule = "";

  String _getInitials(String name) {
    List<String> words = name.split(" ");
    if (words.length >= 2) {
      return words[0][0] + words[1][0];
    } else if (words.isNotEmpty) {
      return words[0][0];
    }
    return "";
  }

  Future<bool?> _confirmDelete(String name) async {
    bool? shouldDelete = await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Confirmar eliminación"),
        content: Text("¿Estás seguro de que deseas eliminar a $name?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text("Cancelar"),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text("Eliminar"),
          ),
        ],
      ),
    );

    if (shouldDelete == true) {
      var querySnapshot = await FirebaseFirestore.instance
          .collection('students')
          .where('name', isEqualTo: name)
          .get();
      if (querySnapshot.docs.isNotEmpty) {
        await querySnapshot.docs.first.reference.delete();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Alumno eliminado")),
        );
      }
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Alumnos de Cumbia"),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              decoration: const InputDecoration(
                labelText: 'Buscar por horario',
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {
                setState(() {
                  searchTerm = value.toLowerCase();
                });
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: FilterWidget(
              title: "Filtrar por Nivel",
              field: "level",
              options: ["Básico","Básico Avanzado", "Intermedio", "Clase Muestra"],
              selectedValue: selectedLevel,
              onSelected: (value) {
                setState(() {
                  selectedLevel = value;
                });
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: FilterWidget(
              title: "Filtrar por Día",
              field: "schedule",
              options: ["Lun/Mie", "Mar/Jue", "Sabado"],
              selectedValue: selectedSchedule,
              onSelected: (value) {
                setState(() {
                  selectedSchedule = value;
                });
              },
            ),
          ),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('students')
                  .where('danceStyle', isEqualTo: 'Cumbia')
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return const Center(
                      child: Text("No hay alumnos registrados en Cumbia"));
                }

                var students = snapshot.data!.docs
                    .map((doc) => doc.data() as Map<String, dynamic>)
                    .toList();

                if (searchTerm.isNotEmpty) {
                  students = students.where((student) {
                    String schedule =
                        student['name']?.toString().toLowerCase() ?? '';
                    return schedule.contains(searchTerm);
                  }).toList();
                }

                if (selectedLevel.isNotEmpty) {
                  students = students.where((student) {
                    String level = student['level']?.toString() ?? '';
                    return level == selectedLevel;
                  }).toList();
                }
                if (selectedSchedule.isNotEmpty) {
                  students = students.where((student) {
                    String schedule = student['schedule']?.toString() ?? '';
                    return schedule == selectedSchedule;
                  }).toList();
                }

                return ListView.builder(
                  itemCount: students.length,
                  itemBuilder: (context, index) {
                    var data = students[index];
                    String name = data['name'] ?? 'Sin Nombre';
                    String phone = data['phone'] ?? 'Sin Teléfono';
                    String level = data['level'] ?? 'Sin Nivel';
                    String schedule = data['schedule'] ?? 'Sin Horario';
                    String initials = _getInitials(name);

                    return Dismissible(
                      key: Key(name),
                      direction: DismissDirection.endToStart,
                      onDismissed: (_) => _confirmDelete(name),
                      confirmDismiss: (direction) async {
                        return await _confirmDelete(name);
                      },
                      background: Container(
                        color: Colors.red,
                        padding: const EdgeInsets.only(left: 16),
                        alignment: Alignment.centerLeft,
                        child: const Icon(Icons.delete, color: Colors.white),
                      ),
                      child: GestureDetector(
                        onTap: () => openStudentDetail(context, name),
                        child: Container(
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
                                      style:
                                          AppTextStyles.studentTextContainer),
                                  const SizedBox(height: 4),
                                  Text("Nivel: $level",
                                      style:
                                          AppTextStyles.studentTextContainer),
                                  const SizedBox(height: 4),
                                  Text("Día: $schedule",
                                      style:
                                          AppTextStyles.studentTextContainer),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: const NavBarNorth(currentIndex: 2),
    );
  }

  void openStudentDetail(BuildContext context, String name) {
    FirebaseFirestore.instance
        .collection('students')
        .where('name', isEqualTo: name)
        .get()
        .then((querySnapshot) {
      if (querySnapshot.docs.isNotEmpty) {
        var doc = querySnapshot.docs.first;
        var studentData = doc.data();
        showModalBottomSheet(
          context: context,
          builder: (_) => StudentDetailScreen(
            studentData: studentData,
            name: name,
            docId: doc.id,
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Alumno no encontrado")),
        );
      }
    });
  }
}
