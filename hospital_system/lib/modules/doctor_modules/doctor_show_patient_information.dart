import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:hospital_system/shared/main_cubit/doctor_cubit/doctor_cubit.dart';
import 'package:hospital_system/shared/main_cubit/doctor_cubit/doctor_states.dart';
import 'package:hospital_system/shared/main_cubit/nurse_cubit/nurse_cubit.dart';
import 'package:hospital_system/shared/main_cubit/nurse_cubit/nurse_states.dart';

import '../../shared/components/constants.dart';
import '../../shared/components/end_points.dart';
import '../../shared/main_cubit/manager_cubit/manager_cubit.dart';
import '../../shared/main_cubit/manager_cubit/manager_states.dart';
import 'doctor_show_specific_patient_appoinment.dart';

class DoctorShowPatientInformations extends StatefulWidget {
  const DoctorShowPatientInformations({super.key, required this.id});
  final String id;

  @override
  State<DoctorShowPatientInformations> createState() =>
      _DoctorShowPatientInformationsState();
}

class _DoctorShowPatientInformationsState
    extends State<DoctorShowPatientInformations>
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
        internetConection('doctor', context);
        ManagerCubit mangerCubit = ManagerCubit.get(context);
        var specificPatientModel = mangerCubit.getSpecificPatientModel?.result;
        return BlocConsumer<DoctorCubit, DoctorState>(
          bloc: DoctorCubit.get(context),
          listener: (context, state) {},
          builder: (context, doctorState) {
            DoctorCubit doctorCubit = DoctorCubit.get(context);

            return BlocConsumer<NurseCubit, NurseState>(
              bloc: NurseCubit.get(context)
                ..getAllPatientAppointment(token: token!, id: widget.id),
              listener: (context, nurseState) {},
              builder: (context, nurseState) {
                NurseCubit nurseCubit = NurseCubit.get(context);
                return Scaffold(
                  appBar: AppBar(
                    leading: IconButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        icon: const Icon(
                          Icons.arrow_back,
                          color: Colors.white,
                        )),
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
                          ? Center(child: loading)
                          : mangerState is ErrorGetSpecificPatient
                              ? Center(
                                  child: Text(mangerCubit.errorModel!.message!),
                                )
                              : mangerCubit.getSpecificPatientModel == null
                                  ? Center(
                                      child: loading,
                                    )
                                  : patientInformations(mangerCubit),
                      //====================================================
                      // end tab (1) Patient Informations
                      //====================================================
                      //===============================================================
                      // tab (2) Diagnose
                      //===============================================================
                      doctorState is LoadingGetPatientWithHisDiagnosis
                          ? Center(child: loading)
                          : doctorState is ErrorGetPatientWithHisDiagnosis
                              ? Center(
                                  child: Text(doctorCubit.errorModel!.message!))
                              : doctorCubit.getPatientWithHisDiagnosisModel ==
                                      null
                                  ? Center(
                                      child: loading,
                                    )
                                  : diagnose(doctorState, doctorCubit),
                      //===============================================================
                      // end tab (2) Diagnose
                      //===============================================================
                      //===============================================================
                      // tab (3) Tasks
                      //===============================================================
                      // ignore: avoid_unnecessary_containers
                      nurseState is LoadingGetAllPatientAppointment
                          ? Center(
                              child: loading,
                            )
                          : nurseState is ErrorGetAllPatientAppointment
                              ? Center(
                                  child: Text(doctorCubit.errorModel!.message!),
                                )
                              : nurseCubit.getAllPatientAppointmentModel == null
                                  ? Center(
                                      child: loading,
                                    )
                                  : tasks(nurseCubit, specificPatientModel),
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
      },
    );
  }

  Widget patientInformations(mangerCubit) => Builder(builder: (context) {
        var specificPatientModel = mangerCubit.getSpecificPatientModel?.result;
        return SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.all(0.0),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: AnimationConfiguration.toStaggeredList(
                  duration: const Duration(milliseconds: 500),
                  childAnimationBuilder: (widget) => SlideAnimation(
                    horizontalOffset: 50.0,
                    child: FadeInAnimation(
                      child: widget,
                    ),
                  ),
                  children: [
                    SizedBox(
                      height: MediaQuery.of(context).size.height * .2,
                      width: MediaQuery.of(context).size.width,
                      child: Stack(
                        children: [
                          SizedBox(
                            height: MediaQuery.of(context).size.height * .2,
                            width: MediaQuery.of(context).size.width,
                            child: ClipPath(
                              clipper: _NameClipper(),
                              child: Container(color: mainColor),
                            ),
                          ),
                          Align(
                            alignment: const Alignment(0, .2),
                            child: CircleAvatar(
                              radius: 60,
                              backgroundColor: const Color(0x9650DEC9),
                              backgroundImage: NetworkImage(
                                  specificPatientModel!.profileImage!),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Center(
                      child: Text(
                        specificPatientModel.name!,
                        style: const TextStyle(
                            fontSize: 24, fontWeight: FontWeight.bold),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 8),
                          Text(
                            'ID: ${specificPatientModel.id}',
                            style: TextStyle(
                                fontSize: 18, color: Colors.grey.shade800),
                          ),
                          const Divider(),
                          const SizedBox(height: 4),
                          Text(
                            'Phone: ${specificPatientModel.phone}',
                            style: TextStyle(
                                fontSize: 18, color: Colors.grey.shade800),
                          ),
                          const Divider(),
                          const SizedBox(height: 4),
                          Text(
                            'Email: ${specificPatientModel.email}',
                            style: TextStyle(
                                fontSize: 18, color: Colors.grey.shade800),
                          ),
                          const Divider(),
                          const SizedBox(height: 4),
                          Text(
                            'address: ${specificPatientModel.address}',
                            style: TextStyle(
                                fontSize: 18, color: Colors.grey.shade800),
                          ),
                          const Divider(),
                          const SizedBox(height: 4),
                          Text(
                            'sex: ${specificPatientModel.sex}',
                            style: TextStyle(
                                fontSize: 18, color: Colors.grey.shade800),
                          ),
                          const Divider(),
                          const SizedBox(height: 4),
                          Text(
                            'medicalHistory: ${specificPatientModel.medicalHistory}',
                            style: TextStyle(
                                fontSize: 18, color: Colors.grey.shade800),
                          ),
                          const Divider(),
                          const SizedBox(height: 4),
                          Text(
                            'dateOfBirth: ${formatDateToPrint(specificPatientModel.dateOfBirth!)}',
                            style: TextStyle(
                                fontSize: 18, color: Colors.grey.shade800),
                          ),
                          const Divider(),
                          const SizedBox(height: 4),
                          Text(
                            'lastVisited: ${formatDateToPrint(specificPatientModel.lastVisited!)}',
                            style: TextStyle(
                                fontSize: 18, color: Colors.grey.shade800),
                          ),
                          const Divider(),
                          const SizedBox(height: 8),
                        ],
                      ),
                    ),
                  ],
                )),
          ),
        );
      });

  Widget diagnose(doctorState, doctorCubit) => Builder(builder: (context) {
        var diagnoseModel = doctorCubit.getPatientWithHisDiagnosisModel?.result;
        return SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: formKey,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: Colors.grey, // Change the color here
                    width: 2.0, // Set the border width
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: AnimationConfiguration.toStaggeredList(
                        duration: const Duration(milliseconds: 500),
                        childAnimationBuilder: (widget) => FlipAnimation(
                          child: FadeInAnimation(
                            child: widget,
                          ),
                        ),
                        children: [
                          doctorState is LoadingDeletePatientDiagnosis
                              ? Center(
                                  child: LinearProgressIndicator(
                                  color: Colors.teal,
                                  backgroundColor: mainColor,
                                ))
                              : Container(),
                          Row(
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  const Text(
                                    'Doctor',
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    '${diagnoseModel!.doctor!.name}',
                                    style: const TextStyle(fontSize: 16),
                                  ),
                                  Text(
                                    '${diagnoseModel.doctor!.id}',
                                    style: const TextStyle(fontSize: 16),
                                  ),
                                  Text(
                                    '${diagnoseModel.doctor!.specialty}',
                                    style: const TextStyle(fontSize: 16),
                                  ),
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
                                                MainAxisAlignment.spaceEvenly,
                                            children: [
                                              ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(20),
                                                child: MaterialButton(
                                                  onPressed: () async {
                                                    Navigator.pop(context);
                                                    await doctorCubit
                                                        .deletePatientDiagnosis(
                                                      token: token!,
                                                      id: widget.id,
                                                    );
                                                  },
                                                  color: mainColor,
                                                  height: 50,
                                                  child: const Text(
                                                    'Yes',
                                                    style: TextStyle(
                                                        color: Colors.white,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                ),
                                              ),
                                              ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(20),
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
                                                      fontWeight:
                                                          FontWeight.bold,
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
                              Center(
                                child: Image.asset(
                                  'lib/assets/images/diagnose.png',
                                  width: mediaQuery(context).width * .3,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          const Divider(
                            height: 2,
                            thickness: 3,
                            color: Colors.grey,
                          ),
                          const SizedBox(height: 16),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('Name: ${diagnoseModel.patient!.name}'),
                              Text(
                                  'Date: ${formatDateToPrint(diagnoseModel.patient!.dateOfBirth)}'),
                            ],
                          ),
                          Text('ID: ${diagnoseModel.patient!.id}'),
                          const SizedBox(height: 16),
                          const Text(
                            'Prescription:',
                            style: TextStyle(
                                fontSize: 22, fontWeight: FontWeight.bold),
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
                          const SizedBox(height: 16),
                          const Text(
                            'Diagnose:',
                            style: TextStyle(
                                fontSize: 22, fontWeight: FontWeight.bold),
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
                          doctorState is LoadingUpdatePatientDiagnosis
                              ? Center(child: loading)
                              : ClipRRect(
                                  borderRadius: BorderRadius.circular(20),
                                  child: MaterialButton(
                                    onPressed: () async {
                                      prescriptionController.text =
                                          prescriptionController.text.trim();
                                      diagnoseController.text =
                                          diagnoseController.text.trim();
                                      if (formKey.currentState!.validate()) {
                                        await doctorCubit
                                            .updatePatientDiagnosis(
                                          prescription: prescriptionController
                                              .text
                                              .trim(),
                                          diagnosis:
                                              diagnoseController.text.trim(),
                                          id: widget.id,
                                          token: token!,
                                        );
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
      });

  Widget tasks(nurseCubit, specificPatientModel) => Padding(
        padding: const EdgeInsets.all(16.0),
        child: AnimationLimiter(
          child: ListView.builder(
            physics: const BouncingScrollPhysics(),
            itemCount: nurseCubit.getAllPatientAppointmentModel?.result?.length,
            itemBuilder: (context, index) {
              var allPatientAppointmentModel =
                  nurseCubit.getAllPatientAppointmentModel?.result![index];
              return AnimationConfiguration.staggeredList(
                position: index,
                delay: const Duration(milliseconds: 100),
                child: SlideAnimation(
                  duration: const Duration(milliseconds: 2500),
                  curve: Curves.fastLinearToSlowEaseIn,
                  horizontalOffset: 30, //-300
                  verticalOffset: 300, //-850
                  child: FlipAnimation(
                    duration: const Duration(milliseconds: 3000),
                    curve: Curves.fastLinearToSlowEaseIn,
                    flipAxis: FlipAxis.y,
                    child: GestureDetector(
                      onTap: () {
                        navigateToWithFade(
                            context,
                            DoctorShowSpecificPatientAppoinment(
                              appointmentId: allPatientAppointmentModel.sId!,
                              patientId: specificPatientModel!.sId!,
                            ));
                      },
                      child: Container(
                        margin: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.shade300,
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            )
                          ],
                          borderRadius: BorderRadius.circular(20),
                          color: Colors.white,
                        ),
                        child: ListTile(
                          leading:
                              Image.asset('lib/assets/images/appointment.png'),
                          title: Padding(
                            padding: const EdgeInsets.only(top: 12.0),
                            child: Text(
                              allPatientAppointmentModel!.patient!.name!,
                              style: const TextStyle(
                                fontSize: 20,
                              ),
                            ),
                          ),
                          subtitle: Column(
                            // mainAxisAlignment:
                            //     MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: 8),
                              Text(
                                  'Created At: ${formatDateToPrint(allPatientAppointmentModel.createdAt!)}'),
                              const SizedBox(height: 8),
                              ListView.builder(
                                physics: const NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                itemCount: (allPatientAppointmentModel
                                            .medications!.length /
                                        2)
                                    .ceil(),
                                itemBuilder: (context, index) {
                                  final startIndex = index * 2;
                                  final endIndex = startIndex + 1;
                                  final medications =
                                      allPatientAppointmentModel.medications!;

                                  return Row(
                                    children: [
                                      Expanded(
                                        child: Text(medications[startIndex]
                                                .medication!
                                                .name ??
                                            ''),
                                      ),
                                      const SizedBox(
                                          width:
                                              10), // Add spacing between medications
                                      if (endIndex < medications.length)
                                        Expanded(
                                          child: Text(medications[endIndex]
                                                  .medication!
                                                  .name ??
                                              ''),
                                        ),
                                    ],
                                  );
                                },
                              ),
                              const SizedBox(height: 8),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      );
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


// const Text(
//                                 'Doctor:',
//                                 style: TextStyle(
//                                     fontSize: 18, fontWeight: FontWeight.bold),
//                               ),
//                               const SizedBox(height: 8),
//                               Text('Name: ${diagnoseModel!.doctor!.name}'),
//                               Text('ID: ${diagnoseModel.doctor!.id}'),