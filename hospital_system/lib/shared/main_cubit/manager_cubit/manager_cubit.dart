import 'dart:convert';
import 'package:hospital_system/models/manager_models/get_specific_manger_model.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hospital_system/models/error_model.dart';
import 'package:hospital_system/models/success_model.dart';
import 'package:hospital_system/models/login_success_model.dart';
import 'package:hospital_system/shared/another/cache_helper.dart';
import 'package:hospital_system/shared/components/constants.dart';
import 'package:hospital_system/shared/components/end_points.dart';
import 'package:hospital_system/models/manager_models/get_all_manger_model.dart';
import 'package:hospital_system/shared/main_cubit/manager_cubit/manager_states.dart';

class ManagerCubit extends Cubit<ManagerState> {
  ManagerCubit() : super(ManagerInitial());

  static ManagerCubit get(context) => BlocProvider.of(context);

  ErrorModel? errorModel;
  SuccessModel? successModel;
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
  LoginSuccessModel? loginSuccessModel;
  Future<void> mangerLogin(
      {required String id, required String password}) async {
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
        token = loginSuccessModel!.token;
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
  Future<void> deleteManger({required String token, required String id}) async {
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
  // Create Manger Account

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
}
