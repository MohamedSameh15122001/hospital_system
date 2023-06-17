import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:hospital_system/shared/components/constants.dart';
import 'package:hospital_system/shared/components/end_points.dart';
import 'package:hospital_system/shared/main_cubit/manager_cubit/manager_cubit.dart';
import 'package:hospital_system/shared/main_cubit/manager_cubit/manager_states.dart';

class MangerAddDoctor extends StatelessWidget {
  MangerAddDoctor({super.key});
  final formKey = GlobalKey<FormState>();

  final TextEditingController nameController = TextEditingController();

  final TextEditingController phoneController = TextEditingController();

  final TextEditingController emailController = TextEditingController();

  final TextEditingController idController = TextEditingController();

  final TextEditingController specialtyController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ManagerCubit, ManagerState>(
      bloc: ManagerCubit.get(context),
      listener: (context, state) {},
      builder: (context, state) {
        internetConection('manger', context);
        ManagerCubit cubit = ManagerCubit.get(context);
        return Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            title: const Text('Add Doctor'),
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
                      child: FadeInAnimation(
                        child: widget,
                      ),
                    ),
                    children: [
                      const SizedBox(height: 40.0),
                      Image.asset(
                        'lib/assets/images/doctor.png',
                        width: mediaQuery(context).width * .60,
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
                          } else if (isValidEmail(value.toString()) == false) {
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
                          } else if (!RegExp(r'^Dr.{6}$').hasMatch(value)) {
                            return 'ID should start with "Dr" and have a total length of 8 characters';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16.0),
                      TextFormField(
                        controller: specialtyController,
                        decoration: InputDecoration(
                          labelText: 'Specialty',
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
                            return 'Please enter specialty';
                          } else if (value.length < 3) {
                            return 'Specialty must be between min 3 characters';
                          } else if (value.length > 30) {
                            return 'Specialty must be between max 30 characters';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 20),
                      state is LoadingCreateDoctorAccount
                          ? Center(child: loading)
                          : ClipRRect(
                              borderRadius: BorderRadius.circular(20),
                              child: MaterialButton(
                                onPressed: () async {
                                  idController.text = idController.text.trim();
                                  nameController.text =
                                      nameController.text.trim();
                                  emailController.text =
                                      emailController.text.trim();
                                  phoneController.text =
                                      phoneController.text.trim();
                                  specialtyController.text =
                                      specialtyController.text.trim();
                                  if (formKey.currentState!.validate()) {
                                    await cubit.createDoctorAccount(
                                        name: nameController.text.trim(),
                                        email: emailController.text.trim(),
                                        phone: phoneController.text.trim(),
                                        id: idController.text.trim(),
                                        specialty:
                                            specialtyController.text.trim(),
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
                    ],
                  )),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
