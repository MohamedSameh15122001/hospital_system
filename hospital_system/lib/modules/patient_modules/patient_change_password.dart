import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:hospital_system/shared/components/constants.dart';
import 'package:hospital_system/shared/components/end_points.dart';
import 'package:hospital_system/shared/main_cubit/patient_cubit/patient_cubit.dart';
import 'package:hospital_system/shared/main_cubit/patient_cubit/patient_states.dart';

class PatientChangePassword extends StatelessWidget {
  PatientChangePassword({super.key});
  final formKey = GlobalKey<FormState>();
  final TextEditingController oldPassController = TextEditingController();
  final TextEditingController newPassController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text('Change Password'),
        centerTitle: true,
      ),
      body: BlocConsumer<PatientCubit, PatientState>(
        bloc: PatientCubit.get(context),
        listener: (context, state) {},
        builder: (context, state) {
          PatientCubit cubit = PatientCubit.get(context);
          return SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: formKey,
                child: AnimationLimiter(
                  child: Column(
                      // mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: AnimationConfiguration.toStaggeredList(
                        duration: const Duration(milliseconds: 500),
                        childAnimationBuilder: (widget) => FlipAnimation(
                          child: FadeInAnimation(
                            child: widget,
                          ),
                        ),
                        children: [
                          const SizedBox(height: 60.0),
                          Image.asset(
                            'lib/assets/images/change_password.png',
                            width: mediaQuery(context).width * .80,
                          ),
                          const SizedBox(height: 40.0),
                          TextFormField(
                            controller: oldPassController,
                            decoration: InputDecoration(
                              labelText: 'Old Password',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20.0),
                              ),
                            ),
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Please enter old password';
                              }
                              RegExp regex =
                                  RegExp(r'^(?=.*[a-zA-Z])(?=.*\d).{8,}$');
                              if (!regex.hasMatch(value)) {
                                return 'Password must contain at least one letter, one digit, and be at least 8 characters long';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 16.0),
                          TextFormField(
                            controller: newPassController,
                            decoration: InputDecoration(
                              labelText: 'New Password',
                              border: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: mainColor,
                                  width: 2.0,
                                ),
                                borderRadius: BorderRadius.circular(20.0),
                              ),
                            ),
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Please enter new password';
                              }
                              RegExp regex =
                                  RegExp(r'^(?=.*[a-zA-Z])(?=.*\d).{8,}$');
                              if (!regex.hasMatch(value)) {
                                return 'Password must contain at least one letter, one digit, and be at least 8 characters long';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 20.0),
                          state is LoadingChangePatientPassword
                              ? Center(child: loading)
                              : ClipRRect(
                                  borderRadius: BorderRadius.circular(20),
                                  child: MaterialButton(
                                    onPressed: () async {
                                      if (formKey.currentState!.validate()) {
                                        if (newPassController.text ==
                                            oldPassController.text) {
                                          cubit.changePatientPassword(
                                            oldPassword: oldPassController.text,
                                            newPassword: newPassController.text,
                                            token: token!,
                                            context: context,
                                          );
                                        } else {
                                          showToast(
                                              text:
                                                  'new and old password is the same',
                                              state: ToastStates.WARNING);
                                        }
                                      }
                                    },
                                    color: mainColor,
                                    minWidth: mediaQuery(context).width,
                                    height: 50,
                                    child: const Text(
                                      'CHANGE',
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ),
                        ],
                      )),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
