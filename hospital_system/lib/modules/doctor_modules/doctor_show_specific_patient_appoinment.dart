import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:hospital_system/shared/components/constants.dart';
import 'package:hospital_system/shared/components/end_points.dart';
import 'package:hospital_system/shared/main_cubit/nurse_cubit/nurse_cubit.dart';
import 'package:hospital_system/shared/main_cubit/nurse_cubit/nurse_states.dart';

class DoctorShowSpecificPatientAppoinment extends StatelessWidget {
  DoctorShowSpecificPatientAppoinment(
      {super.key, required this.patientId, required this.appointmentId});
  final String patientId;
  final String appointmentId;
  final TextEditingController noteController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<NurseCubit, NurseState>(
      bloc: NurseCubit.get(context)
        ..getSpecificPatientAppointment(
            token: token!, patientId: patientId, appointmentId: appointmentId),
      listener: (context, state) {},
      builder: (context, state) {
        internetConection('doctor', context);
        NurseCubit cubit = NurseCubit.get(context);
        var model = cubit.getSpecificPatientAppointmentModel?.result;
        return Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            title: const Text('Appointment details'),
            centerTitle: true,
          ),
          body: state is LoadingGetSpecificPatientAppointment
              ? Center(child: loading)
              : state is ErrorGetSpecificPatientAppointment
                  ? Center(
                      child: Text(cubit.errorModel!.message!),
                    )
                  : cubit.getSpecificPatientAppointmentModel == null
                      ? Center(
                          child: loading,
                        )
                      : SingleChildScrollView(
                          physics: const BouncingScrollPhysics(),
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
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
                                    state is LoadingDoctorAddNotes
                                        ? Padding(
                                            padding: const EdgeInsets.only(
                                                bottom: 20.0),
                                            child: LinearProgressIndicator(
                                              color: Colors.teal,
                                              backgroundColor: mainColor,
                                            ),
                                          )
                                        : Container(),
                                    Center(
                                      child: Image.asset(
                                        'lib/assets/images/appointment.png',
                                        width: mediaQuery(context).width * .40,
                                      ),
                                    ),
                                    const SizedBox(height: 16),
                                    Row(
                                      children: [
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            const Text(
                                              'Patient:',
                                              style: TextStyle(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            const SizedBox(height: 8),
                                            Text(
                                                'Name: ${model!.patient!.name}'),
                                            Text('ID: ${model.patient!.id}'),
                                          ],
                                        ),
                                        const Spacer(),
                                        Transform.scale(
                                          scale: 1.5,
                                          child: Checkbox(
                                            value: model.completed,
                                            onChanged: (value) {},
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 16),
                                    // const SizedBox(height: 16),
                                    // const Text(
                                    //   'Nurse:',
                                    //   style: TextStyle(
                                    //       fontSize: 18,
                                    //       fontWeight: FontWeight.bold),
                                    // ),
                                    // const SizedBox(height: 8),
                                    // Text('Name: ${model.nurse!.name}'),
                                    // Text('ID: ${model.nurse!.id}'),
                                    const SizedBox(height: 16),
                                    const Text(
                                      'medications:',
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
                                    ListView.builder(
                                      physics:
                                          const NeverScrollableScrollPhysics(),
                                      shrinkWrap: true,
                                      itemCount: model.medications!.length,
                                      itemBuilder: (context, index) {
                                        return Row(
                                          children: [
                                            Text(model.medications?[index]
                                                    .medication!.name ??
                                                ''),
                                            const SizedBox(width: 20),
                                            const Icon(Icons.arrow_forward),
                                            const Spacer(),
                                            Text(model
                                                    .medications?[index].dose ??
                                                ''),
                                          ],
                                        );
                                      },
                                    ),
                                    const SizedBox(height: 4),
                                    const Divider(),
                                    const SizedBox(height: 4),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const SizedBox(height: 8),
                                        Text(
                                          'Created At: ${formatDateToPrint(model.createdAt!)}',
                                          style: TextStyle(
                                              fontSize: 18,
                                              color: Colors.grey.shade800),
                                        ),
                                        const Divider(),
                                        const SizedBox(height: 4),
                                        Text(
                                          'Schedule: ${model.schedule.toString()}',
                                          style: TextStyle(
                                              fontSize: 18,
                                              color: Colors.grey.shade800),
                                        ),
                                        const Divider(),
                                        const SizedBox(height: 4),
                                        model.doctorNotes != null
                                            ? Text(
                                                'Doctor Notes: ${model.doctorNotes ?? 'No Doctor Notes'}',
                                                style: TextStyle(
                                                    fontSize: 18,
                                                    color:
                                                        Colors.grey.shade800),
                                              )
                                            : SizedBox(
                                                width: 140,
                                                child: ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.circular(20),
                                                  child: MaterialButton(
                                                    onPressed: () async {
                                                      showDialog(
                                                        context: context,
                                                        builder: (sContext) {
                                                          return AlertDialog(
                                                            title: Form(
                                                              key: formKey,
                                                              child: Column(
                                                                children: [
                                                                  const Text(
                                                                    'Add Note',
                                                                    style:
                                                                        TextStyle(
                                                                      fontSize:
                                                                          16,
                                                                    ),
                                                                  ),
                                                                  const SizedBox(
                                                                      height:
                                                                          20),
                                                                  TextFormField(
                                                                    controller:
                                                                        noteController,
                                                                    maxLines: 6,
                                                                    decoration:
                                                                        const InputDecoration(
                                                                      labelText:
                                                                          'Note',
                                                                    ),
                                                                    validator:
                                                                        (value) {
                                                                      if (value!
                                                                          .isEmpty) {
                                                                        return 'Please enter Note';
                                                                      } else if (value
                                                                              .length <
                                                                          3) {
                                                                        return 'Note must be between min 3 characters';
                                                                      } else if (value
                                                                              .length >
                                                                          1000) {
                                                                        return 'Note must be between max 1000 characters';
                                                                      }
                                                                      return null;
                                                                    },
                                                                  ),
                                                                ],
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
                                                                        if (formKey
                                                                            .currentState!
                                                                            .validate()) {
                                                                          Navigator.pop(
                                                                              sContext);
                                                                          await cubit.doctorAddNotes(
                                                                              doctorNotes: noteController.text,
                                                                              id: model.sId!,
                                                                              token: token!,
                                                                              context: context);
                                                                        }
                                                                      },
                                                                      color:
                                                                          mainColor,
                                                                      height:
                                                                          50,
                                                                      child:
                                                                          const Text(
                                                                        'Send',
                                                                        style: TextStyle(
                                                                            color:
                                                                                Colors.white,
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
                                                                            context);
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
                                                      'ADD NOTE',
                                                      style: TextStyle(
                                                          color: Colors.white,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                        const Divider(),
                                        const SizedBox(height: 4),
                                      ],
                                    ),
                                  ],
                                )),
                          ),
                        ),
        );
      },
    );
  }
}
