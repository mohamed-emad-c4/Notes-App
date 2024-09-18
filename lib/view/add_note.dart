import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:test1/cubit/update_cubit.dart';
import 'package:test1/generated/l10n.dart';
import 'package:test1/models/note.dart';
import 'package:test1/widgets/AddNote.dart';
import '../DB/database.dart';

class AddNote extends StatefulWidget {
  const AddNote({
    super.key,
    required this.allNotes,
  });

  final List<NoteModel> allNotes;

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
        title: Text(S.of(context).AddNote),
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
              const SizedBox(height: 20),
              NoteTitleField(controller: _titleController),
              const SizedBox(height: 16),
              NoteContentField(controller: _contentController),
              const SizedBox(height: 24),
              NoteOptions(
                isFavorite: _isFavorite,
                isArchived: _isArchived,
                onFavoriteChanged: (value) {
                  setState(() {
                    _isFavorite = value ?? false;
                  });
                },
                onArchiveChanged: (value) {
                  setState(() {
                    _isArchived = value ?? false;
                  });
                },
              ),
              const SizedBox(height: 24),
              SaveNoteButton(
                onSave: () {
                  _saveNote();
                  BlocProvider.of<UpdateCubit>(context).updateNotes();
                  Get.back();
                },
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
        S.of(context).Success,
        S.of(context).NoteSavedSuccessfully,
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.green.withOpacity(0.3),
      );
    } else {
      Get.snackbar(
        S.of(context).Error,
        S.of(context).PleaseEnterTitleAndContent,
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red.withOpacity(0.3),
      );
    }
  }
}
