import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:hospital_system/shared/main_cubit/nurse_cubit/nurse_cubit.dart';

import '../../shared/components/constants.dart';
import '../../shared/components/end_points.dart';
import '../../shared/main_cubit/nurse_cubit/nurse_states.dart';
import 'nurse_add_appointment.dart';

class NurseCompletedAppointments extends StatelessWidget {
  const NurseCompletedAppointments({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<NurseCubit, NurseState>(
      bloc: NurseCubit.get(context)..getCompletedAppointments(token: token!),
      listener: (context, state) {},
      builder: (context, state) {
        internetConection('nurse', context);
        NurseCubit cubit = NurseCubit.get(context);
        return Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            title: const Text('Completed Appoinments'),
            centerTitle: true,
          ),
          body: state is LoadingGetComplatedAppointments
              ? const Center(child: CircularProgressIndicator())
              : Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: AnimationLimiter(
                    child: cubit.getComplatedAppointmentsModel?.result ==
                                null &&
                            state is SuccessGetComplatedAppointments
                        ? Center(
                            child: Text('${cubit.errorModel?.message!}!'),
                          )
                        : Column(
                            children: [
                              state is LoadingCheckComplete
                                  ? const Center(
                                      child: LinearProgressIndicator(
                                      color: Colors.teal,
                                    ))
                                  : Container(),
                              state is LoadingCheckComplete
                                  ? const SizedBox(height: 20)
                                  : Container(),
                              Expanded(
                                child: ListView.builder(
                                  physics: const BouncingScrollPhysics(),
                                  itemCount: cubit.getComplatedAppointmentsModel
                                      ?.result?.length,
                                  itemBuilder: (context, index) {
                                    var model = cubit
                                        .getComplatedAppointmentsModel
                                        ?.result![index];
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
                                              leading: Image.asset(
                                                  'lib/assets/images/appointment.png'),
                                              title: Padding(
                                                padding: const EdgeInsets.only(
                                                    top: 12.0),
                                                child: Text(
                                                  model!.patient!.name!,
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
                                                  Text(
                                                      'ID: ${model.patient!.id!}'),
                                                  const SizedBox(height: 8),
                                                  Row(
                                                    children: [
                                                      const Icon(
                                                          Icons.calendar_month),
                                                      Text(
                                                          ' ${formatDateToPrint(model.createdAt!)}'),
                                                    ],
                                                  ),
                                                  const SizedBox(height: 8),
                                                  Row(
                                                    children: [
                                                      const Icon(
                                                          Icons.schedule),
                                                      Text(
                                                          ' ${model.schedule}'),
                                                    ],
                                                  ),
                                                  const Divider(),
                                                  // const SizedBox(height: 8),
                                                  const Text('medicines:'),
                                                  const SizedBox(height: 8),
                                                  ListView.builder(
                                                    physics:
                                                        const NeverScrollableScrollPhysics(),
                                                    shrinkWrap: true,
                                                    itemCount: model
                                                        .medications!.length,
                                                    itemBuilder:
                                                        (context, index) {
                                                      return Row(
                                                        children: [
                                                          Icon(
                                                            Icons.circle,
                                                            color: mainColor,
                                                          ),
                                                          Text(
                                                              '  ${model.medications?[index].medication!.name}'),
                                                        ],
                                                      );
                                                    },
                                                  ),
                                                  const SizedBox(height: 8),
                                                  ClipRRect(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            20),
                                                    child: MaterialButton(
                                                      onPressed: () async {
                                                        showDialog(
                                                          context: context,
                                                          builder:
                                                              (dialogContext) {
                                                            return AlertDialog(
                                                              title: const Text(
                                                                'are you sure the task is finished?',
                                                                style:
                                                                    TextStyle(
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
                                                                          BorderRadius.circular(
                                                                              20),
                                                                      child:
                                                                          MaterialButton(
                                                                        onPressed:
                                                                            () async {
                                                                          Navigator.pop(
                                                                              dialogContext);
                                                                          await cubit.checkComplete(
                                                                              token: token!,
                                                                              appointmentId: model.sId!);
                                                                          for (var i = 0;
                                                                              i < model.medications!.length;
                                                                              i++) {
                                                                            selectedMedicines.add(model.medications![i].medication!.name);
                                                                            medicineToApi.add({
                                                                              'medication': model.medications![i].medication!.sId!,
                                                                              'dose': model.medications![i].dose!,
                                                                            });
                                                                          }

                                                                          // ignore: use_build_context_synchronously
                                                                          navigateToWithFade(
                                                                              context,
                                                                              NurseAddAppointment(
                                                                                patientId: model.patient!.id,
                                                                                schedule: model.schedule,
                                                                              ));
                                                                        },
                                                                        color:
                                                                            mainColor,
                                                                        height:
                                                                            50,
                                                                        child:
                                                                            const Text(
                                                                          'Yes',
                                                                          style: TextStyle(
                                                                              color: Colors.white,
                                                                              fontWeight: FontWeight.bold),
                                                                        ),
                                                                      ),
                                                                    ),
                                                                    ClipRRect(
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              20),
                                                                      child:
                                                                          MaterialButton(
                                                                        onPressed:
                                                                            () {
                                                                          Navigator.pop(
                                                                              dialogContext);
                                                                        },
                                                                        color:
                                                                            mainColor,
                                                                        height:
                                                                            50,
                                                                        child:
                                                                            const Text(
                                                                          'Cancel',
                                                                          style:
                                                                              TextStyle(
                                                                            color:
                                                                                Colors.white,
                                                                            fontWeight:
                                                                                FontWeight.bold,
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
                                                      color: mainColor,
                                                      minWidth:
                                                          mediaQuery(context)
                                                              .width,
                                                      height: 50,
                                                      child: const Text(
                                                        'COMPELETE',
                                                        style: TextStyle(
                                                            color: Colors.white,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                      ),
                                                    ),
                                                  ),
                                                  const SizedBox(height: 10),
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
                            ],
                          ),
                  ),
                ),
        );
      },
    );
  }
}
