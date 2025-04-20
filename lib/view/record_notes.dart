import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:test1/cubit/hide_cubit_cubit.dart';
import 'package:test1/cubit/update_cubit.dart';
import 'package:test1/generated/l10n.dart';
import 'package:test1/models/note.dart';
import 'package:test1/shared/app_theme.dart';
import 'package:test1/DB/database.dart';

class RecordNotes extends StatelessWidget {
  RecordNotes({
    super.key,
    required this.index,
    required this.allNotes,
    required this.isDarkMode,
  });

  int index;
  List<NoteModel> allNotes;
  final bool isDarkMode;

  // Get base color based on note status
  Color getBaseColor() {
    return AppTheme.getNoteCardColor(
        allNotes[index].isFavorite, allNotes[index].archived, isDarkMode);
  }

  // Get darker shade for gradient effect
  Color getDarkerShade() {
    final baseColor = getBaseColor();
    final hslColor = HSLColor.fromColor(baseColor);
    return hslColor
        .withLightness((hslColor.lightness - 0.1).clamp(0.0, 1.0))
        .toColor();
  }

  // Get brighter shade for gradient effect
  Color getBrighterShade() {
    final baseColor = getBaseColor();
    final hslColor = HSLColor.fromColor(baseColor);
    // Increase saturation for more vibrant color
    final adjustedColor = hslColor
        .withSaturation((hslColor.saturation + 0.15).clamp(0.0, 1.0))
        .withLightness((hslColor.lightness + 0.1).clamp(0.0, 1.0));
    return adjustedColor.toColor();
  }

