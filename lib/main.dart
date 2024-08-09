import 'package:flutter/material.dart';
import 'package:test1/cubit/hide_notes_cubit.dart';
import 'package:test1/shared_prefrence.dart';

import 'DB/database.dart';
import 'DB/hide.dart';
import 'models/note.dart';
import 'view/home.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await NotesDatabase.instance.database;
  List<NoteModel> allNotes = await NotesDatabase.instance.readAllNotes();
  await Hide.instance.database;
  SharePrefrenceClass pref=SharePrefrenceClass();
  bool isDark =
      await pref.getVlue(key: 'isDarkMode', defaultValue: false);
      String SelectLang =
      await pref.getVlue(key: 'selectedLanguage', defaultValue: 'en');
  List<NoteModel> allHideNotes = await Hide.instance.readAllNotes();

  runApp(Home(
    allNotes: allNotes,
    isDarkMode: isDark,
    SelectLang: SelectLang,
  ));
}
