import 'package:flutter/material.dart';
import 'package:test1/models/note.dart';
import 'package:test1/models/note_dields.dart'; // Ensure the correct filename

class AddNote extends StatefulWidget {
  const AddNote({super.key});

  @override
  _AddNoteState createState() => _AddNoteState();
}

class _AddNoteState extends State<AddNote> {
  final _titleController = TextEditingController();
  final _contentController = TextEditingController();
  bool _isFavorite = false;
  bool _isArchived = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Note'),
        centerTitle: true,
        backgroundColor: Colors.teal,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: 20,
              ),
              TextField(
                controller: _titleController,
                decoration: InputDecoration(
                  labelText: 'Title',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  contentPadding:
                      const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
                  filled: true,
                  fillColor: Colors.grey[100],
                ),
                maxLength: 100,
                style: const TextStyle(fontSize: 18),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _contentController,
                decoration: InputDecoration(
                  labelText: 'Content',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  contentPadding:
                      const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
                  filled: true,
                  fillColor: Colors.grey[100],
                ),
                maxLines: 6,
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: Row(
                      children: [
                        Checkbox(
                          value: _isFavorite,
                          onChanged: (value) {
                            setState(() {
                              _isFavorite = value ?? false;
                            });
                          },
                          activeColor: Colors.teal,
                        ),
                        const Text('Favorite', style: TextStyle(fontSize: 16)),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Row(
                      children: [
                        Checkbox(
                          value: _isArchived,
                          onChanged: (value) {
                            setState(() {
                              _isArchived = value ?? false;
                            });
                          },
                          activeColor: Colors.teal,
                        ),
                        const Text('Archive', style: TextStyle(fontSize: 16)),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    _saveNote();
                  },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                        vertical: 14, horizontal: 24),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width * 0.5,
                    child: const Text(
                      'Save',
                      textAlign: TextAlign.center,
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _saveNote() {
    final title = _titleController.text;
    final content = _contentController.text;
    final createdTime = DateTime.now().toIso8601String(); // Current time

    if (title.isNotEmpty && content.isNotEmpty) {
      final newNote = NoteModel(
        title: title,
        content: content,
        isFavorite: _isFavorite,
        archived: _isArchived,
        createdTime: createdTime,
      );

      // Add logic to save the note to database or state management
      // Example: notesDatabase.create(newNote);

      Navigator.of(context).pop(); // Return to previous screen
    } else {
      // Show error if title or content is empty
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Title and Content cannot be empty')),
      );
    }
  }
}
