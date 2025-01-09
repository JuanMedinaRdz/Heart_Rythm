import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart'; 
import 'package:hearth_rythm/src/core/constants/app_color.dart';

class MonthlyPaymentScreen extends StatefulWidget {
  final String docId;
  final String studentName;

  const MonthlyPaymentScreen({
    super.key,
    required this.docId,
    required this.studentName,
  });

  @override
  State<MonthlyPaymentScreen> createState() => _MonthlyPaymentScreenState();
}

class _MonthlyPaymentScreenState extends State<MonthlyPaymentScreen> {
  // Estructura: paidMonths[year][month] = { "amountPaid": double, "isPaid": bool }
  Map<String, dynamic> paidMonthsYear = {};
  String selectedYear = DateTime.now().year.toString(); 

  double amount = 0.0; // Cantidad total a pagar por mes
  final months = [
    'Enero', 'Febrero', 'Marzo', 'Abril', 'Mayo', 'Junio',
    'Julio', 'Agosto', 'Septiembre', 'Octubre', 'Noviembre', 'Diciembre'
  ];

  @override
  void initState() {
    super.initState();
    _loadStudentData();
  }

  // Carga los datos del alumno, incluyendo su 'amount' y 'paidMonths'
  Future<void> _loadStudentData() async {
    final doc = await FirebaseFirestore.instance
        .collection('students')
        .doc(widget.docId)
        .get();
    final data = doc.data();
    if (data == null) return;

    // 1) Obtenemos el "amount" que define cuánto se debe pagar cada mes
    amount = double.tryParse(data['amount'].toString()) ?? 0.0;

    // 2) Cargamos la info de paidMonths para el año seleccionado
    if (data['paidMonths'] != null && data['paidMonths'][selectedYear] != null) {
      setState(() {
        paidMonthsYear = Map<String, dynamic>.from(data['paidMonths'][selectedYear]);
      });
    } else {
      setState(() {
        paidMonthsYear = {};
      });
    }
  }

  void _changeYear(String newYear) async {
    setState(() {
      selectedYear = newYear;
    });
    await _loadStudentData();
  }

