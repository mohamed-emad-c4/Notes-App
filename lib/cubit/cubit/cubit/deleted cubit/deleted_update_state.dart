part of 'deleted_update_cubit.dart';

@immutable
sealed class DeletedUpdateState {}

final class DeletedUpdateInitial extends DeletedUpdateState {}
final class DeletedUpdate extends DeletedUpdateState {}
