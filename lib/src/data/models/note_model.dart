import 'dart:ui';
import 'package:cloud_firestore/cloud_firestore.dart';

class Note {
  final String id;
  final String title;
  final String content;
  final DateTime createdAt;
  final DateTime? updatedAt;
  final String? categoryName;
  final Color? categoryColor;

  Note({
    required this.id,
    required this.title,
    required this.content,
    required this.createdAt,
    this.updatedAt,
    this.categoryName,
    this.categoryColor,
  });

  factory Note.fromDocument(Map<String, dynamic> doc, String id) {
    DateTime _convertToDateTime(dynamic value) {
      if (value is Timestamp) {
        return value.toDate();
      } else if (value is String) {
        return DateTime.parse(value);
      } else {
        throw Exception("Invalid date format");
      }
    }

    return Note(
      id: id,
      title: doc['title'] as String,
      content: doc['content'] as String,
      createdAt: _convertToDateTime(doc['createdAt']),
      updatedAt: doc['updatedAt'] != null
          ? _convertToDateTime(doc['updatedAt'])
          : null,
      categoryName: doc['categoryName'] as String?,
      categoryColor: doc['categoryColor'] != null
          ? Color(int.parse(doc['categoryColor'] as String))
          : null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'content': content,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
      'categoryName': categoryName,
      'categoryColor': categoryColor?.value.toString(),
    };
  }

  Note copyWith({
    String? id,
    String? title,
    String? content,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? categoryName,
    Color? categoryColor,
  }) {
    return Note(
      id: id ?? this.id,
      title: title ?? this.title,
      content: content ?? this.content,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      categoryName: categoryName ?? this.categoryName,
      categoryColor: categoryColor ?? this.categoryColor,
    );
  }
}
