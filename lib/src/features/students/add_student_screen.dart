import 'package:flutter/material.dart';
import 'package:hearth_rythm/src/core/constants/app_color.dart';
import 'package:hearth_rythm/src/data/models/student_model.dart';
import 'package:hearth_rythm/src/data/repositories/student_repository.dart';

class AddStudentScreen extends StatefulWidget {
  const AddStudentScreen({super.key});

  @override
  _AddStudentScreenState createState() => _AddStudentScreenState();
}

class _AddStudentScreenState extends State<AddStudentScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();

  String _selectedDanceStyle = '';
  String _selectedSchedule = '';
  String _selectedLevel = '';
  DateTime? _classDate;

  final _studentRepo = StudentRepository();

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
                _buildFormField('Ingresa tu nombre', _nameController),
                const SizedBox(height: 16.0),
                _buildFormField('Ingresa tu número telefónico', _phoneController),
                const SizedBox(height: 16.0),
                _buildSectionTitle('Selecciona el estilo de baile'),
                _buildDanceStyleButtons(),
                const SizedBox(height: 16.0),
                _buildSectionTitle('Selecciona el horario'),
                _buildScheduleButtons(),
                const SizedBox(height: 16.0),
                _buildSectionTitle('Selecciona el nivel'),
                _buildLevelButtons(),
                const SizedBox(height: 24.0),
                Center(
                  
                  child: Container(
                    height: 50,
                    decoration: BoxDecoration(
                      gradient: AppColors.primaryGradientButton,
                      borderRadius: BorderRadius.circular(16.0)
                    ),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.transparent,
                          shadowColor: Colors.transparent,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16.0)
                        )
                      ),
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          _saveStudent();
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

  Widget _buildFormField(String hintText, TextEditingController controller) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        hintText: hintText,
        filled: true,
        fillColor: Colors.transparent,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
          borderSide: const BorderSide(color: AppColors.primaryStart),
        ),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Por favor ingresa un valor';
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

  Widget _buildDanceStyleButtons() {
    return Row(
      children: ['Salsa', 'Cumbia'].map((style) {
        return _buildSelectionButton(
          style,
          _selectedDanceStyle == style,
          () => setState(() => _selectedDanceStyle = style),
        );
      }).toList(),
    );
  }

  Widget _buildScheduleButtons() {
    return Row(
      children: ['Lun/Mie', 'Mar/Jue', 'Sábado'].map((schedule) {
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
      children: [
        Row(
          children: ['Básico', 'Intermedio', 'Clase Muestra'].map((level) {
            return _buildSelectionButton(
              level,
              _selectedLevel == level,
              () => setState(() => _selectedLevel = level),
            );
          }).toList(),
        ),
        if (_selectedLevel == 'Clase Muestra') _buildDatePicker(),
      ],
    );
  }

  Widget _buildSelectionButton(String text, bool isSelected, VoidCallback onPressed) {
    return Expanded(
      child: OutlinedButton(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          backgroundColor: isSelected ? AppColors.primaryEnd : Colors.transparent,
          side: const BorderSide(color: AppColors.primaryStart),
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

  void _saveStudent() {
    final newStudent = Student(
      name: _nameController.text,
      phone: _phoneController.text,
      danceStyle: _selectedDanceStyle,
      schedule: _selectedSchedule,
      level: _selectedLevel,
      classDate: _selectedLevel == 'Clase Muestra' ? _classDate : null,
    );

    _studentRepo.addStudent(newStudent).then((_) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Alumno agregado con éxito')),
      );
      Navigator.pop(context);
    }).catchError((error) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error al agregar alumno')),
      );
    });
  }
}
