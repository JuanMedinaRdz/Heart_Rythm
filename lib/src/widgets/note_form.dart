import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hearth_rythm/src/data/models/category.dart';
import 'package:hearth_rythm/src/data/models/note_model.dart';

class NoteForm extends StatefulWidget {
  final Note? note;

  const NoteForm({super.key, this.note});

  @override
  State<NoteForm> createState() => _NoteFormState();
}

class _NoteFormState extends State<NoteForm> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();
  NoteCategory? _selectedCategory;

  @override
  void initState() {
    super.initState();
    if (widget.note != null) {
      _titleController.text = widget.note!.title;
      _contentController.text = widget.note!.content;
      _selectedCategory = NoteCategory(
        name: widget.note!.categoryName ?? "",
        color: widget.note!.categoryColor ?? Colors.grey,
      );
    }
  }

  void _saveNote() {
    if (_titleController.text.isEmpty ||
        _contentController.text.isEmpty ||
        _selectedCategory == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Completa todos los campos")),
      );
      return;
    }

    final note = Note(
      id: widget.note?.id ?? '',
      title: _titleController.text,
      content: _contentController.text,
      createdAt: widget.note?.createdAt ?? DateTime.now(),
      updatedAt: DateTime.now(),
      categoryName: _selectedCategory!.name,
      categoryColor: _selectedCategory!.color,
    );

    final collection = FirebaseFirestore.instance.collection('notes');
    if (widget.note == null) {
      collection.add(note.toMap());
    } else {
      collection.doc(note.id).update(note.toMap());
    }

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Nueva Nota"),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Card(
          elevation: 8,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: Padding(
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
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
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
                  maxLines: 6,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    hintText: "Escribe el contenido de la nota",
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  "Categoría",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance.collection('categories').snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                      return const Text("No hay categorías disponibles");
                    }

                    final categories = snapshot.data!.docs.map((doc) {
                      final data = doc.data() as Map<String, dynamic>;
                      return NoteCategory.fromMap(data);
                    }).toList();

                    return DropdownButton<NoteCategory>(
  value: _selectedCategory,
  isExpanded: true,
  hint: const Text("Seleccionar categoría"),
  onChanged: (category) {
    setState(() {
      _selectedCategory = category;
    });
  },
  items: categories.map((category) {
    return DropdownMenuItem(
      value: category,
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: category.color,
          ),
          const SizedBox(width: 10),
          Text(category.name),
        ],
      ),
    );
  }).toList(),
);

                  },
                ),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _saveNote,
        icon: const Icon(Icons.save),
        label: const Text("Guardar Nota"),
      ),
    );
  }
}
