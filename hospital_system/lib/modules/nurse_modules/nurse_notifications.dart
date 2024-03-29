import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:hospital_system/shared/components/end_points.dart';
import 'package:hospital_system/shared/main_cubit/nurse_cubit/nurse_cubit.dart';
import 'package:hospital_system/shared/main_cubit/nurse_cubit/nurse_states.dart';

import '../../shared/components/constants.dart';

class NurseNotifications extends StatelessWidget {
  const NurseNotifications({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<NurseCubit, NurseState>(
      bloc: NurseCubit.get(context)..getAllNurseNotifications(token: token!),
      listener: (context, state) {},
      builder: (context, state) {
        internetConection('nurse', context);
        NurseCubit cubit = NurseCubit.get(context);

        return state is LoadingGetAllNurseNotifications
            ? Scaffold(
                body: Center(
                  child: loading,
                ),
              )
            : state is ErrorGetAllNurseNotifications
                ? Scaffold(
                    body: Center(
                      child: Text('${cubit.errorModel!.message!}!'),
                    ),
                  )
                : cubit.getAllNurseNotificationsModel == null
                    ? Scaffold(
                        body: Center(
                          child: loading,
                        ),
                      )
                    : Scaffold(
                        appBar: AppBar(
                          backgroundColor: Colors.transparent,
                          elevation: 0,
                          title: const Text('Notifications'),
                          centerTitle: true,
                          actions: [
                            TextButton(
                              onPressed: () async {
                                showDialog(
                                  context: context,
                                  builder: (context) {
                                    return AlertDialog(
                                      title: const Text(
                                        'are you sure to delete all notifications!',
                                        style: TextStyle(
                                          fontSize: 16,
                                        ),
                                      ),
                                      actions: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          children: [
                                            ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(20),
                                              child: MaterialButton(
                                                onPressed: () async {
                                                  Navigator.pop(context);
                                                  await cubit
                                                      .deleteAllNurseNotifications(
                                                          token: token!);
                                                },
                                                color: mainColor,
                                                height: 50,
                                                child: const Text(
                                                  'Yes',
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                              ),
                                            ),
                                            ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(20),
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
                              child: const Text(
                                'DELETE ALL',
                                style: TextStyle(
                                  color: Colors.red,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            const SizedBox(width: 16),
                          ],
                        ),
                        body: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: AnimationLimiter(
                            child: Column(
                              children: [
                                state is LoadingDeleteSpecificNurseNotification ||
                                        state
                                            is LoadingDeleteAllNurseNotifications
                                    ? LinearProgressIndicator(
                                        color: Colors.teal,
                                        backgroundColor: mainColor,
                                      )
                                    : Container(),
                                state is LoadingDeleteSpecificNurseNotification ||
                                        state
                                            is LoadingDeleteAllNurseNotifications
                                    ? const SizedBox(height: 20)
                                    : Container(),
                                Expanded(
                                  child: ListView.builder(
                                    physics: const BouncingScrollPhysics(),
                                    itemCount: cubit
                                        .getAllNurseNotificationsModel
                                        ?.notifications
                                        ?.length,
                                    itemBuilder: (context, index) {
                                      final reversedIndex = (cubit
                                              .getAllNurseNotificationsModel
                                              ?.notifications!
                                              .length)! -
                                          1 -
                                          index;
                                      var model = cubit
                                          .getAllNurseNotificationsModel
                                          ?.notifications?[reversedIndex];
                                      return AnimationConfiguration
                                          .staggeredList(
                                        position: index,
                                        delay:
                                            const Duration(milliseconds: 100),
                                        child: SlideAnimation(
                                          duration: const Duration(
                                              milliseconds: 2500),
                                          curve: Curves.fastLinearToSlowEaseIn,
                                          horizontalOffset: 30, //-300
                                          verticalOffset: 300, //-850
                                          child: FlipAnimation(
                                            duration: const Duration(
                                                milliseconds: 3000),
                                            curve:
                                                Curves.fastLinearToSlowEaseIn,
                                            flipAxis: FlipAxis.y,
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
                                                borderRadius:
                                                    BorderRadius.circular(20),
                                                color: Colors.white,
                                              ),
                                              child: ListTile(
                                                leading: Image.asset(
                                                    'lib/assets/images/notification.png'),
                                                title: Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          top: 12.0),
                                                  child: Row(
                                                    children: [
                                                      Flexible(
                                                        child: Text(
                                                          model!.title!,
                                                          style:
                                                              const TextStyle(
                                                            fontSize: 20,
                                                          ),
                                                        ),
                                                      ),
                                                      IconButton(
                                                          onPressed: () async {
                                                            showDialog(
                                                              context: context,
                                                              builder:
                                                                  (context) {
                                                                return AlertDialog(
                                                                  title:
                                                                      const Text(
                                                                    'are you sure to delete the notification!',
                                                                    style:
                                                                        TextStyle(
                                                                      fontSize:
                                                                          16,
                                                                    ),
                                                                  ),
                                                                  actions: [
                                                                    Row(
                                                                      mainAxisAlignment:
                                                                          MainAxisAlignment
                                                                              .spaceEvenly,
                                                                      children: [
                                                                        ClipRRect(
                                                                          borderRadius:
                                                                              BorderRadius.circular(20),
                                                                          child:
                                                                              MaterialButton(
                                                                            onPressed:
                                                                                () async {
                                                                              Navigator.pop(context);
                                                                              await cubit.deleteSpecificNurseNotification(token: token!, id: model.sId!);
                                                                            },
                                                                            color:
                                                                                mainColor,
                                                                            height:
                                                                                50,
                                                                            child:
                                                                                const Text(
                                                                              'Yes',
                                                                              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                                                                            ),
                                                                          ),
                                                                        ),
                                                                        ClipRRect(
                                                                          borderRadius:
                                                                              BorderRadius.circular(20),
                                                                          child:
                                                                              MaterialButton(
                                                                            onPressed:
                                                                                () {
                                                                              Navigator.pop(context);
                                                                            },
                                                                            color:
                                                                                mainColor,
                                                                            height:
                                                                                50,
                                                                            child:
                                                                                const Text(
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
                                                                    const SizedBox(
                                                                        height:
                                                                            20),
                                                                  ],
                                                                );
                                                              },
                                                            );
                                                          },
                                                          icon: const Icon(
                                                            Icons.delete,
                                                            color: Colors.red,
                                                          ))
                                                    ],
                                                  ),
                                                ),
                                                subtitle: Column(
                                                  // mainAxisAlignment:
                                                  //     MainAxisAlignment.spaceBetween,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                        'date: ${formatDateWithHours(model.date!)}'),
                                                    const SizedBox(height: 8),
                                                    Text(model.description!),
                                                    const SizedBox(height: 8),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
      },
    );
  }
}
