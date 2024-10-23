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
                // Name Form Field
                TextFormField(
                  controller: _nameController,
                  decoration: InputDecoration(
                    hintText: 'Ingresa tu nombre',
                    filled: true,
                    fillColor: Colors.transparent,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.0),
                      borderSide: const BorderSide(
                        color: AppColors.primaryStart
                      ),
                    ),
                  ),
                  validator: (value) {
                    if(value == null || value.isEmpty) {
                      return 'Por favor ingrese un nombre';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16.0),
        
                // Phone Form Field
                TextFormField(
                  controller: _phoneController,
                  decoration: InputDecoration(
                    hintText: 'Ingresa tu numero telefonico',
                    filled: true,
                    fillColor: Colors.transparent,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.0),
                      borderSide: const BorderSide(color: AppColors.primaryStart
                      ),
                    ),
                  ),
                  validator: (value) {
                    if(value == null || value.isEmpty) {
                      return 'Por favor ingresa un numero para contactarte';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16.0,),
                // Buttons to select the danceStyle
        
                Text('Selecciona el estilo de baile'),
                _buildDanceStyleButtons(),
        
                // Botones de horario
                const SizedBox(height: 16.0),
                const Text('Selecciona el horario:'),
                _buildScheduleButtons(),
        
                 // Botones de nivel
                const SizedBox(height: 16.0),
                Text('Selecciona el nivel:'),
                _buildLevelButtons(),
        
                // Boton para agregar el alumno
                const SizedBox(height: 16.0),
                ElevatedButton(
                  onPressed: () {
                    if(_formKey.currentState!.validate()) {
                      _saveStudent();
                    }
                  }, 
                  child: const Text('Agregar Alumno')
                  )
        
        
              ],
            )),
        ),
      ),
    );
  }
  
   Widget _buildDanceStyleButtons() {
    return Row(
      children: [
        _buildSelectionButton('Salsa', _selectedDanceStyle == 'Salsa', () {
          setState(() {
            _selectedDanceStyle = 'Salsa';
          });
        }),
        const SizedBox(width: 8.0),
        _buildSelectionButton('Cumbia', _selectedDanceStyle == 'Cumbia', () {
          setState(() {
            _selectedDanceStyle = 'Cumbia';
          });
        }),
      ],
    );
  }

   Widget _buildScheduleButtons() {
    return Row(
      children: [
        _buildSelectionButton('Lun/Mie', _selectedSchedule == 'Lun/Mie', () {
          setState(() {
            _selectedSchedule = 'Lun/Mie';
          });
        }),
        const SizedBox(width: 8.0),
        _buildSelectionButton('Mar/Jue', _selectedSchedule == 'Mar/Jue', () {
          setState(() {
            _selectedSchedule = 'Mar/Jue';
          });
        }),
        const SizedBox(width: 8.0),
        _buildSelectionButton('Sabado', _selectedSchedule == 'Sabado', () {
          setState(() {
            _selectedSchedule = 'Sabado';
          });
        }),
      ],
    );
  }

   Widget _buildLevelButtons() {
    return Column(
      children: [
        Row(
          children: [
            _buildSelectionButton('Básico', _selectedLevel == 'Básico', () {
              setState(() {
                _selectedLevel = 'Básico';
              });
            }),
            const SizedBox(width: 8.0),
            _buildSelectionButton('Intermedio', _selectedLevel == 'Intermedio', () {
              setState(() {
                _selectedLevel = 'Intermedio';
              });
            }),
            const SizedBox(width: 8.0),
            _buildSelectionButton('Clase Muestra', _selectedLevel == 'Clase Muestra', () {
              setState(() {
                _selectedLevel = 'Clase Muestra';
              });
            }),
          ],
        ),
        if (_selectedLevel == 'Clase Muestra') _buildDatePicker()
      ],
    );
  }

  Widget _buildSelectionButton(String text, bool isSelected, VoidCallback onPressed) {
    return Expanded(
      child: OutlinedButton(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          backgroundColor: isSelected ? AppColors.primaryEnd : Colors.transparent,
          side: BorderSide(color: AppColors.primaryStart),
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
        SnackBar(content: Text('Alumno agregado con éxito')),
      );
      Navigator.pop(context);
    }).catchError((error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al agregar alumno')),
      );
    });
  }

}