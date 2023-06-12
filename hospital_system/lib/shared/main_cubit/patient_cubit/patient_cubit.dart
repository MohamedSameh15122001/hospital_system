import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hospital_system/models/patient_models/get_patient_appointment_model.dart';
import 'package:hospital_system/models/patient_models/get_patient_diagnosis_model.dart';
import 'package:hospital_system/models/patient_models/get_patient_profile_model.dart';
import 'package:hospital_system/shared/main_cubit/patient_cubit/patient_states.dart';
import 'package:http/http.dart' as http;
import '../../../models/error_model.dart';
import '../../../modules/patient_modules/patient_appointments.dart';
import '../../../modules/patient_modules/patient_home.dart';
import '../../../modules/patient_modules/patient_notifications.dart';
import '../../components/constants.dart';
import '../../components/end_points.dart';

class PatientCubit extends Cubit<PatientState> {
  PatientCubit() : super(PatientInitial());

  static PatientCubit get(context) => BlocProvider.of(context);

  // Bottom Navigation Bar
  var currentIndex = 0;

  List<IconData> listOfIcons = [
    Icons.home_rounded,
    Icons.task,
    Icons.notifications,
  ];

  List<Widget> layoutPages = [
    const PatientHome(),
    const PatientAppointments(),
    const PatientNotifications(),
  ];

  void changeBottomNavBar(index) {
    currentIndex = index;
    HapticFeedback.lightImpact();
    emit(ChangeBottomNavBar());
  }
  // Bottom Navigation Bar

  ErrorModel? errorModel;
  // SuccessModel? successModel;

  // get patient profile
  GetPatientProfileModel? getPatientProfileModel;
  Future<void> getPatientProfile({
    required String token,
  }) async {
    emit(LoadingGetPatientProfile());
    try {
      // Make the GET request
      final response = await http.get(
        Uri.parse('$url$patients$profile'),
        headers: {contentType: applicationJson, 'token': token},
      );

      // Check the status code of the response
      if (response.statusCode == 200) {
        // Request successful
        Map<String, dynamic> successResponse = jsonDecode(response.body);
        getPatientProfileModel =
            GetPatientProfileModel.fromJson(successResponse);

        emit(SuccessGetPatientProfile());
      } else {
        // Request failed
        Map<String, dynamic> errorResponse = jsonDecode(response.body);
        errorModel = ErrorModel.fromJson(errorResponse);
        showToast(text: errorModel!.message!, state: ToastStates.WARNING);
        emit(ErrorGetPatientProfile());
      }
    } catch (e) {
      // An error occurred
      // showToast(text: 'error $e', state: ToastStates.ERROR);
      emit(ErrorGetPatientProfile());
    }
  }
  // get patient profile

  // get patient appointments
  GetPatientAppointmentsModel? getPatientAppointmentsModel;
  Future<void> getPatientAppointments({
    required String token,
  }) async {
    emit(LoadingGetPatientAppointments());
    try {
      // Make the GET request
      final response = await http.get(
        Uri.parse('$url$patients$profile$appointmentes'),
        headers: {contentType: applicationJson, 'token': token},
      );

      // Check the status code of the response
      if (response.statusCode == 200) {
        // Request successful
        Map<String, dynamic> successResponse = jsonDecode(response.body);
        getPatientAppointmentsModel =
            GetPatientAppointmentsModel.fromJson(successResponse);

        emit(SuccessGetPatientAppointments());
      } else {
        // Request failed
        Map<String, dynamic> errorResponse = jsonDecode(response.body);
        errorModel = ErrorModel.fromJson(errorResponse);
        showToast(text: errorModel!.message!, state: ToastStates.WARNING);
        emit(ErrorGetPatientAppointments());
      }
    } catch (e) {
      // An error occurred
      // showToast(text: 'error $e', state: ToastStates.ERROR);
      emit(ErrorGetPatientAppointments());
    }
  }
  // get patient appointments

  // get patient diagnosis
  GetPatientDiagnosisModel? getPatientDiagnosisModel;
  Future<void> getPatientDiagnosis({
    required String token,
  }) async {
    emit(LoadingGetPatientDiagnosis());
    try {
      // Make the GET request
      final response = await http.get(
        Uri.parse('$url$patients$profile$diagnoses'),
        headers: {contentType: applicationJson, 'token': token},
      );

      // Check the status code of the response
      if (response.statusCode == 200) {
        // Request successful
        Map<String, dynamic> successResponse = jsonDecode(response.body);
        getPatientDiagnosisModel =
            GetPatientDiagnosisModel.fromJson(successResponse);

        emit(SuccessGetPatientDiagnosis());
      } else {
        // Request failed
        Map<String, dynamic> errorResponse = jsonDecode(response.body);
        errorModel = ErrorModel.fromJson(errorResponse);
        showToast(text: errorModel!.message!, state: ToastStates.WARNING);
        emit(ErrorGetPatientDiagnosis());
      }
    } catch (e) {
      // An error occurred
      // showToast(text: 'error $e', state: ToastStates.ERROR);
      emit(ErrorGetPatientDiagnosis());
    }
  }
  // get patient diagnosis
}
