part of 'favorit_update_cubit.dart';

@immutable
sealed class FavoritUpdateState {}

final class FavoritUpdateInitial extends FavoritUpdateState {}
final class FavoritUpdate extends FavoritUpdateState {}

