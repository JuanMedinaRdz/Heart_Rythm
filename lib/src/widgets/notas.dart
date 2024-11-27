import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:go_router/go_router.dart';
import 'package:hearth_rythm/src/data/models/note_model.dart';
import 'package:hearth_rythm/src/features/note_detail_screen.dart';
import 'package:hearth_rythm/src/widgets/notes_list.dart';

class NotasScreen extends StatefulWidget {
  const NotasScreen({super.key});

  @override
  State<NotasScreen> createState() => _NotasScreenState();
}

class _NotasScreenState extends State<NotasScreen> {
  Note? _selectedNote; // Nota actualmente seleccionada para visualizar o editar
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();

  Future<void> _saveNote() async {
    if (_selectedNote != null) {
  final updatedNote = _selectedNote!.copyWith(
  title: _titleController.text,
  content: _contentController.text,
  updatedAt: DateTime.now(),
);


      await FirebaseFirestore.instance
          .collection('notes')
          .doc(updatedNote.id)
          .update(updatedNote.toMap());

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Nota actualizada')),
      );

      setState(() {
        _selectedNote = null; // Oculta la vista de edición
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Notas"),
        actions: [
          IconButton(
            icon: const Icon(Icons.category),
            onPressed: () {
              // Navegación a la pantalla de gestión de categorías
              context.go('/north_screen/notas_screen/category-manager');
            },
          ),
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('notes')
            .orderBy('createdAt', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text("No hay notas registradas"));
          }

          final notes = snapshot.data!.docs.map((doc) {
            return Note.fromDocument(doc.data() as Map<String, dynamic>, doc.id);
          }).toList();

          return NotesList(
            notes: notes,
            onNoteSelected: (note) {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => NoteDetailScreen(note: note),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
                        context.go('/north_screen/notas_screen/note-form');

        },
        child: const Icon(Icons.add),
      ),
    );
  }
}