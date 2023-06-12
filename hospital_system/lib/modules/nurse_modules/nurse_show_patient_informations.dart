import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:hospital_system/modules/nurse_modules/nurse_show_specific_patient_appoinment.dart';
import 'package:hospital_system/shared/main_cubit/nurse_cubit/nurse_cubit.dart';

import '../../shared/components/constants.dart';
import '../../shared/components/end_points.dart';
import '../../shared/main_cubit/doctor_cubit/doctor_cubit.dart';
import '../../shared/main_cubit/doctor_cubit/doctor_states.dart';
import '../../shared/main_cubit/manager_cubit/manager_cubit.dart';
import '../../shared/main_cubit/manager_cubit/manager_states.dart';
import '../../shared/main_cubit/nurse_cubit/nurse_states.dart';

class NurseShowPatientInformations extends StatefulWidget {
  const NurseShowPatientInformations({super.key, required this.id});
  final String id;

  @override
  State<NurseShowPatientInformations> createState() =>
      _NurseShowPatientInformationsState();
}

class _NurseShowPatientInformationsState
    extends State<NurseShowPatientInformations>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  // final formKey = GlobalKey<FormState>();

  // final TextEditingController prescriptionController = TextEditingController();

  // final TextEditingController diagnoseController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    // DoctorCubit doctorCubit = DoctorCubit.get(context);

    // doctorCubit
    //     .getPatientWithHisDiagnosis(token: token!, id: widget.id)
    //     .then((value) {
    //   var model = doctorCubit.getPatientWithHisDiagnosisModel!.result;
    //   prescriptionController.text = model!.prescription!;
    //   diagnoseController.text = model.diagnosis!;
    // });
  }

  @override
  void dispose() {
    _tabController.dispose();
    // prescriptionController.dispose();
    // diagnoseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ManagerCubit, ManagerState>(
      bloc: ManagerCubit.get(context)
        ..getSpecificPatient(token: token!, id: widget.id),
      listener: (context, state) {},
      builder: (context, mangerState) {
        internetConection('nurse', context);
        ManagerCubit mangerCubit = ManagerCubit.get(context);

        var specificPatientModel = mangerCubit.getSpecificPatientModel?.result;

        return BlocConsumer<DoctorCubit, DoctorState>(
          bloc: DoctorCubit.get(context)
            ..getPatientWithHisDiagnosis(token: token!, id: widget.id),
          listener: (context, state) {},
          builder: (context, doctorState) {
            DoctorCubit doctorCubit = DoctorCubit.get(context);
            var diagnoseModel =
                doctorCubit.getPatientWithHisDiagnosisModel?.result;
            return BlocConsumer<NurseCubit, NurseState>(
              bloc: NurseCubit.get(context)
                ..getAllPatientAppointment(token: token!, id: widget.id),
              listener: (context, nurseState) {},
              builder: (context, nurseState) {
                NurseCubit nurseCubit = NurseCubit.get(context);

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
                          : patientInformations(specificPatientModel),
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
                              : diagnose(diagnoseModel),
                      //===============================================================
                      // end tab (2) Diagnose
                      //===============================================================
                      //===============================================================
                      // tab (3) Tasks
                      //===============================================================
                      // ignore: avoid_unnecessary_containers
                      nurseState is LoadingGetAllPatientAppointment
                          ? nurseState is ErrorGetAllPatientAppointment
                              ? Center(
                                  child: Text(doctorCubit.errorModel!.message!),
                                )
                              : const Center(
                                  child: CircularProgressIndicator(),
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

  Widget patientInformations(specificPatientModel) => SingleChildScrollView(
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

  Widget diagnose(diagnoseModel) => SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
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
                  Center(
                    child: Image.asset(
                      'lib/assets/images/diagnose.png',
                      width: mediaQuery(context).width * .4,
                    ),
                  ),
                  const Text(
                    'Doctor:',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text('Name: ${diagnoseModel!.doctor!.name}'),
                  Text('ID: ${diagnoseModel.doctor!.id}'),
                  const SizedBox(height: 16),
                  const Text(
                    'Patient:',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text('Name: ${diagnoseModel.patient!.name}'),
                  Text('ID: ${diagnoseModel.patient!.name}'),
                  const SizedBox(height: 16),
                  const Text(
                    'Prescription:',
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  const SizedBox(
                    width: 140,
                    child: Divider(
                      color: primaryColor,
                      thickness: 4,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    '${diagnoseModel.prescription}',
                    style: const TextStyle(fontSize: 18),
                  ),
                  const SizedBox(height: 16),
                  const Divider(),
                  const Text(
                    'Diagnose:',
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
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
                  Text(
                    '${diagnoseModel.diagnosis}',
                    style: const TextStyle(fontSize: 18),
                  ),
                  const SizedBox(height: 20),
                ],
              )),
        ),
      );

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
                            NurseShowSpecificPatientAppoinment(
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
                                itemCount: allPatientAppointmentModel
                                    .medications!.length,
                                itemBuilder: (context, index) {
                                  return Text(allPatientAppointmentModel
                                          .medications?[index]
                                          .medication!
                                          .name ??
                                      '');
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
