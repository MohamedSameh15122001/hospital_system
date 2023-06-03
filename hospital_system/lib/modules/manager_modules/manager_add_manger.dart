import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:hospital_system/shared/components/constants.dart';
import 'package:hospital_system/shared/components/end_points.dart';

import '../../shared/main_cubit/manager_cubit/manager_cubit.dart';
import '../../shared/main_cubit/manager_cubit/manager_states.dart';

class MangerAddManger extends StatelessWidget {
  MangerAddManger({super.key});
  final formKey = GlobalKey<FormState>();

  final TextEditingController nameController = TextEditingController();

  final TextEditingController phoneController = TextEditingController();

  final TextEditingController emailController = TextEditingController();

  final TextEditingController idController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ManagerCubit, ManagerState>(
      bloc: ManagerCubit.get(context),
      listener: (context, state) {},
      builder: (context, state) {
        ManagerCubit cubit = ManagerCubit.get(context);
        return Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            title: const Text('Add Manger'),
            centerTitle: true,
          ),
          body: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: formKey,
                child: AnimationLimiter(
                  child: Column(
                    children: AnimationConfiguration.toStaggeredList(
                        duration: const Duration(milliseconds: 500),
                        childAnimationBuilder: (widget) => FlipAnimation(
                              // curve: Curves.fastLinearToSlowEaseIn,
                              child: FadeInAnimation(
                                // curve: Curves.fastLinearToSlowEaseIn,
                                child: widget,
                              ),
                            ),
                        children: [
                          const SizedBox(height: 60.0),
                          Image.asset(
                            'lib/assets/images/manger.png',
                            width: mediaQuery(context).width * .70,
                          ),
                          const SizedBox(height: 40.0),
                          TextFormField(
                            controller: nameController,
                            decoration: InputDecoration(
                              labelText: 'Name',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20.0),
                              ),
                            ),
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Please enter name';
                              } else if (value.length < 3) {
                                return 'Name must be between min 3 characters';
                              } else if (value.length > 30) {
                                return 'Name must be between max 30 characters';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 16.0),
                          TextFormField(
                            keyboardType: TextInputType.emailAddress,
                            controller: emailController,
                            decoration: InputDecoration(
                              labelText: 'Email',
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
                                return 'Please enter email';
                              } else if (isValidEmail(value.toString()) ==
                                  false) {
                                return 'Email format is incorrect';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 16.0),
                          TextFormField(
                            keyboardType: TextInputType.phone,
                            controller: phoneController,
                            decoration: InputDecoration(
                              labelText: 'Phone',
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
                                return 'Please enter phone';
                              } else if (!RegExp(r'^[0-9]+$').hasMatch(value)) {
                                return 'Invalid phone number. Please enter only numeric digits';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 16.0),
                          TextFormField(
                            controller: idController,
                            decoration: InputDecoration(
                              labelText: 'ID',
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
                                return 'Please enter ID';
                              } else if (!RegExp(r'^Mr.{6}$').hasMatch(value)) {
                                return 'ID should start with "Mr" and have a total length of 8 characters';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 20),
                          state is LoadingCreateMangerAccount
                              ? const Center(child: CircularProgressIndicator())
                              : ClipRRect(
                                  borderRadius: BorderRadius.circular(20),
                                  child: MaterialButton(
                                    onPressed: () async {
                                      if (formKey.currentState!.validate()) {
                                        await cubit.createMangerAccount(
                                            name: nameController.text.trim(),
                                            email: emailController.text.trim(),
                                            phone: phoneController.text.trim(),
                                            id: idController.text.trim(),
                                            token: token!,
                                            context: context);
                                      }
                                    },
                                    color: mainColor,
                                    minWidth: mediaQuery(context).width,
                                    height: 50,
                                    child: const Text(
                                      'ADD',
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ),
                        ]),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
