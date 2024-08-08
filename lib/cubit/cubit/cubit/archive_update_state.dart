part of 'archive_update_cubit.dart';

@immutable
sealed class ArchiveUpdateState {}

final class ArchiveUpdateInitial extends ArchiveUpdateState {}

final class ArchiveUpdate extends ArchiveUpdateState {}
