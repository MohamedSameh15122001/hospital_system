import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:hospital_system/modules/manager_modules/manager_add_doctor.dart';
import 'package:hospital_system/modules/manager_modules/manager_search_doctor.dart';
import 'package:hospital_system/modules/manager_modules/manager_update_doctor.dart';
import 'package:hospital_system/shared/components/constants.dart';

import '../../shared/components/end_points.dart';
import '../../shared/main_cubit/manager_cubit/manager_cubit.dart';
import '../../shared/main_cubit/manager_cubit/manager_states.dart';

class MangerShowDoctors extends StatelessWidget {
  const MangerShowDoctors({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ManagerCubit, ManagerState>(
      bloc: ManagerCubit.get(context)..getAllDoctors(token: token!),
      listener: (context, state) {},
      builder: (context, state) {
        internetConection('manger', context);
        ManagerCubit cubit = ManagerCubit.get(context);
        return Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            title: const Text('Doctors'),
            centerTitle: true,
            actions: [
              InkWell(
                onTap: () {
                  navigateToWithFade(context, MangerSearchDoctor());
                },
                child: CircleAvatar(
                  backgroundColor: mainColor,
                  child: const Icon(
                    Icons.search,
                    color: Colors.white,
                  ),
                ),
              ),
              const SizedBox(width: 20),
            ],
          ),
          body: state is LoadingGetAllDoctors
              ? Center(
                  child: loading,
                )
              : state is ErrorGetAllDoctors
                  ? Center(
                      child: Text(cubit.errorModel!.message!),
                    )
                  : cubit.getAllDoctorsModel!.result!.isEmpty
                      ? const Center(
                          child: Text('No Doctors!'),
                        )
                      : Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: AnimationLimiter(
                            child: ListView.builder(
                              physics: const BouncingScrollPhysics(),
                              itemCount:
                                  cubit.getAllDoctorsModel!.result!.length,
                              itemBuilder: (context, index) {
                                var model =
                                    cubit.getAllDoctorsModel!.result![index];
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
                                            curve:
                                                Curves.fastLinearToSlowEaseIn,
                                            flipAxis: FlipAxis.y,
                                            child: GestureDetector(
                                              onTap: () {
                                                navigateToWithFade(
                                                    context,
                                                    MangerUpdateDoctor(
                                                        id: model.sId!));
                                              },
                                              child: Container(
                                                margin: const EdgeInsets.all(8),
                                                decoration: BoxDecoration(
                                                  boxShadow: [
                                                    BoxShadow(
                                                      color:
                                                          Colors.grey.shade300,
                                                      blurRadius: 10,
                                                      offset:
                                                          const Offset(0, 4),
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
                                                          fontSize: 20),
                                                    ),
                                                  ),
                                                  subtitle: Column(
                                                    // mainAxisAlignment:
                                                    //     MainAxisAlignment.spaceBetween,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      const SizedBox(height: 8),
                                                      Text('ID: ${model.id}'),
                                                      const SizedBox(height: 4),
                                                      Text(
                                                          'Phone: ${model.phone}'),
                                                      const SizedBox(height: 4),
                                                      Text(
                                                          'Email: ${model.email}'),
                                                      const SizedBox(height: 4),
                                                      Text(
                                                          'Specialty: ${model.specialty}'),
                                                      const SizedBox(height: 8),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ))));
                              },
                            ),
                          ),
                        ),
          floatingActionButton: FloatingActionButton(
            child: const Icon(
              Icons.add,
              color: Colors.white,
            ),
            onPressed: () {
              navigateToWithFade(context, MangerAddDoctor());
            },
          ),
        );
      },
    );
  }
}
