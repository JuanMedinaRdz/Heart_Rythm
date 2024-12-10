import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart'; // Para HapticFeedback
import 'package:hearth_rythm/src/core/constants/app_color.dart';

// Puedes mantener la vista horizontal o vertical. Aquí optamos por la horizontal tipo timeline
// pero con las mejoras visuales y el encabezado.
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
  Map<String, bool> paidMonths = {};
  String selectedYear = DateTime.now().year.toString(); // Año actual por defecto

  final months = [
    'Enero', 'Febrero', 'Marzo', 'Abril', 'Mayo', 'Junio',
    'Julio', 'Agosto', 'Septiembre', 'Octubre', 'Noviembre', 'Diciembre'
  ];

  @override
  void initState() {
    super.initState();
    _loadPaidMonths();
  }

  Future<void> _loadPaidMonths() async {
    final doc = await FirebaseFirestore.instance
        .collection('students')
        .doc(widget.docId)
        .get();
    final data = doc.data();
    if (data != null && data['paidMonths'] != null && data['paidMonths'][selectedYear] != null) {

      setState(() {
        paidMonths = Map<String, bool>.from(data['paidMonths'][selectedYear]);
      });
    } else {
      setState(() {
        paidMonths = {}; // Ningún mes pagado en este año
      });
    }
  }

  Future<void> _toggleMonth(String month) async {
    final current = paidMonths[month] ?? false;
    // Haptic feedback al interactuar
    HapticFeedback.mediumImpact();

    setState(() {
      paidMonths[month] = !current;
    });

    // Actualizar en Firebase la estructura con el año
    await FirebaseFirestore.instance
        .collection('students')
        .doc(widget.docId)
        .update({
      'paidMonths.$selectedYear': paidMonths
    });
  }

  void _changeYear(String newYear) async {
    setState(() {
      selectedYear = newYear;
    });
    await _loadPaidMonths();
  }

  @override
  Widget build(BuildContext context) {
    final paidCount = paidMonths.values.where((v) => v).length;
    final progress = paidCount / months.length;

    return Scaffold(
appBar: AppBar(
  leading: IconButton(
    icon: const Icon(Icons.arrow_back),
    onPressed: () {
      Navigator.of(context).pop(); // Regresa a la pantalla anterior
    },
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
              _buildHeader(context),
              const SizedBox(height: 16),
              _buildStats(paidCount, progress),
              const SizedBox(height: 16),
              _buildMonthTimeline(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal:16.0, vertical: 8.0),
      child: Row(
        children: [
          // Icono representativo, podría ser un avatar con iniciales del alumno
          CircleAvatar(
            radius: 24,
            backgroundColor: AppColors.primaryEnd,
            child: Text(
              widget.studentName.isNotEmpty ? widget.studentName[0] : '?',
              style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.studentName,
                  style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                Text(
                  'Mensualidades $selectedYear',
                  style: const TextStyle(fontSize: 16, color: Colors.white, fontWeight: FontWeight.bold),
                ),
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

  List<DropdownMenuItem<String>> _buildYearOptions() {
    final currentYear = DateTime.now().year;
    // Ejemplo: 2 años atrás, año actual, y 2 años adelante
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
                  _buildLegendItem(AppColors.primaryStart, 'Pagado'),
                  const SizedBox(width: 16),
                  _buildLegendItem(Colors.grey[300]!, 'Pendiente'),
                ],
              )
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

  Widget _buildMonthTimeline() {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal:16.0),
        child: ListView.separated(
          itemCount: months.length,
          separatorBuilder: (_, __) => const SizedBox(height: 12),
          itemBuilder: (context, index) {
            final month = months[index];
            final isPaid = paidMonths[month] ?? false;
            return _buildMonthCard(month, isPaid);
          },
        ),
      ),
    );
  }

Widget _buildMonthCard(String month, bool isPaid) {
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
          color: Colors.black, // Asegura que el texto sea negro
        ),
      ),
      trailing: Icon(
        isPaid ? Icons.check_circle : Icons.radio_button_unchecked,
        color: isPaid ? Colors.white : Colors.black54,
      ),
      onTap: () => _toggleMonth(month),
    ),
  );
}

}
