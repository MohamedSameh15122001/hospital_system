import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hospital_system/models/error_model.dart';
import '../../../modules/nurse_modules/nurse_layout.dart';
import 'package:hospital_system/models/success_model.dart';
import '../../../modules/patient_modules/patient_layout.dart';
import 'package:hospital_system/models/login_success_model.dart';
import 'package:hospital_system/shared/another/cache_helper.dart';
import 'package:hospital_system/shared/components/constants.dart';
import 'package:hospital_system/shared/components/end_points.dart';
import '../../../models/manager_models/get_all_doctors_model.dart';
import '../../../models/manager_models/get_all_patients_model.dart';
import '../../../models/manager_models/get_specific_nurse_model.dart';
import '../../../models/manager_models/get_all_medications_model.dart';
import '../../../models/manager_models/get_specific_doctor_model.dart';
import '../../../models/manager_models/get_specific_patient_model.dart';
import 'package:hospital_system/modules/doctor_modules/doctor_layout.dart';
import 'package:hospital_system/modules/manager_modules/manager_home.dart';
import '../../../models/manager_models/get_specific_medication_model.dart';
import 'package:hospital_system/models/manager_models/get_all_nurses_model.dart';
import 'package:hospital_system/models/manager_models/get_all_mangers_model.dart';
import 'package:hospital_system/shared/main_cubit/manager_cubit/manager_states.dart';
import 'package:hospital_system/models/manager_models/get_specific_manger_model.dart';

class ManagerCubit extends Cubit<ManagerState> {
  ManagerCubit() : super(ManagerInitial());

  static ManagerCubit get(context) => BlocProvider.of(context);

  List<String> images = [
    'lib/assets/images/manger.png',
    'lib/assets/images/doctor.png',
    'lib/assets/images/nurse.png',
    'lib/assets/images/patient.png',
    'lib/assets/images/medication.jpg',
  ];
  List<String> names = [
    'Mangers',
    'Doctors',
    'Nurses',
    'Patients',
    'Medicines',
  ];

  String who = "Manger";
  changeRadio(value) {
    who = value;
    emit(ChangeRadio());
  }

  ErrorModel? errorModel;
  SuccessModel? successModel;
  LoginSuccessModel? loginSuccessModel;
  //======================================================================
  // Start Manger
  //======================================================================

  // Create Manger Account
  Future<void> createMangerAccount({
    required String name,
    required String email,
    required String id,
    required String phone,
    required String token,
    required context,
  }) async {
    emit(LoadingCreateMangerAccount());

    // Convert the request body to JSON
    String jsonBody =
        jsonEncode({'name': name, 'email': email, 'Id': id, 'phone': phone});

    try {
      // Make the POST request
      final response = await http.post(
        Uri.parse('$url$mangers'),
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
        await getAllMangers(token: token);
        emit(SuccessCreateMangerAccount());
      } else {
        // Request failed
        Map<String, dynamic> errorResponse = jsonDecode(response.body);
        errorModel = ErrorModel.fromJson(errorResponse);
        showToast(text: errorModel!.message!, state: ToastStates.WARNING);
        emit(ErrorCreateMangerAccount());
      }
    } catch (e) {
      // An error occurred
      showToast(text: 'error $e', state: ToastStates.ERROR);
      emit(ErrorCreateMangerAccount());
    }
  }
  // Create Manger Account

  // Manger Login
  Future<void> mangerLogin(
      {required String id, required String password, required context}) async {
    emit(LoadingMangerLogin());

    // Convert the request body to JSON
    String jsonBody = jsonEncode({'Id': id, 'password': password});

    try {
      // Make the POST request
      final response = await http.post(
        Uri.parse('$url$mangersAuth'),
        headers: {contentType: applicationJson},
        body: jsonBody,
      );

      // Check the status code of the response
      if (response.statusCode == 200) {
        // Request successful
        Map<String, dynamic> successResponse = jsonDecode(response.body);
        loginSuccessModel = LoginSuccessModel.fromJson(successResponse);
        showToast(
            text: loginSuccessModel!.message!, state: ToastStates.SUCCESS);
        CacheHelper.saveData(key: 'token', value: loginSuccessModel!.token);
        CacheHelper.saveData(key: 'who', value: 'Manger');
        token = loginSuccessModel!.token;
        navigateAndFinish(context, const MangerHome());
        emit(SuccessMangerLogin());
      } else {
        // Request failed
        Map<String, dynamic> errorResponse = jsonDecode(response.body);
        errorModel = ErrorModel.fromJson(errorResponse);
        showToast(text: errorModel!.message!, state: ToastStates.WARNING);
        emit(ErrorMangerLogin());
      }
    } catch (e) {
      // An error occurred
      showToast(text: 'error $e', state: ToastStates.ERROR);
      emit(ErrorMangerLogin());
    }
  }
  // Manger Login

