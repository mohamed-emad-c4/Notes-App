import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import '../DB/hide.dart';

part 'hide_cubit_state.dart';

class HideCubitCubit extends Cubit<HideCubitState> {
  HideCubitCubit() : super(HideCubitInitial());
  void deletNote(int index) {
    Hide.instance.delete(index);
    emit(HideCubitUpdated());
  }
}
