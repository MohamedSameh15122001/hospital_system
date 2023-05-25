import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hospital_system/shared/main_cubit/patient_cubit/patient_states.dart';

class PatientCubit extends Cubit<PatientState> {
  PatientCubit() : super(PatientInitial());

  static PatientCubit get(context) => BlocProvider.of(context);
}