  // Get All Mangers
  GetAllMangersModel? getAllMangersModel;
  Future<void> getAllMangers({required String token}) async {
    emit(LoadingGetAllMangers());

    try {
      // Make the GET request
      final response = await http.get(
        Uri.parse('$url$mangers'),
        headers: {contentType: applicationJson, 'token': token},
      );

      // Check the status code of the response
      if (response.statusCode == 200) {
        // Request successful
        Map<String, dynamic> successResponse = jsonDecode(response.body);
        getAllMangersModel = GetAllMangersModel.fromJson(successResponse);
        emit(SuccessGetAllMangers());
      } else {
        // Request failed
        Map<String, dynamic> errorResponse = jsonDecode(response.body);
        errorModel = ErrorModel.fromJson(errorResponse);
        showToast(text: errorModel!.message!, state: ToastStates.WARNING);
        emit(ErrorGetAllMangers());
      }
    } catch (e) {
      // An error occurred
      showToast(text: 'error $e', state: ToastStates.ERROR);
      emit(ErrorGetAllMangers());
    }
  }
  // Get All Mangers

  // Delete Manger
  Future<void> deleteManger(
      {required String token, required String id, required context}) async {
    emit(LoadingDeleteManger());

    try {
      // Make the DELETE request
      final response = await http.delete(
        Uri.parse('$url$mangers/$id'),
        headers: {contentType: applicationJson, 'token': token},
      );

      // Check the status code of the response
      if (response.statusCode == 200) {
        // Request successful
        Map<String, dynamic> successResponse = jsonDecode(response.body);
        successModel = SuccessModel.fromJson(successResponse);
        showToast(text: successModel!.message!, state: ToastStates.SUCCESS);
        Navigator.pop(context);
        await getAllMangers(token: token);
        emit(SuccessDeleteManger());
      } else {
        // Request failed
        Map<String, dynamic> errorResponse = jsonDecode(response.body);
        errorModel = ErrorModel.fromJson(errorResponse);
        showToast(text: errorModel!.message!, state: ToastStates.WARNING);
        emit(ErrorDeleteManger());
      }
    } catch (e) {
      // An error occurred
      showToast(text: 'error $e', state: ToastStates.ERROR);
      emit(ErrorDeleteManger());
    }
  }
  // Delete Manger

  // Update Manger Account
  Future<void> updateMangerAccount({
    required String name,
    required String email,
    required String phone,
    required String id,
    required String token,
    required context,
  }) async {
    emit(LoadingUpdateMangerAccount());

    // Convert the request body to JSON
    String jsonBody =
        jsonEncode({'name': name, 'email': email, 'phone': phone});

    try {
      // Make the PUT request
      final response = await http.put(
        Uri.parse('$url$mangers/$id'),
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
        emit(SuccessUpdateMangerAccount());
      } else {
        // Request failed
        Map<String, dynamic> errorResponse = jsonDecode(response.body);
        errorModel = ErrorModel.fromJson(errorResponse);
        showToast(text: errorModel!.message!, state: ToastStates.WARNING);
        emit(ErrorUpdateMangerAccount());
      }
    } catch (e) {
      // An error occurred
      showToast(text: 'error $e', state: ToastStates.ERROR);
      emit(ErrorUpdateMangerAccount());
    }
  }
  // Update Manger Account

  // Get Specific Manger
  GetSpecificMangerModel? getSpecificMangerModel;
  Future<void> getSpecificManger(
      {required String token, required String id}) async {
    emit(LoadingGetSpecificManger());

    try {
      // Make the GET request
      final response = await http.get(
        Uri.parse('$url$mangers/$id'),
        headers: {contentType: applicationJson, 'token': token},
      );

      // Check the status code of the response
      if (response.statusCode == 200) {
        // Request successful
        Map<String, dynamic> successResponse = jsonDecode(response.body);
        getSpecificMangerModel =
            GetSpecificMangerModel.fromJson(successResponse);
        emit(SuccessGetSpecificManger());
      } else {
        // Request failed
        Map<String, dynamic> errorResponse = jsonDecode(response.body);
        errorModel = ErrorModel.fromJson(errorResponse);
        showToast(text: errorModel!.message!, state: ToastStates.WARNING);
        emit(ErrorGetSpecificManger());
      }
    } catch (e) {
      // An error occurred
      showToast(text: 'error $e', state: ToastStates.ERROR);
      emit(ErrorGetSpecificManger());
    }
  }
  // Get Specific Manger

  //======================================================================
  // End Manger
  //======================================================================

  //======================================================================
  // Start Doctor
  //======================================================================

