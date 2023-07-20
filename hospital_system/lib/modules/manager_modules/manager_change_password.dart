import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:hospital_system/shared/components/constants.dart';
import 'package:hospital_system/shared/components/end_points.dart';
import 'package:hospital_system/shared/main_cubit/manager_cubit/manager_cubit.dart';
import 'package:hospital_system/shared/main_cubit/manager_cubit/manager_states.dart';

class MangerChangePassword extends StatelessWidget {
  MangerChangePassword({super.key});
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
      body: BlocConsumer<ManagerCubit, ManagerState>(
        bloc: ManagerCubit.get(context),
        listener: (context, state) {},
        builder: (context, state) {
          ManagerCubit cubit = ManagerCubit.get(context);
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
                            obscureText: cubit.isVisibleOld,
                            controller: oldPassController,
                            decoration: InputDecoration(
                              suffixIcon: IconButton(
                                  onPressed: () {
                                    cubit.changeVisibleOldPassword();
                                  },
                                  icon: Icon(cubit.isVisibleOld
                                      ? Icons.visibility
                                      : Icons.visibility_off)),
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
                            obscureText: cubit.isVisible,
                            controller: newPassController,
                            decoration: InputDecoration(
                              suffixIcon: IconButton(
                                  onPressed: () {
                                    cubit.changeVisiblePassword();
                                  },
                                  icon: Icon(cubit.isVisible
                                      ? Icons.visibility
                                      : Icons.visibility_off)),
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
                          state is LoadingChangeMangerPassword
                              ? Center(child: loading)
                              : ClipRRect(
                                  borderRadius: BorderRadius.circular(20),
                                  child: MaterialButton(
                                    onPressed: () async {
                                      oldPassController.text =
                                          oldPassController.text.trim();
                                      newPassController.text =
                                          newPassController.text.trim();
                                      if (formKey.currentState!.validate()) {
                                        if (newPassController.text !=
                                            oldPassController.text) {
                                          cubit.changeMangerPassword(
                                            oldPassword:
                                                oldPassController.text.trim(),
                                            newPassword:
                                                newPassController.text.trim(),
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
