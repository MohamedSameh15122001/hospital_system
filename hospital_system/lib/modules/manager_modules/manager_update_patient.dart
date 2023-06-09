import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:hospital_system/shared/components/constants.dart';
import 'package:hospital_system/shared/components/end_points.dart';
import 'package:hospital_system/shared/main_cubit/manager_cubit/manager_cubit.dart';
import 'package:hospital_system/shared/main_cubit/manager_cubit/manager_states.dart';

class MangerUpdatePatient extends StatefulWidget {
  const MangerUpdatePatient({super.key, required this.id});
  final String id;

  @override
  State<MangerUpdatePatient> createState() => _MangerUpdatePatientState();
}

class _MangerUpdatePatientState extends State<MangerUpdatePatient> {
  final formKey = GlobalKey<FormState>();

  TextEditingController nameController = TextEditingController();

  TextEditingController phoneController = TextEditingController();

  TextEditingController emailController = TextEditingController();

  final TextEditingController addressController = TextEditingController();
  final TextEditingController dateOfBirthController = TextEditingController();
  final TextEditingController medicalHistoryController =
      TextEditingController();
  final TextEditingController lastVisitedController = TextEditingController();
  @override
  void initState() {
    super.initState();
    internetConection('manger', context);
    ManagerCubit cubit = ManagerCubit.get(context);

    cubit.getSpecificPatient(token: token!, id: widget.id).then((value) {
      var model = cubit.getSpecificPatientModel!.result;
      nameController.text = model!.name!;
      phoneController.text = model.phone!;
      emailController.text = model.email!;
      addressController.text = model.address!;
      medicalHistoryController.text = model.medicalHistory!;
      dateOfBirthController.text = formatDateToPrint(model.dateOfBirth!);
      lastVisitedController.text = formatDateToPrint(model.lastVisited!);
    });
  }

  @override
  void dispose() {
    nameController.dispose();
    phoneController.dispose();
    emailController.dispose();
    addressController.dispose();
    dateOfBirthController.dispose();
    medicalHistoryController.dispose();
    lastVisitedController.dispose();
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
            title: const Text('Update Patient'),
            centerTitle: true,
            actions: [
              IconButton(
                onPressed: () async {
                  showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: const Text(
                          'are you sure to delete the patient!',
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
                                    await cubit.deletePatient(
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
          body: state is LoadingGetSpecificPatient
              ? const Center(child: CircularProgressIndicator())
              : SingleChildScrollView(
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
                            state is LoadingDeletePatient
                                ? const Center(
                                    child: LinearProgressIndicator(
                                    color: Colors.teal,
                                  ))
                                : Container(),
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
                                } else if (!RegExp(r'^[0-9]+$')
                                    .hasMatch(value)) {
                                  return 'Invalid phone number. Please enter only numeric digits';
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
                                await selectDate(
                                    context, dateOfBirthController);
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
                                final dateRegex =
                                    RegExp(r'^(\d{2})-(\d{2})-(\d{4})$');
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
                                await selectDate(
                                    context, lastVisitedController);
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
                                final dateRegex =
                                    RegExp(r'^(\d{2})-(\d{2})-(\d{4})$');
                                if (value!.isEmpty) {
                                  return 'Please enter Last Visited';
                                } else if (!dateRegex.hasMatch(value)) {
                                  return 'Invalid date format should be dd-mm-yyyy';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 20),
                            state is LoadingUpdatePatientAccount
                                ? const Center(
                                    child: CircularProgressIndicator())
                                : ClipRRect(
                                    borderRadius: BorderRadius.circular(20),
                                    child: MaterialButton(
                                      onPressed: () async {
                                        if (formKey.currentState!.validate()) {
                                          await cubit.updatePatientAccount(
                                              name: nameController.text,
                                              email: emailController.text,
                                              phone: phoneController.text,
                                              address:
                                                  addressController.text.trim(),
                                              medicalHistory:
                                                  medicalHistoryController.text
                                                      .trim(),
                                              dateOfBirth: dateOfBirthController
                                                  .text
                                                  .trim(),
                                              lastVisited: lastVisitedController
                                                  .text
                                                  .trim(),
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
