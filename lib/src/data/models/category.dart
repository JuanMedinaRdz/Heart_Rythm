import 'dart:ui';

class NoteCategory {
  final String name;
  final Color color;

  NoteCategory({required this.name, required this.color});

  factory NoteCategory.fromMap(Map<String, dynamic> map) {
    return NoteCategory(
      name: map['name'],
      color: Color(map['color']),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'color': color.value,
    };
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is NoteCategory &&
        other.name == name &&
        other.color == color;
  }

  @override
  int get hashCode => name.hashCode ^ color.hashCode;
}