  @override
  Widget build(BuildContext context) {
    final baseColor = getBaseColor();
    final brighterColor = getBrighterShade();
    final textColor = isDarkMode
        ? Colors.white.withOpacity(0.95)
        : const Color.fromARGB(255, 45, 44, 44);
    final subtitleColor = isDarkMode
        ? Colors.white.withOpacity(0.8)
        : const Color.fromARGB(255, 110, 108, 108);

    return Card(
      elevation: 6,
      shadowColor: Colors.black.withOpacity(0.2),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide(
          color: isDarkMode
              ? Colors.white.withOpacity(0.3)
              : baseColor.withOpacity(0.3),
          width: 0.5,
        ),
      ),
      child: Container(
        height: MediaQuery.of(context).size.height * 0.22,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [brighterColor, baseColor],
          ),
          boxShadow: [
            BoxShadow(
              color: brighterColor.withOpacity(0.3),
              blurRadius: 8,
              spreadRadius: -2,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      allNotes[index].title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: textColor,
                        shadows: [
                          Shadow(
                            color: Colors.black.withOpacity(0.3),
                            offset: const Offset(0, 1),
                            blurRadius: 2,
                          ),
                        ],
                      ),
                    ),
                  ),
                  _buildPopupMenu(context),
                ],
              ),
              const SizedBox(height: 8),
              Expanded(
                child: Text(
                  allNotes[index].content,
                  maxLines: 4,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: subtitleColor,
                        height: 1.3,
                      ),
                ),
              ),
              const SizedBox(height: 4),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    BlocProvider.of<UpdateCubit>(context)
                        .formatDateTime(allNotes[index].createdTime),
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: subtitleColor,
                          fontWeight: FontWeight.w500,
                        ),
                  ),
                  _buildStatusIcons(),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPopupMenu(BuildContext context) {
    return PopupMenuButton<String>(
      icon: Icon(Icons.more_vert,
          color: isDarkMode ? Colors.white : Colors.black87),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 8,
      offset: const Offset(0, 10),
      color: isDarkMode ? const Color(0xFF2C2C2E) : Colors.white,
      itemBuilder: (context) => [
        PopupMenuItem<String>(
          value: 'Deleted',
          child: Row(
            children: [
              Icon(
                Icons.delete,
                size: 20,
                color: isDarkMode ? Colors.white70 : Colors.grey[800],
              ),
              const SizedBox(
                width: 10,
              ),
              Text(
                S.of(context).Deleted,
                style: TextStyle(
                  color: isDarkMode ? Colors.white : Colors.grey[800],
                ),
              ),
            ],
          ),
        ),
        PopupMenuItem<String>(
          value: 'Archived',
          child: Row(
            children: [
              Icon(
                Icons.archive,
                size: 20,
                color: isDarkMode ? Colors.white70 : Colors.grey[800],
              ),
              const SizedBox(
                width: 10,
              ),
              Text(
                S.of(context).Archived,
                style: TextStyle(
                  color: isDarkMode ? Colors.white : Colors.grey[800],
                ),
              ),
            ],
          ),
        ),
        PopupMenuItem<String>(
          value: 'Favorites',
          child: Row(
            children: [
              const Icon(
                Icons.favorite,
                color: Colors.red,
                size: 20,
              ),
              const SizedBox(
                width: 10,
              ),
              Text(
                S.of(context).Favorites,
                style: TextStyle(
                  color: isDarkMode ? Colors.white : Colors.grey[800],
                ),
              ),
            ],
          ),
        ),
      ],
      onSelected: (value) {
        // Store local references to data needed for operations
        final noteId = allNotes[index].id;
        final noteTitle = allNotes[index].title;
        final noteContent = allNotes[index].content;
        final noteFavorite = allNotes[index].isFavorite;
        final noteArchived = allNotes[index].archived;
        final noteCreatedTime = allNotes[index].createdTime;

        // Create a local function to handle updates without relying on BlocProvider after widget disposal
        void performUpdate(Function(UpdateCubit cubit) action) {
          // Get cubit before any operation that might cause deactivation
          final updateCubit = BlocProvider.of<UpdateCubit>(context);

          // Execute the action
          action(updateCubit);

          // Update notes from within the same context
          updateCubit.updateNotes();
        }

        if (value == 'Deleted') {
          performUpdate((cubit) {
            final newNote = NoteModel(
              id: noteId,
              title: noteTitle,
              content: noteContent,
              isFavorite: noteFavorite,
              archived: noteArchived,
              deleted: true,
              createdTime: DateTime.now().toString(),
            );
            NotesDatabase.instance.update(newNote);
          });
        } else if (value == 'Archived') {
          performUpdate((cubit) {
            final newNote = NoteModel(
              id: noteId,
              title: noteTitle,
              content: noteContent,
              isFavorite: noteFavorite,
              archived: !noteArchived,
              createdTime: DateTime.now().toString(),
            );
            NotesDatabase.instance.update(newNote);
          });
        } else if (value == 'Favorites') {
          performUpdate((cubit) {
            final newNote = NoteModel(
              id: noteId,
              title: noteTitle,
              content: noteContent,
              isFavorite: !noteFavorite,
              archived: noteArchived,
              createdTime: DateTime.now().toString(),
            );
            NotesDatabase.instance.update(newNote);
          });
        }
      },
    );
  }

  Widget _buildStatusIcons() {
    final iconColor = isDarkMode ? Colors.white : Colors.black87;

    return Row(
      children: [
        if (allNotes[index].isFavorite)
          Container(
            padding: const EdgeInsets.all(3),
            decoration: BoxDecoration(
              color:
                  (isDarkMode ? Colors.white : Colors.black).withOpacity(0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(Icons.favorite, color: iconColor, size: 16),
          ),
        if (allNotes[index].archived)
          Container(
            margin: const EdgeInsets.only(left: 4),
            padding: const EdgeInsets.all(3),
            decoration: BoxDecoration(
              color:
                  (isDarkMode ? Colors.white : Colors.black).withOpacity(0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(Icons.archive, color: iconColor, size: 16),
          ),
      ],
    );
  }
}

class RecordNotesHide extends StatelessWidget {
  RecordNotesHide({
    super.key,
    required this.index,
    required this.allNotes,
    required this.isDarkMode,
  });

  int index;
  List<NoteModel> allNotes;
  final bool isDarkMode;

  // Get base color based on note status
  Color getBaseColor() {
    return AppTheme.getNoteCardColor(
        allNotes[index].isFavorite, allNotes[index].archived, isDarkMode);
  }

  // Get darker shade for gradient effect
  Color getDarkerShade() {
    final baseColor = getBaseColor();
    final hslColor = HSLColor.fromColor(baseColor);
    return hslColor
        .withLightness((hslColor.lightness - 0.1).clamp(0.0, 1.0))
        .toColor();
  }

  // Get brighter shade for gradient effect
  Color getBrighterShade() {
    final baseColor = getBaseColor();
    final hslColor = HSLColor.fromColor(baseColor);
    // Increase saturation for more vibrant color
    final adjustedColor = hslColor
        .withSaturation((hslColor.saturation + 0.15).clamp(0.0, 1.0))
        .withLightness((hslColor.lightness + 0.1).clamp(0.0, 1.0));
    return adjustedColor.toColor();
  }

  @override
  Widget build(BuildContext context) {
    final baseColor = getBaseColor();
    final brighterColor = getBrighterShade();
    final textColor = isDarkMode
        ? Colors.white.withOpacity(0.95)
        : const Color.fromARGB(255, 45, 44, 44);
    final subtitleColor = isDarkMode
        ? Colors.white.withOpacity(0.8)
        : const Color.fromARGB(255, 110, 108, 108);

    return Card(
      elevation: 6,
      shadowColor: Colors.black.withOpacity(0.2),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide(
          color: isDarkMode
              ? Colors.white.withOpacity(0.3)
              : baseColor.withOpacity(0.3),
          width: 0.5,
        ),
      ),
      child: Container(
        height: MediaQuery.of(context).size.height * 0.22,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [brighterColor, baseColor],
          ),
          boxShadow: [
            BoxShadow(
              color: brighterColor.withOpacity(0.3),
              blurRadius: 8,
              spreadRadius: -2,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      allNotes[index].title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: textColor,
                        shadows: [
                          Shadow(
                            color: Colors.black.withOpacity(0.3),
                            offset: const Offset(0, 1),
                            blurRadius: 2,
                          ),
                        ],
                      ),
                    ),
                  ),
                  PopupMenuButton<String>(
                    icon: Icon(Icons.more_vert,
                        color: isDarkMode ? Colors.white : Colors.black87),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16)),
                    elevation: 8,
                    offset: const Offset(0, 10),
                    color: isDarkMode ? const Color(0xFF2C2C2E) : Colors.white,
                    itemBuilder: (context) => [
                      PopupMenuItem<String>(
                        value: 'Deleted',
                        child: Row(
                          children: [
                            Icon(
                              Icons.delete,
                              size: 20,
                              color: isDarkMode
                                  ? Colors.white70
                                  : Colors.grey[800],
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            Text(
                              S.of(context).Deletedf,
                              style: TextStyle(
                                color: isDarkMode
                                    ? Colors.white
                                    : Colors.grey[800],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                    onSelected: (value) {
                      if (value == 'Deleted') {
                        // Store local references to avoid deactivation issues
                        final noteId = allNotes[index].id!;

                        // Get cubit before any operation that might cause deactivation
                        final hideCubit =
                            BlocProvider.of<HideCubitCubit>(context);

                        // Execute deletion
                        hideCubit.deletNote(noteId);
                      }
                    },
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Expanded(
                child: Text(
                  allNotes[index].content,
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: Colors.white.withOpacity(0.95),
                        height: 1.3,
                      ),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                BlocProvider.of<UpdateCubit>(context)
                    .formatDateTime(allNotes[index].createdTime),
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Colors.white.withOpacity(0.8),
                      fontWeight: FontWeight.w500,
                    ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
