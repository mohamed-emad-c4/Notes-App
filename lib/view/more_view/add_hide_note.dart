import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:test1/cubit/update_cubit.dart';
import 'package:test1/generated/l10n.dart';
import 'package:test1/models/note.dart';
import 'package:test1/shared/app_theme.dart';

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
      appBar: AppTheme.getGradientAppBar(S.of(context).AddNote),
      body: Container(
        padding: const EdgeInsets.all(20.0),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(30),
            topRight: Radius.circular(30),
          ),
        ),
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                S.of(context).LableTittleAdd,
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 8),
              TextField(
                controller: _titleController,
                decoration: InputDecoration(
                  hintText: S.of(context).LableTittleAdd,
                  prefixIcon: const Icon(Icons.title),
                ),
                maxLength: 100,
                style: Theme.of(context).textTheme.titleMedium,
                textCapitalization: TextCapitalization.sentences,
              ),
              const SizedBox(height: 24),
              Text(
                S.of(context).LableContentAdd,
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 8),
              TextField(
                controller: _contentController,
                decoration: InputDecoration(
                  hintText: S.of(context).LableContentAdd,
                  alignLabelWithHint: true,
                ),
                maxLines: 8,
                style: Theme.of(context).textTheme.bodyLarge,
                textCapitalization: TextCapitalization.sentences,
              ),
              const SizedBox(height: 32),
              Center(
                child: ElevatedButton(
                  onPressed: _saveNote,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.primaryColor,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                        vertical: 14, horizontal: 36),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    minimumSize:
                        Size(MediaQuery.of(context).size.width * 0.5, 50),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.save),
                      const SizedBox(width: 8),
                      Text(
                        S.of(context).Save,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
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
    final title = _titleController.text.trim();
    final content = _contentController.text.trim();
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
      AppTheme.showSnackBar(
        title: S.of(context).Success,
        message: S.of(context).NoteSavedSuccessfully,
      );

      BlocProvider.of<UpdateCubit>(context).updateNotes();
      Navigator.pop(context);
      // Get.back();
      Get.forceAppUpdate();
    } else {
      AppTheme.showSnackBar(
        title: S.of(context).Error,
        message: S.of(context).PleaseEnterTitleAndContent,
        isError: true,
      );
    }
  }
}
