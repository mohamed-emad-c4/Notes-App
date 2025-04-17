import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:test1/cubit/update_cubit.dart';
import 'package:test1/generated/l10n.dart';
import 'package:test1/models/note.dart';
import 'package:test1/shared/app_theme.dart';
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

class _AddNoteState extends State<AddNote> with SingleTickerProviderStateMixin {
  final _titleController = TextEditingController();
  final _contentController = TextEditingController();
  bool _isFavorite = false;
  bool _isArchived = false;

  // Animation controller
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  // For character count
  int get _titleCharCount => _titleController.text.length;
  int get _contentCharCount => _contentController.text.length;
  final int _maxTitleLength = 50;

  @override
  void initState() {
    super.initState();

    // Initialize animation controller
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );

    _fadeAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOut,
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.1),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOut,
    ));

    // Start animation
    _animationController.forward();

    // Add listeners to controllers for state updates
    _titleController.addListener(() {
      setState(() {});
    });

    _contentController.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? Colors.grey[900] : Colors.grey[50],
      appBar: AppBar(
        title: Text(S.of(context).AddNote),
        centerTitle: true,
        backgroundColor: AppTheme.primaryColor,
        elevation: 0,
        actions: [
          // Save button in app bar
          IconButton(
            icon: const Icon(Icons.check),
            tooltip: S.of(context).Save,
            onPressed: _canSave() ? _saveNote : null,
          ),
        ],
      ),
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: SlideTransition(
          position: _slideAnimation,
          child: Container(
            height: double.infinity,
            decoration: BoxDecoration(
              color: isDark ? Colors.grey[850] : Colors.white,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(30),
                topRight: Radius.circular(30),
              ),
            ),
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title field with character count
                    TextField(
                      controller: _titleController,
                      maxLength: _maxTitleLength,
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                      decoration: InputDecoration(
                        hintText: S.of(context).AddNote,
                        border: InputBorder.none,
                        counterText: '',
                        hintStyle: TextStyle(
                          color: isDark ? Colors.grey[400] : Colors.grey[500],
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),

                    // Character count indicator for title
                    if (_titleCharCount > 0)
                      Align(
                        alignment: Alignment.centerRight,
                        child: Text(
                          '$_titleCharCount/$_maxTitleLength',
                          style: TextStyle(
                            fontSize: 12,
                            color: _titleCharCount >= _maxTitleLength
                                ? Colors.red
                                : isDark
                                    ? Colors.grey[400]
                                    : Colors.grey[600],
                          ),
                        ),
                      ),

                    const SizedBox(height: 16),

                    // Content field
                    TextField(
                      controller: _contentController,
                      maxLines: null, // Allow multiline
                      minLines: 10, // Minimum height
                      style: Theme.of(context).textTheme.bodyLarge,
                      decoration: InputDecoration(
                        hintText: S.of(context).LableContentAdd,
                        border: InputBorder.none,
                        hintStyle: TextStyle(
                          color: isDark ? Colors.grey[400] : Colors.grey[500],
                        ),
                      ),
                    ),

                    // Character count for content
                    if (_contentCharCount > 0)
                      Align(
                        alignment: Alignment.centerRight,
                        child: Text(
                          '$_contentCharCount characters',
                          style: TextStyle(
                            fontSize: 12,
                            color: isDark ? Colors.grey[400] : Colors.grey[600],
                          ),
                        ),
                      ),

                    const SizedBox(height: 24),

                    // Note options (favorite, archive)
                    _buildNoteOptions(),

                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _canSave() ? _saveNote : null,
        backgroundColor: _canSave() ? AppTheme.primaryColor : Colors.grey,
        icon: const Icon(Icons.save),
        label: Text(S.of(context).Save),
      ),
    );
  }

  Widget _buildNoteOptions() {
    return Card(
      elevation: 0,
      color: Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color: Colors.grey.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Note Options",
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 16),
            // Favorite option
            SwitchListTile(
              contentPadding: EdgeInsets.zero,
              title: Row(
                children: [
                  Icon(
                    Icons.favorite,
                    color: _isFavorite ? Colors.red : Colors.grey,
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  Text(S.of(context).Favorites),
                ],
              ),
              subtitle: Text(
                "Mark this note as a favorite",
                style: Theme.of(context).textTheme.bodySmall,
              ),
              value: _isFavorite,
              activeColor: AppTheme.primaryColor,
              onChanged: (value) {
                setState(() {
                  _isFavorite = value;
                });
              },
            ),
            const Divider(),
            // Archive option
            SwitchListTile(
              contentPadding: EdgeInsets.zero,
              title: Row(
                children: [
                  Icon(
                    Icons.archive,
                    color: _isArchived ? Colors.green : Colors.grey,
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  Text(S.of(context).Archived),
                ],
              ),
              subtitle: Text(
                "Archive this note",
                style: Theme.of(context).textTheme.bodySmall,
              ),
              value: _isArchived,
              activeColor: AppTheme.primaryColor,
              onChanged: (value) {
                setState(() {
                  _isArchived = value;
                });
              },
            ),
          ],
        ),
      ),
    );
  }

  // Check if can save
  bool _canSave() {
    return _titleController.text.trim().isNotEmpty &&
        _contentController.text.trim().isNotEmpty;
  }

  void _saveNote() async {
    final title = _titleController.text.trim();
    final content = _contentController.text.trim();
    final createdTime = DateTime.now().toString();

    if (title.isNotEmpty && content.isNotEmpty) {
      // Show saving indicator
      Get.dialog(
        const Center(
          child: CircularProgressIndicator(),
        ),
        barrierDismissible: false,
      );

      try {
        final newNote = NoteModel(
          title: title,
          content: content,
          isFavorite: _isFavorite,
          archived: _isArchived,
          createdTime: createdTime,
        );

        await NotesDatabase.instance.create(newNote);

        // Close loading dialog
        Get.back();

        // Update the notes list
        BlocProvider.of<UpdateCubit>(context).updateNotes();

        // Show success message and go back
        Get.back();
        Get.snackbar(
          S.of(context).Success,
          S.of(context).NoteSavedSuccessfully,
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green.withOpacity(0.7),
          colorText: Colors.white,
          margin: const EdgeInsets.all(16),
          borderRadius: 8,
          duration: const Duration(seconds: 2),
        );
      } catch (e) {
        // Close loading dialog
        Get.back();

        // Show error message
        Get.snackbar(
          S.of(context).Error,
          "Failed to save note: $e",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red.withOpacity(0.7),
          colorText: Colors.white,
          margin: const EdgeInsets.all(16),
          borderRadius: 8,
        );
      }
    } else {
      Get.snackbar(
        S.of(context).Error,
        S.of(context).PleaseEnterTitleAndContent,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.withOpacity(0.7),
        colorText: Colors.white,
        margin: const EdgeInsets.all(16),
        borderRadius: 8,
      );
    }
  }
}
