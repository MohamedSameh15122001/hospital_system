import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:hospital_system/modules/manager_modules/manager_add_medicine.dart';
import 'package:hospital_system/modules/manager_modules/manager_search_medication.dart';
import 'package:hospital_system/modules/manager_modules/manager_update_medicine.dart';
import 'package:hospital_system/shared/components/constants.dart';
import 'package:hospital_system/shared/main_cubit/manager_cubit/manager_cubit.dart';
import 'package:hospital_system/shared/main_cubit/manager_cubit/manager_states.dart';

import '../../shared/components/end_points.dart';

class MangerShowMedicines extends StatelessWidget {
  const MangerShowMedicines({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ManagerCubit, ManagerState>(
      bloc: ManagerCubit.get(context)..getAllMedications(token: token!),
      listener: (context, state) {},
      builder: (context, state) {
        internetConection('manger', context);
        ManagerCubit cubit = ManagerCubit.get(context);
        return Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            title: const Text('Medications'),
            centerTitle: true,
            actions: [
              InkWell(
                onTap: () {
                  navigateToWithFade(context, MangerSearchMedication());
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
          body: state is LoadingGetAllMedications
              ? Center(
                  child: loading,
                )
              : state is ErrorGetAllMedications
                  ? Center(
                      child: Text(cubit.errorModel!.message!),
                    )
                  : cubit.getAllMedicationsModel!.result!.isEmpty
                      ? const Center(
                          child: Text('No Medications!'),
                        )
                      : cubit.getAllMedicationsModel == null
                          ? Center(
                              child: loading,
                            )
                          : Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: AnimationLimiter(
                                child: ListView.builder(
                                  physics: const BouncingScrollPhysics(),
                                  itemCount: cubit
                                      .getAllMedicationsModel!.result!.length,
                                  itemBuilder: (context, index) {
                                    var model = cubit
                                        .getAllMedicationsModel!.result![index];
                                    return AnimationConfiguration.staggeredList(
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
                                                curve: Curves
                                                    .fastLinearToSlowEaseIn,
                                                flipAxis: FlipAxis.y,
                                                child: GestureDetector(
                                                  onTap: () {
                                                    navigateToWithFade(
                                                        context,
                                                        MangerUpdateMedication(
                                                            id: model.sId!));
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
                                                          offset: const Offset(
                                                              0, 4),
                                                        )
                                                      ],
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              20),
                                                      color: Colors.white,
                                                    ),
                                                    child: ListTile(
                                                      leading:
                                                          const CircleAvatar(
                                                        radius: 30,
                                                        backgroundColor:
                                                            Color(0x9650DEC9),
                                                        backgroundImage: AssetImage(
                                                            'lib/assets/images/medication.jpg'),
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
                                                          const SizedBox(
                                                              height: 8),
                                                          Text(
                                                              'Active Ingredients: ${model.activeIngredients}'),
                                                          const SizedBox(
                                                              height: 4),
                                                          Text(
                                                              'Doses: ${model.doses}'),
                                                          const SizedBox(
                                                              height: 4),
                                                          Text(
                                                              'Warnings: ${model.warnings}'),
                                                          const SizedBox(
                                                              height: 4),
                                                          Text(
                                                              'Side Effects: ${model.sideEffects}'),
                                                          const SizedBox(
                                                              height: 8),
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
              navigateToWithFade(context, MangerAddMedication());
            },
          ),
        );
      },
    );
  }
}