  // Create Doctor Account
  Future<void> createDoctorAccount(
      {required String name,
      required String email,
      required String id,
      required String phone,
      required String token,
      required String specialty,
      required context}) async {
    emit(LoadingCreateDoctorAccount());

    // Convert the request body to JSON
    String jsonBody = jsonEncode({
      'name': name,
      'email': email,
      'Id': id,
      'phone': phone,
      'specialty': specialty
    });

    try {
      // Make the POST request
      final response = await http.post(
        Uri.parse('$url$doctors'),
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
        await getAllDoctors(token: token);
        emit(SuccessCreateDoctorAccount());
      } else {
        // Request failed
        Map<String, dynamic> errorResponse = jsonDecode(response.body);
        errorModel = ErrorModel.fromJson(errorResponse);
        showToast(text: errorModel!.message!, state: ToastStates.WARNING);
        emit(ErrorCreateDoctorAccount());
      }
    } catch (e) {
      // An error occurred
      showToast(text: 'error $e', state: ToastStates.ERROR);
      emit(ErrorCreateDoctorAccount());
    }
  }
  // Create Doctor Account

  // Doctor Login
  Future<void> doctorLogin(
      {required String id, required String password, required context}) async {
    emit(LoadingDoctorLogin());

    // Convert the request body to JSON
    String jsonBody = jsonEncode({'Id': id, 'password': password});

    try {
      // Make the POST request
      final response = await http.post(
        Uri.parse('$url$doctorsAuth'),
        headers: {contentType: applicationJson},
        body: jsonBody,
      );

      // Check the status code of the response
      if (response.statusCode == 200) {
        // Request successful
        Map<String, dynamic> successResponse = jsonDecode(response.body);
        loginSuccessModel = LoginSuccessModel.fromJson(successResponse);
        showToast(
            text: loginSuccessModel!.message!, state: ToastStates.SUCCESS);
        CacheHelper.saveData(key: 'token', value: loginSuccessModel!.token);
        CacheHelper.saveData(key: 'who', value: 'Doctor');
        token = loginSuccessModel!.token;
        navigateAndFinish(context, const DoctorLayout());
        emit(SuccessDoctorLogin());
      } else {
        // Request failed
        Map<String, dynamic> errorResponse = jsonDecode(response.body);
        errorModel = ErrorModel.fromJson(errorResponse);
        showToast(text: errorModel!.message!, state: ToastStates.WARNING);
        emit(ErrorDoctorLogin());
      }
    } catch (e) {
      // An error occurred
      showToast(text: 'error $e', state: ToastStates.ERROR);
      emit(ErrorDoctorLogin());
    }
  }
  // Doctor Login

  // Get All Doctors
  GetAllDoctorsModel? getAllDoctorsModel;
  Future<void> getAllDoctors({required String token}) async {
    emit(LoadingGetAllDoctors());

    try {
      // Make the GET request
      final response = await http.get(
        Uri.parse('$url$doctors'),
        headers: {contentType: applicationJson, 'token': token},
      );

      // Check the status code of the response
      if (response.statusCode == 200) {
        // Request successful
        Map<String, dynamic> successResponse = jsonDecode(response.body);
        getAllDoctorsModel = GetAllDoctorsModel.fromJson(successResponse);
        emit(SuccessGetAllDoctors());
      } else {
        // Request failed
        Map<String, dynamic> errorResponse = jsonDecode(response.body);
        errorModel = ErrorModel.fromJson(errorResponse);
        showToast(text: errorModel!.message!, state: ToastStates.WARNING);
        emit(ErrorGetAllDoctors());
      }
    } catch (e) {
      // An error occurred
      showToast(text: 'error $e', state: ToastStates.ERROR);
      emit(ErrorGetAllDoctors());
    }
  }
  // Get All Doctors

  // Delete Doctor
  Future<void> deleteDoctor(
      {required String token, required String id, required context}) async {
    emit(LoadingDeleteDoctor());

    try {
      // Make the DELETE request
      final response = await http.delete(
        Uri.parse('$url$doctors/$id'),
        headers: {contentType: applicationJson, 'token': token},
      );

      // Check the status code of the response
      if (response.statusCode == 200) {
        // Request successful
        Map<String, dynamic> successResponse = jsonDecode(response.body);
        successModel = SuccessModel.fromJson(successResponse);
        showToast(text: successModel!.message!, state: ToastStates.SUCCESS);
        Navigator.pop(context);
        await getAllDoctors(token: token);
        emit(SuccessDeleteDoctor());
      } else {
        // Request failed
        Map<String, dynamic> errorResponse = jsonDecode(response.body);
        errorModel = ErrorModel.fromJson(errorResponse);
        showToast(text: errorModel!.message!, state: ToastStates.WARNING);
        emit(ErrorDeleteDoctor());
      }
    } catch (e) {
      // An error occurred
      showToast(text: 'error $e', state: ToastStates.ERROR);
      emit(ErrorDeleteDoctor());
    }
  }
  // Delete Doctor

