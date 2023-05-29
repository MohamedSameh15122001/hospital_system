import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../shared/components/constants.dart';
import '../../shared/components/end_points.dart';
import '../../shared/main_cubit/doctor_cubit/doctor_cubit.dart';
import '../../shared/main_cubit/doctor_cubit/doctor_states.dart';

class DoctorAddDiagnosis extends StatelessWidget {
  DoctorAddDiagnosis({super.key});
  final formKey = GlobalKey<FormState>();

  final TextEditingController prescriptionController = TextEditingController();

  final TextEditingController diagnoseController = TextEditingController();

  final TextEditingController idController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<DoctorCubit, DoctorState>(
      bloc: DoctorCubit.get(context),
      listener: (context, state) {},
      builder: (context, state) {
        DoctorCubit cubit = DoctorCubit.get(context);
        return Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            title: const Text('Add Diagnose'),
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
                    const SizedBox(height: 20.0),
                    Image.asset(
                      'lib/assets/images/diagnose.png',
                      width: mediaQuery(context).width * .40,
                    ),
                    const SizedBox(height: 40.0),
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
                      controller: prescriptionController,
                      maxLines: 6,
                      decoration: InputDecoration(
                        labelText: 'Prescription',
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
                          return 'Please enter prescription';
                        } else if (value.length < 3) {
                          return 'Prescription must be between min 3 characters';
                        } else if (value.length > 1000) {
                          return 'Prescription must be between max 1000 characters';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16.0),
                    TextFormField(
                      controller: diagnoseController,
                      decoration: InputDecoration(
                        labelText: 'Diagnosis',
                        border: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: mainColor,
                            width: 2.0,
                          ),
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                      ),
                      maxLines: 6,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter diagnose';
                        } else if (value.length < 3) {
                          return 'Diagnose must be between min 3 characters';
                        } else if (value.length > 1000) {
                          return 'Diagnose must be between max 1000 characters';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),
                    state is LoadingAddDiagnosis
                        ? const Center(child: CircularProgressIndicator())
                        : ClipRRect(
                            borderRadius: BorderRadius.circular(20),
                            child: MaterialButton(
                              onPressed: () async {
                                if (formKey.currentState!.validate()) {
                                  await cubit.addDiagnosis(
                                      diagnosis: diagnoseController.text.trim(),
                                      prescription:
                                          prescriptionController.text.trim(),
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
