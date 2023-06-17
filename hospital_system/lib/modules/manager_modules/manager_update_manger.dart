import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:hospital_system/shared/components/constants.dart';
import 'package:hospital_system/shared/components/end_points.dart';
import 'package:hospital_system/shared/main_cubit/manager_cubit/manager_cubit.dart';

import '../../shared/main_cubit/manager_cubit/manager_states.dart';

class MangerUpdateManger extends StatefulWidget {
  const MangerUpdateManger({super.key, required this.id});
  final String id;

  @override
  State<MangerUpdateManger> createState() => _MangerUpdateMangerState();
}

class _MangerUpdateMangerState extends State<MangerUpdateManger> {
  final formKey = GlobalKey<FormState>();

  TextEditingController nameController = TextEditingController();

  TextEditingController phoneController = TextEditingController();

  TextEditingController emailController = TextEditingController();
  @override
  void initState() {
    super.initState();
    internetConection('manger', context);
    ManagerCubit cubit = ManagerCubit.get(context);

    cubit.getSpecificManger(token: token!, id: widget.id).then((value) {
      var model = cubit.getSpecificMangerModel!.result;
      nameController.text = model!.name!;
      phoneController.text = model.phone!;
      emailController.text = model.email!;
    });
  }

  @override
  void dispose() {
    nameController.dispose();
    phoneController.dispose();
    emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext lcontext) {
    return BlocConsumer<ManagerCubit, ManagerState>(
      bloc: ManagerCubit.get(context),
      listener: (context, state) {},
      builder: (context, state) {
        ManagerCubit cubit = ManagerCubit.get(context);
        return Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            title: const Text('Update Manger'),
            centerTitle: true,
            actions: [
              IconButton(
                onPressed: () async {
                  showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: const Text(
                          'are you sure to set password as default?',
                          style: TextStyle(
                            fontSize: 16,
                          ),
                        ),
                        actions: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(20),
                                child: MaterialButton(
                                  onPressed: () async {
                                    Navigator.pop(context);
                                    await cubit.setMangerPasswordDefault(
                                      token: token!,
                                      id: widget.id,
                                      context: lcontext,
                                    );
                                  },
                                  color: mainColor,
                                  height: 50,
                                  child: const Text(
                                    'Yes',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ),
                              ClipRRect(
                                borderRadius: BorderRadius.circular(20),
                                child: MaterialButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  color: mainColor,
                                  height: 50,
                                  child: const Text(
                                    'Cancel',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),
                        ],
                      );
                    },
                  );
                },
                icon: Icon(
                  Icons.password,
                  size: 30,
                  color: Colors.red.shade400,
                ),
              ),
              IconButton(
                onPressed: () async {
                  showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: const Text(
                          'are you sure to delete the manger!',
                          style: TextStyle(
                            fontSize: 16,
                          ),
                        ),
                        actions: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(20),
                                child: MaterialButton(
                                  onPressed: () async {
                                    Navigator.pop(context);
                                    await cubit.deleteManger(
                                      token: token!,
                                      id: widget.id,
                                      context: lcontext,
                                    );
                                  },
                                  color: mainColor,
                                  height: 50,
                                  child: const Text(
                                    'Yes',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ),
                              ClipRRect(
                                borderRadius: BorderRadius.circular(20),
                                child: MaterialButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  color: mainColor,
                                  height: 50,
                                  child: const Text(
                                    'Cancel',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),
                        ],
                      );
                    },
                  );
                },
                icon: Icon(
                  Icons.delete,
                  size: 30,
                  color: Colors.red.shade400,
                ),
              ),
              const SizedBox(width: 10),
            ],
          ),
          body: state is LoadingGetSpecificManger
              ? Center(child: loading)
              : state is ErrorGetSpecificManger
                  ? Center(
                      child: Text(cubit.errorModel!.message!),
                    )
                  : cubit.getSpecificMangerModel == null
                      ? Center(
                          child: loading,
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
                                  duration: const Duration(milliseconds: 500),
                                  childAnimationBuilder: (widget) =>
                                      FlipAnimation(
                                    child: FadeInAnimation(
                                      child: widget,
                                    ),
                                  ),
                                  children: [
                                    state is LoadingDeleteManger ||
                                            state
                                                is LoadingSetMangerPasswordDefault
                                        ? Center(
                                            child: LinearProgressIndicator(
                                            color: Colors.teal,
                                            backgroundColor: mainColor,
                                          ))
                                        : Container(),
                                    const SizedBox(height: 60.0),
                                    Image.asset(
                                      'lib/assets/images/manger.png',
                                      width: mediaQuery(context).width * .80,
                                    ),
                                    const SizedBox(height: 40.0),
                                    TextFormField(
                                      controller: nameController,
                                      decoration: InputDecoration(
                                        labelText: 'Name',
                                        border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(20.0),
                                        ),
                                      ),
                                      validator: (value) {
                                        if (value!.isEmpty) {
                                          return 'Please enter name';
                                        } else if (value.length < 3) {
                                          return 'Name must be between min 3 characters';
                                        } else if (value.length > 30) {
                                          return 'Name must be between max 30 characters';
                                        }
                                        return null;
                                      },
                                    ),
                                    const SizedBox(height: 16.0),
                                    TextFormField(
                                      keyboardType: TextInputType.emailAddress,
                                      controller: emailController,
                                      decoration: InputDecoration(
                                        labelText: 'Email',
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
                                          return 'Please enter email';
                                        } else if (isValidEmail(
                                                value.toString()) ==
                                            false) {
                                          return 'Email format is incorrect';
                                        }
                                        return null;
                                      },
                                    ),
                                    const SizedBox(height: 16.0),
                                    TextFormField(
                                      keyboardType: TextInputType.phone,
                                      controller: phoneController,
                                      decoration: InputDecoration(
                                        labelText: 'Phone',
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
                                          return 'Please enter phone';
                                        } else if (!RegExp(r'^[0-9]+$')
                                            .hasMatch(value)) {
                                          return 'Invalid phone number. Please enter only numeric digits';
                                        }
                                        return null;
                                      },
                                    ),
                                    const SizedBox(height: 20),
                                    state is LoadingUpdateMangerAccount
                                        ? Center(child: loading)
                                        : ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(20),
                                            child: MaterialButton(
                                              onPressed: () async {
                                                nameController.text =
                                                    nameController.text.trim();
                                                emailController.text =
                                                    emailController.text.trim();
                                                phoneController.text =
                                                    phoneController.text.trim();
                                                if (formKey.currentState!
                                                    .validate()) {
                                                  await cubit
                                                      .updateMangerAccount(
                                                          name: nameController
                                                              .text
                                                              .trim(),
                                                          email: emailController
                                                              .text
                                                              .trim(),
                                                          phone: phoneController
                                                              .text
                                                              .trim(),
                                                          id: widget.id,
                                                          token: token!,
                                                          context: context);
                                                }
                                              },
                                              color: mainColor,
                                              minWidth:
                                                  mediaQuery(context).width,
                                              height: 50,
                                              child: const Text(
                                                'UPDATE',
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            ),
                                          ),
                                  ],
                                )),
                              ),
                            ),
                          ),
                        ),
        );
      },
    );
  }
}
