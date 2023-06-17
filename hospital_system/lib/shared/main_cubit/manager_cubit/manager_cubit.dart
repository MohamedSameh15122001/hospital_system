import 'dart:convert';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:hospital_system/models/manager_models/get_manger_profile_model.dart';
import 'package:hospital_system/models/manager_models/get_specific_medication_model.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hospital_system/models/error_model.dart';
import '../../../models/manager_models/get_all_medications_model.dart';
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
import '../../../models/manager_models/get_specific_doctor_model.dart';
import '../../../models/manager_models/get_specific_patient_model.dart';
import 'package:hospital_system/modules/doctor_modules/doctor_home.dart';
import 'package:hospital_system/modules/manager_modules/manager_home.dart';
import 'package:hospital_system/models/manager_models/get_all_nurses_model.dart';
import 'package:hospital_system/models/manager_models/get_all_mangers_model.dart';
import 'package:hospital_system/shared/main_cubit/manager_cubit/manager_states.dart';
import 'package:hospital_system/models/manager_models/get_specific_manger_model.dart';

class ManagerCubit extends Cubit<ManagerState> {
  ManagerCubit() : super(ManagerInitial());

  static ManagerCubit get(context) => BlocProvider.of(context);

  // change switch
  bool switchValue = false;
  Future<void> changeSwitch(bool newValue) async {
    switchValue = newValue;
    switchValue
        ? await getAllPatients(token: token!)
        : await getAllPatientsBelongToDoctor(token: token!);
    emit(ChangeSwitch());
  }

  // manger home page
  List<String> images = [
    'lib/assets/images/manger.png',
    'lib/assets/images/doctor.png',
    'lib/assets/images/nurse.png',
    'lib/assets/images/patient.png',
    'lib/assets/images/medication.jpg',
    'lib/assets/images/password.png',
  ];
  List<String> names = [
    'Mangers',
    'Doctors',
    'Nurses',
    'Patients',
    'Medicines',
    'Passwords',
  ];
  // manger home page

  // Change dropdownbutton
  List<String> items = ['male', 'female'];
  String sex = 'male';
  void changeDropDownButton(String newValue) {
    sex = newValue;
    emit(ChangeDropDownButton());
  }

  // Change radio
  String who = "Manger";
  void changeRadio(value) {
    who = value;
    emit(ChangeRadio());
  }

  ErrorModel? errorModel;
  SuccessModel? successModel;
  LoginSuccessModel? loginSuccessModel;

  // Change Manger Password
  Future<void> changeMangerPassword({
    required String oldPassword,
    required String newPassword,
    required String token,
    required context,
  }) async {
    emit(LoadingChangeMangerPassword());

    // Convert the request body to JSON
    String jsonBody =
        jsonEncode({'oldPassword': oldPassword, 'newPassword': newPassword});

    try {
      // Make the POST request
      final response = await http.post(
        Uri.parse('$url$mangers$profile$changePass'),
        headers: {contentType: applicationJson, 'token': token},
        body: jsonBody,
      );

      // Check the status code of the response
      if (response.statusCode == 200) {
        // Request successful
        Map<String, dynamic> successResponse = jsonDecode(response.body);
        successModel = SuccessModel.fromJson(successResponse);
        showToast(text: successModel!.message!, state: ToastStates.SUCCESS);
        await signOut(context);
        emit(SuccessChangeMangerPassword());
      } else {
        // Request failed
        Map<String, dynamic> errorResponse = jsonDecode(response.body);
        errorModel = ErrorModel.fromJson(errorResponse);
        showToast(text: errorModel!.message!, state: ToastStates.WARNING);
        emit(ErrorChangeMangerPassword());
      }
    } catch (e) {
      // An error occurred
      // showToast(text: 'error $e', state: ToastStates.ERROR);
      emit(ErrorChangeMangerPassword());
    }
  }
  // Create Manger Account