  // Update Doctor Account
  Future<void> updateDoctorAccount(
      {required String name,
      required String email,
      required String phone,
      required String specialty,
      required String id,
      required String token,
      required context}) async {
    emit(LoadingUpdateDoctorAccount());

    // Convert the request body to JSON
    String jsonBody = jsonEncode(
        {'name': name, 'email': email, 'phone': phone, 'specialty': specialty});

    try {
      // Make the PUT request
      final response = await http.put(
        Uri.parse('$url$doctors/$id'),
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
        await getAllDoctors(token: token);
        emit(SuccessUpdateDoctorAccount());
      } else {
        // Request failed
        Map<String, dynamic> errorResponse = jsonDecode(response.body);
        errorModel = ErrorModel.fromJson(errorResponse);
        showToast(text: errorModel!.message!, state: ToastStates.WARNING);
        emit(ErrorUpdateDoctorAccount());
      }
    } catch (e) {
      // An error occurred
      showToast(text: 'error $e', state: ToastStates.ERROR);
      emit(ErrorUpdateDoctorAccount());
    }
  }
  // Update Doctor Account

  // Get Specific Doctor
  GetSpecificDoctorModel? getSpecificDoctorModel;
  Future<void> getSpecificDoctor(
      {required String token, required String id}) async {
    emit(LoadingGetSpecificDoctor());

    try {
      // Make the GET request
      final response = await http.get(
        Uri.parse('$url$doctors/$id'),
        headers: {contentType: applicationJson, 'token': token},
      );

      // Check the status code of the response
      if (response.statusCode == 200) {
        // Request successful
        Map<String, dynamic> successResponse = jsonDecode(response.body);
        getSpecificDoctorModel =
            GetSpecificDoctorModel.fromJson(successResponse);
        emit(SuccessGetSpecificDoctor());
      } else {
        // Request failed
        Map<String, dynamic> errorResponse = jsonDecode(response.body);
        errorModel = ErrorModel.fromJson(errorResponse);
        showToast(text: errorModel!.message!, state: ToastStates.WARNING);
        emit(ErrorGetSpecificDoctor());
      }
    } catch (e) {
      // An error occurred
      showToast(text: 'error $e', state: ToastStates.ERROR);
      emit(ErrorGetSpecificDoctor());
    }
  }
  // Get Specific Doctor

  //======================================================================
  // End Doctor
  //======================================================================

  //======================================================================
  // Start Nurce
  //======================================================================

  // Create Nurse Account
  Future<void> createNurseAccount(
      {required String name,
      required String email,
      required String id,
      required String phone,
      required String address,
      required String department,
      required String token,
      required context}) async {
    emit(LoadingCreateNurseAccount());

    // Convert the request body to JSON
    String jsonBody = jsonEncode({
      'name': name,
      'email': email,
      'Id': id,
      'phone': phone,
      'address': address,
      'department': department,
    });

    try {
      // Make the POST request
      final response = await http.post(
        Uri.parse('$url$nurses'),
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
        await getAllNurses(token: token);
        emit(SuccessCreateNurseAccount());
      } else {
        // Request failed
        Map<String, dynamic> errorResponse = jsonDecode(response.body);
        errorModel = ErrorModel.fromJson(errorResponse);
        showToast(text: errorModel!.message!, state: ToastStates.WARNING);
        emit(ErrorCreateNurseAccount());
      }
    } catch (e) {
      // An error occurred
      showToast(text: 'error $e', state: ToastStates.ERROR);
      emit(ErrorCreateNurseAccount());
    }
  }
  // Create Nurse Account

  // Nurse Login
  Future<void> nurseLogin(
      {required String id, required String password, required context}) async {
    emit(LoadingNurseLogin());

    // Convert the request body to JSON
    String jsonBody = jsonEncode({'Id': id, 'password': password});

    try {
      // Make the POST request
      final response = await http.post(
        Uri.parse('$url$nursesAuth'),
        headers: {contentType: applicationJson},
        body: jsonBody,
      );

      // Check the status code of the response
      if (response.statusCode == 200) {
        // Request successful
        Map<String, dynamic> successResponse = jsonDecode(response.body);
        loginSuccessModel = LoginSuccessModel.fromJson(successResponse);
        showToast(
            text: loginSuccessModel!.message!, state: ToastStates.SUCCESS);
        CacheHelper.saveData(key: 'token', value: loginSuccessModel!.token);
        CacheHelper.saveData(key: 'who', value: 'Nurse');
        token = loginSuccessModel!.token;
        navigateAndFinish(context, const NurseLayout());
        emit(SuccessNurseLogin());
      } else {
        // Request failed
        Map<String, dynamic> errorResponse = jsonDecode(response.body);
        errorModel = ErrorModel.fromJson(errorResponse);
        showToast(text: errorModel!.message!, state: ToastStates.WARNING);
        emit(ErrorNurseLogin());
      }
    } catch (e) {
      // An error occurred
      showToast(text: 'error $e', state: ToastStates.ERROR);
      emit(ErrorNurseLogin());
    }
  }
  // Nurse Login

