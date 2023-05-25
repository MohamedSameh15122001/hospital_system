import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hospital_system/shared/main_cubit/doctor_cubit/doctor_states.dart';

class DoctorCubit extends Cubit<DoctorState> {
  DoctorCubit() : super(DoctorInitial());

  static DoctorCubit get(context) => BlocProvider.of(context);
}
