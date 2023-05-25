import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hospital_system/shared/main_cubit/nurse_cubit/nurse_states.dart';

class NurseCubit extends Cubit<NurseState> {
  NurseCubit() : super(NurseInitial());

  static NurseCubit get(context) => BlocProvider.of(context);
}
