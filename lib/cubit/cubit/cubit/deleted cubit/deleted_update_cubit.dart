import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:test1/DB/database.dart';
import 'package:test1/models/note.dart';

part 'deleted_update_state.dart';

class DeletedUpdateCubit extends Cubit<DeletedUpdateState> {
  DeletedUpdateCubit() : super(DeletedUpdateInitial());
  void RemoveNoteFromDeleted({required allNotes, required index}) async {
    final newNote = NoteModel(
      id: allNotes[index].id,
      title: allNotes[index].title,
      content: allNotes[index].content,
      isFavorite: allNotes[index].isFavorite,
      deleted: false,
      archived: allNotes[index].archived,
      createdTime: DateTime.now().toString(),
    );
    await NotesDatabase.instance.update(newNote);
    emit(DeletedUpdate());
  }

  void AddNoteToArchived({required allNotes, required index}) async {
    final newNote = NoteModel(
      id: allNotes[index].id,
      title: allNotes[index].title,
      content: allNotes[index].content,
      isFavorite: allNotes[index].isFavorite,
      deleted: false,
      archived: true,
      createdTime: DateTime.now().toString(),
    );
    await NotesDatabase.instance.update(newNote);
    emit(DeletedUpdate());
  }

  void AddNoteToFavorit({required allNotes, required index}) async {
    final newNote = NoteModel(
      id: allNotes[index].id,
      title: allNotes[index].title,
      content: allNotes[index].content,
      isFavorite: true,
      deleted: false,
      archived: allNotes[index].archived,
      createdTime: DateTime.now().toString(),
    );
    await NotesDatabase.instance.update(newNote);
    emit(DeletedUpdate());
  }

  void RestoreNote({required allNotes, required index}) async {
    final newNote = NoteModel(
      id: allNotes[index].id,
      title: allNotes[index].title,
      content: allNotes[index].content,
      isFavorite: allNotes[index].isFavorite,
      deleted: false,
      archived: allNotes[index].archived,
      createdTime: DateTime.now().toString(),
    );
    await NotesDatabase.instance.update(newNote);
    emit(DeletedUpdate());
  }

  void PremanentDelete({required allNotes, required index}) async {
    final newNote = NoteModel(
      id: allNotes[index].id,
      title: allNotes[index].title,
      content: allNotes[index].content,
      isFavorite: allNotes[index].isFavorite,
      deleted: false,
      archived: allNotes[index].archived,
      createdTime: DateTime.now().toString(),
    );
    await NotesDatabase.instance.delete(newNote.id!);
    emit(DeletedUpdate());
  }
}
