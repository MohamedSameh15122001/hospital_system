import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:hospital_system/shared/main_cubit/doctor_cubit/doctor_cubit.dart';
import 'package:hospital_system/shared/main_cubit/doctor_cubit/doctor_states.dart';

import '../../shared/components/constants.dart';
import '../../shared/components/end_points.dart';
import '../../shared/main_cubit/manager_cubit/manager_cubit.dart';
import '../../shared/main_cubit/manager_cubit/manager_states.dart';

class DoctorShowPatientInformation extends StatefulWidget {
  const DoctorShowPatientInformation({super.key, required this.id});
  final String id;

  @override
  State<DoctorShowPatientInformation> createState() =>
      _DoctorShowPatientInformationState();
}

class _DoctorShowPatientInformationState
    extends State<DoctorShowPatientInformation>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final formKey = GlobalKey<FormState>();

  final TextEditingController prescriptionController = TextEditingController();

  final TextEditingController diagnoseController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    DoctorCubit doctorCubit = DoctorCubit.get(context);

    doctorCubit
        .getPatientWithHisDiagnosis(token: token!, id: widget.id)
        .then((value) {
      var model = doctorCubit.getPatientWithHisDiagnosisModel!.result;
      prescriptionController.text = model!.prescription!;
      diagnoseController.text = model.diagnosis!;
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    prescriptionController.dispose();
    diagnoseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ManagerCubit, ManagerState>(
      bloc: ManagerCubit.get(context)
        ..getSpecificPatient(token: token!, id: widget.id),
      listener: (context, state) {},
      builder: (context, mangerState) {
        ManagerCubit mangerCubit = ManagerCubit.get(context);

        var specificPatientModel = mangerCubit.getSpecificPatientModel?.result;

        return BlocConsumer<DoctorCubit, DoctorState>(
          bloc: DoctorCubit.get(context),
          listener: (context, state) {},
          builder: (context, doctorState) {
            DoctorCubit doctorCubit = DoctorCubit.get(context);
            var diagnoseModel =
                doctorCubit.getPatientWithHisDiagnosisModel?.result;
            return Scaffold(
              appBar: AppBar(
                elevation: 0,
                // foregroundColor: Colors.white,
                // backgroundColor: const Color(0x9300DEBD),
                backgroundColor: mainColor,
                title: const Text(
                  'Patient',
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold),
                ),
                bottom: TabBar(
                  labelColor: Colors.white,
                  labelStyle: const TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold),
                  indicatorColor: Colors.white,
                  indicatorWeight: 4,
                  unselectedLabelColor: Colors.grey.shade600,
                  controller: _tabController,
                  tabs: const [
                    Tab(text: 'Information'),
                    Tab(text: 'Diagnose'),
                    Tab(text: 'Tasks'),
                  ],
                ),
              ),
              body: TabBarView(
                controller: _tabController,
                children: [
                  //====================================================
                  // tab (1) Patient Informations
                  //====================================================
                  mangerState is LoadingGetSpecificPatient
                      ? const Center(child: CircularProgressIndicator())
                      : SingleChildScrollView(
                          physics: const BouncingScrollPhysics(),
                          child: Padding(
                            padding: const EdgeInsets.all(0.0),
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children:
                                    AnimationConfiguration.toStaggeredList(
                                  duration: const Duration(milliseconds: 500),
                                  childAnimationBuilder: (widget) =>
                                      SlideAnimation(
                                    horizontalOffset: 50.0,
                                    child: FadeInAnimation(
                                      child: widget,
                                    ),
                                  ),
                                  children: [
                                    SizedBox(
                                      height:
                                          MediaQuery.of(context).size.height *
                                              .2,
                                      width: MediaQuery.of(context).size.width,
                                      child: Stack(
                                        children: [
                                          SizedBox(
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .height *
                                                .2,
                                            width: MediaQuery.of(context)
                                                .size
                                                .width,
                                            child: ClipPath(
                                              clipper: _NameClipper(),
                                              child:
                                                  Container(color: mainColor),
                                            ),
                                          ),
                                          Align(
                                            alignment: const Alignment(0, .2),
                                            child: CircleAvatar(
                                              radius: 60,
                                              backgroundColor:
                                                  const Color(0x9650DEC9),
                                              backgroundImage: NetworkImage(
                                                  specificPatientModel!
                                                      .profileImage!),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Center(
                                      child: Text(
                                        specificPatientModel.name!,
                                        style: const TextStyle(
                                            fontSize: 24,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(16.0),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          const SizedBox(height: 8),
                                          Text(
                                            'ID: ${specificPatientModel.id}',
                                            style: TextStyle(
                                                fontSize: 18,
                                                color: Colors.grey.shade800),
                                          ),
                                          const Divider(),
                                          const SizedBox(height: 4),
                                          Text(
                                            'Phone: ${specificPatientModel.phone}',
                                            style: TextStyle(
                                                fontSize: 18,
                                                color: Colors.grey.shade800),
                                          ),
                                          const Divider(),
                                          const SizedBox(height: 4),
                                          Text(
                                            'Email: ${specificPatientModel.email}',
                                            style: TextStyle(
                                                fontSize: 18,
                                                color: Colors.grey.shade800),
                                          ),
                                          const Divider(),
                                          const SizedBox(height: 4),
                                          Text(
                                            'address: ${specificPatientModel.address}',
                                            style: TextStyle(
                                                fontSize: 18,
                                                color: Colors.grey.shade800),
                                          ),
                                          const Divider(),
                                          const SizedBox(height: 4),
                                          Text(
                                            'sex: ${specificPatientModel.sex}',
                                            style: TextStyle(
                                                fontSize: 18,
                                                color: Colors.grey.shade800),
                                          ),
                                          const Divider(),
                                          const SizedBox(height: 4),
                                          Text(
                                            'medicalHistory: ${specificPatientModel.medicalHistory}',
                                            style: TextStyle(
                                                fontSize: 18,
                                                color: Colors.grey.shade800),
                                          ),
                                          const Divider(),
                                          const SizedBox(height: 4),
                                          Text(
                                            'dateOfBirth: ${formatDateToPrint(specificPatientModel.dateOfBirth!)}',
                                            style: TextStyle(
                                                fontSize: 18,
                                                color: Colors.grey.shade800),
                                          ),
                                          const Divider(),
                                          const SizedBox(height: 4),
                                          Text(
                                            'lastVisited: ${formatDateToPrint(specificPatientModel.lastVisited!)}',
                                            style: TextStyle(
                                                fontSize: 18,
                                                color: Colors.grey.shade800),
                                          ),
                                          const Divider(),
                                          const SizedBox(height: 8),
                                        ],
                                      ),
                                    ),
                                  ],
                                )),
                          ),
                        ),
                  //====================================================
                  // end tab (1) Patient Informations
                  //====================================================
                  //===============================================================
                  // tab (2) Diagnose
                  //===============================================================
                  doctorState is LoadingGetPatientWithHisDiagnosis
                      ? const Center(child: CircularProgressIndicator())
                      : doctorState is ErrorGetPatientWithHisDiagnosis
                          ? Center(
                              child: Text(doctorCubit.errorModel!.message!),
                            )
                          : SingleChildScrollView(
                              physics: const BouncingScrollPhysics(),
                              child: Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Form(
                                  key: formKey,
                                  child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: AnimationConfiguration
                                          .toStaggeredList(
                                        duration:
                                            const Duration(milliseconds: 500),
                                        childAnimationBuilder: (widget) =>
                                            FlipAnimation(
                                          child: FadeInAnimation(
                                            child: widget,
                                          ),
                                        ),
                                        children: [
                                          doctorState
                                                  is LoadingDeletePatientDiagnosis
                                              ? const Center(
                                                  child:
                                                      LinearProgressIndicator(
                                                  color: Colors.teal,
                                                ))
                                              : Container(),
                                          Row(
                                            children: [
                                              Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  const Text(
                                                    'Doctor:',
                                                    style: TextStyle(
                                                        fontSize: 18,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                  const SizedBox(height: 8),
                                                  Text(
                                                      'Name: ${diagnoseModel!.doctor!.name}'),
                                                  Text(
                                                      'ID: ${diagnoseModel.doctor!.id}'),
                                                ],
                                              ),
                                              const Spacer(),
                                              IconButton(
                                                onPressed: () async {
                                                  showDialog(
                                                    context: context,
                                                    builder: (context) {
                                                      return AlertDialog(
                                                        title: const Text(
                                                          'are you sure to delete the diagnose!',
                                                          style: TextStyle(
                                                            fontSize: 16,
                                                          ),
                                                        ),
                                                        actions: [
                                                          Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .spaceEvenly,
                                                            children: [
                                                              ClipRRect(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            20),
                                                                child:
                                                                    MaterialButton(
                                                                  onPressed:
                                                                      () async {
                                                                    Navigator.pop(
                                                                        context);
                                                                    await doctorCubit
                                                                        .deletePatientDiagnosis(
                                                                      token:
                                                                          token!,
                                                                      id: widget
                                                                          .id,
                                                                    );
                                                                  },
                                                                  color:
                                                                      mainColor,
                                                                  height: 50,
                                                                  child:
                                                                      const Text(
                                                                    'Yes',
                                                                    style: TextStyle(
                                                                        color: Colors
                                                                            .white,
                                                                        fontWeight:
                                                                            FontWeight.bold),
                                                                  ),
                                                                ),
                                                              ),
                                                              ClipRRect(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            20),
                                                                child:
                                                                    MaterialButton(
                                                                  onPressed:
                                                                      () {
                                                                    Navigator.pop(
                                                                        context);
                                                                  },
                                                                  color:
                                                                      mainColor,
                                                                  height: 50,
                                                                  child:
                                                                      const Text(
                                                                    'Cancel',
                                                                    style:
                                                                        TextStyle(
                                                                      color: Colors
                                                                          .white,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold,
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                          const SizedBox(
                                                              height: 20),
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
                                            ],
                                          ),
                                          const SizedBox(height: 16),
                                          const Text(
                                            'Patient:',
                                            style: TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          const SizedBox(height: 8),
                                          Text(
                                              'Name: ${diagnoseModel.patient!.name}'),
                                          Text(
                                              'ID: ${diagnoseModel.patient!.name}'),
                                          const SizedBox(height: 16),
                                          const Text(
                                            'Prescription:',
                                            style: TextStyle(
                                                fontSize: 22,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          const SizedBox(height: 8),
                                          const SizedBox(
                                            width: 140,
                                            child: Divider(
                                              color: primaryColor,
                                              thickness: 4,
                                            ),
                                          ),
                                          const SizedBox(height: 20),
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
                                                borderRadius:
                                                    BorderRadius.circular(20.0),
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
                                          const SizedBox(height: 16),
                                          const Text(
                                            'Diagnose:',
                                            style: TextStyle(
                                                fontSize: 22,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          const SizedBox(height: 8),
                                          const SizedBox(
                                            width: 110,
                                            child: Divider(
                                              color: primaryColor,
                                              thickness: 4,
                                            ),
                                          ),
                                          const SizedBox(height: 20),
                                          TextFormField(
                                            controller: diagnoseController,
                                            decoration: InputDecoration(
                                              labelText: 'Diagnosis',
                                              border: OutlineInputBorder(
                                                borderSide: BorderSide(
                                                  color: mainColor,
                                                  width: 2.0,
                                                ),
                                                borderRadius:
                                                    BorderRadius.circular(20.0),
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
                                          doctorState
                                                  is LoadingUpdatePatientDiagnosis
                                              ? const Center(
                                                  child:
                                                      CircularProgressIndicator())
                                              : ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.circular(20),
                                                  child: MaterialButton(
                                                    onPressed: () async {
                                                      if (formKey.currentState!
                                                          .validate()) {
                                                        await doctorCubit
                                                            .updatePatientDiagnosis(
                                                          prescription:
                                                              prescriptionController
                                                                  .text,
                                                          diagnosis:
                                                              diagnoseController
                                                                  .text,
                                                          id: widget.id,
                                                          token: token!,
                                                        );
                                                      }
                                                    },
                                                    color: mainColor,
                                                    minWidth:
                                                        mediaQuery(context)
                                                            .width,
                                                    height: 50,
                                                    child: const Text(
                                                      'UPDATE',
                                                      style: TextStyle(
                                                          color: Colors.white,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                  ),
                                                ),
                                        ],
                                      )),
                                ),
                              ),
                            ),
                  //===============================================================
                  // end tab (2) Diagnose
                  //===============================================================
                  //===============================================================
                  // tab (3) Tasks
                  //===============================================================
                  // ignore: avoid_unnecessary_containers
                  const Center(
                    child: Text('No tasks!'),
                  ),
                  //===============================================================
                  // end tab (3) Tasks
                  //===============================================================
                ],
              ),
            );
          },
        );
      },
    );
  }
}

// ignore: unused_element
class _NameClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();

    path.moveTo(0, 0);
    path.lineTo(size.width, 0);
    path.lineTo(size.width, size.height * .3);

    //x1,y1 the point to going | x2,y2 the point to draw
    path.quadraticBezierTo(size.width * .5, size.height, 0, size.height * .3);

    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => true;
}
