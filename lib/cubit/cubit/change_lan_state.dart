part of 'change_lan_cubit.dart';

@immutable
sealed class ChangeLanState {}

final class ChangeLanInitial extends ChangeLanState {
  ChangeLanInitial({ required this.SelectLang});
  String SelectLang ;
}
final class ChangeLanSuccess extends ChangeLanState {
  ChangeLanSuccess({ required this.SelectLang});
  String SelectLang ;
}
