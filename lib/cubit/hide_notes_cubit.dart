import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:test1/shared_prefrence.dart';

part 'hide_notes_state.dart';

SharePrefrenceClass sharePrefrenceClass = SharePrefrenceClass();
class HideNotesCubit extends Cubit<HideNotesState> {
  HideNotesCubit() : super(HideNotesInitial());
  
  void chechPIN()async {
    bool isCreatPIN= await sharePrefrenceClass.getVlue(key: 'CreatPIN');
    

 if (isCreatPIN==false) {
   await sharePrefrenceClass.saveValuebool(value: true, key: 'CreatPIN');
   emit(HideNotesCreatPIN()); 
 }else{
  emit(HideNotesEnterPIN());
 }
    
  }

  void hideNotes() {
    
    emit(HideNotesView());
  }

}