  // get manger profile
  GetMangerProfileModel? getMangerProfileModel;
  Future<void> getMangerProfile({
    required String token,
  }) async {
    emit(LoadingGetMangerProfile());
    try {
      // Make the GET request
      final response = await http.get(
        Uri.parse('$url$mangers$profile'),
        headers: {contentType: applicationJson, 'token': token},
      );

      // Check the status code of the response
      if (response.statusCode == 200) {
        // Request successful
        Map<String, dynamic> successResponse = jsonDecode(response.body);
        getMangerProfileModel = GetMangerProfileModel.fromJson(successResponse);

        emit(SuccessGetMangerProfile());
      } else {
        // Request failed
        Map<String, dynamic> errorResponse = jsonDecode(response.body);
        errorModel = ErrorModel.fromJson(errorResponse);
        showToast(text: errorModel!.message!, state: ToastStates.WARNING);
        emit(ErrorGetMangerProfile());
      }
    } catch (e) {
      // An error occurred
      // showToast(text: 'error $e', state: ToastStates.ERROR);
      emit(ErrorGetMangerProfile());
    }
  }
  // get manger profile

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
      // showToast(text: 'error $e', state: ToastStates.ERROR);
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
        await CacheHelper.saveData(
            key: 'token', value: loginSuccessModel!.token);
        await CacheHelper.saveData(key: 'who', value: 'manger');
        token = loginSuccessModel!.token;
        navigateAndFinishWithFade(context, const MangerHome());
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
      // showToast(text: 'error $e', state: ToastStates.ERROR);
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
      // showToast(text: 'error $e', state: ToastStates.ERROR);
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
      // showToast(text: 'error $e', state: ToastStates.ERROR);
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
      // showToast(text: 'error $e', state: ToastStates.ERROR);
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
      // showToast(text: 'error $e', state: ToastStates.ERROR);
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
      // showToast(text: 'error $e', state: ToastStates.ERROR);
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
        await CacheHelper.saveData(
            key: 'token', value: loginSuccessModel!.token);
        await CacheHelper.saveData(key: 'who', value: 'doctor');
        token = loginSuccessModel!.token;
        navigateAndFinishWithFade(context, const DoctorHome());
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
      // showToast(text: 'error $e', state: ToastStates.ERROR);
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
      // showToast(text: 'error $e', state: ToastStates.ERROR);
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
      // showToast(text: 'error $e', state: ToastStates.ERROR);
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
      // showToast(text: 'error $e', state: ToastStates.ERROR);
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
      // showToast(text: 'error $e', state: ToastStates.ERROR);
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
      // showToast(text: 'error $e', state: ToastStates.ERROR);
      emit(ErrorCreateNurseAccount());
    }
  }
  // Create Nurse Account

  // Nurse Login
  Future<void> nurseLogin(
      {required String id, required String password, required context}) async {
    emit(LoadingNurseLogin());

    String? fcmToken = await FirebaseMessaging.instance.getToken();
    // Convert the request body to JSON
    String jsonBody =
        jsonEncode({'Id': id, 'password': password, 'fcmToken': fcmToken});

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
        await CacheHelper.saveData(
            key: 'token', value: loginSuccessModel!.token);
        await CacheHelper.saveData(key: 'who', value: 'nurse');
        token = loginSuccessModel!.token;
        navigateAndFinishWithFade(context, const NurseLayout());
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
      // showToast(text: 'error $e', state: ToastStates.ERROR);
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
      // showToast(text: 'error $e', state: ToastStates.ERROR);
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
      // showToast(text: 'error $e', state: ToastStates.ERROR);
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
      // showToast(text: 'error $e', state: ToastStates.ERROR);
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
      // showToast(text: 'error $e', state: ToastStates.ERROR);
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
      required String medicalHistory,
      required String dateOfBirth,
      required String lastVisited,
      required String sex,
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
      'sex': sex
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
      // showToast(text: 'error $e', state: ToastStates.ERROR);
      emit(ErrorCreatePatientAccount());
    }
  }
  // Create Patient Account

  // Patient Login
  Future<void> patientLogin(
      {required String id, required String password, required context}) async {
    emit(LoadingPatientLogin());
    String? fcmToken = await FirebaseMessaging.instance.getToken();
    // Convert the request body to JSON
    String jsonBody =
        jsonEncode({'Id': id, 'password': password, 'fcmToken': fcmToken});

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
        await CacheHelper.saveData(
            key: 'token', value: loginSuccessModel!.token);
        await CacheHelper.saveData(key: 'who', value: 'patient');
        token = loginSuccessModel!.token;
        navigateAndFinishWithFade(context, const PatientLayout());
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
      // showToast(text: 'error $e', state: ToastStates.ERROR);
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
      // showToast(text: 'error $e', state: ToastStates.ERROR);
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
      // showToast(text: 'error $e', state: ToastStates.ERROR);
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
      'medicalHistory': medicalHistory,
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
        await getAllPatients(token: token);
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
      // showToast(text: 'error $e', state: ToastStates.ERROR);
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
      // showToast(text: 'error $e', state: ToastStates.ERROR);
      emit(ErrorGetSpecificPatient());
    }
  }
  // Get Specific Patient

  //======================================================================
  // End patient
  //======================================================================

  //======================================================================
  // Start Medication
  //======================================================================

  // Create Medication
  Future<void> createMedication(
      {required String name,
      required String activeIngredients,
      required String doses,
      required String warnings,
      required String sideEffects,
      required String token,
      required context}) async {
    emit(LoadingCreateMedication());

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
        await getAllMedications(token: token);
        emit(SuccessCreateMedication());
      } else {
        // Request failed
        Map<String, dynamic> errorResponse = jsonDecode(response.body);
        errorModel = ErrorModel.fromJson(errorResponse);

        showToast(text: errorModel!.message!, state: ToastStates.WARNING);
        emit(ErrorCreateMedication());
      }
    } catch (e) {
      // An error occurred
      // showToast(text: 'error $e', state: ToastStates.ERROR);
      emit(ErrorCreateMedication());
    }
  }
  // Create Medication

  // Get All Medications
  GetAllMedicationsModel? getAllMedicationsModel;
  List med = [];
  Future<void> getAllMedications({required String token}) async {
    emit(LoadingGetAllMedications());
    med = [];
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
        getAllMedicationsModel =
            GetAllMedicationsModel.fromJson(successResponse);
        for (var element in getAllMedicationsModel!.result!) {
          med.add('${element.name}:\n${element.doses}');
        }

        emit(SuccessGetAllMedications());
      } else {
        // Request failed
        Map<String, dynamic> errorResponse = jsonDecode(response.body);
        errorModel = ErrorModel.fromJson(errorResponse);
        showToast(text: errorModel!.message!, state: ToastStates.WARNING);
        emit(ErrorGetAllMedications());
      }
    } catch (e) {
      // An error occurred
      // showToast(text: 'error $e', state: ToastStates.ERROR);
      emit(ErrorGetAllMedications());
    }
  }
  // Get All Medications

  // Delete Medication
  Future<void> deleteMedication(
      {required String token, required String id, required context}) async {
    emit(LoadingDeleteMedication());

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
        await getAllMedications(token: token);
        emit(SuccessDeleteMedication());
      } else {
        // Request failed
        Map<String, dynamic> errorResponse = jsonDecode(response.body);
        errorModel = ErrorModel.fromJson(errorResponse);
        showToast(text: errorModel!.message!, state: ToastStates.WARNING);
        emit(ErrorDeleteMedication());
      }
    } catch (e) {
      // An error occurred
      // showToast(text: 'error $e', state: ToastStates.ERROR);
      emit(ErrorDeleteMedication());
    }
  }
  // Delete Medication

  // Update Medication
  Future<void> updateMedication({
    required String name,
    required String activeIngredients,
    required String doses,
    required String warnings,
    required String sideEffects,
    required String id,
    required String token,
    required context,
  }) async {
    emit(LoadingUpdateMedication());

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
        await getAllMedications(token: token);
        emit(SuccessUpdateMedication());
      } else {
        // Request failed
        Map<String, dynamic> errorResponse = jsonDecode(response.body);
        errorModel = ErrorModel.fromJson(errorResponse);
        showToast(text: errorModel!.message!, state: ToastStates.WARNING);
        emit(ErrorUpdateMedication());
      }
    } catch (e) {
      // An error occurred
      // showToast(text: 'error $e', state: ToastStates.ERROR);
      emit(ErrorUpdateMedication());
    }
  }
  // Update Medication

  // Get Specific Medication
  GetSpecificMedicationModel? getSpecificMedicationModel;
  Future<void> getSpecificMedication(
      {required String token, required String id}) async {
    emit(LoadingGetSpecificMedication());

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
        getSpecificMedicationModel =
            GetSpecificMedicationModel.fromJson(successResponse);
        emit(SuccessGetSpecificMedication());
      } else {
        // Request failed
        Map<String, dynamic> errorResponse = jsonDecode(response.body);
        errorModel = ErrorModel.fromJson(errorResponse);
        showToast(text: errorModel!.message!, state: ToastStates.WARNING);
        emit(ErrorGetSpecificMedication());
      }
    } catch (e) {
      // An error occurred
      // showToast(text: 'error $e', state: ToastStates.ERROR);
      emit(ErrorGetSpecificMedication());
    }
  }
  // Get Specific Medication

  //======================================================================
  // End Medication
  //======================================================================

  //======================================================================
  // Search
  //======================================================================
  // Search Mangers
  GetAllMangersModel? searchGetAllMangersModel;
  Future<void> searchMangers(
      {required String token, required String input}) async {
    emit(LoadingSearchMangers());

    try {
      // Make the GET request
      final response = await http.get(
        Uri.parse('$url$mangers/?keyword=$input'),
        headers: {contentType: applicationJson, 'token': token},
      );

      // Check the status code of the response
      if (response.statusCode == 200) {
        // Request successful
        Map<String, dynamic> successResponse = jsonDecode(response.body);
        searchGetAllMangersModel = GetAllMangersModel.fromJson(successResponse);
        emit(SuccessSearchMangers());
      } else {
        // Request failed
        Map<String, dynamic> errorResponse = jsonDecode(response.body);
        errorModel = ErrorModel.fromJson(errorResponse);
        showToast(text: errorModel!.message!, state: ToastStates.WARNING);
        emit(ErrorSearchMangers());
      }
    } catch (e) {
      // An error occurred
      // showToast(text: 'error $e', state: ToastStates.ERROR);
      emit(ErrorSearchMangers());
    }
  }
  // Search Mangers

  // Search Doctors
  GetAllDoctorsModel? searchGetAllDoctorsModel;
  Future<void> searchDoctors(
      {required String token, required String input}) async {
    emit(LoadingSearchDoctors());

    try {
      // Make the GET request
      final response = await http.get(
        Uri.parse('$url$doctors/?keyword=$input'),
        headers: {contentType: applicationJson, 'token': token},
      );

      // Check the status code of the response
      if (response.statusCode == 200) {
        // Request successful
        Map<String, dynamic> successResponse = jsonDecode(response.body);
        searchGetAllDoctorsModel = GetAllDoctorsModel.fromJson(successResponse);
        emit(SuccessSearchDoctors());
      } else {
        // Request failed
        Map<String, dynamic> errorResponse = jsonDecode(response.body);
        errorModel = ErrorModel.fromJson(errorResponse);
        showToast(text: errorModel!.message!, state: ToastStates.WARNING);
        emit(ErrorSearchDoctors());
      }
    } catch (e) {
      // An error occurred
      // showToast(text: 'error $e', state: ToastStates.ERROR);
      emit(ErrorSearchDoctors());
    }
  }
  // Search Doctors

  // Search Nurses
  GetAllNursesModel? searchGetAllNursesModel;
  Future<void> searchNurses(
      {required String token, required String input}) async {
    emit(LoadingSearchNurses());

    try {
      // Make the GET request
      final response = await http.get(
        Uri.parse('$url$nurses/?keyword=$input'),
        headers: {contentType: applicationJson, 'token': token},
      );

      // Check the status code of the response
      if (response.statusCode == 200) {
        // Request successful
        Map<String, dynamic> successResponse = jsonDecode(response.body);
        searchGetAllNursesModel = GetAllNursesModel.fromJson(successResponse);
        emit(SuccessSearchNurses());
      } else {
        // Request failed
        Map<String, dynamic> errorResponse = jsonDecode(response.body);
        errorModel = ErrorModel.fromJson(errorResponse);
        showToast(text: errorModel!.message!, state: ToastStates.WARNING);
        emit(ErrorSearchNurses());
      }
    } catch (e) {
      // An error occurred
      // showToast(text: 'error $e', state: ToastStates.ERROR);
      emit(ErrorSearchNurses());
    }
  }
  // Search Nurses

  // Search Patients
  GetAllPatientsModel? searchGetAllPatientsModel;
  Future<void> searchPatients(
      {required String token, required String input}) async {
    emit(LoadingSearchPatients());

    try {
      // Make the GET request
      final response = await http.get(
        Uri.parse('$url$patients/?keyword=$input'),
        headers: {contentType: applicationJson, 'token': token},
      );

      // Check the status code of the response
      if (response.statusCode == 200) {
        // Request successful
        Map<String, dynamic> successResponse = jsonDecode(response.body);
        searchGetAllPatientsModel =
            GetAllPatientsModel.fromJson(successResponse);
        emit(SuccessSearchPatients());
      } else {
        // Request failed
        Map<String, dynamic> errorResponse = jsonDecode(response.body);
        errorModel = ErrorModel.fromJson(errorResponse);
        showToast(text: errorModel!.message!, state: ToastStates.WARNING);
        emit(ErrorSearchPatients());
      }
    } catch (e) {
      // An error occurred
      // showToast(text: 'error $e', state: ToastStates.ERROR);
      emit(ErrorSearchPatients());
    }
  }
  // Search Patients

  // Search Medications
  GetAllMedicationsModel? searchGetAllMedicationsModel;
  Future<void> searchMedications(
      {required String token, required String input}) async {
    emit(LoadingSearchMedications());

    try {
      // Make the GET request
      final response = await http.get(
        Uri.parse('$url$medications/?keyword=$input'),
        headers: {contentType: applicationJson, 'token': token},
      );

      // Check the status code of the response
      if (response.statusCode == 200) {
        // Request successful
        Map<String, dynamic> successResponse = jsonDecode(response.body);
        searchGetAllMedicationsModel =
            GetAllMedicationsModel.fromJson(successResponse);
        emit(SuccessSearchMedications());
      } else {
        // Request failed
        Map<String, dynamic> errorResponse = jsonDecode(response.body);
        errorModel = ErrorModel.fromJson(errorResponse);
        showToast(text: errorModel!.message!, state: ToastStates.WARNING);
        emit(ErrorSearchMedications());
      }
    } catch (e) {
      // An error occurred
      // showToast(text: 'error $e', state: ToastStates.ERROR);
      emit(ErrorSearchMedications());
    }
  }
  // Search Medications
  //======================================================================
  // Search
  //======================================================================

  //======================================================================
  // Set Password Default
  //======================================================================

  // Set Manger Password Default
  Future<void> setMangerPasswordDefault(
      {required String token, required String id, required context}) async {
    emit(LoadingSetMangerPasswordDefault());

    try {
      // Make the GET request
      final response = await http.get(
        Uri.parse('$url$mangers$defaultPassword/$id'),
        headers: {contentType: applicationJson, 'token': token},
      );

      // Check the status code of the response
      if (response.statusCode == 200) {
        // Request successful
        Map<String, dynamic> successResponse = jsonDecode(response.body);
        successModel = SuccessModel.fromJson(successResponse);
        showToast(text: successModel!.message!, state: ToastStates.SUCCESS);
        Navigator.pop(context);
        emit(SuccessSetMangerPasswordDefault());
      } else {
        // Request failed
        Map<String, dynamic> errorResponse = jsonDecode(response.body);
        errorModel = ErrorModel.fromJson(errorResponse);
        showToast(text: errorModel!.message!, state: ToastStates.WARNING);
        emit(ErrorSetMangerPasswordDefault());
      }
    } catch (e) {
      // An error occurred
      // showToast(text: 'error $e', state: ToastStates.ERROR);
      emit(ErrorSetMangerPasswordDefault());
    }
  }
  // Set Manger Password Default

  // Set Doctor Password Default
  Future<void> setDoctorPasswordDefault(
      {required String token, required String id, required context}) async {
    emit(LoadingSetDoctorPasswordDefault());

    try {
      // Make the GET request
      final response = await http.get(
        Uri.parse('$url$doctors$defaultPassword/$id'),
        headers: {contentType: applicationJson, 'token': token},
      );

      // Check the status code of the response
      if (response.statusCode == 200) {
        // Request successful
        Map<String, dynamic> successResponse = jsonDecode(response.body);
        successModel = SuccessModel.fromJson(successResponse);
        showToast(text: successModel!.message!, state: ToastStates.SUCCESS);
        Navigator.pop(context);
        emit(SuccessSetDoctorPasswordDefault());
      } else {
        // Request failed
        Map<String, dynamic> errorResponse = jsonDecode(response.body);
        errorModel = ErrorModel.fromJson(errorResponse);
        showToast(text: errorModel!.message!, state: ToastStates.WARNING);
        emit(ErrorSetDoctorPasswordDefault());
      }
    } catch (e) {
      // An error occurred
      // showToast(text: 'error $e', state: ToastStates.ERROR);
      emit(ErrorSetDoctorPasswordDefault());
    }
  }
  // Set Doctor Password Default

  // Set Nurse Password Default
  Future<void> setNursePasswordDefault(
      {required String token, required String id, required context}) async {
    emit(LoadingSetNursePasswordDefault());

    try {
      // Make the GET request
      final response = await http.get(
        Uri.parse('$url$nurses$defaultPassword/$id'),
        headers: {contentType: applicationJson, 'token': token},
      );

      // Check the status code of the response
      if (response.statusCode == 200) {
        // Request successful
        Map<String, dynamic> successResponse = jsonDecode(response.body);
        successModel = SuccessModel.fromJson(successResponse);
        showToast(text: successModel!.message!, state: ToastStates.SUCCESS);
        Navigator.pop(context);
        emit(SuccessSetNursePasswordDefault());
      } else {
        // Request failed
        Map<String, dynamic> errorResponse = jsonDecode(response.body);
        errorModel = ErrorModel.fromJson(errorResponse);
        showToast(text: errorModel!.message!, state: ToastStates.WARNING);
        emit(ErrorSetNursePasswordDefault());
      }
    } catch (e) {
      // An error occurred
      // showToast(text: 'error $e', state: ToastStates.ERROR);
      emit(ErrorSetNursePasswordDefault());
    }
  }
  // Set Nurse Password Default

  // Set Patient Password Default
  Future<void> setPatientPasswordDefault(
      {required String token, required String id, required context}) async {
    emit(LoadingSetPatientPasswordDefault());

    try {
      // Make the GET request
      final response = await http.get(
        Uri.parse('$url$patients$defaultPassword/$id'),
        headers: {contentType: applicationJson, 'token': token},
      );

      // Check the status code of the response
      if (response.statusCode == 200) {
        // Request successful
        Map<String, dynamic> successResponse = jsonDecode(response.body);
        successModel = SuccessModel.fromJson(successResponse);
        showToast(text: successModel!.message!, state: ToastStates.SUCCESS);
        Navigator.pop(context);
        emit(SuccessSetPatientPasswordDefault());
      } else {
        // Request failed
        Map<String, dynamic> errorResponse = jsonDecode(response.body);
        errorModel = ErrorModel.fromJson(errorResponse);
        showToast(text: errorModel!.message!, state: ToastStates.WARNING);
        emit(ErrorSetPatientPasswordDefault());
      }
    } catch (e) {
      // An error occurred
      // showToast(text: 'error $e', state: ToastStates.ERROR);
      emit(ErrorSetPatientPasswordDefault());
    }
  }
  // Set Patient Password Default

  //======================================================================
  // Set Password Default
  //======================================================================

  // get all Patients belong to doctor
  GetAllPatientsModel? getAllPatientsBelongToDoctorModel;
  Future<void> getAllPatientsBelongToDoctor({required String token}) async {
    emit(LoadingGetAllPatientsBelongToDoctor());

    try {
      // Make the GET request
      final response = await http.get(
        Uri.parse('$url$patients$belongsDoctor'),
        headers: {contentType: applicationJson, 'token': token},
      );

      // Check the status code of the response
      if (response.statusCode == 200) {
        // Request successful
        Map<String, dynamic> successResponse = jsonDecode(response.body);
        getAllPatientsBelongToDoctorModel =
            GetAllPatientsModel.fromJson(successResponse);
        emit(SuccessGetAllPatientsBelongToDoctor());
      } else {
        // Request failed
        Map<String, dynamic> errorResponse = jsonDecode(response.body);
        errorModel = ErrorModel.fromJson(errorResponse);
        showToast(text: errorModel!.message!, state: ToastStates.WARNING);
        emit(ErrorGetAllPatientsBelongToDoctor());
      }
    } catch (e) {
      // An error occurred
      // showToast(text: 'error $e', state: ToastStates.ERROR);
      emit(ErrorGetAllPatientsBelongToDoctor());
    }
  }
  // get all Patients belong to doctor
}
