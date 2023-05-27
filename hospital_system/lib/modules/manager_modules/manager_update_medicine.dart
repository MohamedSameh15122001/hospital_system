// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hospital_system/shared/components/constants.dart';
import 'package:hospital_system/shared/components/end_points.dart';

import '../../shared/main_cubit/manager_cubit/manager_cubit.dart';
import '../../shared/main_cubit/manager_cubit/manager_states.dart';

class MangerUpdateMedication extends StatefulWidget {
  const MangerUpdateMedication({
    Key? key,
    required this.id,
  }) : super(key: key);
  final String id;

  @override
  State<MangerUpdateMedication> createState() => _MangerUpdateMedicationState();
}

class _MangerUpdateMedicationState extends State<MangerUpdateMedication> {
  final formKey = GlobalKey<FormState>();

  TextEditingController nameController = TextEditingController();

  final TextEditingController activeIngredientsController =
      TextEditingController();

  final TextEditingController dosesController = TextEditingController();

  final TextEditingController sideEffectsController = TextEditingController();

  final TextEditingController warningsController = TextEditingController();
  @override
  void initState() {
    super.initState();

    ManagerCubit cubit = ManagerCubit.get(context);

    cubit.getSpecificMedication(token: token!, id: widget.id).then((value) {
      var model = cubit.getSpecificMedicationModel!.result;
      nameController.text = model!.name!;
      activeIngredientsController.text = model.activeIngredients!;
      dosesController.text = model.doses!;
      sideEffectsController.text = model.sideEffects!;
      warningsController.text = model.warnings!;
    });
  }

  @override
  void dispose() {
    nameController.dispose();
    activeIngredientsController.dispose();
    dosesController.dispose();
    sideEffectsController.dispose();
    warningsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext lcontext) {
    return BlocConsumer<ManagerCubit, ManagerState>(
      bloc: ManagerCubit.get(context),
      listener: (context, state) {},
      builder: (context, state) {
        ManagerCubit cubit = ManagerCubit.get(context);
        return Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            title: const Text('Update Medication'),
            centerTitle: true,
            actions: [
              IconButton(
                onPressed: () async {
                  showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: const Text(
                          'are you sure to delete the medication!',
                          style: TextStyle(
                            fontSize: 16,
                          ),
                        ),
                        actions: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(20),
                                child: MaterialButton(
                                  onPressed: () async {
                                    Navigator.pop(context);
                                    await cubit.deleteMedication(
                                      token: token!,
                                      id: widget.id,
                                      context: lcontext,
                                    );
                                  },
                                  color: mainColor,
                                  height: 50,
                                  child: const Text(
                                    'Yes',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ),
                              ClipRRect(
                                borderRadius: BorderRadius.circular(20),
                                child: MaterialButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  color: mainColor,
                                  height: 50,
                                  child: const Text(
                                    'Cancel',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),
                        ],
                      );
                    },
                  );
                },
                icon: Icon(
                  Icons.delete,
                  size: 30,
                  color: Colors.red.shade400,
                ),
              ),
              const SizedBox(width: 10),
            ],
          ),
          body: state is LoadingGetSpecificMedication
              ? const Center(child: CircularProgressIndicator())
              : SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Form(
                      key: formKey,
                      child: Column(
                        children: [
                          state is LoadingDeleteMedication
                              ? const Center(
                                  child: LinearProgressIndicator(
                                  color: Colors.teal,
                                ))
                              : Container(),
                          const SizedBox(height: 20.0),
                          // Image.asset(
                          //   'lib/assets/images/medication.jpg',
                          //   width: mediaQuery(context).width * .80,
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
                          state is LoadingUpdateMedication
                              ? const Center(child: CircularProgressIndicator())
                              : ClipRRect(
                                  borderRadius: BorderRadius.circular(20),
                                  child: MaterialButton(
                                    onPressed: () async {
                                      if (formKey.currentState!.validate()) {
                                        await cubit.updateMedication(
                                            name: nameController.text,
                                            activeIngredients:
                                                activeIngredientsController
                                                    .text,
                                            doses: dosesController.text,
                                            sideEffects:
                                                sideEffectsController.text,
                                            warnings: warningsController.text,
                                            id: widget.id,
                                            token: token!,
                                            context: context);
                                      }
                                    },
                                    color: mainColor,
                                    minWidth: mediaQuery(context).width,
                                    height: 50,
                                    child: const Text(
                                      'UPDATE',
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
