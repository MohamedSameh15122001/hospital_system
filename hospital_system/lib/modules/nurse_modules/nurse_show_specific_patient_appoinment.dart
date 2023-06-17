// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:hospital_system/shared/components/constants.dart';
import 'package:hospital_system/shared/main_cubit/nurse_cubit/nurse_cubit.dart';

import '../../shared/components/end_points.dart';
import '../../shared/main_cubit/nurse_cubit/nurse_states.dart';

class NurseShowSpecificPatientAppoinment extends StatelessWidget {
  const NurseShowSpecificPatientAppoinment({
    Key? key,
    required this.patientId,
    required this.appointmentId,
  }) : super(key: key);
  final String patientId;
  final String appointmentId;
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<NurseCubit, NurseState>(
      bloc: NurseCubit.get(context)
        ..getSpecificPatientAppointment(
            token: token!, patientId: patientId, appointmentId: appointmentId),
      listener: (context, state) {},
      builder: (context, state) {
        internetConection('nurse', context);
        NurseCubit cubit = NurseCubit.get(context);
        var model = cubit.getSpecificPatientAppointmentModel?.result;
        return Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            title: const Text('Appoinment details'),
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
                                    const SizedBox(height: 16),
                                    const Text(
                                      'Nurse:',
                                      style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    const SizedBox(height: 8),
                                    Text('Name: ${model.nurse!.name}'),
                                    Text('ID: ${model.nurse!.id}'),
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
                                        Text(
                                          'Doctor Notes: ${model.doctorNotes ?? 'No Doctor Notes'}',
                                          style: TextStyle(
                                              fontSize: 18,
                                              color: Colors.grey.shade800),
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
