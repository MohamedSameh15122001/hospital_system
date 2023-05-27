import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hospital_system/shared/components/constants.dart';
import 'package:hospital_system/shared/components/end_points.dart';
import 'package:hospital_system/shared/main_cubit/manager_cubit/manager_cubit.dart';
import 'package:hospital_system/shared/main_cubit/manager_cubit/manager_states.dart';

class MangerAddMedication extends StatelessWidget {
  MangerAddMedication({super.key});

  final formKey = GlobalKey<FormState>();

  final TextEditingController nameController = TextEditingController();

  final TextEditingController activeIngredientsController =
      TextEditingController();

  final TextEditingController dosesController = TextEditingController();

  final TextEditingController sideEffectsController = TextEditingController();

  final TextEditingController warningsController = TextEditingController();

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
            title: const Text('Add Medication'),
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
                    // Image.asset(
                    //   'lib/assets/images/medication.jpg',
                    //   width: mediaQuery(context).width * .70,
                    // ),
                    const CircleAvatar(
                      radius: 100,
                      backgroundImage:
                          AssetImage('lib/assets/images/medication.jpg'),
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
                      controller: activeIngredientsController,
                      decoration: InputDecoration(
                        labelText: 'Active Ingredients',
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
                          return 'Please enter active ingredients';
                        } else if (value.length < 3) {
                          return 'Active ingredients must be between min 3 characters';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16.0),
                    TextFormField(
                      controller: dosesController,
                      decoration: InputDecoration(
                        labelText: 'Doses',
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
                          return 'Please enter doses';
                        } else if (value.length < 3) {
                          return 'Doses must be between min 3 characters';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16.0),
                    TextFormField(
                      controller: warningsController,
                      decoration: InputDecoration(
                        labelText: 'Warnings',
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
                          return 'Please enter warnings';
                        } else if (value.length < 3) {
                          return 'Warnings must be between min 3 characters';
                        } else if (value.length > 1000) {
                          return 'Warnings must be between max 1000 characters';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16.0),
                    TextFormField(
                      controller: sideEffectsController,
                      decoration: InputDecoration(
                        labelText: 'Side Effects',
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
                          return 'Please enter side effects';
                        } else if (value.length < 3) {
                          return 'Side Effects must be between min 3 characters';
                        } else if (value.length > 1000) {
                          return 'Side Effects must be between max 1000 characters';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),
                    state is LoadingCreateMedication
                        ? const Center(child: CircularProgressIndicator())
                        : ClipRRect(
                            borderRadius: BorderRadius.circular(20),
                            child: MaterialButton(
                              onPressed: () async {
                                if (formKey.currentState!.validate()) {
                                  await cubit.createMedication(
                                      name: nameController.text.trim(),
                                      activeIngredients:
                                          activeIngredientsController.text
                                              .trim(),
                                      doses: dosesController.text.trim(),
                                      sideEffects:
                                          sideEffectsController.text.trim(),
                                      warnings: warningsController.text.trim(),
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