  // Get All Nurses
  GetAllNursesModel? getAllNursesModel;
  Future<void> getAllNurses({required String token}) async {
    emit(LoadingGetAllNurses());

    try {
      // Make the GET request
      final response = await http.get(
        Uri.parse('$url$nurses'),
        headers: {contentType: applicationJson, 'token': token},
      );

      // Check the status code of the response
      if (response.statusCode == 200) {
        // Request successful
        Map<String, dynamic> successResponse = jsonDecode(response.body);
        getAllNursesModel = GetAllNursesModel.fromJson(successResponse);
        emit(SuccessGetAllNurses());
      } else {
        // Request failed
        Map<String, dynamic> errorResponse = jsonDecode(response.body);
        errorModel = ErrorModel.fromJson(errorResponse);
        showToast(text: errorModel!.message!, state: ToastStates.WARNING);
        emit(ErrorGetAllNurses());
      }
    } catch (e) {
      // An error occurred
      showToast(text: 'error $e', state: ToastStates.ERROR);
      emit(ErrorGetAllNurses());
    }
  }
  // Get All Nurses

  // Delete Nurse
  Future<void> deleteNurse(
      {required String token, required String id, required context}) async {
    emit(LoadingDeleteNurse());

    try {
      // Make the DELETE request
      final response = await http.delete(
        Uri.parse('$url$nurses/$id'),
        headers: {contentType: applicationJson, 'token': token},
      );

      // Check the status code of the response
      if (response.statusCode == 200) {
        // Request successful
        Map<String, dynamic> successResponse = jsonDecode(response.body);
        successModel = SuccessModel.fromJson(successResponse);
        showToast(text: successModel!.message!, state: ToastStates.SUCCESS);
        Navigator.pop(context);
        await getAllNurses(token: token);
        emit(SuccessDeleteNurse());
      } else {
        // Request failed
        Map<String, dynamic> errorResponse = jsonDecode(response.body);
        errorModel = ErrorModel.fromJson(errorResponse);
        showToast(text: errorModel!.message!, state: ToastStates.WARNING);
        emit(ErrorDeleteNurse());
      }
    } catch (e) {
      // An error occurred
      showToast(text: 'error $e', state: ToastStates.ERROR);
      emit(ErrorDeleteNurse());
    }
  }
  // Delete Nurse

  // Update Nurse Account
  Future<void> updateNurseAccount({
    required String name,
    required String email,
    required String phone,
    required String address,
    required String department,
    required String id,
    required String token,
    required context,
  }) async {
    emit(LoadingUpdateNurseAccount());

    // Convert the request body to JSON
    String jsonBody = jsonEncode({
      'name': name,
      'email': email,
      'phone': phone,
      'department': department,
      'address': address
    });

    try {
      // Make the PUT request
      final response = await http.put(
        Uri.parse('$url$nurses/$id'),
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
        await getAllNurses(token: token);
        emit(SuccessUpdateNurseAccount());
      } else {
        // Request failed
        Map<String, dynamic> errorResponse = jsonDecode(response.body);
        errorModel = ErrorModel.fromJson(errorResponse);
        showToast(text: errorModel!.message!, state: ToastStates.WARNING);
        emit(ErrorUpdateNurseAccount());
      }
    } catch (e) {
      // An error occurred
      showToast(text: 'error $e', state: ToastStates.ERROR);
      emit(ErrorUpdateNurseAccount());
    }
  }
  // Update Nurse Account

  // Get Specific Nurse
  GetSpecificNurseModel? getSpecificNurseModel;
  Future<void> getSpecificNurse(
      {required String token, required String id}) async {
    emit(LoadingGetSpecificNurse());

    try {
      // Make the GET request
      final response = await http.get(
        Uri.parse('$url$nurses/$id'),
        headers: {contentType: applicationJson, 'token': token},
      );

      // Check the status code of the response
      if (response.statusCode == 200) {
        // Request successful
        Map<String, dynamic> successResponse = jsonDecode(response.body);
        getSpecificNurseModel = GetSpecificNurseModel.fromJson(successResponse);
        emit(SuccessGetSpecificNurse());
      } else {
        // Request failed
        Map<String, dynamic> errorResponse = jsonDecode(response.body);
        errorModel = ErrorModel.fromJson(errorResponse);
        showToast(text: errorModel!.message!, state: ToastStates.WARNING);
        emit(ErrorGetSpecificNurse());
      }
    } catch (e) {
      // An error occurred
      showToast(text: 'error $e', state: ToastStates.ERROR);
      emit(ErrorGetSpecificNurse());
    }
  }
  // Get Specific Nurse

