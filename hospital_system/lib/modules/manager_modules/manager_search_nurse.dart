import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:hospital_system/modules/manager_modules/manager_update_nurse.dart';
import 'package:hospital_system/shared/components/constants.dart';
import 'package:hospital_system/shared/components/end_points.dart';
import 'package:hospital_system/shared/main_cubit/manager_cubit/manager_cubit.dart';
import 'package:hospital_system/shared/main_cubit/manager_cubit/manager_states.dart';

class MangerSearchNurse extends StatelessWidget {
  MangerSearchNurse({super.key});
  final FocusNode _focusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    FocusScope.of(context).requestFocus(_focusNode);
    return BlocConsumer<ManagerCubit, ManagerState>(
      bloc: ManagerCubit.get(context)..searchNurses(token: token!, input: ''),
      listener: (context, state) {},
      builder: (context, state) {
        internetConection('manger', context);
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
                        labelText: 'Search Nurse With Name Or ID',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                      ),
                      onChanged: (value) async {
                        await cubit.searchNurses(token: token!, input: value);
                      },
                    ),
                    const SizedBox(height: 20),
                    state is LoadingSearchNurses
                        ? Center(
                            child: loading,
                          )
                        : state is ErrorSearchNurses
                            ? Center(
                                child: Text(cubit.errorModel!.message!),
                              )
                            : cubit.searchGetAllNursesModel!.result!.isEmpty
                                ? const Center(
                                    child: Text('No Nurses!'),
                                  )
                                : cubit.searchGetAllNursesModel == null
                                    ? Center(
                                        child: loading,
                                      )
                                    : Expanded(
                                        child: ListView.builder(
                                          physics:
                                              const BouncingScrollPhysics(),
                                          itemCount: cubit
                                              .searchGetAllNursesModel!
                                              .result!
                                              .length,
                                          itemBuilder: (context, index) {
                                            var model = cubit
                                                .searchGetAllNursesModel!
                                                .result![index];
                                            return AnimationConfiguration
                                                .staggeredList(
                                              position: index,
                                              delay: const Duration(
                                                  milliseconds: 100),
                                              child: SlideAnimation(
                                                duration: const Duration(
                                                    milliseconds: 2500),
                                                curve: Curves
                                                    .fastLinearToSlowEaseIn,
                                                horizontalOffset: 30, //-300
                                                verticalOffset: 300, //-850
                                                child: FlipAnimation(
                                                  duration: const Duration(
                                                      milliseconds: 3000),
                                                  curve: Curves
                                                      .fastLinearToSlowEaseIn,
                                                  flipAxis: FlipAxis.y,
                                                  child: GestureDetector(
                                                    onTap: () {
                                                      navigateToWithFade(
                                                          context,
                                                          MangerUpdateNurse(
                                                            id: model.sId!,
                                                          ));
                                                    },
                                                    child: Container(
                                                      margin:
                                                          const EdgeInsets.all(
                                                              8),
                                                      decoration: BoxDecoration(
                                                        boxShadow: [
                                                          BoxShadow(
                                                            color: Colors
                                                                .grey.shade300,
                                                            blurRadius: 10,
                                                            offset:
                                                                const Offset(
                                                                    0, 4),
                                                          )
                                                        ],
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(20),
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
                                                              const EdgeInsets
                                                                      .only(
                                                                  top: 12.0),
                                                          child: Text(
                                                            model.name!,
                                                            style:
                                                                const TextStyle(
                                                                    fontSize:
                                                                        20),
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
                                                            Text(
                                                                'ID: ${model.id}'),
                                                            const SizedBox(
                                                                height: 4),
                                                            Text(
                                                                'Phone: ${model.phone}'),
                                                            const SizedBox(
                                                                height: 4),
                                                            Text(
                                                                'Email: ${model.email}'),
                                                            const SizedBox(
                                                                height: 4),
                                                            Text(
                                                                'Address: ${model.address}'),
                                                            const SizedBox(
                                                                height: 4),
                                                            Text(
                                                                'department: ${model.department}'),
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
