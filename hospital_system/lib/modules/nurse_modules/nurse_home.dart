import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:hospital_system/modules/nurse_modules/nurse_profile.dart';
import 'package:hospital_system/modules/nurse_modules/nurse_search_patient.dart';

import '../../shared/another/push_notification_service.dart';
import '../../shared/components/constants.dart';
import '../../shared/components/end_points.dart';
import '../../shared/main_cubit/manager_cubit/manager_cubit.dart';
import '../../shared/main_cubit/manager_cubit/manager_states.dart';
import 'nurse_show_patient_informations.dart';

class NurseHome extends StatelessWidget {
  const NurseHome({super.key});

  @override
  Widget build(BuildContext context) {
    // PushNotificationServicesApp..setupInteractMessage();
    PushNotificationsService.setupNotifications();
    return BlocConsumer<ManagerCubit, ManagerState>(
      bloc: ManagerCubit.get(context)..getAllPatients(token: token!),
      listener: (context, state) {},
      builder: (context, state) {
        internetConection('nurse', context);
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
                    navigateToWithFade(context, NurseSearchPatient());
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
                    navigateToWithFade(context, const NurseProfile());
                  },
                  child: const CircleAvatar(
                    backgroundColor: Color(0x3850DEC9),
                    radius: 24,
                    backgroundImage: AssetImage('lib/assets/images/nurse.png'),
                  ),
                ),
              ],
            ),
            centerTitle: true,
          ),
          body: state is LoadingGetAllPatients
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
                      : Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: AnimationLimiter(
                            child: ListView.builder(
                              physics: const BouncingScrollPhysics(),
                              itemCount:
                                  cubit.getAllPatientsModel!.result!.length,
                              itemBuilder: (context, index) {
                                var model =
                                    cubit.getAllPatientsModel!.result![index];
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
                                      duration:
                                          const Duration(milliseconds: 3000),
                                      curve: Curves.fastLinearToSlowEaseIn,
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
                                              padding: const EdgeInsets.only(
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
                        ),
        );
      },
    );
  }
}
