import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:test1/DB/database.dart';
import 'package:test1/models/note.dart';

part 'favorit_update_state.dart';

class FavoritUpdateCubit extends Cubit<FavoritUpdateState> {
  FavoritUpdateCubit() : super(FavoritUpdateInitial());
  void AddToDeleted({required allNotes, required index}) async {
    final newNote = NoteModel(
      id: allNotes[index].id,
      title: allNotes[index].title,
      content: allNotes[index].content,
      isFavorite: false,
      deleted: true,
      archived: allNotes[index].archived,
      createdTime: DateTime.now().toString(),
    );
    await NotesDatabase.instance.update(newNote);
    emit(FavoritUpdate());
  }

  void AddNoteToArchived({required allNotes, required index}) async {
    final newNote = NoteModel(
      id: allNotes[index].id,
      title: allNotes[index].title,
      content: allNotes[index].content,
      isFavorite: false,
      deleted: allNotes[index].deleted,
      archived: true,
      createdTime: DateTime.now().toString(),
    );
    await NotesDatabase.instance.update(newNote);
    emit(FavoritUpdate());
  }

  void Dislike({required allNotes, required index}) async {
    final newNote = NoteModel(
      id: allNotes[index].id,
      title: allNotes[index].title,
      content: allNotes[index].content,
      isFavorite: false,
      deleted: allNotes[index].deleted,
      archived: allNotes[index].archived,
      createdTime: DateTime.now().toString(),
    );
    await NotesDatabase.instance.update(newNote);
    emit(FavoritUpdate());
  }
}
