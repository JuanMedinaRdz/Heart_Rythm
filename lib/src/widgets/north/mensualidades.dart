import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class MensualidadScreen extends StatefulWidget {
  const MensualidadScreen({Key? key}) : super(key: key);

  @override
  State<MensualidadScreen> createState() => _MensualidadScreenState();
}

class _MensualidadScreenState extends State<MensualidadScreen> {
  Map<String, int> monthlyPayments = {
    "Enero": 0,
    "Febrero": 0,
    "Marzo": 0,
    "Abril": 0,
    "Mayo": 0,
    "Junio": 0,
    "Julio": 0,
    "Agosto": 0,
    "Septiembre": 0,
    "Octubre": 0,
    "Noviembre": 0,
    "Diciembre": 0,
  };

  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchMonthlyPayments();
  }

  Future<void> _fetchMonthlyPayments() async {
    try {
      final snapshot =
          await FirebaseFirestore.instance.collection('students').get();

      for (var doc in snapshot.docs) {
        Map<String, dynamic> paidMonths = doc['paidMonths'] ?? {};
        paidMonths.forEach((month, hasPaid) {
          if (hasPaid == true) {
            monthlyPayments[month] = (monthlyPayments[month] ?? 0) + 1;
          }
        });
      }
    } catch (e) {
      print('Error fetching data: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Porcentaje de pago por mes')),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: monthlyPayments.values.every((count) => count == 0)
                  ? const Center(
                      child: Text('No hay datos para mostrar.'),
                    )
                  : PieChart(
                      PieChartData(
                        sections: _generatePieSections(),
                        centerSpaceRadius: 120,
                        sectionsSpace: 10,
                        borderData: FlBorderData(show: true),
                        // Configura la animación automáticamente
                        startDegreeOffset: 0,
                      ),
                    ),
            ),
    );

  }

  List<PieChartSectionData> _generatePieSections() {
    final totalPayments = monthlyPayments.values.reduce((a, b) => a + b);

    return monthlyPayments.entries
        .where((entry) => entry.value > 0)
        .map((entry) {
          final percentage = (entry.value / totalPayments) * 100;

          return PieChartSectionData(
            value: entry.value.toDouble(),
            title: '${entry.key}\n${percentage.toStringAsFixed(1)}%',
            color: _getColorForMonth(entry.key),
            radius: 50,
            titleStyle: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          );
        })
        .toList();
  }

  Color _getColorForMonth(String month) {
    final colors = [
      Colors.red,
      Colors.orange,
      Color.fromARGB(255, 96, 180, 212),
      Colors.green,
      Colors.teal,
      Colors.blue,
      Colors.indigo,
      Colors.purple,
      Colors.pink,
      Colors.brown,
      Colors.cyan,
      Color.fromARGB(255, 212, 56, 186),
    ];

    final index = [
      "Enero",
      "Febrero",
      "Marzo",
      "Abril",
      "Mayo",
      "Junio",
      "Julio",
      "Agosto",
      "Septiembre",
      "Octubre",
      "Noviembre",
      "Diciembre",
    ].indexOf(month);

    return colors[index % colors.length];
  }
  
}
