import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:hospital_system/shared/components/constants.dart';
import 'package:hospital_system/shared/components/end_points.dart';
import 'package:hospital_system/shared/main_cubit/manager_cubit/manager_cubit.dart';
import 'package:hospital_system/shared/main_cubit/manager_cubit/manager_states.dart';

class MangerUpdateNurse extends StatefulWidget {
  const MangerUpdateNurse({super.key, required this.id});
  final String id;

  @override
  State<MangerUpdateNurse> createState() => _MangerUpdateNurseState();
}

class _MangerUpdateNurseState extends State<MangerUpdateNurse> {
  final formKey = GlobalKey<FormState>();

  TextEditingController nameController = TextEditingController();

  TextEditingController phoneController = TextEditingController();

  TextEditingController emailController = TextEditingController();

  TextEditingController addressController = TextEditingController();

  TextEditingController departmentController = TextEditingController();
  @override
  void initState() {
    super.initState();
    internetConection('manger', context);
    ManagerCubit cubit = ManagerCubit.get(context);

    cubit.getSpecificNurse(token: token!, id: widget.id).then((value) {
      var model = cubit.getSpecificNurseModel!.result;
      nameController.text = model!.name!;
      phoneController.text = model.phone!;
      emailController.text = model.email!;
      addressController.text = model.address!;
      departmentController.text = model.department!;
    });
  }

  @override
  void dispose() {
    nameController.dispose();
    phoneController.dispose();
    emailController.dispose();
    addressController.dispose();
    departmentController.dispose();
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
            title: const Text('Update Nurse'),
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
                                    await cubit.setNursePasswordDefault(
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
                          'are you sure to delete the nurse!',
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
                                    await cubit.deleteNurse(
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
          body: state is LoadingGetSpecificNurse
              ? Center(child: loading)
              : state is ErrorGetSpecificNurse
                  ? Center(
                      child: Text(cubit.errorModel!.message!),
                    )
                  : cubit.getSpecificNurseModel == null
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
                                    state is LoadingDeleteNurse ||
                                            state
                                                is LoadingSetNursePasswordDefault
                                        ? Center(
                                            child: LinearProgressIndicator(
                                            color: Colors.teal,
                                            backgroundColor: mainColor,
                                          ))
                                        : Container(),
                                    const SizedBox(height: 20.0),
                                    Image.asset(
                                      'lib/assets/images/nurse.png',
                                      width: mediaQuery(context).width * .60,
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
                                    const SizedBox(height: 16.0),
                                    TextFormField(
                                      controller: addressController,
                                      decoration: InputDecoration(
                                        labelText: 'Address',
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
                                          return 'Please enter address';
                                        } else if (value.length < 5) {
                                          return 'Address must be between min 5 characters';
                                        } else if (value.length > 100) {
                                          return 'Address must be between max 100 characters';
                                        }
                                        return null;
                                      },
                                    ),
                                    const SizedBox(height: 16.0),
                                    TextFormField(
                                      controller: departmentController,
                                      decoration: InputDecoration(
                                        labelText: 'Department',
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
                                          return 'Please enter department';
                                        } else if (value.length < 3) {
                                          return 'Department must be between min 3 characters';
                                        } else if (value.length > 30) {
                                          return 'Department must be between max 30 characters';
                                        }
                                        return null;
                                      },
                                    ),
                                    const SizedBox(height: 20),
                                    state is LoadingUpdateNurseAccount
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
                                                addressController.text =
                                                    addressController.text
                                                        .trim();
                                                departmentController.text =
                                                    departmentController.text
                                                        .trim();
                                                if (formKey.currentState!
                                                    .validate()) {
                                                  await cubit.updateNurseAccount(
                                                      name: nameController.text
                                                          .trim(),
                                                      email: emailController
                                                          .text
                                                          .trim(),
                                                      phone: phoneController
                                                          .text
                                                          .trim(),
                                                      address: addressController
                                                          .text
                                                          .trim(),
                                                      department:
                                                          departmentController
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
