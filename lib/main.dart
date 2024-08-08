import 'package:flutter/material.dart';

import 'DB/database.dart';
import 'DB/hide.dart';
import 'models/note.dart';
import 'view/home.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await NotesDatabase.instance.database;
    List<NoteModel> allNotes = await NotesDatabase.instance.readAllNotes();
     await Hide.instance.database;
 List<NoteModel> allHideNotes = await Hide.instance.readAllNotes();
  runApp( Home(allNotes: allNotes,));
}
