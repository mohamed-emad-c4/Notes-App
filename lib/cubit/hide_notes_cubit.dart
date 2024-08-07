import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:test1/shared_prefrence.dart';

part 'hide_notes_state.dart';

SharePrefrenceClass sharePrefrenceClass = SharePrefrenceClass();
class HideNotesCubit extends Cubit<HideNotesState> {
  HideNotesCubit() : super(HideNotesInitial());
  
  void creatPIN()async {
    bool isCreatPIN= await sharePrefrenceClass.getVlue(key: 'isCreatPIN') ?? false;

 if (isCreatPIN==false) {
   await sharePrefrenceClass.saveValue(value: true, key: 'isCreatPIN');
   emit(HideNotesCreatPIN()); 
 }else{
  emit(HideNotesEnterPIN());
 }
    
  }

  void hideNotes() {
    
    emit(HideNotesView());
  }

}
