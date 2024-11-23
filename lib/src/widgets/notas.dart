import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hearth_rythm/src/core/constants/text_styles.dart';

class NotasScreen extends StatefulWidget {
  const NotasScreen({Key? key}) : super(key: key);

  @override
  _NotasScreenState createState() => _NotasScreenState();
}

class _NotasScreenState extends State<NotasScreen> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();
  bool _isCreating = false;

  Future<void> _addNote() async {
    final title = _titleController.text;
    final content = _contentController.text;

    if (title.isNotEmpty && content.isNotEmpty) {
      // Guardar la nota en Firebase
      await FirebaseFirestore.instance.collection('notes').add({
        'title': title,
        'content': content,
        'createdAt': Timestamp.now(),
      });

      // Limpiar los campos
      _titleController.clear();
      _contentController.clear();

      // Cerrar la sección de agregar nota
      setState(() {
        _isCreating = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Notas"),
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('notes')
                  .orderBy('createdAt', descending: true)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return const Center(child: Text("No hay notas."));
                }

                var notes = snapshot.data!.docs.map((doc) {
                  var data = doc.data() as Map<String, dynamic>;
                  return {
                    'id': doc.id,
                    'title': data['title'],
                    'content': data['content'],
                  };
                }).toList();

                return ListView.builder(
                  itemCount: notes.length,
                  itemBuilder: (context, index) {
                    var note = notes[index];
                    return GestureDetector(
                      onTap: () {
                        // Navegar a la pantalla de detalle de la nota
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => NotaDetalleScreen(noteId: note['id']),
                          ),
                        );
                      },
                      child: Card(
                        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                        child: ListTile(
                          title: Text(note['title']),
                          subtitle: Text(
                            note['content'],
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
          if (_isCreating) ...[
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  TextField(
                    controller: _titleController,
                    decoration: const InputDecoration(
                      labelText: 'Título',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    controller: _contentController,
                    maxLines: 3,
                    decoration: const InputDecoration(
                      labelText: 'Contenido',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                FloatingActionButton(
                  onPressed: _addNote,
                  child: const Icon(Icons.check),
                ),
              ],
            ),
          ]
        ],
      ),
      floatingActionButton: !_isCreating
          ? FloatingActionButton(
              onPressed: () {
                setState(() {
                  _isCreating = true;
                });
              },
              child: const Icon(Icons.add),
            )
          : null,
    );
  }
}

class NotaDetalleScreen extends StatelessWidget {
  final String noteId;

  const NotaDetalleScreen({Key? key, required this.noteId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Detalle de Nota")),
      body: FutureBuilder<DocumentSnapshot>(
        future: FirebaseFirestore.instance.collection('notes').doc(noteId).get(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || !snapshot.data!.exists) {
            return const Center(child: Text("Nota no encontrada."));
          }

          var noteData = snapshot.data!.data() as Map<String, dynamic>;
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  noteData['title'],
                  style: AppTextStyles.notesTitle,
                ),
                const SizedBox(height: 10),
                Text(
                  noteData['content'],
                  style: AppTextStyles.notesContent,
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
