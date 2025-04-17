import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:test1/cubit/hide_notes_cubit.dart';
import 'package:test1/cubit/update_cubit.dart';
import 'package:test1/generated/l10n.dart';
import 'package:test1/models/note.dart';
import 'package:test1/view/add_note.dart';
import 'package:test1/view/more_view/Favorite.dart';
import 'package:test1/view/more_view/archive.dart';
import 'package:test1/view/more_view/deleted.dart';
import 'package:test1/view/more_view/setting.dart';
import 'package:test1/view/record_notes.dart';

class Notes extends StatelessWidget {
  Notes({
    super.key,
    required this.allNotes,
    required this.isDarkMode,
  });

  final List<NoteModel> allNotes;
  bool isDarkMode;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        physics: const ScrollPhysics(),
        child: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 10, right: 10),
                child: Row(
                  children: [
                    GestureDetector(
                      onDoubleTap: () {
                        BlocProvider.of<HideNotesCubit>(context).chechPIN();
                      },
                      child: Text(
                        S.of(context).Notes,
                        style: const TextStyle(
                            fontSize: 25, fontWeight: FontWeight.bold),
                      ),
                    ),
                    Text(
                      S.of(context).Recorder,
                      style: const TextStyle(
                          fontSize: 25, fontWeight: FontWeight.bold),
                    ),
                    const Spacer(),
                    const SizedBox(width: 10),
                    PopupMenuButton<String>(
                      itemBuilder: (context) => [
                        PopupMenuItem<String>(
                          value: 'Deleted',
                          child: Row(
                            children: [
                              const Icon(Icons.delete, size: 20),
                              const SizedBox(width: 10),
                              Text(S.of(context).Deleted),
                            ],
                          ),
                        ),
                        PopupMenuItem<String>(
                          value: 'Archived',
                          child: Row(
                            children: [
                              const Icon(Icons.archive, size: 20),
                              const SizedBox(width: 10),
                              Text(S.of(context).Archived),
                            ],
                          ),
                        ),
                        PopupMenuItem<String>(
                          value: 'Favorites',
                          child: Row(
                            children: [
                              const Icon(Icons.favorite,
                                  color: Colors.red, size: 20),
                              const SizedBox(width: 10),
                              Text(S.of(context).Favorites),
                            ],
                          ),
                        ),
                        PopupMenuItem<String>(
                          value: 'Settings',
                          child: Row(
                            children: [
                              const Icon(Icons.settings, size: 20),
                              const SizedBox(width: 10),
                              Text(S.of(context).Settings),
                            ],
                          ),
                        )
                      ],
                      onSelected: (value) {
                        if (value == 'Deleted') {
                          Get.to(const DeletedNotes());
                        } else if (value == 'Archived') {
                          Get.to(const ArchivedList());
                        } else if (value == 'Favorites') {
                          Get.to(const FavoriteList());
                        } else if (value == 'Settings') {
                          Get.to(Setting(
                            isDarkMode: isDarkMode,
                          ));
                        }
                      },
                    ),
                  ],
                ),
              ),
              NotesList(
                allNotes: allNotes,
                isDarkMode: isDarkMode,
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: Stack(
        children: [
          Positioned(
            bottom: 90, // Adjust positioning as needed
            right: 16,
            child: FloatingActionButton(
              onPressed: () {
                Get.to(AddNote(allNotes: allNotes));
              },
              heroTag: 'addNoteButton',
              child: const Icon(Icons.add), // Unique tag for this button
            ),
          ),
        ],
      ),
    );
  }
}

class PopupMenu extends StatelessWidget {
  const PopupMenu({super.key, required this.isDarkMode});

