import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:hospital_system/modules/doctor_modules/doctor_add_diagnosis.dart';
import 'package:hospital_system/modules/doctor_modules/doctor_profile.dart';
import 'package:hospital_system/modules/doctor_modules/doctor_search_patient.dart';
import 'package:hospital_system/modules/doctor_modules/doctor_show_patient_information.dart';
import 'package:hospital_system/modules/nurse_modules/nurse_show_patient_informations.dart';
import 'package:hospital_system/shared/components/constants.dart';

import '../../shared/components/end_points.dart';
import '../../shared/main_cubit/manager_cubit/manager_cubit.dart';
import '../../shared/main_cubit/manager_cubit/manager_states.dart';

class DoctorHome extends StatefulWidget {
  const DoctorHome({super.key});

  @override
  State<DoctorHome> createState() => _DoctorHomeState();
}

class _DoctorHomeState extends State<DoctorHome> {
  @override
  void initState() {
    ManagerCubit cubit = ManagerCubit.get(context);
    cubit.switchValue
        ? cubit.getAllPatients(token: token!)
        : cubit.getAllPatientsBelongToDoctor(token: token!);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ManagerCubit, ManagerState>(
      bloc: ManagerCubit.get(context),
      listener: (context, state) {},
      builder: (context, state) {
        internetConection('doctor', context);

        ManagerCubit cubit = ManagerCubit.get(context);

        return Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            title: Row(
              children: [
                RichText(
                  text: TextSpan(
                    children: const [
                      TextSpan(
                        text: '👋',
                        style: TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                            color: Colors.black),
                      ),
                    ],
                    text: 'Welcome Back ',
                    style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey.shade900),
                  ),
                ),
                const Spacer(),
                InkWell(
                  onTap: () {
                    navigateToWithFade(context, DoctorSearchPatient());
                  },
                  child: CircleAvatar(
                    backgroundColor: mainColor,
                    child: const Icon(
                      Icons.search,
                      color: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                InkWell(
                  onTap: () async {
                    navigateToWithFade(context, const DoctorProfile());
                  },
                  child: const CircleAvatar(
                    backgroundColor: Color(0x3850DEC9),
                    radius: 24,
                    backgroundImage: AssetImage('lib/assets/images/doctor.png'),
                  ),
                ),
              ],
            ),
            centerTitle: true,
          ),
          body: cubit.switchValue
              ? (state is LoadingGetAllPatients
                  ? Center(
                      child: loading,
                    )
                  : state is ErrorGetAllPatients
                      ? Center(
                          child: Text(cubit.errorModel!.message!),
                        )
                      : cubit.getAllPatientsModel!.result!.isEmpty
                          ? const Center(
                              child: Text('No Patients!'),
                            )
                          : cubit.getAllPatientsModel == null
                              ? Center(
                                  child: loading,
                                )
                              : Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: AnimationLimiter(
                                    child: ListView.builder(
                                      physics: const BouncingScrollPhysics(),
                                      itemCount: cubit
                                          .getAllPatientsModel!.result!.length,
                                      itemBuilder: (context, index) {
                                        var model = cubit.getAllPatientsModel!
                                            .result![index];
                                        return AnimationConfiguration
                                            .staggeredList(
                                          position: index,
                                          delay:
                                              const Duration(milliseconds: 100),
                                          child: SlideAnimation(
                                            duration: const Duration(
                                                milliseconds: 2500),
                                            curve:
                                                Curves.fastLinearToSlowEaseIn,
                                            horizontalOffset: 30, //-300
                                            verticalOffset: 300, //-850
                                            child: FlipAnimation(
                                              duration: const Duration(
                                                  milliseconds: 3000),
                                              curve:
                                                  Curves.fastLinearToSlowEaseIn,
                                              flipAxis: FlipAxis.y,
                                              child: GestureDetector(
                                                onTap: () {
                                                  navigateToWithFade(
                                                      context,
                                                      NurseShowPatientInformations(
                                                        id: model.sId!,
                                                      ));
                                                },
                                                child: Container(
                                                  margin:
                                                      const EdgeInsets.all(8),
                                                  decoration: BoxDecoration(
                                                    boxShadow: [
                                                      BoxShadow(
                                                        color: Colors
                                                            .grey.shade300,
                                                        blurRadius: 10,
                                                        offset:
                                                            const Offset(0, 4),
                                                      )
                                                    ],
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            20),
                                                    color: Colors.white,
                                                  ),
                                                  child: ListTile(
                                                    leading: CircleAvatar(
                                                      radius: 30,
                                                      backgroundColor:
                                                          const Color(
                                                              0x9650DEC9),
                                                      backgroundImage:
                                                          NetworkImage(model
                                                              .profileImage!),
                                                    ),
                                                    title: Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              top: 12.0),
                                                      child: Text(
                                                        model.name!,
                                                        style: const TextStyle(
                                                          fontSize: 20,
                                                        ),
                                                      ),
                                                    ),
                                                    subtitle: Column(
                                                      // mainAxisAlignment:
                                                      //     MainAxisAlignment.spaceBetween,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        const SizedBox(
                                                            height: 8),
                                                        Text('ID: ${model.id}'),
                                                        const SizedBox(
                                                            height: 8),
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
                                ))
              : (state is LoadingGetAllPatientsBelongToDoctor
                  ? Center(
                      child: loading,
                    )
                  : state is ErrorGetAllPatientsBelongToDoctor
                      ? Center(
                          child: Text(cubit.errorModel!.message!),
                        )
                      : cubit.getAllPatientsBelongToDoctorModel == null
                          ? Center(
                              child: loading,
                            )
                          : Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: AnimationLimiter(
                                child: ListView.builder(
                                  physics: const BouncingScrollPhysics(),
                                  itemCount: cubit
                                      .getAllPatientsBelongToDoctorModel!
                                      .result!
                                      .length,
                                  itemBuilder: (context, index) {
                                    var model = cubit
                                        .getAllPatientsBelongToDoctorModel!
                                        .result![index];
                                    return AnimationConfiguration.staggeredList(
                                      position: index,
                                      delay: const Duration(milliseconds: 100),
                                      child: SlideAnimation(
                                        duration:
                                            const Duration(milliseconds: 2500),
                                        curve: Curves.fastLinearToSlowEaseIn,
                                        horizontalOffset: 30, //-300
                                        verticalOffset: 300, //-850
                                        child: FlipAnimation(
                                          duration: const Duration(
                                              milliseconds: 3000),
                                          curve: Curves.fastLinearToSlowEaseIn,
                                          flipAxis: FlipAxis.y,
                                          child: GestureDetector(
                                            onTap: () {
                                              navigateToWithFade(
                                                  context,
                                                  DoctorShowPatientInformations(
                                                    id: model.sId!,
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
                                                borderRadius:
                                                    BorderRadius.circular(20),
                                                color: Colors.white,
                                              ),
                                              child: ListTile(
                                                leading: CircleAvatar(
                                                  radius: 30,
                                                  backgroundColor:
                                                      const Color(0x9650DEC9),
                                                  backgroundImage: NetworkImage(
                                                      model.profileImage!),
                                                ),
                                                title: Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          top: 12.0),
                                                  child: Text(
                                                    model.name!,
                                                    style: const TextStyle(
                                                      fontSize: 20,
                                                    ),
                                                  ),
                                                ),
                                                subtitle: Column(
                                                  // mainAxisAlignment:
                                                  //     MainAxisAlignment.spaceBetween,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    const SizedBox(height: 8),
                                                    Text('ID: ${model.id}'),
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
                            )),
          floatingActionButton: FloatingActionButton(
            child: const Icon(
              Icons.add,
              color: Colors.white,
            ),
            onPressed: () {
              navigateToWithFade(context, DoctorAddDiagnosis());
            },
          ),
          bottomSheet: SizedBox(
            height: 50,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Center(
                child: Row(
                  children: [
                    Text(
                      cubit.switchValue
                          ? 'switch to your patients 👉'
                          : 'switch to all patients 👉',
                      style: const TextStyle(fontSize: 16),
                    ),
                    const SizedBox(width: 20),
                    Switch(
                      value: cubit.switchValue,
                      onChanged: (value) async {
                        await cubit.changeSwitch(value);
                      },
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
