import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:test1/DB/database.dart';
import 'package:test1/cubit/favorit_update_cubit.dart';
import 'package:test1/cubit/update_cubit.dart';
import 'package:test1/generated/l10n.dart';
import 'package:test1/models/note.dart';

Future<List<NoteModel>> getFavoriteList() async {
  List<NoteModel> lis = await NotesDatabase.instance.getAllFavoriteNotes();
  return lis;
}

class FavoriteList extends StatelessWidget {
  const FavoriteList({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FavoritUpdateCubit, FavoritUpdateState>(
      builder: (context, state) {
        if (state is FavoritUpdate || state is FavoritUpdateInitial) {
          return Scaffold(
            appBar: AppBar(
              title: Text(
                S.of(context).FavoriteNotes,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.5,
                ),
              ),
              centerTitle: true,
              backgroundColor: Colors.pinkAccent,
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
                    Colors.pinkAccent.withAlpha(25),
                    Colors.white,
                  ],
                ),
              ),
              child: FutureBuilder<List<NoteModel>>(
                future: getFavoriteList(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(
                        color: Colors.pinkAccent,
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
                            color: Colors.pinkAccent,
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
                            Icons.favorite_border,
                            size: 64,
                            color: Colors.grey,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            S.of(context).NoFavoriteNotesAvailable,
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
                    final favoriteNotes = snapshot.data!;
                    List<NoteModel> favoriteNotes2 =
                        favoriteNotes.reversed.toList();

                    return ListView.builder(
                      padding: const EdgeInsets.all(12),
                      itemCount: favoriteNotes2.length,
                      itemBuilder: (context, index) {
                        final note = favoriteNotes2[index];
                        return Hero(
                          tag: 'favorite_note_${note.id}',
                          child: Dismissible(
                            key: Key(note.id.toString()),
                            direction: DismissDirection.horizontal,
                            onDismissed: (direction) {
                              if (direction == DismissDirection.startToEnd) {
                                BlocProvider.of<FavoritUpdateCubit>(context)
                                    .AddNoteToArchived(
                                        allNotes: favoriteNotes2, index: index);
                                BlocProvider.of<UpdateCubit>(context)
                                    .updateNotes();
                              } else if (direction ==
                                  DismissDirection.endToStart) {
                                BlocProvider.of<FavoritUpdateCubit>(context)
                                    .AddToDeleted(
                                        allNotes: favoriteNotes2, index: index);
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
                                  Icon(Icons.archive, color: Colors.white),
                                  SizedBox(width: 8),
                                  Text(
                                    'Archive',
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
                                  Icon(Icons.delete, color: Colors.white),
                                ],
                              ),
                            ),
                            child: Card(
                              elevation: 4,
                              shadowColor: Colors.pinkAccent.withAlpha(50),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15),
                              ),
                              child: Container(
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                    colors: [
                                      Colors.pinkAccent.withAlpha(204),
                                      Colors.pinkAccent.withAlpha(153),
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
                                                value: 'Deleted',
                                                child: Row(
                                                  children: [
                                                    const Icon(
                                                      Icons.delete,
                                                      size: 20,
                                                      color: Colors.red,
                                                    ),
                                                    const SizedBox(width: 10),
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
                                                      color: Colors.blue,
                                                    ),
                                                    const SizedBox(width: 10),
                                                    Text(
                                                        S.of(context).Archived),
                                                  ],
                                                ),
                                              ),
                                              PopupMenuItem<String>(
                                                value: 'Disliked',
                                                child: Row(
                                                  children: [
                                                    const FaIcon(
                                                      FontAwesomeIcons
                                                          .heartBroken,
                                                      size: 20,
                                                      color: Colors.purple,
                                                    ),
                                                    const SizedBox(width: 10),
                                                    Text(S.of(context).Dislike),
                                                  ],
                                                ),
                                              ),
                                            ],
                                            onSelected: (value) {
                                              if (value == 'Deleted') {
                                                BlocProvider.of<
                                                            FavoritUpdateCubit>(
                                                        context)
                                                    .AddToDeleted(
                                                        allNotes:
                                                            favoriteNotes2,
                                                        index: index);
                                                BlocProvider.of<UpdateCubit>(
                                                        context)
                                                    .updateNotes();
                                              } else if (value == 'Archived') {
                                                BlocProvider.of<
                                                            FavoritUpdateCubit>(
                                                        context)
                                                    .AddNoteToArchived(
                                                        allNotes:
                                                            favoriteNotes2,
                                                        index: index);
                                                BlocProvider.of<UpdateCubit>(
                                                        context)
                                                    .updateNotes();
                                              } else if (value == 'Disliked') {
                                                BlocProvider.of<
                                                            FavoritUpdateCubit>(
                                                        context)
                                                    .Dislike(
                                                        allNotes:
                                                            favoriteNotes2,
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
            child: Text("No notes available"),
          );
        }
      },
    );
  }
}
