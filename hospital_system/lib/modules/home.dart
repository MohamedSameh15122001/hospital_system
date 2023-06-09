import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hospital_system/shared/main_cubit/manager_cubit/manager_cubit.dart';
import 'package:hospital_system/shared/main_cubit/manager_cubit/manager_states.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<ManagerCubit, ManagerState>(
        bloc: ManagerCubit.get(context)
          ..getSpecificManger(
              id: '646e2250010c0175e240808d',
              token:
                  'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJVc2VySWQiOiI2NDZlMjI1MDAxMGMwMTc1ZTI0MDgwOGQiLCJuYW1lIjoiTW9oYW1lZCBOYXNzZXIiLCJyb2xlIjoibWFuZ2VyIiwiaWF0IjoxNjg0OTQwMzU4fQ.A1Ek8rI8TjdRy_Q75tLoj-x6DHuhemQ8N9ShmnQHi8Y'),
        listener: (context, state) {},
        builder: (context, state) {
          return Container(
            color: const Color(0x00575ce5),
          );
        },
      ),
    );
  }
}
