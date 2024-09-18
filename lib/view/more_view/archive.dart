import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:test1/DB/database.dart';
import 'package:test1/cubit/cubit/cubit/archive_update_cubit.dart';
import 'package:test1/cubit/update_cubit.dart';
import 'package:test1/generated/l10n.dart';
import 'package:test1/models/note.dart';

// Function to get the list of archived notes
Future<List<NoteModel>> getArchivedList() async {
  try {
    // Fetch archived notes from the database
    List<NoteModel> list = await NotesDatabase.instance.getAllArchivedNotes();
    return list;
  } catch (e) {
    // Handle any exceptions and return an empty list
    return [];
  }
}

class ArchivedList extends StatelessWidget {
  const ArchivedList({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ArchiveUpdateCubit, ArchiveUpdateState>(
      builder: (context, state) {
        if (state is ArchiveUpdate || state is ArchiveUpdateInitial) {
          return Scaffold(
            appBar: AppBar(
              title: Text(S.of(context).ArchivedNotes), // Text translated
              centerTitle: true,
              backgroundColor: Colors.teal,
            ),
            body: FutureBuilder<List<NoteModel>>(
              future: getArchivedList(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (snapshot.hasError) {
                  return Center(
                    child: Text(
                      '${S.of(context).Error}: ${snapshot.error}', // Text translated
                      style: const TextStyle(fontSize: 18),
                    ),
                  );
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Center(
                    child: Text(
                      S.of(context).NoArchivedNotesAvailable, // Text translated
                      style: const TextStyle(fontSize: 18),
                    ),
                  );
                } else {
                  final archivedNotes = snapshot.data!;
                  List<NoteModel> archivedNotesReversed =
                      archivedNotes.reversed.toList();

                  return ListView.builder(
                    padding: const EdgeInsets.all(3),
                    itemCount: archivedNotesReversed.length,
                    itemBuilder: (context, index) {
                      final note = archivedNotesReversed[index];
                      return Dismissible(
                        key: Key(note.id.toString()), // Unique key for each note
                        direction: DismissDirection.horizontal,
                        onDismissed: (direction) {
                          if (direction == DismissDirection.startToEnd) {
                            BlocProvider.of<ArchiveUpdateCubit>(context)
                                .AddNoteToFavorit(
                                    allNotes: archivedNotesReversed,
                                    index: index);
                            Get.snackbar(S.of(context).AddedToFavorites, S.of(context).NoteAddedSuccessfully); // Translated
                          } else if (direction == DismissDirection.endToStart) {
                            BlocProvider.of<ArchiveUpdateCubit>(context)
                                .AddNoteToDeleted(
                                    allNotes: archivedNotesReversed,
                                    index: index);

                            BlocProvider.of<UpdateCubit>(context).updateNotes();
                            Get.snackbar(S.of(context).AddedToDeleted, S.of(context).NoteAddedSuccessfully); // Translated
                          }
                        },
                        background: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(30),
                            color: Colors.blue, // Color for adding to favorites
                          ),
                          alignment: Alignment.centerLeft,
                          padding: const EdgeInsets.symmetric(horizontal: 3),
                          child: const Icon(Icons.favorite, color: Colors.white),
                        ),
                        secondaryBackground: Container(
                          alignment: Alignment.centerRight,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(30),
                            color: Colors.red,
                          ),
                          padding: const EdgeInsets.symmetric(horizontal: 15),
                          child: const Icon(Icons.delete, color: Colors.white),
                        ),
                        child: Card(
                          color: Colors.green.withOpacity(0.7),
                          child: SizedBox(
                            height: MediaQuery.of(context).size.height * 0.25,
                            width: MediaQuery.of(context).size.width,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                children: [
                                  Row(
                                    children: [
                                      SizedBox(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.68,
                                        child: Text(
                                          note.title,
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: const TextStyle(fontSize: 18),
                                        ),
                                      ),
                                      const Spacer(),
                                      PopupMenuButton<String>(
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
                                                Text(S.of(context).Deleted), // Translated
                                              ],
                                            ),
                                          ),
                                          PopupMenuItem<String>(
                                            value: 'Favorites',
                                            child: Row(
                                              children: [
                                                const Icon(
                                                  Icons.favorite,
                                                  size: 20,
                                                ),
                                                const SizedBox(
                                                  width: 10,
                                                ),
                                                Text(S.of(context).Favorite), // Translated
                                              ],
                                            ),
                                          ),
                                          PopupMenuItem<String>(
                                            value: 'Unarchived',
                                            child: Row(
                                              children: [
                                                const Icon(
                                                  Icons.unarchive,
                                                  size: 20,
                                                ),
                                                const SizedBox(
                                                  width: 10,
                                                ),
                                                Text(S.of(context).Unarchived), // Translated
                                              ],
                                            ),
                                          ),
                                        ],
                                        onSelected: (value) {
                                          if (value == 'Deleted') {
                                            BlocProvider.of<ArchiveUpdateCubit>(
                                                    context)
                                                .AddNoteToDeleted(
                                                    allNotes:
                                                        archivedNotesReversed,
                                                    index: index);

                                            BlocProvider.of<UpdateCubit>(
                                                    context)
                                                .updateNotes();
                                            Get.snackbar(S.of(context).AddedToDeleted, S.of(context).NoteAddedSuccessfully); // Translated
                                          } else if (value == 'Unarchived') {
                                            BlocProvider.of<ArchiveUpdateCubit>(
                                                    context)
                                                .RemoveNoteFromArchive(
                                                    allNotes:
                                                        archivedNotesReversed,
                                                    index: index);
                                            BlocProvider.of<UpdateCubit>(
                                                    context)
                                                .updateNotes();
                                            Get.snackbar("", S.of(context).NoteAddedSuccessfully); // Translated
                                          } else if (value == 'Favorites') {
                                            BlocProvider.of<ArchiveUpdateCubit>(
                                                    context)
                                                .AddNoteToFavorit(
                                                    allNotes:
                                                        archivedNotesReversed,
                                                    index: index);
                                            BlocProvider.of<UpdateCubit>(
                                                    context)
                                                .updateNotes();
                                            Get.snackbar(S.of(context).AddedToFavorites, S.of(context).NoteAddedSuccessfully); // Translated
                                          }
                                        },
                                      ),
                                    ],
                                  ),
                                  Align(
                                    alignment: Alignment.topLeft,
                                    child: Text(
                                      note.content,
                                      maxLines: 4,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                          fontSize: 16,
                                          color: Colors.grey[200]),
                                    ),
                                  ),
                                  const Spacer(),
                                  Align(
                                    alignment: Alignment.bottomLeft,
                                    child: Text(
                                      BlocProvider.of<UpdateCubit>(context)
                                          .formatDateTime(note.createdTime),
                                      style: TextStyle(
                                          fontSize: 12,
                                          color: Colors.grey[300]),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  );
                }
              },
            ),
          );
        } else {
          return Center(
            child: Text(
              S.of(context).NoArchivedNotesAvailable, // Translated
              style: const TextStyle(fontSize: 18),
            ),
          );
        }
      },
    );
  }
}
