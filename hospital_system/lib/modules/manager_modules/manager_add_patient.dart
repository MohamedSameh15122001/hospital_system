import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hospital_system/shared/components/constants.dart';
import 'package:hospital_system/shared/components/end_points.dart';
import 'package:hospital_system/shared/main_cubit/manager_cubit/manager_cubit.dart';
import 'package:hospital_system/shared/main_cubit/manager_cubit/manager_states.dart';

class MangerAddPatient extends StatelessWidget {
  MangerAddPatient({super.key});

  final formKey = GlobalKey<FormState>();

  final TextEditingController nameController = TextEditingController();

  final TextEditingController phoneController = TextEditingController();

  final TextEditingController emailController = TextEditingController();

  final TextEditingController idController = TextEditingController();

  final TextEditingController addressController = TextEditingController();
  final TextEditingController dateOfBirthController = TextEditingController();
  final TextEditingController medicalHistoryController =
      TextEditingController();
  final TextEditingController lastVisitedController = TextEditingController();

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
            title: const Text('Add Patient'),
            centerTitle: true,
          ),
          body: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: formKey,
                child: Column(
                  children: [
                    Image.asset(
                      'lib/assets/images/patient.png',
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
                        } else if (!RegExp(r'^Pt.{6}$').hasMatch(value)) {
                          return 'ID should start with "Pt" and have a total length of 8 characters';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16.0),
                    TextFormField(
                      controller: addressController,
                      decoration: InputDecoration(
                        labelText: 'Address',
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
                          return 'Please enter address';
                        } else if (value.length < 5) {
                          return 'Address must be between min 5 characters';
                        } else if (value.length > 100) {
                          return 'Address must be between max 100 characters';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16.0),
                    TextFormField(
                      controller: medicalHistoryController,
                      decoration: InputDecoration(
                        labelText: 'Medical History',
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
                          return 'Please enter medical history';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16.0),
                    TextFormField(
                      keyboardType: TextInputType.none,
                      onTap: () async {
                        await selectDate(context, dateOfBirthController);
                        dateOfBirthController.text =
                            formatDateToGetFromDatePicker(
                                dateOfBirthController.text);
                      },
                      controller: dateOfBirthController,
                      decoration: InputDecoration(
                        labelText: 'Date Of Birth',
                        border: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: mainColor,
                            width: 2.0,
                          ),
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                      ),
                      validator: (value) {
                        final dateRegex = RegExp(r'^(\d{2})-(\d{2})-(\d{4})$');
                        if (value!.isEmpty) {
                          return 'Please enter date of birth';
                        } else if (!dateRegex.hasMatch(value)) {
                          return 'Invalid date format should be dd-mm-yyyy';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16.0),
                    TextFormField(
                      keyboardType: TextInputType.none,
                      onTap: () async {
                        await selectDate(context, lastVisitedController);
                        lastVisitedController.text =
                            formatDateToGetFromDatePicker(
                                lastVisitedController.text);
                      },
                      controller: lastVisitedController,
                      decoration: InputDecoration(
                        labelText: 'Last Visited',
                        border: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: mainColor,
                            width: 2.0,
                          ),
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                      ),
                      validator: (value) {
                        final dateRegex = RegExp(r'^(\d{2})-(\d{2})-(\d{4})$');
                        if (value!.isEmpty) {
                          return 'Please enter Last Visited';
                        } else if (!dateRegex.hasMatch(value)) {
                          return 'Invalid date format should be dd-mm-yyyy';
                        }

                        // else if () {
                        //   return 'Invalid date';
                        // }
                        // try {
                        //   DateTime.parse(value);
                        // } catch (error) {
                        //   return 'Invalid date';
                        // }

                        return null;
                      },
                    ),
                    const SizedBox(height: 20),
                    state is LoadingCreatePatientAccount
                        ? const Center(child: CircularProgressIndicator())
                        : ClipRRect(
                            borderRadius: BorderRadius.circular(20),
                            child: MaterialButton(
                              onPressed: () async {
                                if (formKey.currentState!.validate()) {
                                  await cubit.createPatientAccount(
                                      name: nameController.text.trim(),
                                      email: emailController.text.trim(),
                                      phone: phoneController.text.trim(),
                                      id: idController.text.trim(),
                                      address: addressController.text.trim(),
                                      medicalHistory:
                                          medicalHistoryController.text.trim(),
                                      dateOfBirth:
                                          dateOfBirthController.text.trim(),
                                      lastVisited:
                                          lastVisitedController.text.trim(),
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
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
