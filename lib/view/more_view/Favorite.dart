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
            title: Text(S.of(context).FavoriteNotes), // Text translated
            centerTitle: true,
          ),
          body: FutureBuilder<List<NoteModel>>(
            future: getFavoriteList(),
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
                    S.of(context).NoFavoriteNotesAvailable, // Text translated
                    style: const TextStyle(fontSize: 18),
                  ),
                );
              } else {
                final favoriteNotes = snapshot.data!;
                List<NoteModel> favoriteNotes2 =
                    favoriteNotes.reversed.toList();

                return ListView.builder(
                  padding: const EdgeInsets.all(3),
                  itemCount: favoriteNotes2.length,
                  itemBuilder: (context, index) {
                    final note = favoriteNotes2[index];
                    return Dismissible(
                      key: Key(note.id.toString()),
                      direction: DismissDirection.horizontal,
                      onDismissed: (direction) {
                        if (direction == DismissDirection.startToEnd) {
                          // Archive action
                        } else if (direction == DismissDirection.endToStart) {
                          // Delete action
                        }
                      },
                      background: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30),
                          color: Colors.green,
                        ),
                        alignment: Alignment.centerLeft,
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Icon(Icons.archive, color: Colors.white),
                      ),
                      secondaryBackground: Container(
                        alignment: Alignment.centerRight,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30),
                          color: Colors.red,
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Icon(Icons.delete, color: Colors.white),
                      ),
                      child: Card(
                        color: const Color.fromARGB(255, 172, 41, 54),
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
                                      width: MediaQuery.of(context).size.width *
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
                                              Icon(
                                                Icons.delete,
                                                size: 20,
                                              ),
                                              SizedBox(
                                                width: 10,
                                              ),
                                              Text(S.of(context).Deleted), // Text translated
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
                                              ),
                                              SizedBox(
                                                width: 10,
                                              ),
                                              Text(S.of(context).Archived), // Text translated
                                            ],
                                          ),
                                        ),
                                        PopupMenuItem<String>(
                                          value: 'Disliked',
                                          child: Row(
                                            children: [
                                              FaIcon(
                                                  FontAwesomeIcons.heartBroken),
                                              SizedBox(
                                                width: 10,
                                              ),
                                              Text(S.of(context).Dislike), // Text translated
                                            ],
                                          ),
                                        ),
                                      ],
                                      onSelected: (value) {
                                        if (value == 'Deleted') {
                                          BlocProvider.of<FavoritUpdateCubit>(
                                                  context)
                                              .AddToDeleted(
                                                  allNotes: favoriteNotes2,
                                                  index: index);
                                          BlocProvider.of<UpdateCubit>(context)
                                              .updateNotes();
                                        } else if (value == 'Archived') {
                                          BlocProvider.of<FavoritUpdateCubit>(
                                                  context)
                                              .AddNoteToArchived(
                                                  allNotes: favoriteNotes2,
                                                  index: index);
                                          BlocProvider.of<UpdateCubit>(context)
                                              .updateNotes();
                                        } else if (value == 'Disliked') {
                                          BlocProvider.of<FavoritUpdateCubit>(
                                                  context)
                                              .Dislike(
                                                  allNotes: favoriteNotes2,
                                                  index: index);
                                          BlocProvider.of<UpdateCubit>(context)
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
                                        fontSize: 16, color: Colors.grey[200]),
                                  ),
                                ),
                                const Spacer(),
                                Align(
                                  alignment: Alignment.bottomLeft,
                                  child: Text(
                                    BlocProvider.of<UpdateCubit>(context)
                                        .formatDateTime(note.createdTime),
                                    style: TextStyle(
                                        fontSize: 12, color: Colors.grey[300]),
                                  ),
                                ),
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
        return const Center(
          child: Text("No notes available"),
        );
      }
    });
  }
}
