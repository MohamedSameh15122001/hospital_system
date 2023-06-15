import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:hospital_system/modules/nurse_modules/nurse_show_patient_informations.dart';
import 'package:hospital_system/shared/components/constants.dart';
import 'package:hospital_system/shared/components/end_points.dart';
import 'package:hospital_system/shared/main_cubit/manager_cubit/manager_cubit.dart';
import 'package:hospital_system/shared/main_cubit/manager_cubit/manager_states.dart';

class NurseSearchPatient extends StatelessWidget {
  NurseSearchPatient({super.key});
  final FocusNode _focusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    FocusScope.of(context).requestFocus(_focusNode);
    return BlocConsumer<ManagerCubit, ManagerState>(
      bloc: ManagerCubit.get(context)..searchPatients(token: token!, input: ''),
      listener: (context, state) {},
      builder: (context, state) {
        internetConection('nurse', context);
        ManagerCubit cubit = ManagerCubit.get(context);
        return Scaffold(
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: AnimationLimiter(
                child: Column(
                  children: [
                    TextFormField(
                      focusNode: _focusNode,
                      decoration: InputDecoration(
                        labelText: 'Search Patient With Name Or ID',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                      ),
                      onChanged: (value) async {
                        await cubit.searchPatients(token: token!, input: value);
                      },
                    ),
                    const SizedBox(height: 20),
                    state is LoadingSearchPatients
                        ? Center(
                            child: loading,
                          )
                        : state is ErrorSearchPatients
                            ? Center(
                                child: Text(cubit.errorModel!.message!),
                              )
                            : cubit.searchGetAllPatientsModel!.result!.isEmpty
                                ? const Center(
                                    child: Text('No Patients!'),
                                  )
                                : Expanded(
                                    child: ListView.builder(
                                      physics: const BouncingScrollPhysics(),
                                      itemCount: cubit
                                          .searchGetAllPatientsModel!
                                          .result!
                                          .length,
                                      itemBuilder: (context, index) {
                                        var model = cubit
                                            .searchGetAllPatientsModel!
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
