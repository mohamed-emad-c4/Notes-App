import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:test1/cubit/hide_cubit_cubit.dart';
import 'package:test1/cubit/update_cubit.dart';
import 'package:test1/generated/l10n.dart';
import 'package:test1/models/note.dart';
import 'package:test1/shared/app_theme.dart';

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

  Color getColor() {
    return AppTheme.getNoteCardColor(
        allNotes[index].isFavorite, allNotes[index].archived, isDarkMode);
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      color: getColor(),
      child: SizedBox(
        height: MediaQuery.of(context).size.height * 0.22,
        width: MediaQuery.of(context).size.width,
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
                      style: Theme.of(context).textTheme.titleLarge,
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
                        color: Colors.white.withOpacity(0.9),
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
                          color: Colors.white.withOpacity(0.7),
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
      icon: const Icon(Icons.more_vert, color: Colors.white),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      itemBuilder: (context) => [
        PopupMenuItem<String>(
          value: 'Deleted',
          child: Row(
            children: [
              const Icon(
                Icons.delete,
                size: 20,
              ),
              const SizedBox(
                width: 10,
              ),
              Text(S.of(context).Deleted),
            ],
          ),
        ),
        PopupMenuItem<String>(
          value: 'Archived',
          child: Row(
            children: [
              const Icon(
                Icons.archive,
                size: 20,
              ),
              const SizedBox(
                width: 10,
              ),
              Text(S.of(context).Archived),
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
              Text(S.of(context).Favorites),
            ],
          ),
        ),
      ],
      onSelected: (value) {
        if (value == 'Deleted') {
          BlocProvider.of<UpdateCubit>(context)
              .AddNoteToDeleted(allNotes: allNotes, index: index);
          BlocProvider.of<UpdateCubit>(context).updateNotes();
        } else if (value == 'Archived') {
          BlocProvider.of<UpdateCubit>(context)
              .AddNoteToArchive(allNotes: allNotes, index: index);
          BlocProvider.of<UpdateCubit>(context).updateNotes();
        } else if (value == 'Favorites') {
          BlocProvider.of<UpdateCubit>(context)
              .AddNoteToFavorit(allNotes: allNotes, index: index);
          BlocProvider.of<UpdateCubit>(context).updateNotes();
        }
      },
    );
  }

  Widget _buildStatusIcons() {
    return Row(
      children: [
        if (allNotes[index].isFavorite)
          const Icon(Icons.favorite, color: Colors.white, size: 16),
        if (allNotes[index].archived)
          const Padding(
            padding: EdgeInsets.only(left: 4),
            child: Icon(Icons.archive, color: Colors.white, size: 16),
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

  Color getColor() {
    return AppTheme.getNoteCardColor(
        allNotes[index].isFavorite, allNotes[index].archived, isDarkMode);
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      color: getColor(),
      child: SizedBox(
        height: MediaQuery.of(context).size.height * 0.22,
        width: MediaQuery.of(context).size.width,
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
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                  ),
                  PopupMenuButton<String>(
                    icon: const Icon(Icons.more_vert, color: Colors.white),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                    itemBuilder: (context) => [
                      PopupMenuItem<String>(
                        value: 'Deleted',
                        child: Row(
                          children: [
                            const Icon(
                              Icons.delete,
                              size: 20,
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            Text(S.of(context).Deletedf),
                          ],
                        ),
                      ),
                    ],
                    onSelected: (value) {
                      if (value == 'Deleted') {
                        BlocProvider.of<HideCubitCubit>(context)
                            .deletNote(allNotes[index].id!);
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
                        color: Colors.white.withOpacity(0.9),
                      ),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                BlocProvider.of<UpdateCubit>(context)
                    .formatDateTime(allNotes[index].createdTime),
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Colors.white.withOpacity(0.7),
                    ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
