
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:test1/cubit/update_cubit.dart';
import 'package:test1/models/note.dart';

import '../DB/database.dart';

class AddNote extends StatefulWidget {
  AddNote({super.key, required this.allNotes});
  List<NoteModel> allNotes;

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
                  onPressed: () async {
                    _saveNote();
                    // widget.allNotes =
                    //     await NotesDatabase.instance.readAllNotes();
                    BlocProvider.of<UpdateCubit>(context).updateNotes();
                    Get.back();
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

  void _saveNote() async {
    final title = _titleController.text;
    final content = _contentController.text;
    final createdTime = DateTime.now().toString();

    if (title.isNotEmpty && content.isNotEmpty) {
      final newNote = NoteModel(
        title: title,
        content: content,
        isFavorite: _isFavorite,
        archived: _isArchived,
        createdTime: createdTime,
      );
      await NotesDatabase.instance.create(newNote);
      Get.snackbar(
        'Success',
        'Note saved successfully',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.green.withOpacity(0.3),
      );
    } else {
      Get.snackbar(
        'Error',
        'Please enter a title and content',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red.withOpacity(0.3),
      );
    }
  }
}
