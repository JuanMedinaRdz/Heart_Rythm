import 'package:flutter/material.dart';

class EditStudentForm extends StatefulWidget {
  final Map<String, dynamic> initialData;
  final ValueChanged<Map<String, dynamic>> onSave;

  const EditStudentForm({
    super.key,
    required this.initialData,
    required this.onSave,
  });

  @override
  State<EditStudentForm> createState() => _EditStudentFormState();
}

class _EditStudentFormState extends State<EditStudentForm> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _phoneController;
  String _selectedLevel = '';
  String _selectedTeacher = '';
  String _selectedSchedule = '';
  DateTime? _classDate;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.initialData['name']);
    _phoneController = TextEditingController(text: widget.initialData['phone']);
    _selectedLevel = widget.initialData['level'] ?? '';
    _selectedTeacher = widget.initialData['teacher'] ?? '';
    _selectedSchedule = widget.initialData['schedule'] ?? '';

    // Si el alumno ya tenía classDate como String ISO8601,
    // conviértelo a DateTime para poder mostrar/editar
    if (_selectedLevel == 'Clase Muestra' && widget.initialData['classDate'] != null) {
      final rawDate = widget.initialData['classDate'];
      if (rawDate is String) {
        _classDate = DateTime.tryParse(rawDate);
      }
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  void _saveChanges() {
    if (_formKey.currentState!.validate()
        && _selectedLevel.isNotEmpty
        && _selectedTeacher.isNotEmpty
        && _selectedSchedule.isNotEmpty) 
    {
      final updatedData = {
        'name': _nameController.text,
        'phone': _phoneController.text,
        'level': _selectedLevel,
        'teacher': _selectedTeacher,
        'schedule': _selectedSchedule,
        'updatedAt': DateTime.now(),
      };

      // Si es Clase Muestra, guarda la fecha en formato ISO8601
      if (_selectedLevel == 'Clase Muestra' && _classDate != null) {
        updatedData['classDate'] = _classDate!.toIso8601String();
      } else {
        // Si dejas de ser Clase Muestra, podrías eliminarlo
        // updatedData['classDate'] = null;
      }

      widget.onSave(updatedData);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Completa todos los campos')),
      );
    }
  }

  void _pickClassDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _classDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() {
        _classDate = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            _buildTextField('Nombre', _nameController),
            const SizedBox(height: 8),
            _buildPhoneField('Teléfono', _phoneController),
            const SizedBox(height: 8),
            _buildDropdownField(
              title: "Nivel",
              value: _selectedLevel,
              options: ['Básico', 'Básico Avanzado', 'Intermedio', 'Clase Muestra'],
              onChanged: (value) => setState(() => _selectedLevel = value ?? ''),
            ),
            const SizedBox(height: 8),
            _buildDropdownField(
              title: "Maestro",
              value: _selectedTeacher,
              options: ['Desi', 'Nico', 'Juan', 'Ximena', 'Monse'],
              onChanged: (value) => setState(() => _selectedTeacher = value ?? ''),
            ),
            const SizedBox(height: 8),
            _buildDropdownField(
              title: "Día",
              value: _selectedSchedule,
              options: ['Lun/Mie', 'Mar/Jue', 'Sabado'],
              onChanged: (value) => setState(() => _selectedSchedule = value ?? ''),
            ),
            // Mostrar un campo de fecha si es clase muestra
            if (_selectedLevel == 'Clase Muestra')
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('Fecha Clase Muestra: '),
                    Text(
                      _classDate == null
                          ? 'No seleccionada'
                          : '${_classDate!.toLocal()}'.split(' ')[0],
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(width: 8),
                    IconButton(
                      icon: const Icon(Icons.calendar_today),
                      onPressed: _pickClassDate,
                    ),
                  ],
                ),
              ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _saveChanges,
              child: const Text('Guardar Cambios'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(labelText: label),
      validator: (value) => (value == null || value.isEmpty) ? 'Campo requerido' : null,
    );
  }

  Widget _buildPhoneField(String label, TextEditingController controller) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(labelText: label),
      keyboardType: TextInputType.phone,
      validator: (value) {
        if (value == null || value.isEmpty) return 'Campo requerido';
        if (!RegExp(r'^\d{10}$').hasMatch(value)) {
          return 'Número inválido (10 dígitos)';
        }
        return null;
      },
    );
  }

  Widget _buildDropdownField({
    required String title,
    required String value,
    required List<String> options,
    required ValueChanged<String?> onChanged,
  }) {
    return DropdownButtonFormField<String>(
      decoration: InputDecoration(labelText: title),
      value: value.isEmpty ? null : value,
      items: options
          .map((opt) => DropdownMenuItem<String>(
                value: opt,
                child: Text(opt),
              ))
          .toList(),
      onChanged: onChanged,
      validator: (val) => (val == null || val.isEmpty) ? 'Campo requerido' : null,
    );
  }
}
