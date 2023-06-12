import 'package:flutter/material.dart';
import 'package:hospital_system/shared/components/constants.dart';

class PatientNotifications extends StatelessWidget {
  const PatientNotifications({super.key});

  @override
  Widget build(BuildContext context) {
    internetConection('patient', context);
    return const Center(
      child: Text('Notification'),
    );
  }
}