  final bool isDarkMode;

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<String>(
      itemBuilder: (context) => [
        PopupMenuItem<String>(
          value: 'Deleted',
          child: Row(
            children: [
              const Icon(Icons.delete, size: 20),
              const SizedBox(width: 10),
              Text(S.of(context).Deleted),
            ],
          ),
        ),
        PopupMenuItem<String>(
          value: 'Archived',
          child: Row(
            children: [
              const Icon(Icons.archive, size: 20),
              const SizedBox(width: 10),
              Text(S.of(context).Archived),
            ],
          ),
        ),
        PopupMenuItem<String>(
          value: 'Favorites',
          child: Row(
            children: [
              const Icon(Icons.favorite, color: Colors.red, size: 20),
              const SizedBox(width: 10),
              Text(S.of(context).Favorites),
            ],
          ),
        ),
        PopupMenuItem<String>(
          value: 'Settings',
          child: Row(
            children: [
              const Icon(Icons.settings, size: 20),
              const SizedBox(width: 10),
              Text(S.of(context).Settings),
            ],
          ),
        )
      ],
      onSelected: (value) {
        if (value == 'Deleted') {
          Get.to(const DeletedNotes());
        } else if (value == 'Archived') {
          Get.to(const ArchivedList());
        } else if (value == 'Favorites') {
          Get.to(const FavoriteList());
        } else if (value == 'Settings') {
          Get.to(Setting(isDarkMode: isDarkMode));
        }
      },
    );
  }
}

class NotesList extends StatelessWidget {
  const NotesList({
    super.key,
    required this.allNotes,
    required this.isDarkMode,
  });

  final List<NoteModel> allNotes;
  final bool isDarkMode;

  @override
  Widget build(BuildContext context) {
    return allNotes.isEmpty
        ? _buildEmptyState(context)
        : ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) {
              return Dismissible(
                key: Key("$index"),
                direction: DismissDirection.horizontal,
                onDismissed: (direction) {
                  if (direction == DismissDirection.startToEnd) {
                    try {
                      BlocProvider.of<UpdateCubit>(context)
                          .AddNoteToArchive(allNotes: allNotes, index: index);
                      BlocProvider.of<UpdateCubit>(context).updateNotes();
                      Get.snackbar(
                        "Done",
                        "Added to archive",
                        snackPosition: SnackPosition.BOTTOM,
                        backgroundColor: Colors.green.withOpacity(0.7),
                        colorText: Colors.white,
                        margin: const EdgeInsets.all(10),
                        borderRadius: 10,
                      );
                      BlocProvider.of<UpdateCubit>(context).updateNotes();
                    } catch (e) {
                      Get.snackbar(
                        "Error",
                        "Failed to add note",
                        snackPosition: SnackPosition.BOTTOM,
                        backgroundColor: Colors.red.withOpacity(0.7),
                        colorText: Colors.white,
                        margin: const EdgeInsets.all(10),
                        borderRadius: 10,
                      );
                    }
                  } else if (direction == DismissDirection.endToStart) {
                    try {
                      BlocProvider.of<UpdateCubit>(context)
                          .AddNoteToDeleted(allNotes: allNotes, index: index);
                      BlocProvider.of<UpdateCubit>(context).updateNotes();
                      Get.snackbar(
                        "Done",
                        "Deleted",
                        snackPosition: SnackPosition.BOTTOM,
                        backgroundColor: Colors.red.withOpacity(0.7),
                        colorText: Colors.white,
                        margin: const EdgeInsets.all(10),
                        borderRadius: 10,
                      );
                    } catch (e) {
                      Get.snackbar(
                        "Error",
                        "Failed to delete note",
                        snackPosition: SnackPosition.BOTTOM,
                        backgroundColor: Colors.red.withOpacity(0.7),
                        colorText: Colors.white,
                        margin: const EdgeInsets.all(10),
                        borderRadius: 10,
                      );
                    }
                  }
                },
                background: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    color: Colors.green,
                  ),
                  alignment: Alignment.centerLeft,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: const Icon(Icons.archive, color: Colors.white),
                ),
                secondaryBackground: Container(
                  alignment: Alignment.centerRight,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    color: Colors.red,
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: const Icon(Icons.delete, color: Colors.white),
                ),
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                  child: GestureDetector(
                    onTap: () {
                      log(allNotes[index].title);
                    },
                    child: RecordNotes(
                      allNotes: allNotes,
                      index: index,
                      isDarkMode: isDarkMode,
                    ),
                  ),
                ),
              );
            },
            itemCount: allNotes.length,
          );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(height: 100),
          Icon(
            Icons.note_alt_outlined,
            size: 80,
            color: Theme.of(context).colorScheme.primary.withOpacity(0.7),
          ),
          const SizedBox(height: 16),
          Text(
            "No notes yet",
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 8),
          Text(
            "Tap the + button to create a new note",
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color:
                      Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
                ),
          ),
        ],
      ),
    );
  }
}
