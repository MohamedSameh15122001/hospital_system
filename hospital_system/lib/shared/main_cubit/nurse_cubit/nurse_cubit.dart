import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hospital_system/models/nurse_models/get_nurse_profile_model.dart';
import 'package:hospital_system/shared/main_cubit/nurse_cubit/nurse_states.dart';

import '../../../models/error_model.dart';
import '../../../models/nurse_models/get_all_patient_appointment_model.dart';
import '../../../models/nurse_models/get_complated_appointments_model.dart';
import '../../../models/nurse_models/get_specific_patient_appointment_model.dart';
import '../../../models/success_model.dart';
import '../../../modules/nurse_modules/nurse_home.dart';
import '../../../modules/nurse_modules/nurse_notifications.dart';
import '../../../modules/nurse_modules/nurse_completed_appointments.dart';
import 'package:http/http.dart' as http;

import '../../components/constants.dart';
import '../../components/end_points.dart';

class NurseCubit extends Cubit<NurseState> {
  NurseCubit() : super(NurseInitial());

  static NurseCubit get(context) => BlocProvider.of(context);

  // Bottom Navigation Bar
  var currentIndex = 0;

  List<IconData> listOfIcons = [
    Icons.home_rounded,
    Icons.task,
    Icons.notifications,
  ];

  List<Widget> layoutPages = [
    const NurseHome(),
    const NurseCompletedAppointments(),
    const NurseNotifications(),
  ];

  void changeBottomNavBar(index) {
    currentIndex = index;
    HapticFeedback.lightImpact();
    emit(ChangeBottomNavBar());
  }
  // Bottom Navigation Bar

  ErrorModel? errorModel;
  SuccessModel? successModel;
  // Add Appointment
  Future<void> addAppointment({
    required String id,
    required double schedule,
    required List<Map<String, String>> medications,
    required String token,
    required context,
  }) async {
    emit(LoadingAddAppointment());

    // Convert the request body to JSON
    String jsonBody = jsonEncode(
        {'schedule': schedule, 'Id': id, 'medications': medications});

    try {
      // Make the POST request
      final response = await http.post(
        Uri.parse('$url$appointments'),
        headers: {contentType: applicationJson, 'token': token},
        body: jsonBody,
      );

      // Check the status code of the response
      if (response.statusCode == 200) {
        // Request successful
        Map<String, dynamic> successResponse = jsonDecode(response.body);
        successModel = SuccessModel.fromJson(successResponse);
        showToast(text: successModel!.message!, state: ToastStates.SUCCESS);
        Navigator.pop(context);
        // await getAllMangers(token: token);
        emit(SuccessAddAppointment());
      } else {
        // Request failed
        Map<String, dynamic> errorResponse = jsonDecode(response.body);
        errorModel = ErrorModel.fromJson(errorResponse);
        showToast(text: errorModel!.message!, state: ToastStates.WARNING);
        emit(ErrorAddAppointment());
      }
    } catch (e) {
      // An error occurred
      // showToast(text: 'error $e', state: ToastStates.ERROR);
      emit(ErrorAddAppointment());
    }
  }
  // Add Appointment

  // Get All Patient Appointment
  GetAllPatientAppointmentModel? getAllPatientAppointmentModel;
  Future<void> getAllPatientAppointment(
      {required String token, required String id}) async {
    emit(LoadingGetAllPatientAppointment());
    try {
      // Make the GET request
      final response = await http.get(
        Uri.parse('$url$patients/$id$appointments'),
        headers: {contentType: applicationJson, 'token': token},
      );

      // Check the status code of the response
      if (response.statusCode == 200) {
        // Request successful
        Map<String, dynamic> successResponse = jsonDecode(response.body);
        getAllPatientAppointmentModel =
            GetAllPatientAppointmentModel.fromJson(successResponse);

        emit(SuccessGetAllPatientAppointment());
      } else {
        // Request failed
        Map<String, dynamic> errorResponse = jsonDecode(response.body);
        errorModel = ErrorModel.fromJson(errorResponse);
        showToast(text: errorModel!.message!, state: ToastStates.WARNING);
        emit(ErrorGetAllPatientAppointment());
      }
    } catch (e) {
      // An error occurred
      // showToast(text: 'error $e', state: ToastStates.ERROR);
      emit(ErrorGetAllPatientAppointment());
    }
  }
  // Get All Patient Appointment

