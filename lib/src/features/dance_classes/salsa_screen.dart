import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hearth_rythm/src/core/constants/app_color.dart';
import 'package:hearth_rythm/src/core/constants/text_styles.dart';
import 'package:hearth_rythm/src/features/students/student_detail_screen.dart';
import 'package:hearth_rythm/src/widgets/north/navbar_north_screen.dart';
import 'package:intl/intl.dart';

class SalsaBachataScreen extends StatefulWidget {
  const SalsaBachataScreen({super.key});

  @override
  _SalsaBachataScreenState createState() => _SalsaBachataScreenState();
}

class _SalsaBachataScreenState extends State<SalsaBachataScreen> {
  String searchTerm = "";
  String selectedLevel = "";
  String selectedSchedule = "";
  String selectedTeacher = "";
  String selectedDanceStyle = "";

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

  void _clearFilters() {
    setState(() {
      selectedLevel = "";
      selectedSchedule = "";
      selectedTeacher = "";
      selectedDanceStyle = "";
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Alumnos Sucursal Norte"),
        actions: [
          Builder(
            builder: (context) {
              return IconButton(
                icon: const Icon(Icons.filter_list),
                onPressed: () {
                  Scaffold.of(context).openEndDrawer();
                },
              );
            },
          ),
        ],
      ),
      endDrawer: Drawer(
        child: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("Filtrar por Nivel",
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  ...[
                    "Básico",
                    "Básico Avanzado",
                    "Intermedio",
                    "Clase Muestra"
                  ].map((option) => RadioListTile<String>(
                        title: Text(option),
                        value: option,
                        groupValue: selectedLevel,
                        onChanged: (value) {
                          setState(() {
                            selectedLevel = value ?? "";
                          });
                          Navigator.pop(context);
                        },
                      )),
                  const SizedBox(height: 16),
                  const Text("Filtrar por Día",
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  ...["Lun/Mie", "Mar/Jue", "Sabado"]
                      .map((option) => RadioListTile<String>(
                            title: Text(option),
                            value: option,
                            groupValue: selectedSchedule,
                            onChanged: (value) {
                              setState(() {
                                selectedSchedule = value ?? "";
                              });
                              Navigator.pop(context);
                            },
                          )),
                  const SizedBox(height: 16),
                  const Text("Filtrar por Maestro",
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  ...["Desi", "Nico", "Juan", "Ximena", "Monse"]
                      .map((option) => RadioListTile<String>(
                            title: Text(option),
                            value: option,
                            groupValue: selectedTeacher,
                            onChanged: (value) {
                              setState(() {
                                selectedTeacher = value ?? "";
                              });
                              Navigator.pop(context);
                            },
                          )),
                  const SizedBox(height: 16),
                  const Text("Filtrar por Estilo de Baile",
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  ...[
                    "Salsa",
                    "Cumbia",
                    "Kisomba",
                  ].map((option) => RadioListTile<String>(
                        title: Text(option),
                        value: option,
                        groupValue: selectedDanceStyle,
                        onChanged: (value) {
                          setState(() {
                            selectedDanceStyle = value ?? "";
                          });
                          Navigator.pop(context);
                        },
                      )),
                  const SizedBox(height: 16),
                  // Podemos quitar el Spacer, pues SingleChildScrollView no limita el tamaño interno
                  // const Spacer(),
                  ElevatedButton.icon(
                    onPressed: () {
                      _clearFilters();
                      Navigator.pop(context);
                    },
                    icon: const Icon(Icons.clear),
                    label: const Text("Limpiar Filtros"),
                    style:
                        ElevatedButton.styleFrom(backgroundColor: Colors.red),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              decoration: const InputDecoration(
                labelText: 'Buscar por nombre o telefono',
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {
                setState(() {
                  searchTerm = value.toLowerCase();
                });
              },
            ),
          ),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('students')
                  .where('danceStyle')
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return const Center(
                      child: Text("No hay alumnos registrados en Salsa"));
                }

                var students = snapshot.data!.docs
                    .map((doc) => doc.data() as Map<String, dynamic>)
                    .toList();

                if (searchTerm.isNotEmpty) {
                  students = students.where((student) {
                    String name =
                        student['name']?.toString().toLowerCase() ?? '';
                    String phone =
                        student['phone']?.toString().toLowerCase() ?? '';

                    // Retorna true si "searchTerm" aparece en el nombre o en el teléfono
                    return name.contains(searchTerm) ||
                        phone.contains(searchTerm);
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

                if (selectedTeacher.isNotEmpty) {
                  students = students.where((student) {
                    String teacher = student['teacher']?.toString() ?? '';
                    return teacher == selectedTeacher;
                  }).toList();
                }
                                if (selectedDanceStyle.isNotEmpty) {
                  students = students.where((student) {
                    String danceStyle = student['danceStyle']?.toString() ?? '';
                    return danceStyle == selectedDanceStyle;
                  }).toList();
                }

return ListView.builder(
  itemCount: students.length,
  itemBuilder: (context, index) {
    var data = students[index];
    String name = data['name'] ?? 'Sin Nombre';
    String phone = data['phone'] ?? 'Sin Teléfono';
    String level = data['level'] ?? 'Sin Nivel';
    String teacher = data['teacher'] ?? 'Maestro desconocido';
    String schedule = data['schedule'] ?? 'Sin Horario';
    
    // Obtenemos la fecha en ISO8601
    String? rawDate = data['classDate'];

    // Parseamos la fecha (podría ser null o no parseable)
    DateTime? parsedDate = (rawDate != null) ? DateTime.tryParse(rawDate) : null;
    // Formateador de fecha, ejemplo dd/MM/yyyy
    final DateFormat formatter = DateFormat('dd/MM/yyyy');
    
    // Generamos iniciales
    String initials = _getInitials(name);

    // Cambiamos el color si es "Clase Muestra"
    final containerColor = (level == "Clase Muestra")
      ? AppColors.claseMuestraContainer// color alternativo
      : AppColors.studentContainer;

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
          margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: containerColor,       // <-- color distinto para clase muestra
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
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(name, style: AppTextStyles.studentTextContainer),
                  const SizedBox(height: 4),
                  Text("Teléfono: $phone", style: AppTextStyles.studentTextContainer),
                  const SizedBox(height: 4),
                  Text("Nivel: $level", style: AppTextStyles.studentTextContainer),
                  const SizedBox(height: 4),
                  Text("Maestro: $teacher", style: AppTextStyles.studentTextContainer),
                  const SizedBox(height: 4),
                  Text("Día: $schedule", style: AppTextStyles.studentTextContainer),
                  
                  // Muestra la fecha formateada solo si es Clase Muestra y parsedDate no es null
                  if (level == "Clase Muestra" && parsedDate != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 4.0),
                      child: Text(
                        "Fecha: ${formatter.format(parsedDate)}",
                        style: AppTextStyles.studentTextContainer,
                      ),
                    ),
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
      bottomNavigationBar: const NavBarNorth(currentIndex: 1),
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
