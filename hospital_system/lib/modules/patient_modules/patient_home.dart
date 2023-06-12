import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:hospital_system/modules/patient_modules/patient_profile.dart';
import 'package:hospital_system/shared/main_cubit/patient_cubit/patient_cubit.dart';
import 'package:hospital_system/shared/main_cubit/patient_cubit/patient_states.dart';

import '../../shared/components/constants.dart';
import '../../shared/components/end_points.dart';

class PatientHome extends StatelessWidget {
  const PatientHome({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<PatientCubit, PatientState>(
      bloc: PatientCubit.get(context)..getPatientDiagnosis(token: token!),
      listener: (context, state) {},
      builder: (context, state) {
        internetConection('patient', context);
        PatientCubit cubit = PatientCubit.get(context);
        var model = cubit.getPatientDiagnosisModel?.result?.first;
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
                    navigateToWithFade(context, const PatientProfile());
                  },
                  child: const CircleAvatar(
                    backgroundColor: Color(0x3850DEC9),
                    radius: 24,
                    backgroundImage:
                        AssetImage('lib/assets/images/patient.png'),
                  ),
                ),
              ],
            ),
            centerTitle: true,
          ),
          body: state is LoadingGetPatientDiagnosis
              ? const Center(child: CircularProgressIndicator())
              : state is ErrorGetPatientDiagnosis
                  ? Center(
                      child: Text(cubit.errorModel!.message!),
                    )
                  : SingleChildScrollView(
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
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(height: 8),
                                Text('Name: ${model!.doctor!.name}'),
                                Text('ID: ${model.doctor!.id}'),
                                const SizedBox(height: 16),
                                const Text(
                                  'Patient:',
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(height: 8),
                                Text('Name: ${model.patient!.name}'),
                                Text('ID: ${model.patient!.name}'),
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
                                const SizedBox(height: 10),
                                Text(
                                  '${model.prescription}',
                                  style: const TextStyle(fontSize: 18),
                                ),
                                const SizedBox(height: 16),
                                const Divider(),
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
                                Text(
                                  '${model.diagnosis}',
                                  style: const TextStyle(fontSize: 18),
                                ),
                                const SizedBox(height: 20),
                              ],
                            )),
                      ),
                    ),
        );
      },
    );
  }
}
