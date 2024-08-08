part of 'hide_cubit_cubit.dart';

@immutable
sealed class HideCubitState {}

final class HideCubitInitial extends HideCubitState {}
final class HideCubitUpdated extends HideCubitState {}
