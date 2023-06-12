import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hospital_system/shared/components/constants.dart';
import 'package:hospital_system/shared/main_cubit/patient_cubit/patient_states.dart';

import '../../shared/main_cubit/patient_cubit/patient_cubit.dart';

class PatientLayout extends StatelessWidget {
  const PatientLayout({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<PatientCubit, PatientState>(
      listener: (context, state) {},
      builder: (context, state) {
        internetConection('patient', context);
        PatientCubit cubit = PatientCubit.get(context);
        return Scaffold(
          bottomNavigationBar: Container(
            margin: const EdgeInsets.all(20),
            height: mediaQuery(context).width * .155,
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(.15),
                  blurRadius: 30,
                  offset: const Offset(0, 10),
                ),
              ],
              borderRadius: BorderRadius.circular(50),
            ),
            child: ListView.builder(
              itemCount: 3,
              scrollDirection: Axis.horizontal,
              padding: EdgeInsets.symmetric(
                  horizontal: mediaQuery(context).width * .024),
              itemBuilder: (context, index) => InkWell(
                onTap: () {
                  cubit.changeBottomNavBar(index);
                },
                splashColor: Colors.transparent,
                highlightColor: Colors.transparent,
                child: Stack(
                  children: [
                    SizedBox(
                      width: mediaQuery(context).width * .2825,
                      child: Center(
                        child: AnimatedContainer(
                          duration: const Duration(seconds: 1),
                          curve: Curves.fastLinearToSlowEaseIn,
                          height: index == cubit.currentIndex
                              ? mediaQuery(context).width * .12
                              : 0,
                          width: index == cubit.currentIndex
                              ? mediaQuery(context).width * .3125
                              : 0,
                          decoration: BoxDecoration(
                            color: index == cubit.currentIndex
                                ? Colors.green.withOpacity(.2)
                                : Colors.transparent,
                            borderRadius: BorderRadius.circular(50),
                          ),
                        ),
                      ),
                    ),
                    Container(
                      width: mediaQuery(context).width * .2825,
                      alignment: Alignment.center,
                      child: Icon(
                        cubit.listOfIcons[index],
                        size: mediaQuery(context).width * .076,
                        color: index == mediaQuery(context).width
                            ? Colors.blueAccent
                            : Colors.black26,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          body: cubit.layoutPages[cubit.currentIndex],
        );
      },
    );
  }
}
