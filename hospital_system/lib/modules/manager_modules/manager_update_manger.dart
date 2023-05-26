import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
              ? const Center(child: CircularProgressIndicator())
              : SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Form(
                      key: formKey,
                      child: Column(
                        children: [
                          state is LoadingDeleteManger
                              ? const Center(
                                  child: LinearProgressIndicator(
                                  color: Colors.teal,
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
                                borderRadius: BorderRadius.circular(20.0),
                              ),
                            ),
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Please enter name';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 16.0),
                          TextFormField(
                            controller: emailController,
                            decoration: InputDecoration(
                              labelText: 'Email',
                              border: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: mainColor,
                                  width: 2.0,
                                ),
                                borderRadius: BorderRadius.circular(20.0),
                              ),
                            ),
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Please enter email';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 16.0),
                          TextFormField(
                            controller: phoneController,
                            decoration: InputDecoration(
                              labelText: 'Phone',
                              border: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: mainColor,
                                  width: 2.0,
                                ),
                                borderRadius: BorderRadius.circular(20.0),
                              ),
                            ),
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Please enter phone';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 20),
                          state is LoadingUpdateMangerAccount
                              ? const Center(child: CircularProgressIndicator())
                              : ClipRRect(
                                  borderRadius: BorderRadius.circular(20),
                                  child: MaterialButton(
                                    onPressed: () async {
                                      if (formKey.currentState!.validate()) {
                                        await cubit.updateMangerAccount(
                                            name: nameController.text,
                                            email: emailController.text,
                                            phone: phoneController.text,
                                            id: widget.id,
                                            token: token!,
                                            context: context);
                                      }
                                    },
                                    color: mainColor,
                                    minWidth: mediaQuery(context).width,
                                    height: 50,
                                    child: const Text(
                                      'UPDATE',
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold),
                                    ),
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