  @override
  Widget build(BuildContext context) {
    final paidCount = paidMonthsYear.values
        .where((monthMap) => (monthMap['isPaid'] ?? false) == true)
        .length;
    final progress = paidCount / months.length;

    return Scaffold(
      appBar: AppBar(
        title: Text('Mensualidades - ${widget.studentName}'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.black12, Colors.black26],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              const SizedBox(height: 16),
              _buildHeader(),        // Encabezado con Monto, botón edición, y selector de año
              const SizedBox(height: 16),
              _buildStats(paidCount, progress),
              const SizedBox(height: 16),
              _buildMonthlyList(),
            ],
          ),
        ),
      ),
    );
  }

  // Encabezado: Muestra el monto mensual y un botón para cambiarlo
  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal:16.0),
      child: Row(
        children: [
          // Texto de Monto Mensual
          Expanded(
            child: Row(
              children: [
                Text(
                  'Monto Mensual: \$${amount.toStringAsFixed(2)}', 
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                IconButton(
                  icon: const Icon(Icons.edit),
                  onPressed: _showEditAmountDialog,
                  tooltip: 'Editar Monto Mensual',
                )
              ],
            ),
          ),
          // Dropdown para cambiar el año
          DropdownButton<String>(
            value: selectedYear,
            items: _buildYearOptions(),
            onChanged: (value) {
              if (value != null) _changeYear(value);
            },
          )
        ],
      ),
    );
  }

  // Muestra un diálogo para editar el monto (amount)
  void _showEditAmountDialog() {
    final TextEditingController amountController = 
      TextEditingController(text: amount.toStringAsFixed(2));

    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          title: const Text('Editar Monto Mensual'),
          content: TextField(
            controller: amountController,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              labelText: 'Nuevo monto en pesos',
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx), 
              child: const Text('Cancelar')
            ),
            ElevatedButton(
              onPressed: () async {
                final input = amountController.text.trim();
                if (input.isEmpty) return;

                final newAmount = double.tryParse(input) ?? 0.0;
                await _updateAmount(newAmount);

                if (mounted) Navigator.pop(ctx);
              }, 
              child: const Text('Guardar'),
            )
          ],
        );
      }
    );
  }

  Future<void> _updateAmount(double newAmount) async {
    // 1) Actualiza la variable local
    setState(() {
      amount = newAmount;
    });

    // 2) Guarda en Firebase
    await FirebaseFirestore.instance
      .collection('students')
      .doc(widget.docId)
      .update({"amount": newAmount});
  }

  List<DropdownMenuItem<String>> _buildYearOptions() {
    final currentYear = DateTime.now().year;
    final years = List.generate(5, (i) => (currentYear - 2 + i).toString());

    return years.map((y) {
      return DropdownMenuItem<String>(
        value: y,
        child: Text(y),
      );
    }).toList();
  }

  Widget _buildStats(int paidCount, double progress) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal:16.0),
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        elevation: 2,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Pagado: $paidCount/${months.length}',
                  style: const TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              LinearProgressIndicator(
                value: progress,
                backgroundColor: Colors.grey[300],
                valueColor: const AlwaysStoppedAnimation<Color>(AppColors.primaryStart),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  _buildLegendItem(AppColors.primaryStart, 'Completado'),
                  const SizedBox(width: 16),
                  _buildLegendItem(Colors.grey[300]!, 'Pendiente'),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLegendItem(Color color, String label) {
    return Row(
      children: [
        Container(width: 16, height: 16, color: color),
        const SizedBox(width: 4),
        Text(label, style: const TextStyle(fontSize: 14)),
      ],
    );
  }

  Widget _buildMonthlyList() {
    return Expanded(
      child: ListView.separated(
        itemCount: months.length,
        separatorBuilder: (_, __) => const SizedBox(height: 12),
        padding: const EdgeInsets.symmetric(horizontal:16.0),
        itemBuilder: (context, index) {
          final month = months[index];
          final data = paidMonthsYear[month] ?? {"amountPaid": 0.0, "isPaid": false};
          final isPaid = data["isPaid"] ?? false;
          final amountPaid = data["amountPaid"] ?? 0.0;
          final color = isPaid ? AppColors.primaryStart : Colors.grey[300];

          return AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(10),
            ),
            child: ListTile(
              title: Text(
                month,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              subtitle: Text(
                'Pagado: \$${amountPaid.toStringAsFixed(2)} de \$${amount.toStringAsFixed(2)}',
                style: const TextStyle(fontSize: 14, color: Colors.black54),
              ),
              trailing: Icon(
                isPaid ? Icons.check_circle : Icons.radio_button_unchecked,
                color: isPaid ? Colors.white : Colors.black54,
              ),
              onTap: () => _showPaymentDialog(month),
            ),
          );
        },
      ),
    );
  }

  void _showPaymentDialog(String month) {
    final TextEditingController paymentController = TextEditingController();
    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          title: Text('Pago para $month'),
          content: TextField(
            controller: paymentController,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              labelText: 'Cantidad a abonar',
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx), 
              child: const Text('Cancelar')
            ),
            ElevatedButton(
              onPressed: () async {
                final input = paymentController.text.trim();
                if (input.isEmpty) return;

                final partialPayment = double.tryParse(input) ?? 0.0;
                await _addPartialPayment(month, partialPayment);
                if (mounted) Navigator.pop(ctx);
              }, 
              child: const Text('Guardar'),
            )
          ],
        );
      }
    );
  }

  Future<void> _addPartialPayment(String month, double partialPayment) async {
    HapticFeedback.mediumImpact();

    var currentData = paidMonthsYear[month] ?? {"amountPaid": 0.0, "isPaid": false};
    double currentPaid = (currentData["amountPaid"] ?? 0.0).toDouble();
    double updatedPaid = currentPaid + partialPayment;

    bool isPaidFlag = updatedPaid >= amount;

    final updatedMonthData = {
      "amountPaid": updatedPaid,
      "isPaid": isPaidFlag,
    };

    setState(() {
      paidMonthsYear[month] = updatedMonthData;
    });

    await FirebaseFirestore.instance
      .collection('students')
      .doc(widget.docId)
      .update({
        "paidMonths.$selectedYear.$month": updatedMonthData,
        "amount": amount, // Aseguramos que el amount se mantenga actualizado
      });
  }
}
