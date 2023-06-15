import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:hospital_system/shared/components/constants.dart';
import 'package:hospital_system/shared/components/end_points.dart';
import 'package:hospital_system/shared/main_cubit/patient_cubit/patient_cubit.dart';
import 'package:hospital_system/shared/main_cubit/patient_cubit/patient_states.dart';

class PatientAppointments extends StatelessWidget {
  const PatientAppointments({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<PatientCubit, PatientState>(
      bloc: PatientCubit.get(context)..getPatientAppointments(token: token!),
      listener: (context, state) {},
      builder: (context, state) {
        internetConection('patient', context);
        PatientCubit cubit = PatientCubit.get(context);
        return state is LoadingGetPatientAppointments
            ? Center(
                child: loading,
              )
            : state is ErrorGetPatientAppointments
                ? Center(
                    child: Text(cubit.errorModel!.message!),
                  )
                : Scaffold(
                    appBar: AppBar(
                      backgroundColor: Colors.transparent,
                      elevation: 0,
                      title: const Text('Appointments'),
                      centerTitle: true,
                    ),
                    body: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: AnimationLimiter(
                        child: ListView.builder(
                          physics: const BouncingScrollPhysics(),
                          itemCount:
                              cubit.getPatientAppointmentsModel?.result?.length,
                          itemBuilder: (context, index) {
                            var allPatientAppointmentModel = cubit
                                .getPatientAppointmentsModel?.result![index];
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
                                      leading: Image.asset(
                                          'lib/assets/images/appointment.png'),
                                      title: Padding(
                                        padding:
                                            const EdgeInsets.only(top: 12.0),
                                        child: Row(
                                          children: [
                                            Text(
                                              allPatientAppointmentModel!
                                                  .patient!.name!,
                                              style: const TextStyle(
                                                fontSize: 20,
                                              ),
                                            ),
                                            const Spacer(),
                                            Transform.scale(
                                              scale: 1.3,
                                              child: Checkbox(
                                                value:
                                                    allPatientAppointmentModel
                                                        .completed,
                                                onChanged: (value) {},
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      subtitle: Column(
                                        // mainAxisAlignment:
                                        //     MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                              'Schedule: ${allPatientAppointmentModel.schedule.toString()}'),
                                          const SizedBox(height: 8),
                                          Text(
                                              'Created At: ${formatDateToPrint(allPatientAppointmentModel.createdAt!)}'),
                                          const SizedBox(height: 8),
                                          ListView.builder(
                                            physics:
                                                const NeverScrollableScrollPhysics(),
                                            shrinkWrap: true,
                                            itemCount:
                                                (allPatientAppointmentModel
                                                            .medications!
                                                            .length /
                                                        2)
                                                    .ceil(),
                                            itemBuilder: (context, index) {
                                              final startIndex = index * 2;
                                              final endIndex = startIndex + 1;
                                              final medications =
                                                  allPatientAppointmentModel
                                                      .medications!;

                                              return Row(
                                                children: [
                                                  Expanded(
                                                    child: Text(
                                                        medications[startIndex]
                                                                .medication!
                                                                .name ??
                                                            ''),
                                                  ),
                                                  const SizedBox(
                                                      width:
                                                          10), // Add spacing between medications
                                                  if (endIndex <
                                                      medications.length)
                                                    Expanded(
                                                      child: Text(
                                                          medications[endIndex]
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
                            );
                          },
                        ),
                      ),
                    ),
                  );
      },
    );
  }
}
