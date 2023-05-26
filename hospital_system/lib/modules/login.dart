import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hospital_system/shared/components/constants.dart';
import 'package:hospital_system/shared/main_cubit/manager_cubit/manager_cubit.dart';
import 'package:hospital_system/shared/main_cubit/manager_cubit/manager_states.dart';

class Login extends StatelessWidget {
  Login({super.key});
  final formKey = GlobalKey<FormState>();
  final TextEditingController idController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    internetConection(context);
    return Scaffold(
      body: BlocConsumer<ManagerCubit, ManagerState>(
        bloc: ManagerCubit.get(context),
        listener: (context, state) {},
        builder: (context, state) {
          ManagerCubit cubit = ManagerCubit.get(context);
          return SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: formKey,
                child: Column(
                  // mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(height: 60.0),
                    Image.asset(
                      'lib/assets/images/login_image.png',
                      width: mediaQuery(context).width * .80,
                    ),
                    const SizedBox(height: 40.0),
                    TextFormField(
                      controller: idController,
                      decoration: InputDecoration(
                        labelText: 'Id',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                      ),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter your name';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16.0),
                    TextFormField(
                      controller: passwordController,
                      decoration: InputDecoration(
                        labelText: 'Password',
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
                          return 'Please enter your password';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Row(
                          children: [
                            Radio(
                              value: 'Manger',
                              groupValue: cubit.who,
                              onChanged: (value) {
                                cubit.changeRadio(value);
                              },
                            ),
                            const Text('Manger'),
                          ],
                        ),
                        Row(
                          children: [
                            Radio(
                              value: 'Doctor',
                              groupValue: cubit.who,
                              onChanged: (value) {
                                cubit.changeRadio(value);
                              },
                            ),
                            const Text('Doctor'),
                          ],
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Row(
                          children: [
                            Radio(
                              value: 'Nurse',
                              groupValue: cubit.who,
                              onChanged: (value) {
                                cubit.changeRadio(value);
                              },
                            ),
                            const Text('Nurse'),
                          ],
                        ),
                        Row(
                          children: [
                            Radio(
                              value: 'Patient',
                              groupValue: cubit.who,
                              onChanged: (value) {
                                cubit.changeRadio(value);
                              },
                            ),
                            const Text('Patient'),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    state is LoadingMangerLogin || state is LoadingDoctorLogin
                        ? const Center(child: CircularProgressIndicator())
                        : ClipRRect(
                            borderRadius: BorderRadius.circular(20),
                            child: MaterialButton(
                              onPressed: () async {
                                if (formKey.currentState!.validate()) {
                                  if (cubit.who == "Manger") {
                                    await cubit.mangerLogin(
                                        id: idController.text,
                                        password: passwordController.text,
                                        context: context);
                                  } else if (cubit.who == "Doctor") {
                                    await cubit.doctorLogin(
                                        id: idController.text,
                                        password: passwordController.text,
                                        context: context);
                                  } else if (cubit.who == "Nurse") {
                                    await cubit.nurseLogin(
                                        id: idController.text,
                                        password: passwordController.text,
                                        context: context);
                                  } else if (cubit.who == "Patient") {
                                    await cubit.patientLogin(
                                        id: idController.text,
                                        password: passwordController.text,
                                        context: context);
                                  }
                                }
                              },
                              color: mainColor,
                              minWidth: mediaQuery(context).width,
                              height: 50,
                              child: const Text(
                                'LOGIN',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),

                    // RadioListTile(
                    //   title: const Text('patient'),
                    //   value: 3,
                    //   groupValue: _selectedValue,
                    //   onChanged: (value) {},
                    // ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
