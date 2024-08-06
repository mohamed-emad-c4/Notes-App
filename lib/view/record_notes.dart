import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
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
    return Padding(
      padding: const EdgeInsets.all(3.0),
      child: Card(
        color: getColor(),
        child: SizedBox(
          height: MediaQuery.of(context).size.height * 0.2,
          width: MediaQuery.of(context).size.width,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
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
                        } else if (value == 'Archived') {
                        } else if (value == 'Favorites') {}
                      },
                    ),
                  ],
                ),
                Text(
                  allNotes[index].content,
                  maxLines: 4,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
