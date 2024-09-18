import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:test1/DB/database.dart';
import 'package:test1/cubit/cubit/cubit/deleted%20cubit/deleted_update_cubit.dart';
import 'package:test1/cubit/update_cubit.dart';
import 'package:test1/generated/l10n.dart';
import 'package:test1/models/note.dart';

class DeletedNotes extends StatelessWidget {
  const DeletedNotes({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DeletedUpdateCubit, DeletedUpdateState>(
        builder: (context, state) {
      if (state is DeletedUpdate || state is DeletedUpdateInitial) {
        return Scaffold(
          appBar: AppBar(
            title: Text(S.of(context).DeletedNotes), // Text translated
            centerTitle: true,
            backgroundColor: Colors.redAccent, // تغيير لون AppBar
          ),
          body: FutureBuilder<List<NoteModel>>(
            future: NotesDatabase.instance
                .getAllDeletedNotes(), // جلب الملاحظات المحذوفة
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
                    S.of(context).NoDeletedNotesAvailable, // Text translated
                    style: const TextStyle(fontSize: 18),
                  ),
                );
              } else {
                final deletedNotes = snapshot.data!;
                return ListView.builder(
                  padding: const EdgeInsets.all(3),
                  itemCount: deletedNotes.length,
                  itemBuilder: (context, index) {
                    final note = deletedNotes[index];
                    return Dismissible(
                        key: Key(note.title), // مفتاح مميز لكل عنصر
                        direction: DismissDirection.horizontal,
                        onDismissed: (direction) async {
                          if (direction == DismissDirection.endToStart) {
                            // حذف الملاحظة بشكل دائم
                            BlocProvider.of<DeletedUpdateCubit>(context)
                                .PremanentDelete(
                                    allNotes: deletedNotes, index: index);
                          } else if (direction == DismissDirection.startToEnd) {
                            // استعادة الملاحظة
                            BlocProvider.of<DeletedUpdateCubit>(context)
                                .RemoveNoteFromDeleted(
                                    allNotes: deletedNotes, index: index);
                            BlocProvider.of<UpdateCubit>(context).updateNotes();
                          }
                        },
                        background: Container(
                          color: Colors.green, // لون الاستعادة
                          alignment: Alignment.centerLeft,
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: const Icon(Icons.restore, color: Colors.white),
                        ),
                        secondaryBackground: Container(
                          color: Colors.red, // لون الحذف
                          alignment: Alignment.centerRight,
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: const Icon(Icons.delete, color: Colors.white),
                        ),
                        child: Card(
                          color: Colors.redAccent.withOpacity(0.7),
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
                                            value: 'Premanent Delete',
                                            child: Row(
                                              children: [
                                                const Icon(
                                                  Icons.delete,
                                                  size: 20,
                                                ),
                                                const SizedBox(
                                                  width: 10,
                                                ),
                                                Text(S.of(context).Deletedf), // Text translated
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
                                                Text(S.of(context).Archived), // Text translated
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
                                                Text(S.of(context).Favorite), // Text translated
                                              ],
                                            ),
                                          ),
                                          PopupMenuItem<String>(
                                            value: 'Restore',
                                            child: Row(
                                              children: [
                                                const Icon(
                                                  Icons.restart_alt,
                                                  size: 20,
                                                ),
                                                const SizedBox(
                                                  width: 10,
                                                ),
                                                Text(S.of(context).Restore), // Text translated
                                              ],
                                            ),
                                          )
                                        ],
                                        onSelected: (value) {
                                          if (value == 'Premanent Delete') {
                                            BlocProvider.of<DeletedUpdateCubit>(
                                                    context)
                                                .PremanentDelete(
                                                    allNotes: deletedNotes,
                                                    index: index);
                                          } else if (value == 'Archived') {
                                            BlocProvider.of<DeletedUpdateCubit>(
                                                    context)
                                                .AddNoteToArchived(
                                                    allNotes: deletedNotes,
                                                    index: index);
                                          } else if (value == 'Favorites') {
                                            BlocProvider.of<DeletedUpdateCubit>(
                                                    context)
                                                .AddNoteToFavorit(
                                                    allNotes: deletedNotes,
                                                    index: index);
                                          } else if (value == 'Restore') {
                                            BlocProvider.of<DeletedUpdateCubit>(
                                                    context)
                                                .RestoreNote(
                                                    allNotes: deletedNotes,
                                                    index: index);
                                            BlocProvider.of<UpdateCubit>(
                                                    context)
                                                .updateNotes();
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
                        ));
                  },
                );
              }
            },
          ),
        );
      } else {
        return const Center(
          child: Text('No Deleted Notes'),
        );
      }
    });
  }
}