  //======================================================================
  // End Nurce
  //======================================================================

  //======================================================================
  // Start patient
  //======================================================================

  // Create Patient Account
  Future<void> createPatientAccount(
      {required String name,
      required String email,
      required String id,
      required String phone,
      required String address,
      required String dateOfBirth,
      required String medicalHistory,
      required String lastVisited,
      required String token,
      required context}) async {
    emit(LoadingCreatePatientAccount());

    // Convert the request body to JSON
    String jsonBody = jsonEncode({
      'name': name,
      'email': email,
      'Id': id,
      'phone': phone,
      'address': address,
      'dateOfBirth': dateOfBirth,
      'medicalHistory': medicalHistory,
      'lastVisited': lastVisited,
    });

    try {
      // Make the POST request
      final response = await http.post(
        Uri.parse('$url$patients'),
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
        await getAllPatients(token: token);
        emit(SuccessCreatePatientAccount());
      } else {
        // Request failed
        Map<String, dynamic> errorResponse = jsonDecode(response.body);
        errorModel = ErrorModel.fromJson(errorResponse);
        showToast(text: errorModel!.message!, state: ToastStates.WARNING);
        emit(ErrorCreatePatientAccount());
      }
    } catch (e) {
      // An error occurred
      showToast(text: 'error $e', state: ToastStates.ERROR);
      emit(ErrorCreatePatientAccount());
    }
  }
  // Create Patient Account

  // Patient Login
  Future<void> patientLogin(
      {required String id, required String password, required context}) async {
    emit(LoadingPatientLogin());

    // Convert the request body to JSON
    String jsonBody = jsonEncode({'Id': id, 'password': password});

    try {
      // Make the POST request
      final response = await http.post(
        Uri.parse('$url$patientsAuth'),
        headers: {contentType: applicationJson},
        body: jsonBody,
      );

      // Check the status code of the response
      if (response.statusCode == 200) {
        // Request successful
        Map<String, dynamic> successResponse = jsonDecode(response.body);
        loginSuccessModel = LoginSuccessModel.fromJson(successResponse);
        showToast(
            text: loginSuccessModel!.message!, state: ToastStates.SUCCESS);
        CacheHelper.saveData(key: 'token', value: loginSuccessModel!.token);
        CacheHelper.saveData(key: 'who', value: 'Patient');
        token = loginSuccessModel!.token;
        navigateAndFinish(context, const PatientLayout());
        emit(SuccessPatientLogin());
      } else {
        // Request failed
        Map<String, dynamic> errorResponse = jsonDecode(response.body);
        errorModel = ErrorModel.fromJson(errorResponse);
        showToast(text: errorModel!.message!, state: ToastStates.WARNING);
        emit(ErrorPatientLogin());
      }
    } catch (e) {
      // An error occurred
      showToast(text: 'error $e', state: ToastStates.ERROR);
      emit(ErrorPatientLogin());
    }
  }
  // Patient Login

  // Get All Patients
  GetAllPatientsModel? getAllPatientsModel;
  Future<void> getAllPatients({required String token}) async {
    emit(LoadingGetAllPatients());

    try {
      // Make the GET request
      final response = await http.get(
        Uri.parse('$url$patients'),
        headers: {contentType: applicationJson, 'token': token},
      );

      // Check the status code of the response
      if (response.statusCode == 200) {
        // Request successful
        Map<String, dynamic> successResponse = jsonDecode(response.body);
        getAllPatientsModel = GetAllPatientsModel.fromJson(successResponse);
        emit(SuccessGetAllPatients());
      } else {
        // Request failed
        Map<String, dynamic> errorResponse = jsonDecode(response.body);
        errorModel = ErrorModel.fromJson(errorResponse);
        showToast(text: errorModel!.message!, state: ToastStates.WARNING);
        emit(ErrorGetAllPatients());
      }
    } catch (e) {
      // An error occurred
      showToast(text: 'error $e', state: ToastStates.ERROR);
      emit(ErrorGetAllPatients());
    }
  }
  // Get All Patients

