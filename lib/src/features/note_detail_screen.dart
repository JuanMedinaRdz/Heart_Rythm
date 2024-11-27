import 'package:flutter/material.dart';
import 'package:hearth_rythm/src/data/models/note_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class NoteDetailScreen extends StatefulWidget {
  final Note note;

  const NoteDetailScreen({super.key, required this.note});

  @override
  State<NoteDetailScreen> createState() => _NoteDetailScreenState();
}

class _NoteDetailScreenState extends State<NoteDetailScreen> {
  late TextEditingController _titleController;
  late TextEditingController _contentController;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.note.title);
    _contentController = TextEditingController(text: widget.note.content);
  }

  Future<void> _saveNote() async {
    final updatedNote = widget.note.copyWith(
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

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Detalle de la Nota"),
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: _saveNote,
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Título",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _titleController,
              style: const TextStyle(fontSize: 16),
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: "Escribe el título de la nota",
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              "Contenido",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _contentController,
              maxLines: 10,
              style: const TextStyle(fontSize: 16),
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: "Escribe el contenido de la nota",
              ),
            ),
            if (widget.note.categoryName != null &&
                widget.note.categoryColor != null)
              Padding(
                padding: const EdgeInsets.only(top: 16.0),
                child: Row(
                  children: [
                    CircleAvatar(
                      backgroundColor: widget.note.categoryColor,
                      radius: 12,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      widget.note.categoryName!,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}
