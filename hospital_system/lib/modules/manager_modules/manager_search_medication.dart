import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:hospital_system/modules/manager_modules/manager_update_medicine.dart';
import 'package:hospital_system/shared/components/constants.dart';
import 'package:hospital_system/shared/components/end_points.dart';
import 'package:hospital_system/shared/main_cubit/manager_cubit/manager_cubit.dart';
import 'package:hospital_system/shared/main_cubit/manager_cubit/manager_states.dart';

class MangerSearchMedication extends StatelessWidget {
  MangerSearchMedication({super.key});
  final FocusNode _focusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    FocusScope.of(context).requestFocus(_focusNode);
    return BlocConsumer<ManagerCubit, ManagerState>(
      bloc: ManagerCubit.get(context)
        ..searchMedications(token: token!, input: ''),
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
                        labelText: 'Search Medication With Name Or ID',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                      ),
                      onChanged: (value) async {
                        await cubit.searchMedications(
                            token: token!, input: value);
                      },
                    ),
                    const SizedBox(height: 20),
                    state is LoadingSearchMedications
                        ? Center(
                            child: loading,
                          )
                        : state is ErrorSearchMedications
                            ? Center(
                                child: Text(cubit.errorModel!.message!),
                              )
                            : cubit.searchGetAllMedicationsModel!.result!
                                    .isEmpty
                                ? const Center(
                                    child: Text('No Medications!'),
                                  )
                                : Expanded(
                                    child: ListView.builder(
                                      physics: const BouncingScrollPhysics(),
                                      itemCount: cubit
                                          .searchGetAllMedicationsModel!
                                          .result!
                                          .length,
                                      itemBuilder: (context, index) {
                                        var model = cubit
                                            .searchGetAllMedicationsModel!
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
                                                      MangerUpdateMedication(
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
                                                    leading: const CircleAvatar(
                                                      radius: 30,
                                                      backgroundColor:
                                                          Color(0x9650DEC9),
                                                      backgroundImage: AssetImage(
                                                          'lib/assets/images/medication.jpg'),
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
