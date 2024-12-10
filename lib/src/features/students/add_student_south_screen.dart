import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hearth_rythm/src/core/constants/app_color.dart';
import 'package:hearth_rythm/src/data/models/student_model.dart';
import 'package:hearth_rythm/src/data/repositories/student_repository.dart';
import 'package:lottie/lottie.dart';

class AddStudentScreenSouth extends StatefulWidget {
  const AddStudentScreenSouth({super.key});

  @override
  _AddStudentScreenSouthState createState() => _AddStudentScreenSouthState();
}

class _AddStudentScreenSouthState extends State<AddStudentScreenSouth> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();

  String _selectedSchedule = '';
  String _selectedLevel = '';
  String _selectedTeacher = '';
  DateTime? _classDate;

  final _studentRepo = StudentSouthRepository();

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Agregar Alumno')),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildTextField('Ingresa tu nombre', _nameController),
                const SizedBox(height: 16.0),
                _buildPhoneField(
                    'Ingresa tu número telefónico', _phoneController),
                const SizedBox(height: 16.0),
                _buildSectionTitle('Selecciona el horario'),
                _buildScheduleButtons(),
                const SizedBox(height: 16.0),
                _buildSectionTitle('Selecciona el nivel'),
                _buildLevelButtons(),
                const SizedBox(height: 16.0),
                _buildSectionTitle('Selecciona un Maestro'),
                _buildTeacherButtons(),
                const SizedBox(height: 24.0),
                Center(
                  child: Container(
                    height: 50,
                    decoration: BoxDecoration(
                        gradient: AppColors.secondGradientButton,
                        borderRadius: BorderRadius.circular(16.0)),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.transparent,
                          shadowColor: Colors.transparent,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16.0))),
                      onPressed: () {
                        if (_formKey.currentState!.validate() &&
                            _selectedSchedule.isNotEmpty &&
                            _selectedLevel.isNotEmpty) {
                          _saveStudent();
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                  'Por favor completa todos los campos requeridos'),
                            ),
                          );
                        }
                      },
                      child: const Text('Agregar Alumno'),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(String hintText, TextEditingController controller) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        hintText: hintText,
        filled: true,
        fillColor: Colors.transparent,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
          borderSide: const BorderSide(color: AppColors.secondStart),
        ),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Por favor ingresa un valor';
        }
        if (value.trim().split('').length < 2) {
          return 'Ingresa tu nombre completo';
        }
        return null;
      },
    );
  }

  Widget _buildPhoneField(String hintText, TextEditingController controller) {
    return TextFormField(
      controller: controller,
      keyboardType: TextInputType.phone,
      decoration: InputDecoration(
        hintText: hintText,
        filled: true,
        fillColor: Colors.transparent,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
          borderSide: const BorderSide(color: AppColors.secondStart),
        ),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Por favor ingresa un valor';
        }
        final phoneRegex =
            RegExp(r'^[0-9]{10}$'); // Valida un número de 10 dígitos
        if (!phoneRegex.hasMatch(value)) {
          return 'Ingresa un número telefónico válido (10 dígitos)';
        }
        return null;
      },
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(fontWeight: FontWeight.bold),
    );
  }

  Widget _buildScheduleButtons() {
    return Row(
      children: ['Lun/Mie', 'Mar/Jue', 'Sabado'].map((schedule) {
        return _buildSelectionButton(
          schedule,
          _selectedSchedule == schedule,
          () => setState(() => _selectedSchedule = schedule),
        );
      }).toList(),
    );
  }

  Widget _buildLevelButtons() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              'Básico',
              'Básico Avanzado',
              'Intermedio',
              'Clase Muestra'
            ].map((level) {
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: _buildSelectionButton(
                  level,
                  _selectedLevel == level,
                  () => setState(() => _selectedLevel = level),
                ),
              );
            }).toList(),
          ),
        ),
        if (_selectedLevel == 'Clase Muestra') _buildDatePicker(),
      ],
    );
  }

  Widget _buildTeacherButtons() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              'Nico',
              'Ximena',
            ].map((teacher) {
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: _buildSelectionButton(
                  teacher,
                  _selectedTeacher == teacher,
                  () => setState(() => _selectedTeacher = teacher),
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  Widget _buildSelectionButton(
      String text, bool isSelected, VoidCallback onPressed) {
    return Padding(
      padding: const EdgeInsets.only(right: 8.0),
      child: OutlinedButton(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          backgroundColor:
              isSelected ? AppColors.primaryEnd : Colors.transparent,
          side: const BorderSide(color: AppColors.secondStart),
        ),
        child: Text(text),
      ),
    );
  }

  Widget _buildDatePicker() {
    return TextButton(
      onPressed: () async {
        final DateTime? pickedDate = await showDatePicker(
          context: context,
          initialDate: DateTime.now(),
          firstDate: DateTime(2000),
          lastDate: DateTime(2100),
        );
        if (pickedDate != null) {
          setState(() {
            _classDate = pickedDate;
          });
        }
      },
      child: Text(_classDate == null
          ? 'Selecciona una fecha'
          : 'Fecha seleccionada: ${_classDate!.toLocal()}'),
    );
  }

  void _showSuccessAnimation() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Dialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Lottie.asset(
                  'lib/src/core/assets/animations/check_succes.json', // Ruta al archivo JSON de Lottie
                  repeat: false,
                  width: 150,
                ),
                const SizedBox(height: 16),
                const Text(
                  'Alumno agregado con éxito',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        );
      },
    );

    // Cerrar el diálogo y regresar a la pantalla anterior después de 2 segundos
    Future.delayed(const Duration(seconds: 2), () {
      Navigator.of(context).pop(); // Cerrar el diálogo de éxito
      GoRouter.of(context)
          .push('/south_screen'); // Regresar a la pantalla anterior
    });
  }

  void _saveStudent() {
    final newStudent = Student(
      name: _nameController.text,
      phone: _phoneController.text,
      schedule: _selectedSchedule,
      level: _selectedLevel,
      teacher: _selectedTeacher,
      classDate: _selectedLevel == 'Clase Muestra' ? _classDate : null,
    );

    _studentRepo.addStudent(newStudent).then((_) {
      _showSuccessAnimation();
    }).catchError((error) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error al agregar alumno')),
      );
    });
  }
}