  // Delete Patient
  Future<void> deletePatient(
      {required String token, required String id, required context}) async {
    emit(LoadingDeletePatient());

    try {
      // Make the DELETE request
      final response = await http.delete(
        Uri.parse('$url$patients/$id'),
        headers: {contentType: applicationJson, 'token': token},
      );

      // Check the status code of the response
      if (response.statusCode == 200) {
        // Request successful
        Map<String, dynamic> successResponse = jsonDecode(response.body);
        successModel = SuccessModel.fromJson(successResponse);
        showToast(text: successModel!.message!, state: ToastStates.SUCCESS);
        Navigator.pop(context);
        await getAllPatients(token: token);
        emit(SuccessDeletePatient());
      } else {
        // Request failed
        Map<String, dynamic> errorResponse = jsonDecode(response.body);
        errorModel = ErrorModel.fromJson(errorResponse);
        showToast(text: errorModel!.message!, state: ToastStates.WARNING);
        emit(ErrorDeletePatient());
      }
    } catch (e) {
      // An error occurred
      showToast(text: 'error $e', state: ToastStates.ERROR);
      emit(ErrorDeletePatient());
    }
  }
  // Delete Patient

  // Update Patient Account
  Future<void> updatePatientAccount({
    required String name,
    required String email,
    required String phone,
    required String address,
    required String medicalHistory,
    required String lastVisited,
    required String dateOfBirth,
    required String id,
    required String token,
    required context,
  }) async {
    emit(LoadingUpdatePatientAccount());

    // Convert the request body to JSON
    String jsonBody = jsonEncode({
      'name': name,
      'email': email,
      'phone': phone,
      'department': medicalHistory,
      'lastVisited': lastVisited,
      'dateOfBirth': dateOfBirth,
      'address': address
    });

    try {
      // Make the PUT request
      final response = await http.put(
        Uri.parse('$url$patients/$id'),
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
        emit(SuccessUpdatePatientAccount());
      } else {
        // Request failed
        Map<String, dynamic> errorResponse = jsonDecode(response.body);
        errorModel = ErrorModel.fromJson(errorResponse);
        showToast(text: errorModel!.message!, state: ToastStates.WARNING);
        emit(ErrorUpdatePatientAccount());
      }
    } catch (e) {
      // An error occurred
      showToast(text: 'error $e', state: ToastStates.ERROR);
      emit(ErrorUpdatePatientAccount());
    }
  }
  // Update Patient Account

  // Get Specific Patient
  GetSpecificPatientModel? getSpecificPatientModel;
  Future<void> getSpecificPatient(
      {required String token, required String id}) async {
    emit(LoadingGetSpecificPatient());

    try {
      // Make the GET request
      final response = await http.get(
        Uri.parse('$url$patients/$id'),
        headers: {contentType: applicationJson, 'token': token},
      );

      // Check the status code of the response
      if (response.statusCode == 200) {
        // Request successful
        Map<String, dynamic> successResponse = jsonDecode(response.body);
        getSpecificPatientModel =
            GetSpecificPatientModel.fromJson(successResponse);
        emit(SuccessGetSpecificPatient());
      } else {
        // Request failed
        Map<String, dynamic> errorResponse = jsonDecode(response.body);
        errorModel = ErrorModel.fromJson(errorResponse);
        showToast(text: errorModel!.message!, state: ToastStates.WARNING);
        emit(ErrorGetSpecificPatient());
      }
    } catch (e) {
      // An error occurred
      showToast(text: 'error $e', state: ToastStates.ERROR);
      emit(ErrorGetSpecificPatient());
    }
  }
  // Get Specific Patient

  //======================================================================
  // End patient
  //======================================================================

  //======================================================================
  // Start medication
  //======================================================================

  // Create medication
  Future<void> createmedication(
      {required String name,
      required List<String> activeIngredients,
      required List<String> doses,
      required String warnings,
      required String sideEffects,
      required String token,
      required context}) async {
    emit(LoadingCreatemedication());

    // Convert the request body to JSON
    String jsonBody = jsonEncode({
      'name': name,
      'activeIngredients': activeIngredients,
      'doses': doses,
      'warnings': warnings,
      'sideEffects': sideEffects,
    });

    try {
      // Make the POST request
      final response = await http.post(
        Uri.parse('$url$medications'),
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
        await getAllmedications(token: token);
        emit(SuccessCreatemedication());
      } else {
        // Request failed
        Map<String, dynamic> errorResponse = jsonDecode(response.body);
        errorModel = ErrorModel.fromJson(errorResponse);
        showToast(text: errorModel!.message!, state: ToastStates.WARNING);
        emit(ErrorCreatemedication());
      }
    } catch (e) {
      // An error occurred
      showToast(text: 'error $e', state: ToastStates.ERROR);
      emit(ErrorCreatemedication());
    }
  }
  // Create medication

