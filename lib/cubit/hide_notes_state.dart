part of 'hide_notes_cubit.dart';

@immutable
sealed class HideNotesState {}

final class HideNotesInitial extends HideNotesState {}
final class HideNotesCreatPIN extends HideNotesState {}

final class HideNotesEnterPIN extends HideNotesState {}
final class HideNotesView extends HideNotesState {}


