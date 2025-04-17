import 'package:bloc/bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:meta/meta.dart';
import 'package:test1/shared_prefrence.dart';

part 'hide_notes_state.dart';

SharePrefrenceClass sharePrefrenceClass = SharePrefrenceClass();

class HideNotesCubit extends Cubit<HideNotesState> {
  HideNotesCubit() : super(HideNotesInitial());
  final _storage = const FlutterSecureStorage();

  Future<void> chechPIN() async {
    try {
      // Check if PIN exists in secure storage
      final savedPin = await _storage.read(key: 'user_pin');

      if (savedPin == null || savedPin.isEmpty) {
        // PIN doesn't exist, go to create PIN
        await sharePrefrenceClass.saveValuebool(value: true, key: 'CreatPIN');
        emit(HideNotesCreatPIN());
      } else {
        // PIN exists, go to enter PIN
        emit(HideNotesEnterPIN());
      }
    } catch (e) {
      // If there's an error, default to create PIN
      await sharePrefrenceClass.saveValuebool(value: true, key: 'CreatPIN');
      emit(HideNotesCreatPIN());
    }
  }

  void hideNotes() {
    emit(HideNotesView());
  }
}
