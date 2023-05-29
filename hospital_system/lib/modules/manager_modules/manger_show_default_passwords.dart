import 'package:flutter/material.dart';
import 'package:hospital_system/shared/components/constants.dart';

class MangerShowDefaultPasswords extends StatelessWidget {
  const MangerShowDefaultPasswords({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: const Text('Default Passwords'),
          centerTitle: true,
        ),
        body: const SizedBox(
          width: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              PasswordCard(role: 'Manager', password: 'Manger#2023'),
              SizedBox(height: 16),
              PasswordCard(role: 'Doctor', password: 'Doctor#2023'),
              SizedBox(height: 16),
              PasswordCard(role: 'Nurse', password: 'Nurse#2023'),
              SizedBox(height: 16),
              PasswordCard(role: 'Patient', password: 'Patient#2023'),
            ],
          ),
        ));
  }
}

class PasswordCard extends StatelessWidget {
  final String role;
  final String password;

  const PasswordCard({super.key, required this.role, required this.password});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Role: $role',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: mainColor,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Default Password: $password',
              style: const TextStyle(
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
