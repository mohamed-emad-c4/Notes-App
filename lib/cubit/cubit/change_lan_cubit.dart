import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:test1/shared_prefrence.dart';

part 'change_lan_state.dart';

class ChangeLanCubit extends Cubit<ChangeLanState> {
  ChangeLanCubit() : super(ChangeLanInitial(
  ));
   String SelectLang = 'en';
  void changeLan() async {
    final pref = SharePrefrenceClass();
    SelectLang =
        await pref.getVlue(key: 'selectedLanguage', defaultValue: 'en');
    emit(ChangeLanSuccess(SelectLang: SelectLang));
  }
}
