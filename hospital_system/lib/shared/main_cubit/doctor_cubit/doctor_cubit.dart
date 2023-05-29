import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hospital_system/models/error_model.dart';
import 'package:hospital_system/shared/components/end_points.dart';
import 'package:hospital_system/shared/main_cubit/doctor_cubit/doctor_states.dart';
import 'package:http/http.dart' as http;

import '../../../models/doctor_models/get_patient_with_his_diagnosis_model.dart';
import '../../../models/success_model.dart';
import '../../components/constants.dart';

class DoctorCubit extends Cubit<DoctorState> {
  DoctorCubit() : super(DoctorInitial());

  static DoctorCubit get(context) => BlocProvider.of(context);

  ErrorModel? errorModel;
  SuccessModel? successModel;

  // Add Diagnosis
  Future<void> addDiagnosis({
    required String id,
    required String prescription,
    required String diagnosis,
    required String token,
    required context,
  }) async {
    emit(LoadingAddDiagnosis());

    // Convert the request body to JSON
    String jsonBody = jsonEncode(
        {'prescription': prescription, 'diagnosis': diagnosis, 'Id': id});

    try {
      // Make the POST request
      final response = await http.post(
        Uri.parse('$url$diagnoses'),
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
        emit(SuccessAddDiagnosis());
      } else {
        // Request failed
        Map<String, dynamic> errorResponse = jsonDecode(response.body);
        errorModel = ErrorModel.fromJson(errorResponse);
        showToast(text: errorModel!.message!, state: ToastStates.WARNING);
        emit(ErrorAddDiagnosis());
      }
    } catch (e) {
      // An error occurred
      showToast(text: 'error $e', state: ToastStates.ERROR);
      emit(ErrorAddDiagnosis());
    }
  }
  // Add Diagnosis

  // Get Patient With His Diagnosis
  GetPatientWithHisDiagnosisModel? getPatientWithHisDiagnosisModel;
  Future<void> getPatientWithHisDiagnosis(
      {required String token, required String id}) async {
    emit(LoadingGetPatientWithHisDiagnosis());

    try {
      // Make the GET request
      final response = await http.get(
        Uri.parse('$url$patients/$id$diagnosis'),
        headers: {contentType: applicationJson, 'token': token},
      );

      // Check the status code of the response
      if (response.statusCode == 200) {
        // Request successful
        Map<String, dynamic> successResponse = jsonDecode(response.body);
        getPatientWithHisDiagnosisModel =
            GetPatientWithHisDiagnosisModel.fromJson(successResponse);
        emit(SuccessGetPatientWithHisDiagnosis());
      } else {
        // Request failed
        Map<String, dynamic> errorResponse = jsonDecode(response.body);
        errorModel = ErrorModel.fromJson(errorResponse);
        showToast(text: errorModel!.message!, state: ToastStates.WARNING);
        emit(ErrorGetPatientWithHisDiagnosis());
      }
    } catch (e) {
      // An error occurred
      showToast(text: 'error $e', state: ToastStates.ERROR);
      emit(ErrorGetPatientWithHisDiagnosis());
    }
  }
  // Get Patient With His Diagnosis

  // Update Patient Diagnosis
  Future<void> updatePatientDiagnosis({
    required String diagnosis,
    required String prescription,
    required String id,
    required String token,
    // required context,
  }) async {
    emit(LoadingUpdatePatientDiagnosis());

    // Convert the request body to JSON
    String jsonBody =
        jsonEncode({'diagnosis': diagnosis, 'prescription': prescription});

    try {
      // Make the PUT request
      final response = await http.put(
        Uri.parse('$url$patients/$id$diagnosis'),
        headers: {contentType: applicationJson, 'token': token},
        body: jsonBody,
      );

      // Check the status code of the response
      if (response.statusCode == 200) {
        // Request successful
        Map<String, dynamic> successResponse = jsonDecode(response.body);
        successModel = SuccessModel.fromJson(successResponse);
        showToast(text: successModel!.message!, state: ToastStates.SUCCESS);
        // Navigator.pop(context);
        emit(SuccessUpdatePatientDiagnosis());
      } else {
        // Request failed
        Map<String, dynamic> errorResponse = jsonDecode(response.body);
        errorModel = ErrorModel.fromJson(errorResponse);
        showToast(text: errorModel!.message!, state: ToastStates.WARNING);
        emit(ErrorUpdatePatientDiagnosis());
      }
    } catch (e) {
      // An error occurred
      showToast(text: 'error $e', state: ToastStates.ERROR);
      emit(ErrorUpdatePatientDiagnosis());
    }
  }
  // Update Patient Diagnosis

  // Delete Patient Diagnosis
  Future<void> deletePatientDiagnosis(
      {required String token, required String id}) async {
    emit(LoadingDeletePatientDiagnosis());

    try {
      // Make the DELETE request
      final response = await http.delete(
        Uri.parse('$url$patients/$id$diagnosis'),
        headers: {contentType: applicationJson, 'token': token},
      );

      // Check the status code of the response
      if (response.statusCode == 200) {
        // Request successful
        Map<String, dynamic> successResponse = jsonDecode(response.body);
        successModel = SuccessModel.fromJson(successResponse);
        showToast(text: successModel!.message!, state: ToastStates.SUCCESS);

        // Navigator.pop(context);
        // await getAllPatients(token: token);
        emit(SuccessDeletePatientDiagnosis());
      } else {
        // Request failed
        Map<String, dynamic> errorResponse = jsonDecode(response.body);
        errorModel = ErrorModel.fromJson(errorResponse);
        showToast(text: errorModel!.message!, state: ToastStates.WARNING);
        emit(ErrorDeletePatientDiagnosis());
      }
    } catch (e) {
      // An error occurred
      showToast(text: 'error $e', state: ToastStates.ERROR);
      emit(ErrorDeletePatientDiagnosis());
    }
  }
  // Delete Patient Diagnosis
}
