import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hospital_system/modules/doctor_modules/doctor_add_diagnosis.dart';
import 'package:hospital_system/modules/doctor_modules/doctor_show_patient_information.dart';
import 'package:hospital_system/shared/components/constants.dart';

import '../../shared/components/end_points.dart';
import '../../shared/main_cubit/manager_cubit/manager_cubit.dart';
import '../../shared/main_cubit/manager_cubit/manager_states.dart';

class DoctorHome extends StatelessWidget {
  const DoctorHome({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ManagerCubit, ManagerState>(
      bloc: ManagerCubit.get(context)..getAllPatients(token: token!),
      listener: (context, state) {},
      builder: (context, state) {
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
                  onTap: () async {
                    await signOut(context);
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
          body: state is LoadingGetAllPatients
              ? const Center(
                  child: CircularProgressIndicator(),
                )
              : cubit.getAllPatientsModel!.result!.isEmpty
                  ? const Center(
                      child: Text('No Patients!'),
                    )
                  : Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: ListView.builder(
                        physics: const BouncingScrollPhysics(),
                        itemCount: cubit.getAllPatientsModel!.result!.length,
                        itemBuilder: (context, index) {
                          var model = cubit.getAllPatientsModel!.result![index];
                          return GestureDetector(
                            onTap: () {
                              navigateTo(
                                  context,
                                  DoctorShowPatientInformation(
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
                                borderRadius: BorderRadius.circular(20),
                                color: Colors.white,
                              ),
                              child: ListTile(
                                leading: CircleAvatar(
                                  radius: 30,
                                  backgroundColor: const Color(0x9650DEC9),
                                  backgroundImage:
                                      NetworkImage(model.profileImage!),
                                ),
                                title: Padding(
                                  padding: const EdgeInsets.only(top: 12.0),
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
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const SizedBox(height: 8),
                                    Text('ID: ${model.id}'),
                                    const SizedBox(height: 8),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
          floatingActionButton: FloatingActionButton(
            child: const Icon(
              Icons.add,
              color: Colors.white,
            ),
            onPressed: () {
              navigateTo(context, DoctorAddDiagnosis());
            },
          ),
        );
      },
    );
  }
}
