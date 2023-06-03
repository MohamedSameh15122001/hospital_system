import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class NurseAddScedule extends StatefulWidget {
  const NurseAddScedule({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _NurseAddSceduleState createState() => _NurseAddSceduleState();
}

class _NurseAddSceduleState extends State<NurseAddScedule> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController patientController = TextEditingController();
  final TextEditingController scheduledTimeController = TextEditingController();
  final TextEditingController nurseController = TextEditingController();
  final TextEditingController doctorNotesController = TextEditingController();
  final List<Map<String, String>> medications = [];

  void handleAddMedication() {
    setState(() {
      medications.add({'medication': '', 'dose': ''});
    });
  }

  void handleRemoveMedication(int index) {
    setState(() {
      medications.removeAt(index);
    });
  }

  Future<void> handleSubmit() async {
    if (formKey.currentState!.validate()) {
      // Perform API call with the form data
      Map<String, dynamic> formData = {
        'patient': patientController.text,
        'medications': medications,
        'scheduledTime': scheduledTimeController.text,
        'nurse': nurseController.text,
        'doctorNotes': doctorNotesController.text,
        'completed': false,
      };

      try {
        final response = await http.post(
          Uri.parse('your-api-url'),
          body: formData,
        );

        if (response.statusCode == 200) {
          if (kDebugMode) {
            print('Task submitted successfully!');
          }
          // Perform any additional actions after successful submission
        } else {
          if (kDebugMode) {
            print('Error submitting task. Status code: ${response.statusCode}');
          }
          // Handle error scenario if needed
        }
      } catch (error) {
        if (kDebugMode) {
          print('Error submitting task: $error');
        }
        // Handle error scenario if needed
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Form(
        key: formKey,
        child: Column(
          children: [
            TextFormField(
              controller: patientController,
              decoration: const InputDecoration(labelText: 'Patient'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter the patient name';
                }
                return null;
              },
            ),
            TextFormField(
              controller: scheduledTimeController,
              decoration: const InputDecoration(labelText: 'Scheduled Time'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter the scheduled time';
                }
                return null;
              },
            ),
            TextFormField(
              controller: nurseController,
              decoration: const InputDecoration(labelText: 'Nurse'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter the nurse name';
                }
                return null;
              },
            ),
            TextFormField(
              controller: doctorNotesController,
              decoration: const InputDecoration(labelText: 'Doctor Notes'),
            ),
            Column(
              children: medications.map((medication) {
                int index = medications.indexOf(medication);
                return Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        decoration:
                            const InputDecoration(labelText: 'Medication'),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter the medication';
                          }
                          return null;
                        },
                        onChanged: (value) {
                          setState(() {
                            medications[index]['medication'] = value;
                          });
                        },
                      ),
                    ),
                    Expanded(
                      child: TextFormField(
                        decoration: const InputDecoration(labelText: 'Dose'),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter the dose';
                          }
                          return null;
                        },
                        onChanged: (value) {
                          setState(() {
                            medications[index]['dose'] = value;
                          });
                        },
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.remove),
                      onPressed: () => handleRemoveMedication(index),
                    ),
                  ],
                );
              }).toList(),
            ),
            TextButton(
              onPressed: handleAddMedication,
              child: const Text('Add Medication'),
            ),
            ElevatedButton(
              onPressed: handleSubmit,
              child: const Text('Submit'),
            ),
          ],
        ),
      ),
    );
  }
}
