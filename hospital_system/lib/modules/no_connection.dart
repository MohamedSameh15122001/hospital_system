import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hospital_system/shared/components/constants.dart';

import '../shared/main_cubit/manager_cubit/manager_cubit.dart';
import '../shared/main_cubit/manager_cubit/manager_states.dart';

class NoConnection extends StatelessWidget {
  const NoConnection({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ManagerCubit, ManagerState>(
      listener: (context, state) {},
      builder: (context, state) {
        return Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
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
                  onPressed: () {
                    internetConection(context).then((value) {
                      // navigateAndFinish(context, );
                    });
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
          ],
        );
      },
    );
  }
}
