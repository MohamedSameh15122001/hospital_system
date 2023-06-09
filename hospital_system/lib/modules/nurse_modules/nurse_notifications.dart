import 'package:flutter/material.dart';

import '../../shared/components/constants.dart';

class NurseNotifications extends StatelessWidget {
  const NurseNotifications({super.key});

  @override
  Widget build(BuildContext context) {
    internetConection('nurse', context);
    return const Center(
      child: Text('notification'),
    );
  }
}
