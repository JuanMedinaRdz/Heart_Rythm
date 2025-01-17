import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hearth_rythm/src/core/constants/app_color.dart';
import 'package:hearth_rythm/src/data/models/student_model.dart';
import 'package:hearth_rythm/src/data/repositories/student_repository.dart';
import 'package:hearth_rythm/src/widgets/north/custom_text_field.dart';
import 'package:hearth_rythm/src/widgets/north/date_picker_widget.dart';
import 'package:hearth_rythm/src/widgets/north/phone_text_field.dart';
import 'package:hearth_rythm/src/widgets/north/section_title.dart';
import 'package:hearth_rythm/src/widgets/north/selection_button_group.dart';
import 'package:hearth_rythm/src/widgets/north/succes_animation_dialog.dart';

class AddStudentScreen extends StatefulWidget {
  const AddStudentScreen({super.key});

  @override
  _AddStudentScreenState createState() => _AddStudentScreenState();
}

class _AddStudentScreenState extends State<AddStudentScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _paymentController = TextEditingController();

  String _selectedDanceStyle = '';
  String _selectedSchedule = '';
  String _selectedLevel = '';
  String _selectedTeacher = '';
  DateTime? _classDate;

  final _studentRepo = StudentRepository();

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _paymentController.dispose();
    super.dispose();
  }

  void _saveStudent() {
  try {
    final student = Student(
      name: _nameController.text.trim(),
      phone: _phoneController.text.trim(),
      amount: _paymentController.text.trim(),
      danceStyle: _selectedDanceStyle,
      schedule: _selectedSchedule,
      level: _selectedLevel,
      teacher: _selectedTeacher,
      classDate: _classDate,
    );
    _studentRepo.addStudent(student);
    _showSuccessAnimation();
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(e.toString())),
    );
  }
}


  void _showSuccessAnimation() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return SuccessAnimationDialog(
          message: 'Alumno agregado con éxito',
        );
      },
    );

    Future.delayed(const Duration(seconds: 2), () {
      Navigator.of(context).pop();
      GoRouter.of(context).push('/north_screen');
    });
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
                const SectionTitle('Selecciona el estilo de baile'),
                SelectionButtonGroup(
                  options: const ['Salsa', 'Cumbia', 'Kisomba'],
                  selectedValue: _selectedDanceStyle,
                  onSelected: (value) =>
                      setState(() => _selectedDanceStyle = value),
                ),
                const SizedBox(height: 16.0),
                const SectionTitle('Selecciona el horario'),
                SelectionButtonGroup(
                  options: const ['Lun/Mie', 'Mar/Jue', 'Sabado', 'Miercoles', 'Viernes'],
                  selectedValue: _selectedSchedule,
                  onSelected: (value) =>
                      setState(() => _selectedSchedule = value),
                ),
                const SizedBox(height: 16.0),
                const SectionTitle('Selecciona el nivel'),
                SelectionButtonGroup(
                  options: const [
                    'Básico',
                    'Básico Avanzado',
                    'Intermedio',
                    'Clase Muestra'
                  ],
                  selectedValue: _selectedLevel,
                  onSelected: (value) => setState(() => _selectedLevel = value),
                ),
                if (_selectedLevel == 'Clase Muestra')
                  DatePickerWidget(
                    selectedDate: _classDate,
                    onDateSelected: (pickedDate) =>
                        setState(() => _classDate = pickedDate),
                  ),
                const SizedBox(height: 16.0),
                const SectionTitle('Cantidad en pesos'),
                _buildPaymentField(
                    'Ingresa la cantidad en pesos', _paymentController),
                const SizedBox(height: 16.0),
                const SectionTitle('Selecciona el Maestro'),
                SelectionButtonGroup(
                  options: const ['Desi', 'Nico', 'Juan', 'Ximena', 'Monse', 'Rebeca'],
                  selectedValue: _selectedTeacher,
                  onSelected: (value) =>
                      setState(() => _selectedTeacher = value),
                ),
                const SizedBox(height: 24.0),
                Center(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryEnd,
                      padding: const EdgeInsets.symmetric(
                          vertical: 12, horizontal: 24),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16.0),
                      ),
                    ),
                    onPressed: () {
                      if (_formKey.currentState!.validate() &&
                          _selectedDanceStyle.isNotEmpty &&
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
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(String hintText, TextEditingController controller) {
    return CustomTextField(
      hintText: hintText,
      controller: controller,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Por favor ingresa un valor';
        }
        final words = value.trim().split(' ');
        if (words.length < 2) {
          return 'Ingresa al menos 2 nombres. (Nombre - Apellido)';
        }
        return null;
      },
      icon: const Icon(Icons.person),
    );
  }

  Widget _buildPhoneField(String hintText, TextEditingController controller) {
    return PhoneTextField(controller: controller);
  }

  Widget _buildPaymentField(String hintText, TextEditingController controller) {
    // Ejemplo de validación simple. También podrías parsear a double si lo requieres.
    return CustomTextField(
      hintText: hintText,
      controller: controller,
      keyboardType: TextInputType.number,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Por favor ingresa la cantidad en pesos';
        }
        // Validación simple para comprobar que sea numérico
        final numericRegex = RegExp(r'^[0-9]+(\.[0-9]+)?$');
        if (!numericRegex.hasMatch(value)) {
          return 'Ingresa un valor numérico válido';
        }
        return null;
      },
      icon: const Icon(Icons.attach_money),
    );
  }
}
