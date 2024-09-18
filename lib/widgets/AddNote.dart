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
          backgroundColor: Colors.teal,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 24),
          elevation: 5,
        ),
        child: SizedBox(
          width: MediaQuery.of(context).size.width * 0.5,
          child: Text(
            S.of(context).Save,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
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
          child: _OptionCheckbox(
            label: S.of(context).Favorite,
            value: isFavorite,
            onChanged: onFavoriteChanged,
          ),
        ),
        Expanded(
          child: _OptionCheckbox(
            label: S.of(context).Archive,
            value: isArchived,
            onChanged: onArchiveChanged,
          ),
        ),
      ],
    );
  }
}

class _OptionCheckbox extends StatelessWidget {
  const _OptionCheckbox({
    required this.label,
    required this.value,
    required this.onChanged,
  });

  final String label;
  final bool value;
  final ValueChanged<bool?> onChanged;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Checkbox(
          value: value,
          onChanged: onChanged,
          activeColor: Colors.teal,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(4),
          ),
        ),
        Text(label, style: const TextStyle(fontSize: 16)),
      ],
    );
  }
}

class NoteContentField extends StatelessWidget {
  const NoteContentField({super.key, required this.controller});

  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 16.0),
        child: TextField(
          controller: controller,
          decoration: InputDecoration(
            labelText: S.of(context).LableContentAdd,
            border: InputBorder.none,
          ),
          maxLines: 6,
          style: const TextStyle(fontSize: 16),
        ),
      ),
    );
  }
}

class NoteTitleField extends StatelessWidget {
  const NoteTitleField({super.key, required this.controller});

  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
        child: TextField(
          controller: controller,
          decoration: InputDecoration(
            labelText: S.of(context).LableTittleAdd,
            border: InputBorder.none,
          ),
          maxLength: 100,
          style: const TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}