  // Get All medications
  GetAllmedicationsModel? getAllmedicationsModel;
  Future<void> getAllmedications({required String token}) async {
    emit(LoadingGetAllmedications());

    try {
      // Make the GET request
      final response = await http.get(
        Uri.parse('$url$medications'),
        headers: {contentType: applicationJson, 'token': token},
      );

      // Check the status code of the response
      if (response.statusCode == 200) {
        // Request successful
        Map<String, dynamic> successResponse = jsonDecode(response.body);
        getAllmedicationsModel =
            GetAllmedicationsModel.fromJson(successResponse);
        emit(SuccessGetAllmedications());
      } else {
        // Request failed
        Map<String, dynamic> errorResponse = jsonDecode(response.body);
        errorModel = ErrorModel.fromJson(errorResponse);
        showToast(text: errorModel!.message!, state: ToastStates.WARNING);
        emit(ErrorGetAllmedications());
      }
    } catch (e) {
      // An error occurred
      showToast(text: 'error $e', state: ToastStates.ERROR);
      emit(ErrorGetAllmedications());
    }
  }
  // Get All medications

  // Delete medication
  Future<void> deletemedication(
      {required String token, required String id, required context}) async {
    emit(LoadingDeletemedication());

    try {
      // Make the DELETE request
      final response = await http.delete(
        Uri.parse('$url$medications/$id'),
        headers: {contentType: applicationJson, 'token': token},
      );

      // Check the status code of the response
      if (response.statusCode == 200) {
        // Request successful
        Map<String, dynamic> successResponse = jsonDecode(response.body);
        successModel = SuccessModel.fromJson(successResponse);
        showToast(text: successModel!.message!, state: ToastStates.SUCCESS);
        Navigator.pop(context);
        await getAllmedications(token: token);
        emit(SuccessDeletemedication());
      } else {
        // Request failed
        Map<String, dynamic> errorResponse = jsonDecode(response.body);
        errorModel = ErrorModel.fromJson(errorResponse);
        showToast(text: errorModel!.message!, state: ToastStates.WARNING);
        emit(ErrorDeletemedication());
      }
    } catch (e) {
      // An error occurred
      showToast(text: 'error $e', state: ToastStates.ERROR);
      emit(ErrorDeletemedication());
    }
  }
  // Delete medication

  // Update medication
  Future<void> updatemedication({
    required String name,
    required List<String> activeIngredients,
    required List<String> doses,
    required String warnings,
    required String sideEffects,
    required String id,
    required String token,
    required context,
  }) async {
    emit(LoadingUpdatemedication());

    // Convert the request body to JSON
    String jsonBody = jsonEncode({
      'name': name,
      'activeIngredients': activeIngredients,
      'doses': doses,
      'warnings': warnings,
      'sideEffects': sideEffects,
    });

    try {
      // Make the PUT request
      final response = await http.put(
        Uri.parse('$url$medications/$id'),
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
        emit(SuccessUpdatemedication());
      } else {
        // Request failed
        Map<String, dynamic> errorResponse = jsonDecode(response.body);
        errorModel = ErrorModel.fromJson(errorResponse);
        showToast(text: errorModel!.message!, state: ToastStates.WARNING);
        emit(ErrorUpdatemedication());
      }
    } catch (e) {
      // An error occurred
      showToast(text: 'error $e', state: ToastStates.ERROR);
      emit(ErrorUpdatemedication());
    }
  }
  // Update medication

  // Get Specific medication
  GetSpecificmedicationModel? getSpecificmedicationModel;
  Future<void> getSpecificmedication(
      {required String token, required String id}) async {
    emit(LoadingGetSpecificmedication());

    try {
      // Make the GET request
      final response = await http.get(
        Uri.parse('$url$medications/$id'),
        headers: {contentType: applicationJson, 'token': token},
      );

      // Check the status code of the response
      if (response.statusCode == 200) {
        // Request successful
        Map<String, dynamic> successResponse = jsonDecode(response.body);
        getSpecificmedicationModel =
            GetSpecificmedicationModel.fromJson(successResponse);
        emit(SuccessGetSpecificmedication());
      } else {
        // Request failed
        Map<String, dynamic> errorResponse = jsonDecode(response.body);
        errorModel = ErrorModel.fromJson(errorResponse);
        showToast(text: errorModel!.message!, state: ToastStates.WARNING);
        emit(ErrorGetSpecificmedication());
      }
    } catch (e) {
      // An error occurred
      showToast(text: 'error $e', state: ToastStates.ERROR);
      emit(ErrorGetSpecificmedication());
    }
  }
  // Get Specific medication

  //======================================================================
  // End medication
  //======================================================================
}
