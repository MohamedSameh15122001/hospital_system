import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hospital_system/modules/manager_modules/manager_add_patient.dart';
import 'package:hospital_system/modules/manager_modules/manager_update_patient.dart';
import 'package:hospital_system/shared/components/constants.dart';
import 'package:hospital_system/shared/components/end_points.dart';
import 'package:hospital_system/shared/main_cubit/manager_cubit/manager_cubit.dart';
import 'package:hospital_system/shared/main_cubit/manager_cubit/manager_states.dart';

class MangerShowPatients extends StatelessWidget {
  const MangerShowPatients({super.key});

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
            title: const Text('Patients'),
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
                                  context, MangerUpdatePatient(id: model.sId!));
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
                                    style: const TextStyle(fontSize: 20),
                                  ),
                                ),
                                subtitle: Column(
                                  // mainAxisAlignment:
                                  //     MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const SizedBox(height: 8),
                                    Text('ID: ${model.id}'),
                                    const SizedBox(height: 4),
                                    Text('Phone: ${model.phone}'),
                                    const SizedBox(height: 4),
                                    Text('Email: ${model.email}'),
                                    const SizedBox(height: 4),
                                    Text('address: ${model.address}'),
                                    const SizedBox(height: 4),
                                    Text(
                                        'medicalHistory: ${model.medicalHistory}'),
                                    const SizedBox(height: 4),
                                    Text(
                                        'dateOfBirth: ${formatDateToPrint(model.dateOfBirth!)}'),
                                    const SizedBox(height: 4),
                                    Text(
                                        'lastVisited: ${formatDateToPrint(model.lastVisited!)}'),
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
              navigateTo(context, MangerAddPatient());
            },
          ),
        );
      },
    );
  }
}
