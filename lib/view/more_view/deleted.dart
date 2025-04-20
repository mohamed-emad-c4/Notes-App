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
              title: Text(
                S.of(context).DeletedNotes,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.5,
                ),
              ),
              centerTitle: true,
              backgroundColor: Colors.redAccent,
              elevation: 0,
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.vertical(
                  bottom: Radius.circular(20),
                ),
              ),
            ),
            body: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.redAccent.withAlpha(25),
                    Colors.white,
                  ],
                ),
              ),
              child: FutureBuilder<List<NoteModel>>(
                future: NotesDatabase.instance.getAllDeletedNotes(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(
                        color: Colors.redAccent,
                      ),
                    );
                  } else if (snapshot.hasError) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.error_outline,
                            size: 48,
                            color: Colors.redAccent,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            '${S.of(context).Error}: ${snapshot.error}',
                            style: const TextStyle(fontSize: 18),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    );
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.delete_outline,
                            size: 64,
                            color: Colors.grey,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            S.of(context).NoDeletedNotesAvailable,
                            style: const TextStyle(
                              fontSize: 18,
                              color: Colors.grey,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    );
                  } else {
                    final deletedNotes = snapshot.data!;
                    return ListView.builder(
                      padding: const EdgeInsets.all(12),
                      itemCount: deletedNotes.length,
                      itemBuilder: (context, index) {
                        final note = deletedNotes[index];
                        return Hero(
                          tag: 'deleted_note_${note.id}',
                          child: Dismissible(
                            key: Key(note.title),
                            direction: DismissDirection.horizontal,
                            onDismissed: (direction) async {
                              if (direction == DismissDirection.endToStart) {
                                BlocProvider.of<DeletedUpdateCubit>(context)
                                    .PremanentDelete(
                                        allNotes: deletedNotes, index: index);
                              } else if (direction ==
                                  DismissDirection.startToEnd) {
                                BlocProvider.of<DeletedUpdateCubit>(context)
                                    .RemoveNoteFromDeleted(
                                        allNotes: deletedNotes, index: index);
                                BlocProvider.of<UpdateCubit>(context)
                                    .updateNotes();
                              }
                            },
                            background: Container(
                              decoration: BoxDecoration(
                                color: Colors.green,
                                borderRadius: BorderRadius.circular(15),
                              ),
                              alignment: Alignment.centerLeft,
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 20),
                              child: const Row(
                                children: [
                                  Icon(Icons.restore, color: Colors.white),
                                  SizedBox(width: 8),
                                  Text(
                                    'Restore',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            secondaryBackground: Container(
                              decoration: BoxDecoration(
                                color: Colors.red,
                                borderRadius: BorderRadius.circular(15),
                              ),
                              alignment: Alignment.centerRight,
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 20),
                              child: const Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Text(
                                    'Delete',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(width: 8),
                                  Icon(Icons.delete_forever,
                                      color: Colors.white),
                                ],
                              ),
                            ),
                            child: Card(
                              elevation: 4,
                              shadowColor: Colors.redAccent.withAlpha(50),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15),
                              ),
                              child: Container(
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                    colors: [
                                      Colors.redAccent.withAlpha(204),
                                      Colors.redAccent.withAlpha(153),
                                    ],
                                  ),
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(12.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Expanded(
                                            child: Text(
                                              note.title,
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                              style: const TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.white,
                                              ),
                                            ),
                                          ),
                                          PopupMenuButton<String>(
                                            icon: const Icon(
                                              Icons.more_vert,
                                              color: Colors.white,
                                            ),
                                            itemBuilder: (context) => [
                                              PopupMenuItem<String>(
                                                value: 'Premanent Delete',
                                                child: Row(
                                                  children: [
                                                    const Icon(
                                                      Icons.delete,
                                                      size: 20,
                                                      color: Colors.red,
                                                    ),
                                                    const SizedBox(width: 10),
                                                    Text(
                                                        S.of(context).Deletedf),
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
                                                      color: Colors.blue,
                                                    ),
                                                    const SizedBox(width: 10),
                                                    Text(
                                                        S.of(context).Archived),
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
                                                      color: Colors.pink,
                                                    ),
                                                    const SizedBox(width: 10),
                                                    Text(
                                                        S.of(context).Favorite),
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
                                                      color: Colors.green,
                                                    ),
                                                    const SizedBox(width: 10),
                                                    Text(S.of(context).Restore),
                                                  ],
                                                ),
                                              ),
                                            ],
                                            onSelected: (value) {
                                              if (value == 'Premanent Delete') {
                                                BlocProvider.of<
                                                            DeletedUpdateCubit>(
                                                        context)
                                                    .PremanentDelete(
                                                        allNotes: deletedNotes,
                                                        index: index);
                                              } else if (value == 'Archived') {
                                                BlocProvider.of<
                                                            DeletedUpdateCubit>(
                                                        context)
                                                    .AddNoteToArchived(
                                                        allNotes: deletedNotes,
                                                        index: index);
                                              } else if (value == 'Favorites') {
                                                BlocProvider.of<
                                                            DeletedUpdateCubit>(
                                                        context)
                                                    .AddNoteToFavorit(
                                                        allNotes: deletedNotes,
                                                        index: index);
                                              } else if (value == 'Restore') {
                                                BlocProvider.of<
                                                            DeletedUpdateCubit>(
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
                                      const SizedBox(height: 8),
                                      Text(
                                        note.content,
                                        maxLines: 4,
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(
                                          fontSize: 16,
                                          color: Colors.white70,
                                        ),
                                      ),
                                      const Spacer(),
                                      Text(
                                        BlocProvider.of<UpdateCubit>(context)
                                            .formatDateTime(note.createdTime),
                                        style: const TextStyle(
                                          fontSize: 12,
                                          color: Colors.white70,
                                        ),
                                      ),
                                    ],
                                  ),
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
            ),
          );
        } else {
          return const Center(
            child: Text('No Deleted Notes'),
          );
        }
      },
    );
  }
}
