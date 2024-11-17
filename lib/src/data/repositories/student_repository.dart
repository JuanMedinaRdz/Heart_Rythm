import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hearth_rythm/src/data/models/student_model.dart';

class StudentRepository {
  final CollectionReference studentCollection = FirebaseFirestore.instance.collection('students');

  Future<void> addStudent(Student student) {
    return studentCollection.add(student.toMap());
  }
}

class StudentSouthRepository {
  final CollectionReference studentCollection = FirebaseFirestore.instance.collection('studentsSouth');

  Future<void> addStudent(Student student) {
    return studentCollection.add(student.toMap());
  }
}