  // Get Specific Patient Appointment
  GetSpecificPatientAppointmentModel? getSpecificPatientAppointmentModel;
  Future<void> getSpecificPatientAppointment(
      {required String token,
      required String patientId,
      required String appointmentId}) async {
    emit(LoadingGetSpecificPatientAppointment());
    try {
      // Make the GET request
      final response = await http.get(
        Uri.parse('$url$patients/$patientId$appointments/$appointmentId'),
        headers: {contentType: applicationJson, 'token': token},
      );

      // Check the status code of the response
      if (response.statusCode == 200) {
        // Request successful
        Map<String, dynamic> successResponse = jsonDecode(response.body);
        getSpecificPatientAppointmentModel =
            GetSpecificPatientAppointmentModel.fromJson(successResponse);

        emit(SuccessGetSpecificPatientAppointment());
      } else {
        // Request failed
        Map<String, dynamic> errorResponse = jsonDecode(response.body);
        errorModel = ErrorModel.fromJson(errorResponse);
        showToast(text: errorModel!.message!, state: ToastStates.WARNING);
        emit(ErrorGetSpecificPatientAppointment());
      }
    } catch (e) {
      // An error occurred
      // showToast(text: 'error $e', state: ToastStates.ERROR);
      emit(ErrorGetSpecificPatientAppointment());
    }
  }
  // Get Specific Patient Appointment

  // Get Completed Appointments
  GetComplatedAppointmentsModel? getComplatedAppointmentsModel;
  Future<void> getCompletedAppointments({
    required String token,
  }) async {
    getComplatedAppointmentsModel = null;
    emit(LoadingGetComplatedAppointments());
    try {
      // Make the GET request
      final response = await http.get(
        Uri.parse('$url$appointments$complated'),
        headers: {contentType: applicationJson, 'token': token},
      );

      // Check the status code of the response
      if (response.statusCode == 200) {
        // Request successful
        Map<String, dynamic> successResponse = jsonDecode(response.body);
        getComplatedAppointmentsModel =
            GetComplatedAppointmentsModel.fromJson(successResponse);

        emit(SuccessGetComplatedAppointments());
      } else {
        // Request failed
        Map<String, dynamic> errorResponse = jsonDecode(response.body);
        errorModel = ErrorModel.fromJson(errorResponse);
        // showToast(text: errorModel!.message!, state: ToastStates.WARNING);
        emit(ErrorGetComplatedAppointments());
      }
    } catch (e) {
      // An error occurred
      // showToast(text: 'error $e', state: ToastStates.ERROR);
      emit(ErrorGetComplatedAppointments());
    }
  }
  // Get Completed Appointments

  // Check Complete
  Future<void> checkComplete(
      {required String token, required String appointmentId}) async {
    emit(LoadingCheckComplete());
    try {
      // Make the GET request
      final response = await http.get(
        Uri.parse('$url$appointments$complated/$appointmentId'),
        headers: {contentType: applicationJson, 'token': token},
      );

      // Check the status code of the response
      if (response.statusCode == 200) {
        // Request successful
        Map<String, dynamic> successResponse = jsonDecode(response.body);
        successModel = SuccessModel.fromJson(successResponse);
        showToast(text: successModel!.message!, state: ToastStates.SUCCESS);
        await getCompletedAppointments(token: token);
        emit(SuccessCheckComplete());
      } else {
        // Request failed
        Map<String, dynamic> errorResponse = jsonDecode(response.body);
        errorModel = ErrorModel.fromJson(errorResponse);
        showToast(text: errorModel!.message!, state: ToastStates.WARNING);
        emit(ErrorCheckComplete());
      }
    } catch (e) {
      // An error occurred
      // showToast(text: 'error $e', state: ToastStates.ERROR);
      emit(ErrorCheckComplete());
    }
  }
  // Check Complete

  // get nurse profile
  GetNurseProfileModel? getNurseProfileModel;
  Future<void> getNurseProfile({
    required String token,
  }) async {
    emit(LoadingGetNurseProfile());
    try {
      // Make the GET request
      final response = await http.get(
        Uri.parse('$url$nurses$profile'),
        headers: {contentType: applicationJson, 'token': token},
      );

      // Check the status code of the response
      if (response.statusCode == 200) {
        // Request successful
        Map<String, dynamic> successResponse = jsonDecode(response.body);
        getNurseProfileModel = GetNurseProfileModel.fromJson(successResponse);

        emit(SuccessGetNurseProfile());
      } else {
        // Request failed
        Map<String, dynamic> errorResponse = jsonDecode(response.body);
        errorModel = ErrorModel.fromJson(errorResponse);
        showToast(text: errorModel!.message!, state: ToastStates.WARNING);
        emit(ErrorGetNurseProfile());
      }
    } catch (e) {
      // An error occurred
      // showToast(text: 'error $e', state: ToastStates.ERROR);
      emit(ErrorGetNurseProfile());
    }
  }
  // get nurse profile
}
