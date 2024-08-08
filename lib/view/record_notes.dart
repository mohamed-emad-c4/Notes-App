import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:test1/cubit/hide_cubit_cubit.dart';
import 'package:test1/cubit/update_cubit.dart';
import 'package:test1/models/note.dart';

class RecordNotes extends StatelessWidget {
  RecordNotes({super.key, required this.index, required this.allNotes});
  int index;
  List<NoteModel> allNotes;
  Color getColor() {
    if (allNotes[index].isFavorite && allNotes[index].archived) {
      return Colors.amber.withOpacity(0.7);
    } else if (allNotes[index].isFavorite) {
      return Colors.red.withOpacity(0.7);
    } else if (allNotes[index].archived) {
      return Colors.green.withOpacity(0.7);
    } else {
      return Colors.grey.withOpacity(0.7);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      color: getColor(),
      child: SizedBox(
        height: MediaQuery.of(context).size.height * 0.22,
        width: MediaQuery.of(context).size.width,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 5),
          child: Column(
            children: [
              Row(
                children: [
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.78,
                    child: Text(
                      allNotes[index].title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontSize: 18),
                    ),
                  ),
                  const Spacer(),
                  PopupMenuButton<String>(
                    itemBuilder: (context) => [
                      const PopupMenuItem<String>(
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
                            Text('Deleted'),
                          ],
                        ),
                      ),
                      const PopupMenuItem<String>(
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
                            Text('Archived'),
                          ],
                        ),
                      ),
                      const PopupMenuItem<String>(
                        value: 'Favorites',
                        child: Row(
                          children: [
                            Icon(
                              Icons.favorite,
                              color: Colors.red,
                              size: 20,
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Text('Favorites'),
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
                  ),
                ],
              ),
              Align(
                alignment: Alignment.topLeft,
                child: Text(
                  allNotes[index].content,
                  maxLines: 4,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontSize: 16, color: Colors.grey[200]),
                ),
              ),
              const Spacer(),
              Align(
                alignment: Alignment.bottomLeft,
                child: Text(
                  BlocProvider.of<UpdateCubit>(context)
                      .formatDateTime(allNotes[index].createdTime),
                  style: TextStyle(fontSize: 12, color: Colors.grey[300]),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class RecordNotesHide extends StatelessWidget {
  RecordNotesHide({super.key, required this.index, required this.allNotes});
  int index;
  List<NoteModel> allNotes;
  Color getColor() {
    if (allNotes[index].isFavorite && allNotes[index].archived) {
      return Colors.amber.withOpacity(0.7);
    } else if (allNotes[index].isFavorite) {
      return Colors.red.withOpacity(0.7);
    } else if (allNotes[index].archived) {
      return Colors.green.withOpacity(0.7);
    } else {
      return Colors.grey.withOpacity(0.7);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      color: getColor(),
      child: SizedBox(
        height: MediaQuery.of(context).size.height * 0.22,
        width: MediaQuery.of(context).size.width,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 5),
          child: Column(
            children: [
              Row(
                children: [
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.78,
                    child: Text(
                      allNotes[index].title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontSize: 18),
                    ),
                  ),
                  const Spacer(),
                  PopupMenuButton<String>(
                    itemBuilder: (context) => [
                      const PopupMenuItem<String>(
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
                            Text('Deleted'),
                          ],
                        ),
                      ),
                    ],
                    onSelected: (value) {
                      if (value == 'Deleted') {
                        BlocProvider.of<HideCubitCubit>(context)
                            .deletNote( allNotes[index].id!);

                       
                      }
                    },
                  ),
                ],
              ),
              Align(
                alignment: Alignment.topLeft,
                child: Text(
                  allNotes[index].content,
                  maxLines: 4,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontSize: 16, color: Colors.grey[200]),
                ),
              ),
              const Spacer(),
              Align(
                alignment: Alignment.bottomLeft,
                child: Text(
                  BlocProvider.of<UpdateCubit>(context)
                      .formatDateTime(allNotes[index].createdTime),
                  style: TextStyle(fontSize: 12, color: Colors.grey[300]),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
