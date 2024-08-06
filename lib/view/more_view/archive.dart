import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:test1/DB/database.dart';
import 'package:test1/models/note.dart';

Future<List<NoteModel>> getArchivedList() async {
  List<NoteModel> list = await NotesDatabase.instance.getAllArchivedNotes();
  return list;
}

class ArchivedList extends StatelessWidget {
  const ArchivedList({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Archived Notes'),
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
                'Error: ${snapshot.error}',
                style: const TextStyle(fontSize: 18),
              ),
            );
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
              child: Text(
                'No Archived Notes Available',
                style: TextStyle(fontSize: 18),
              ),
            );
          } else {
            final archivedNotes = snapshot.data!;
            List<NoteModel> archivedNotesReversed =
                archivedNotes.reversed.toList();

            return ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: archivedNotesReversed.length,
              itemBuilder: (context, index) {
                final note = archivedNotesReversed[index];
                return Dismissible(
                  key: Key(note.title),
                  direction: DismissDirection.horizontal,
                  onDismissed: (direction) {
                    if (direction == DismissDirection.startToEnd) {
                      _addNoteToFavorites(note.toJson());
                    } else if (direction == DismissDirection.endToStart) {
                      _deleteArchivedNote(note.id!);
                    }
                  },
                  background: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      color: Colors.blue, // لون لإعادة إلى المفضلة
                    ),
                    alignment: Alignment.centerLeft,
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: const Icon(Icons.favorite, color: Colors.white),
                  ),
                  secondaryBackground: Container(
                    alignment: Alignment.centerRight,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      color: Colors.red,
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: const Icon(Icons.delete, color: Colors.white),
                  ),
                  child: Card(
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
                                  width:
                                      MediaQuery.of(context).size.width * 0.68,
                                  child: Text(
                                    note.title,
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
                                  ],
                                  onSelected: (value) {
                                    if (value == 'Deleted') {
                                    } else if (value == 'Archived') {
                                    } else if (value == 'Favorites') {}
                                  },
                                ),
                              ],
                            ),
                            Align(
                              alignment: AlignmentDirectional.topStart,
                              child: Text(
                                note.content,
                                maxLines: 4,
                                textAlign: TextAlign.start,
                                overflow: TextOverflow.ellipsis,
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
  }

  void _addNoteToFavorites(Map<String, dynamic> note) async {
    final newNote = NoteModel.fromJson(note);
    newNote.isFavorite = !newNote.isFavorite;
    await NotesDatabase.instance.update(newNote);
    Get.snackbar("Done", "Added to favorites");
  }

  void _deleteArchivedNote(int id) async {
    await NotesDatabase.instance.delete(id);
    Get.snackbar("Done", "Deleted from archive");
  }

  void _showNoteDetails(BuildContext context, Map<String, dynamic> note) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(note['title']),
          content: Text(note['content']),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text(
                'Close',
                style: TextStyle(color: Colors.teal),
              ),
            ),
          ],
        );
      },
    );
  }
}
