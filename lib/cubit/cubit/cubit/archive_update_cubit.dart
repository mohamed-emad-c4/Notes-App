import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:test1/DB/database.dart';
import 'package:test1/models/note.dart';

part 'archive_update_state.dart';

class ArchiveUpdateCubit extends Cubit<ArchiveUpdateState> {
  ArchiveUpdateCubit() : super(ArchiveUpdateInitial());
  void RemoveNoteFromArchive({required allNotes, required index}) async {
    final newNote = NoteModel(
      id: allNotes[index].id,
      title: allNotes[index].title,
      content: allNotes[index].content,
      isFavorite: allNotes[index].isFavorite,
      archived: !allNotes[index].archived,
      createdTime: DateTime.now().toString(),
    );
    await NotesDatabase.instance.update(newNote);
    emit(ArchiveUpdate());
  }

  void AddNoteToFavorit({required allNotes, required index}) async {
    final newNote = NoteModel(
      id: allNotes[index].id,
      title: allNotes[index].title,
      content: allNotes[index].content,
      isFavorite: true,
      archived: allNotes[index].archived,
      createdTime: DateTime.now().toString(),
    );
    await NotesDatabase.instance.update(newNote);
    emit(ArchiveUpdate());
  }

  void AddNoteToDeleted({required allNotes, required index}) async {
    final newNote = NoteModel(
      id: allNotes[index].id,
      title: allNotes[index].title,
      content: allNotes[index].content,
      isFavorite: allNotes[index].isFavorite,
      deleted: true,
      archived: false,
      createdTime: DateTime.now().toString(),
    );
    await NotesDatabase.instance.update(newNote);
    emit(ArchiveUpdate());
  }
}
