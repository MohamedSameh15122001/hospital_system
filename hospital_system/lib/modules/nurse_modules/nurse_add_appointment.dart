// ignore_for_file: invalid_use_of_protected_member, invalid_use_of_visible_for_testing_member

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:hospital_system/shared/components/end_points.dart';

import '../../shared/components/constants.dart';
import '../../shared/main_cubit/manager_cubit/manager_cubit.dart';
import '../../shared/main_cubit/manager_cubit/manager_states.dart';
import '../../shared/main_cubit/nurse_cubit/nurse_cubit.dart';
import '../../shared/main_cubit/nurse_cubit/nurse_states.dart';

class NurseAddAppointment extends StatefulWidget {
  const NurseAddAppointment({
    super.key,
    this.patientId,
    this.schedule,
  });
  // ignore: prefer_typing_uninitialized_variables
  final patientId;
  // ignore: prefer_typing_uninitialized_variables
  final schedule;

  @override
  State<NurseAddAppointment> createState() => _NurseAddAppointmentState();
}

class _NurseAddAppointmentState extends State<NurseAddAppointment> {
  final formKey = GlobalKey<FormState>();

  final TextEditingController idController = TextEditingController();

  final TextEditingController scheduleController = TextEditingController();

  @override
  void initState() {
    internetConection('nurse', context);
    if (widget.patientId != null &&
        widget.schedule != null &&
        selectedMedicines.isNotEmpty &&
        medicineToApi.isNotEmpty) {
      idController.text = widget.patientId;
      scheduleController.text = widget.schedule.toString();
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ManagerCubit, ManagerState>(
      bloc: ManagerCubit.get(context)..getAllMedications(token: token!),
      listener: (context, managerstate) {},
      builder: (context, managerstate) {
        ManagerCubit managerCubit = ManagerCubit.get(context);
        var medicineModel = managerCubit.getAllMedicationsModel?.result;

        return BlocConsumer<NurseCubit, NurseState>(
          bloc: NurseCubit.get(context),
          listener: (context, nurseState) {},
          builder: (context, nurseState) {
            NurseCubit nurseCubit = NurseCubit.get(context);
            return Scaffold(
              appBar: AppBar(
                backgroundColor: Colors.transparent,
                elevation: 0,
                title: const Text('Add appointment'),
                centerTitle: true,
              ),
              body: managerstate is LoadingGetAllMedications
                  ? Center(child: loading)
                  : managerstate is ErrorGetAllMedications
                      ? Center(
                          child: Text(managerCubit.errorModel!.message!),
                        )
                      : SingleChildScrollView(
                          physics: const BouncingScrollPhysics(),
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Form(
                              key: formKey,
                              child: AnimationLimiter(
                                child: Column(
                                  children:
                                      AnimationConfiguration.toStaggeredList(
                                          duration:
                                              const Duration(milliseconds: 500),
                                          childAnimationBuilder: (widget) =>
                                              FlipAnimation(
                                                // curve: Curves.fastLinearToSlowEaseIn,
                                                child: FadeInAnimation(
                                                  // curve: Curves.fastLinearToSlowEaseIn,
                                                  child: widget,
                                                ),
                                              ),
                                          children: [
                                        // const SizedBox(height: 60.0),
                                        Image.asset(
                                          'lib/assets/images/appointment.png',
                                          width:
                                              mediaQuery(context).width * .40,
                                        ),
                                        const SizedBox(height: 40.0),
                                        TextFormField(
                                          controller: idController,
                                          decoration: InputDecoration(
                                            labelText: 'Patient ID',
                                            border: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(20.0),
                                            ),
                                          ),
                                          validator: (value) {
                                            if (value!.isEmpty) {
                                              return 'Please enter patient ID';
                                            } else if (!RegExp(r'^Pt.{6}$')
                                                .hasMatch(value)) {
                                              return 'ID should start with "Pt" and have a total length of 8 characters';
                                            }
                                            // else if (!RegExp(r'^Pt.{6}$')
                                            //     .hasMatch(value)) {
                                            //   return 'ID should start with "Pt" and have a total length of 8 characters';
                                            // }
                                            return null;
                                          },
                                        ),
                                        const SizedBox(height: 16.0),
                                        TextFormField(
                                          keyboardType: TextInputType.number,
                                          controller: scheduleController,
                                          decoration: InputDecoration(
                                            labelText: 'Schedule',
                                            border: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                color: mainColor,
                                                width: 2.0,
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(20.0),
                                            ),
                                          ),
                                          validator: (value) {
                                            if (value!.isEmpty) {
                                              return 'Please enter schedule';
                                            }
                                            return null;
                                          },
                                        ),
                                        const SizedBox(height: 20),
                                        managerCubit.med.isEmpty &&
                                                managerstate
                                                    is SuccessGetAllMedications
                                            ? const Center(
                                                child: Text(
                                                    'no medicines found please let manger add medicine first!'),
                                              )
                                            : Expanded(
                                                child: ListView.builder(
                                                  physics:
                                                      const BouncingScrollPhysics(),
                                                  shrinkWrap: true,
                                                  itemCount:
                                                      managerCubit.med.length,
                                                  itemBuilder:
                                                      (context, index) {
                                                    return CheckboxListTile(
                                                      title: Text(managerCubit
                                                          .med[index]),
                                                      value: selectedMedicines
                                                          .contains(managerCubit
                                                              .med[index]),
                                                      onChanged: (value) {
                                                        if (value!) {
                                                          selectedMedicines.add(
                                                              managerCubit
                                                                  .med[index]);
                                                          medicineToApi.add({
                                                            'medication':
                                                                medicineModel![
                                                                        index]
                                                                    .sId!,
                                                            'dose':
                                                                medicineModel[
                                                                        index]
                                                                    .doses!
                                                          });
                                                        } else {
                                                          selectedMedicines
                                                              .remove(
                                                                  managerCubit
                                                                          .med[
                                                                      index]);
                                                          medicineToApi.remove({
                                                            'medication':
                                                                medicineModel![
                                                                        index]
                                                                    .sId,
                                                            'dose':
                                                                medicineModel[
                                                                        index]
                                                                    .doses
                                                          });
                                                        }
                                                        nurseCubit.emit(
                                                            ChangeSelect());
                                                      },
                                                    );
                                                  },
                                                ),
                                              ),
                                        const SizedBox(height: 20),
                                        nurseState is LoadingAddAppointment
                                            ? Center(child: loading)
                                            : ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(20),
                                                child: MaterialButton(
                                                  onPressed: () async {
                                                    if (formKey.currentState!
                                                        .validate()) {
                                                      if (medicineToApi
                                                          .isEmpty) {
                                                        showToast(
                                                            text:
                                                                'must select at lest one medicne',
                                                            state: ToastStates
                                                                .WARNING);
                                                      } else {
                                                        await nurseCubit.addAppointment(
                                                            schedule: double.parse(
                                                                scheduleController
                                                                    .text
                                                                    .trim()),
                                                            id: idController
                                                                .text
                                                                .trim(),
                                                            medications:
                                                                medicineToApi,
                                                            token: token!,
                                                            context: context);
                                                      }
                                                    }
                                                  },
                                                  color: mainColor,
                                                  minWidth:
                                                      mediaQuery(context).width,
                                                  height: 50,
                                                  child: const Text(
                                                    'ADD',
                                                    style: TextStyle(
                                                        color: Colors.white,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                ),
                                              ),
                                      ]),
                                ),
                              ),
                            ),
                          ),
                        ),
            );
          },
        );
      },
    );
  }
}
