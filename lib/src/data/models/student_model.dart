class Student {
  final String name;
  final String phone;
  final String? danceStyle;
  final String schedule;
  final String level;
  final DateTime? classDate; // Solo si se selecciona clase muestra

  Student({
    required this.name,
    required this.phone,
     this.danceStyle,
    required this.schedule,
    required this.level,
    this.classDate,
  });

  // Convesión a mapa para Firebase 
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'phone': phone,
      'danceStyle': danceStyle,
      'schedule': schedule,
      'level': level,
      'classDate': classDate?.toIso8601String(),
    };
  }


}