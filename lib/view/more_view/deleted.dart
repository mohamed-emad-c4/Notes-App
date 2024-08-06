import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:test1/DB/database.dart';
import 'package:test1/cubit/update_cubit.dart';
import 'package:test1/models/note.dart';

class DeletedNotes extends StatelessWidget {
  const DeletedNotes({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Deleted Notes'),
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
                'Error: ${snapshot.error}',
                style: const TextStyle(fontSize: 18),
              ),
            );
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
              child: Text(
                'No Deleted Notes Available',
                style: TextStyle(fontSize: 18),
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
                    // تحديد اتجاه الحذف أو الأرشفة
                    direction: DismissDirection.horizontal,
                    onDismissed: (direction) async {
                      if (direction == DismissDirection.endToStart) {
                        // حذف الملاحظة بشكل دائم
                        await _deleteNotePermanently(context, note);
                        deletedNotes.removeAt(index);
                      } else if (direction == DismissDirection.startToEnd) {
                        // استعادة الملاحظة
                        await _restoreNote(context, note);
                        deletedNotes.removeAt(index);
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
  }

  // نافذة منبثقة لعرض تفاصيل الملاحظة
  void _showNoteDetails(BuildContext context, NoteModel note) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(note.title),
          content: Text(note.content),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text(
                'Close',
                style: TextStyle(color: Colors.redAccent), // تغيير لون النص
              ),
            ),
            TextButton(
              onPressed: () async {
                Navigator.of(context).pop();
                // استعادة الملاحظة
                await _restoreNote(context, note);
              },
              child: const Text(
                'Restore',
                style: TextStyle(color: Colors.green), // تغيير لون النص
              ),
            ),
          ],
        );
      },
    );
  }

  // استعادة الملاحظة
  Future<void> _restoreNote(BuildContext context, NoteModel note) async {
    final restoredNote = note.CopyWith(deleted: false);
    await NotesDatabase.instance.update(restoredNote);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Note "${note.title}" restored!'),
        backgroundColor: Colors.green,
      ),
    );
  }

  // حذف الملاحظة بشكل دائم
  Future<void> _deleteNotePermanently(
      BuildContext context, NoteModel note) async {
    await NotesDatabase.instance.delete(note.id!);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Note "${note.title}" deleted permanently!'),
        backgroundColor: Colors.red,
      ),
    );
  }
}
