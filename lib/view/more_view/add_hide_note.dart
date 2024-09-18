import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:test1/cubit/update_cubit.dart';
import 'package:test1/generated/l10n.dart';
import 'package:test1/models/note.dart';

import '../../DB/hide.dart';

class AddHideNote extends StatefulWidget {
  AddHideNote({super.key, required this.allNotes});
  List<NoteModel> allNotes;
  @override
  _AddHideNoteState createState() => _AddHideNoteState();
}

class _AddHideNoteState extends State<AddHideNote> {
  final _titleController = TextEditingController();
  final _contentController = TextEditingController();
  final bool _isFavorite = false;
  final bool _isArchived = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(S.of(context).AddNote), // Text translated
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
                  labelText: S.of(context).LableTittleAdd, // Text translated
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
                  labelText: S.of(context).LableContentAdd, // Text translated
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
              Center(
                child: ElevatedButton(
                  onPressed: () async {
                    _saveNote();
                    
                    BlocProvider.of<UpdateCubit>(context).updateNotes();
                    Get.back();
                    Get.forceAppUpdate();
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
                    child: Text(
                      S.of(context).Save, // Text translated
                      textAlign: TextAlign.center,
                      style:
                          const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
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
      await Hide.instance.create(newNote);
      Get.snackbar(
        S.of(context).Success, // Text translated
        S.of(context).NoteSavedSuccessfully, // Text translated
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.green.withOpacity(0.3),
      );
    } else {
      Get.snackbar(
        S.of(context).Error, // Text translated
        S.of(context).PleaseEnterTitleAndContent, // Text translated
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red.withOpacity(0.3),
      );
    }
  }
}
