import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hearth_rythm/src/data/models/category.dart';

class CategoryManagerScreen extends StatefulWidget {
  const CategoryManagerScreen({super.key});

  @override
  State<CategoryManagerScreen> createState() => _CategoryManagerScreenState();
}

class _CategoryManagerScreenState extends State<CategoryManagerScreen> {
  final TextEditingController _nameController = TextEditingController();
  Color _selectedColor = Colors.blue;

  void _pickColor(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Seleccionar Color'),
          content: SingleChildScrollView(
            child: ColorPicker(
              pickerColor: _selectedColor,
              onColorChanged: (color) {
                setState(() {
                  _selectedColor = color;
                });
              },
              enableAlpha: false,
              showLabel: true,
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancelar'),
              onPressed: () => Navigator.of(context).pop(),
            ),
            TextButton(
              child: const Text('Seleccionar'),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ],
        );
      },
    );
  }

  Future<void> _addCategory() async {
    if (_nameController.text.isNotEmpty) {
      final newCategory = NoteCategory(
        name: _nameController.text,
        color: _selectedColor,
      );

      await FirebaseFirestore.instance.collection('categories').add(newCategory.toMap());

      _nameController.clear();
      setState(() {
        _selectedColor = Colors.blue;
      });
    }
  }

  Future<void> _deleteCategory(String categoryId) async {
    await FirebaseFirestore.instance.collection('categories').doc(categoryId).delete();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Categoría eliminada')),
    );
  }

  Future<bool?> _confirmDelete(BuildContext context) async {
    return showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Eliminar Categoría'),
          content: const Text('¿Estás seguro de que deseas eliminar esta categoría?'),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Gestionar Categorías"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: "Nombre de la categoría"),
            ),
            const SizedBox(height: 20),
            const Text("Seleccionar color:"),
            const SizedBox(height: 10),
            GestureDetector(
              onTap: () => _pickColor(context),
              child: CircleAvatar(
                radius: 30,
                backgroundColor: _selectedColor,
                child: const Icon(Icons.color_lens, color: Colors.white),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _addCategory,
              child: const Text("Agregar Categoría"),
            ),
            const SizedBox(height: 20),
            const Text("Categorías Existentes:"),
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance.collection('categories').snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const CircularProgressIndicator();
                  }
                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return const Text("No hay categorías creadas");
                  }
                  final categories = snapshot.data!.docs.map((doc) {
                    final data = doc.data() as Map<String, dynamic>;
                    return {
                      'id': doc.id,
                      'category': NoteCategory.fromMap(data),
                    };
                  }).toList();

                  return ListView.builder(
                    itemCount: categories.length,
                    itemBuilder: (context, index) {
                      final categoryData = categories[index];
                      final categoryId = categoryData['id'] as String;
                      final category = categoryData['category'] as NoteCategory;

                      return ListTile(
                        leading: CircleAvatar(
                          backgroundColor: category.color,
                        ),
                        title: Text(category.name),
                        trailing: IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () async {
                            final confirm = await _confirmDelete(context);
                            if (confirm == true) {
                              await _deleteCategory(categoryId);
                            }
                          },
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
