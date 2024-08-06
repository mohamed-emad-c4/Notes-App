import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'update_state.dart';

class UpdateCubit extends Cubit<UpdateState> {
  UpdateCubit() : super(UpdateInitial());
}
