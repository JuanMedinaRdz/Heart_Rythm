import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hearth_rythm/src/core/constants/app_color.dart';
import 'package:hearth_rythm/src/features/students/edtih_student_south.dart';
import 'package:hearth_rythm/src/features/students/monthly_payment_south.dart';
import 'package:hearth_rythm/src/widgets/north/succes_animation_dialog.dart';

class StudentDetailScreenSouth extends StatefulWidget {
  final Map<String, dynamic> studentData;
  final String name;
  final String docId;

  const StudentDetailScreenSouth({
    required this.studentData,
    required this.name,
    required this.docId,
    super.key,
  });

  @override
  State<StudentDetailScreenSouth> createState() => _StudentDetailScreenSouthState();
}

class _StudentDetailScreenSouthState extends State<StudentDetailScreenSouth> {
  bool _isLoading = false;

  String get phone => widget.studentData['phone'] ?? 'Sin Teléfono';
  String get teacher => widget.studentData['teacher'] ?? 'Maestro desconocido';
  String get schedule => widget.studentData['schedule'] ?? 'Sin Horario';

  void _openEditForm() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape:
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
      builder: (context) {
        return SafeArea(
          child: Padding(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom,
              left: 16,
              right: 16,
              top: 16,
            ),
            child: EditStudentFormSouth(
              initialData: widget.studentData,
              onSave: _updateStudent,
            ),
          ),
        );
      },
    );
  }

  Future<void> _updateStudent(Map<String, dynamic> updatedData) async {
    Navigator.pop(context); 

    setState(() {
      _isLoading = true;
    });

    try {
      await FirebaseFirestore.instance
          .collection('studentsSouth')
          .doc(widget.docId)
          .update(updatedData);
      setState(() {
        _isLoading = false;
      });
      _showSuccessAnimation();
    } catch (error) {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error al actualizar el alumno')),
      );
    }
  }

  void _showSuccessAnimation() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return const SuccessAnimationDialog(
          message: 'Alumno actualizado con éxito',
        );
      },
    );

    Future.delayed(const Duration(seconds: 2), () {
      Navigator.of(context).pop(); 
    });
  }

  void _goToMonthlyPayments() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => MonthlyPaymentScreenSouth(
          docId: widget.docId,
          studentName: widget.name,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final name = widget.name;

    return _isLoading
        ? const Center(child: CircularProgressIndicator())
        : Padding(
            padding: const EdgeInsets.all(16.0),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Center(
                    child: Text(
                      name,
                      style: const TextStyle(
                          fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Center(
                    child: Text(
                      'Teléfono: $phone',
                      style: const TextStyle(fontSize: 16),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Center(
                    child: Text(
                      'Maestro: $teacher',
                      style: const TextStyle(fontSize: 16),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Center(
                    child: Text(
                      'Día: $schedule',
                      style: const TextStyle(fontSize: 16),
                    ),
                  ),
                  const SizedBox(height: 26),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildActionButton(
                        icon: Icons.payment,
                        label: 'Mensualidades',
                        onTap: _goToMonthlyPayments,
                      ),
                      _buildActionButton(
                        icon: Icons.edit,
                        label: 'Editar Alumno',
                        onTap: _openEditForm,
                      ),
                      _buildActionButton(
                        icon: Icons.star,
                        label: 'Extra',
                        onTap: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Funcionalidad extra :)')),
                          );
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 26),
                  ElevatedButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text('Cerrar'),
                  ),
                ],
              ),
            ),
          );
  }

Widget _buildActionButton({
  required IconData icon,
  required String label,
  required VoidCallback onTap,
}) {
  return Column(
    children: [
      InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8.0), // Ajusta el radio para esquinas más o menos redondeadas
        child: Container(
          width: 100,
          height: 55,
          decoration: BoxDecoration(
            color: AppColors.secondStart,
            borderRadius: BorderRadius.circular(8.0), // Ajusta para hacerlo más cuadrado o sin borde redondeado
          ),
          child: Icon(icon, color: Colors.white),
        ),
      ),
      const SizedBox(height: 4),
      Text(label, style: const TextStyle(fontSize: 14)),
    ],
  );
}

}
