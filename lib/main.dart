import 'package:flutter/material.dart';

import 'DB/database.dart';
import 'models/note.dart';
import 'view/home.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await NotesDatabase.instance.database;
    List<NoteModel> allNotes = await NotesDatabase.instance.readAllNotes();

  runApp( Home(allNotes: allNotes,));
}
