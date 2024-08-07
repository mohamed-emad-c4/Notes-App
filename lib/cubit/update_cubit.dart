import 'package:bloc/bloc.dart';
import 'package:intl/intl.dart';
import 'package:meta/meta.dart';
import 'package:test1/DB/database.dart';
import 'package:test1/models/note.dart';

part 'update_state.dart';

List<NoteModel> allNotes = [];

class UpdateCubit extends Cubit<UpdateState> {
  UpdateCubit() : super(UpdateInitial());

  void AddNoteToFavorit({required allNotes, required index}) async {
  final newNote = NoteModel(
    id: allNotes[index].id,
    title: allNotes[index].title,
    content: allNotes[index].content,
    isFavorite: !allNotes[index].isFavorite,
    archived: allNotes[index].archived,
    createdTime: DateTime.now().toIso8601String(),
  );
  await NotesDatabase.instance.update(newNote);
}

void AddNoteToArchive({required allNotes, required index}) async {
  final newNote = NoteModel(
    id: allNotes[index].id,
    title: allNotes[index].title,
    content: allNotes[index].content,
    isFavorite: allNotes[index].isFavorite,
    archived: !allNotes[index].archived,
    createdTime: DateTime.now().toString(),
  );
  await NotesDatabase.instance.update(newNote);
}


void AddNoteToDeleted({required allNotes, required index}) async {
  final newNote = NoteModel(
    id: allNotes[index].id,
    title: allNotes[index].title,
    content: allNotes[index].content,
    isFavorite: allNotes[index].isFavorite,
    archived: allNotes[index].archived,
    deleted: !allNotes[index].deleted,
    createdTime: DateTime.now().toString(),
  );
  await NotesDatabase.instance.update(newNote);
}
String formatDateTime(String input) {
  DateTime dateTime = DateTime.parse(input);
  DateTime now = DateTime.now();
  Duration difference = now.difference(dateTime);

  if (difference.inDays >= 1) {
    if (difference.inDays == 1) {
      return "Yesterday at ${DateFormat('h:mm a').format(dateTime)}";
    } else {
      return DateFormat('d MMM y h:mm a').format(dateTime);
    }
  } else if (difference.inHours >= 1) {
    return "${difference.inHours} hour${difference.inHours > 1 ? 's' : ''} ago";
  } else if (difference.inMinutes >= 1) {
    return "${difference.inMinutes} minute${difference.inMinutes > 1 ? 's' : ''} ago";
  } else {
    return "Just now";
  }
}
  void updateLoading() => emit(UpdateLoading());
  void updateNotes() async {
    allNotes = await NotesDatabase.instance.readAllNotes();
    emit(UpdateNotes(
      allNotes: allNotes,
    ));
  }
  void ChangeThemefunction()  {
    
    emit(ChangeTheme());}

  void deleteNote() => emit(DeleteNote());
  void AddNoteStateFunction() => emit(AddNoteState());
}
