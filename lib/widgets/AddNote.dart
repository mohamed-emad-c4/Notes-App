import 'package:flutter/material.dart';

import '../generated/l10n.dart';

class SaveNoteButton extends StatelessWidget {
  const SaveNoteButton({super.key, required this.onSave});

  final VoidCallback onSave;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ElevatedButton(
        onPressed: onSave,
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(
            vertical: 14,
            horizontal: 24,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: SizedBox(
          width: MediaQuery.of(context).size.width * 0.5,
          child: Text(
            S.of(context).Save,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}

class NoteOptions extends StatelessWidget {
  const NoteOptions({
    super.key,
    required this.isFavorite,
    required this.isArchived,
    required this.onFavoriteChanged,
    required this.onArchiveChanged,
  });

  final bool isFavorite;
  final bool isArchived;
  final ValueChanged<bool?> onFavoriteChanged;
  final ValueChanged<bool?> onArchiveChanged;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Row(
            children: [
              Checkbox(
                value: isFavorite,
                onChanged: onFavoriteChanged,
                activeColor: Colors.teal,
              ),
              Text(S.of(context).Favorite,
                  style: const TextStyle(fontSize: 16)),
            ],
          ),
        ),
        Expanded(
          child: Row(
            children: [
              Checkbox(
                value: isArchived,
                onChanged: onArchiveChanged,
                activeColor: Colors.teal,
              ),
              Text(S.of(context).Archive, style: const TextStyle(fontSize: 16)),
            ],
          ),
        ),
      ],
    );
  }
}

class NoteContentField extends StatelessWidget {
  const NoteContentField({super.key, required this.controller});

  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: S.of(context).LableContentAdd,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        contentPadding: const EdgeInsets.symmetric(
          vertical: 16,
          horizontal: 12,
        ),
      ),
      maxLines: 6,
      style: const TextStyle(fontSize: 16),
    );
  }
}

class NoteTitleField extends StatelessWidget {
  const NoteTitleField({super.key, required this.controller});

  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: S.of(context).LableTittleAdd,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        contentPadding: const EdgeInsets.symmetric(
          vertical: 16,
          horizontal: 12,
        ),
      ),
      maxLength: 100,
      style: const TextStyle(fontSize: 18),
    );
  }
}
