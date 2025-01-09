class Student {
  final String name;
  final String phone;
  final String? amount;
  final String? danceStyle;
  final String schedule;
  final String level;
  final String teacher;
  final DateTime? classDate; // Solo si se selecciona clase muestra

  Student({
    required this.name,
    required this.phone,
    this.amount,
    this.danceStyle,
    required this.schedule,
    required this.level,
    required this.teacher,
    this.classDate,
  });

  // Convesión a mapa para Firebase
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'phone': phone,
      'amount': amount,
      'danceStyle': danceStyle,
      'schedule': schedule,
      'level': level,
      'teacher': teacher,
      'classDate': classDate?.toIso8601String(),
    };
  }
}
