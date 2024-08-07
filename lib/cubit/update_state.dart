part of 'update_cubit.dart';

@immutable
sealed class UpdateState {}

final class UpdateInitial extends UpdateState {}

final class UpdateLoading extends UpdateState {}

final class AddNoteState extends UpdateState {}

final class UpdateNotes extends UpdateState {
  final List<NoteModel> allNotes;
  UpdateNotes({required this.allNotes});
}

final class DeleteNote extends UpdateState {}
final class ChangeTheme extends UpdateState {}


