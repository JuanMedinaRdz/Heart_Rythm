import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hearth_rythm/src/data/models/note_model.dart';

class NotesList extends StatelessWidget {
  final List<Note> notes;
  final Function(Note) onNoteSelected;

  const NotesList({
    super.key,
    required this.notes,
    required this.onNoteSelected,
  });

  Future<bool?> _confirmDelete(BuildContext context) async {
    return showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Eliminar Nota'),
          content: const Text('¿Estás seguro de que deseas eliminar esta nota?'),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text('Eliminar'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _deleteNoteFromFirebase(String noteId, BuildContext context) async {
    await FirebaseFirestore.instance.collection('notes').doc(noteId).delete();

    // Usa ScaffoldMessenger para mostrar un SnackBar seguro
    if (ScaffoldMessenger.maybeOf(context) != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Nota eliminada')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (notes.isEmpty) {
      return const Center(
        child: Text(
          "No hay notas registradas.",
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
      );
    }

    return ListView.builder(
      itemCount: notes.length,
      itemBuilder: (context, index) {
        final note = notes[index];

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          child: Dismissible(
            key: Key(note.id),
            direction: DismissDirection.endToStart,
            background: Container(
              color: Colors.red,
              alignment: Alignment.centerRight,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: const Icon(Icons.delete, color: Colors.white),
            ),
            confirmDismiss: (direction) async {
              final result = await _confirmDelete(context);
              return result ?? false;
            },
            onDismissed: (direction) async {
              await _deleteNoteFromFirebase(note.id, context);
            },
            child: SizedBox(
              width: double.infinity,
              child: GestureDetector(
                onTap: () => onNoteSelected(note),
                child: Hero(
                  tag: note.id, // Identificador único para evitar conflictos
                  child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Stack(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                note.title,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                note.content,
                                maxLines: 3,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(fontSize: 14),
                              ),
                            ],
                          ),
                        ),
                        if (note.categoryName != null && note.categoryColor != null)
                          Positioned(
                            top: 8,
                            right: 8,
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                CircleAvatar(
                                  backgroundColor: note.categoryColor,
                                  radius: 8,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  note.categoryName!,
                                  style: const TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.grey,
                                  ),
                                ),
                              ],
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
