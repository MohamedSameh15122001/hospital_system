import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hospital_system/modules/manager_modules/manager_show_doctors.dart';
import 'package:hospital_system/modules/manager_modules/manager_show_managers.dart';
import 'package:hospital_system/modules/manager_modules/manager_show_medication.dart';
import 'package:hospital_system/modules/manager_modules/manager_show_nurses.dart';
import 'package:hospital_system/modules/manager_modules/manager_show_patients.dart';
import 'package:hospital_system/shared/components/constants.dart';
import 'package:hospital_system/shared/main_cubit/manager_cubit/manager_cubit.dart';
import 'package:hospital_system/shared/main_cubit/manager_cubit/manager_states.dart';

class MangerHome extends StatelessWidget {
  const MangerHome({super.key});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: Colors.grey.shade200,
        statusBarIconBrightness: Brightness.dark,
      ),
    );
    return BlocConsumer<ManagerCubit, ManagerState>(
      bloc: ManagerCubit.get(context),
      listener: (context, state) {},
      builder: (context, state) {
        ManagerCubit cubit = ManagerCubit.get(context);
        return Scaffold(
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Row(
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
                      const CircleAvatar(
                        backgroundColor: Color(0x3850DEC9),
                        radius: 24,
                        backgroundImage:
                            AssetImage('lib/assets/images/manger.png'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 30),
                  Expanded(
                    child: GridView.builder(
                      physics: const BouncingScrollPhysics(),
                      itemCount: 5,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2, childAspectRatio: .8),
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onTap: () {
                            switch (index) {
                              case 0:
                                navigateTo(context, const MangerShowMangers());
                                break;
                              case 1:
                                navigateTo(context, const MangerShowDoctors());
                                break;
                              case 2:
                                navigateTo(context, const MangerShowNurses());
                                break;
                              case 3:
                                navigateTo(context, const MangerShowPatients());
                                break;
                              case 4:
                                navigateTo(
                                    context, const MangerShowMedicines());
                                break;
                              default:
                            }
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
                              borderRadius: BorderRadius.circular(20),
                              color: Colors.white,
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                // const SizedBox(height: 20),
                                CircleAvatar(
                                  backgroundColor: const Color(0x9650DEC9),
                                  backgroundImage:
                                      AssetImage(cubit.images[index]),
                                  radius: 50,
                                ),
                                Text(
                                  cubit.names[index],
                                  style: TextStyle(
                                      fontSize: 22,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.grey.shade700),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
