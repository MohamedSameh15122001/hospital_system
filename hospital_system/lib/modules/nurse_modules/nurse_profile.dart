import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:hospital_system/modules/nurse_modules/nurse_change_password.dart';
import 'package:hospital_system/shared/components/end_points.dart';
import 'package:hospital_system/shared/main_cubit/nurse_cubit/nurse_cubit.dart';
import 'package:hospital_system/shared/main_cubit/nurse_cubit/nurse_states.dart';

import '../../shared/components/constants.dart';

class NurseProfile extends StatelessWidget {
  const NurseProfile({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<NurseCubit, NurseState>(
      bloc: NurseCubit.get(context)..getNurseProfile(token: token!),
      listener: (context, state) {},
      builder: (context, state) {
        internetConection('nurse', context);
        NurseCubit cubit = NurseCubit.get(context);
        var model = cubit.getNurseProfileModel?.data;
        return Scaffold(
          appBar: AppBar(
            backgroundColor: mainColor,
            elevation: 0,
            title: const Text(
              'Profile',
              style:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
            centerTitle: true,
            leading: IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: const Icon(
                  Icons.arrow_back,
                  color: Colors.white,
                )),
          ),
          body: state is LoadingGetNurseProfile
              ? Center(child: loading)
              : state is ErrorGetNurseProfile
                  ? Center(
                      child: Text(cubit.errorModel!.message!),
                    )
                  : SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      child: Padding(
                        padding: const EdgeInsets.all(0.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: AnimationConfiguration.toStaggeredList(
                            duration: const Duration(milliseconds: 500),
                            childAnimationBuilder: (widget) => SlideAnimation(
                              horizontalOffset: 50.0,
                              child: FadeInAnimation(
                                child: widget,
                              ),
                            ),
                            children: [
                              SizedBox(
                                height: MediaQuery.of(context).size.height * .2,
                                width: MediaQuery.of(context).size.width,
                                child: Stack(
                                  children: [
                                    SizedBox(
                                      height:
                                          MediaQuery.of(context).size.height *
                                              .2,
                                      width: MediaQuery.of(context).size.width,
                                      child: ClipPath(
                                        clipper: _NameClipper(),
                                        child: Container(color: mainColor),
                                      ),
                                    ),
                                    Align(
                                      alignment: const Alignment(0, .2),
                                      child: CircleAvatar(
                                        radius: 60,
                                        backgroundColor:
                                            const Color(0x9650DEC9),
                                        backgroundImage:
                                            NetworkImage(model!.profileImage!),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Center(
                                child: Text(
                                  model.name!,
                                  style: const TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const SizedBox(height: 8),
                                    Text(
                                      'ID: ${model.id}',
                                      style: TextStyle(
                                          fontSize: 18,
                                          color: Colors.grey.shade800),
                                    ),
                                    const Divider(),
                                    const SizedBox(height: 4),
                                    Text(
                                      'Phone: ${model.phone}',
                                      style: TextStyle(
                                          fontSize: 18,
                                          color: Colors.grey.shade800),
                                    ),
                                    const Divider(),
                                    const SizedBox(height: 4),
                                    Text(
                                      'Email: ${model.email}',
                                      style: TextStyle(
                                          fontSize: 18,
                                          color: Colors.grey.shade800),
                                    ),
                                    const Divider(),
                                    const SizedBox(height: 4),
                                    Text(
                                      'address: ${model.address}',
                                      style: TextStyle(
                                          fontSize: 18,
                                          color: Colors.grey.shade800),
                                    ),
                                    const Divider(),
                                    const SizedBox(height: 4),
                                    Text(
                                      'department: ${model.department}',
                                      style: TextStyle(
                                          fontSize: 18,
                                          color: Colors.grey.shade800),
                                    ),
                                    const Divider(),
                                    const SizedBox(height: 8),
                                    SizedBox(
                                      width: 200,
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(20),
                                        child: MaterialButton(
                                          onPressed: () {
                                            navigateToWithFade(
                                                context, NurseChangePassword());
                                          },
                                          color: mainColor,
                                          minWidth: mediaQuery(context).width,
                                          height: 50,
                                          child: const Text(
                                            'CHANGE PASSWORD',
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
          bottomSheet: Padding(
            padding: const EdgeInsets.all(16.0),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: MaterialButton(
                onPressed: () async {
                  await signOut(context);
                },
                color: mainColor,
                minWidth: mediaQuery(context).width,
                height: 50,
                child: const Text(
                  'SIGN OUT',
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class _NameClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();

    path.moveTo(0, 0);
    path.lineTo(size.width, 0);
    path.lineTo(size.width, size.height * .3);

    //x1,y1 the point to going | x2,y2 the point to draw
    path.quadraticBezierTo(size.width * .5, size.height, 0, size.height * .3);

    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => true;
}
