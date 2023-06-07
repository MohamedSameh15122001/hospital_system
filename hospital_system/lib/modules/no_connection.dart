// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hospital_system/modules/doctor_modules/doctor_home.dart';
import 'package:hospital_system/modules/manager_modules/manager_home.dart';
import 'package:hospital_system/shared/components/constants.dart';

import '../shared/main_cubit/manager_cubit/manager_cubit.dart';
import '../shared/main_cubit/manager_cubit/manager_states.dart';

class NoConnection extends StatelessWidget {
  const NoConnection({super.key, required this.who});
  final String who;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ManagerCubit, ManagerState>(
      listener: (context, state) {},
      builder: (context, state) {
        return Scaffold(
          body: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: AnimationConfiguration.toStaggeredList(
                duration: const Duration(milliseconds: 500),
                childAnimationBuilder: (widget) => FlipAnimation(
                      child: FadeInAnimation(
                        child: widget,
                      ),
                    ),
                children: [
                  Text(
                    "No connection",
                    style: GoogleFonts.poppins(fontSize: 25),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  const Icon(
                    Icons.wifi,
                    size: 170,
                    color: Colors.grey,
                  ),
                  Text(
                    "An internet error occurred, please try again",
                    style: GoogleFonts.poppins(
                        fontSize: 15, fontWeight: FontWeight.w300),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: MaterialButton(
                        onPressed: () async {
                          await internetConection(context);
                          if (isNetworkConnection) {
                            switch (who) {
                              case 'manger':
                                navigateAndFinishWithFade(
                                    context, const MangerHome());
                                break;
                              case 'doctor':
                                navigateAndFinishWithFade(
                                    context, const DoctorHome());
                                break;
                              case 'nurse':
                                break;
                              case 'patient':
                                break;
                              default:
                            }
                          } else {}
                        },
                        minWidth: MediaQuery.of(context).size.width,
                        height: 50,
                        color: primaryColor,
                        child: Text("TRY AGAIN",
                            style: GoogleFonts.poppins(
                              color: Colors.white,
                              fontSize: 20,
                            )),
                      ),
                    ),
                  ),
                ]),
          ),
        );
      },
    );
  }
}
