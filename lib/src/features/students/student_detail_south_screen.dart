import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:lottie/lottie.dart';

class StudentDetailSouthScreen extends StatefulWidget {
  final Map<String, dynamic> studentData;
  final String name;
  final String docId;

  const StudentDetailSouthScreen({
    required this.studentData,
    required this.name,
    required this.docId,
    super.key,
  });

  @override
  _StudentDetailSheetStateSouth createState() =>
      _StudentDetailSheetStateSouth();
}

class _StudentDetailSheetStateSouth extends State<StudentDetailSouthScreen> {
  Map<String, bool> paidMonths = {};
  bool _showAnimation = false;

  @override
  void initState() {
    super.initState();
    // Cargar el estado de pagos de Firebase, si existe
    loadPaidMonths();
  }

  void loadPaidMonths() {
    if (widget.studentData.containsKey('paidMonths')) {
      setState(() {
        paidMonths = Map<String, bool>.from(widget.studentData['paidMonths']);
      });
    }
  }

  void updateMonthPayment(String month, bool isPaid) {
    setState(() {
      paidMonths[month] = isPaid;
      _showAnimation = true;
    });
        Future.delayed(const Duration(seconds: 5), () {
      setState(() {
        _showAnimation = false;
      });
    });

    // Actualizar en Firebase el estado de pagos de mensualidades
    FirebaseFirestore.instance
        .collection('studentsSouth')
        .doc(widget.docId)
        .update({'paidMonths': paidMonths});
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Nombre del alumno
          Text(
            widget.name,
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          // Teléfono del alumno
          Text(
            'Teléfono: ${widget.studentData['phone'] ?? 'Sin Teléfono'}',
            style: TextStyle(fontSize: 16),
          ),
          const SizedBox(height: 16),
          // Título de mensualidades
          Text(
            'Mensualidades Pagadas',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          // Lista de meses para registrar el pago de mensualidades
          Expanded(
            child: Stack(children: [
              ListView(
                children: [
                  for (var month in [
                    'Enero',
                    'Febrero',
                    'Marzo',
                    'Abril',
                    'Mayo',
                    'Junio',
                    'Julio',
                    'Agosto',
                    'Septiembre',
                    'Octubre',
                    'Noviembre',
                    'Diciembre'
                  ])
                    ListTile(
                      title: Text(month),
                      trailing: Checkbox(
                        value: paidMonths[month] ?? false,
                        onChanged: (value) {
                          updateMonthPayment(month, value ?? false);
                        },
                      ),
                    ),
                ],
              ),
              if (_showAnimation)
                Center(
                  child: Lottie.asset(
                    'lib/src/core/assets/animations/cash.json', // Ruta del archivo Lottie
                    width: 250,
                    height: 250,
                    repeat: false,
                  ),
                )
            ]),
          ),
          const SizedBox(height: 8),
          // Botón para cerrar el sheet
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cerrar'),
          ),
        ],
      ),
    );
  }
}
