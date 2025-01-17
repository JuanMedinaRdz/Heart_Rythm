class StudentValidationException implements Exception {
  final String message;

  StudentValidationException(this.message);

  @override
  String toString() => 'StudentValidationException: $message';
}

class Student {
  final String name;
  final String phone;
  final String? amount;
  final String? danceStyle;
  final String schedule;
  final String level;
  final String teacher;
  final DateTime? classDate; // Solo si se selecciona clase muestra

  Student._({
    required this.name,
    required this.phone,
    this.amount,
    this.danceStyle,
    required this.schedule,
    required this.level,
    required this.teacher,
    this.classDate,
  });

  /// Constructor factory con validaciones
  factory Student({
    required String name,
    required String phone,
    String? amount,
    String? danceStyle,
    required String schedule,
    required String level,
    required String teacher,
    DateTime? classDate,
  }) {
    // Validaciones
    if (name.trim().split(' ').length < 2) {
      throw StudentValidationException('El nombre debe tener al menos dos palabras.');
    }

    if (phone.isEmpty || !RegExp(r'^\d{10}$').hasMatch(phone)) {
      throw StudentValidationException('El número de teléfono debe ser válido (10 dígitos).');
    }

    if (amount != null && double.tryParse(amount) == null) {
      throw StudentValidationException('La cantidad debe ser un número válido.');
    }

    if (level == 'Clase Muestra' && classDate == null) {
      throw StudentValidationException('La fecha es requerida para una Clase Muestra.');
    }

    // Si todas las validaciones pasan, crea la instancia
    return Student._(
      name: name,
      phone: phone,
      amount: amount,
      danceStyle: danceStyle,
      schedule: schedule,
      level: level,
      teacher: teacher,
      classDate: classDate,
    );
  }

  /// Conversión a mapa para Firebase
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
