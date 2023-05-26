import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';

bool isNetworkConnection = true;
Future<void> internetConection(context) async {
  try {
    final result = await InternetAddress.lookup('example.com');
    if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
      isNetworkConnection = true;
    }
  } on SocketException catch (_) {
    isNetworkConnection = false;
    showSnackBar(context, 'Please Check Your Internet');
    // showTopSnackBar(
    //     context,
    //     const CustomSnackBar.success(
    //       backgroundColor: Colors.red,
    //       message: 'Please Check Your Internet',
    //       // icon: Icon(null),
    //     ),
    //   );
  }
}

Future<void> selectTime(
    context, TextEditingController controller, TimeOfDay selectedTime) async {
  final TimeOfDay? pickedTime = await showTimePicker(
    context: context,
    initialTime: TimeOfDay.now(),
  );

  if (pickedTime != null) {
    // setState(() {
    selectedTime = pickedTime;
    controller.text = pickedTime.format(context);
    // });
  }
}

Future<void> selectDate(
    BuildContext context, TextEditingController controller) async {
  final DateTime? picked = await showDatePicker(
    context: context,
    initialDate: DateTime.now(),
    firstDate: DateTime(2000),
    lastDate: DateTime(2100),
  );

  if (picked != null) {
    controller.text = picked.toString();
  }
}

bool isValidEmail(email) {
  return RegExp(
    r'^(([^<>()[\]\\.,;:\s@"]+(\.[^<>()[\]\\.,;:\s@"]+)*)|(".+"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$',
  ).hasMatch(email);
}

bool isValidPass(pass) {
  return RegExp(r"^(?=.*[a-zA-Z])(?=.*\d).{8,}$").hasMatch(pass);
}

String formatDateToPrint(String dateStr) {
  // to convert to 15-12-2000
  DateTime dateTime = DateTime.parse(dateStr);
  String formattedDate = DateFormat('dd-MM-yyyy').format(dateTime);
  // to convert to 15/12/2000
  // final originalFormat = DateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS'Z'");
  // final parsedDate = originalFormat.parse(dateStr);
  // final newFormat = DateFormat("dd/MM/yyyy");
  // final formattedDate = newFormat.format(parsedDate);
  return formattedDate;
}

String formatDateToGetFromDatePicker(String dateStr) {
  final originalFormat = DateFormat("yyyy-MM-dd HH:mm:ss.SSS");
  final parsedDate = originalFormat.parse(dateStr);
  final newFormat = DateFormat("dd-MM-yyyy");
  final formattedDate = newFormat.format(parsedDate);
  return formattedDate;
}

// String getDate(formattedString) {
//   DateTime dateTime = DateTime.parse(formattedString);
//   String date = DateFormat.yMMMd().format(dateTime);
//   return date;
// }

Color mainColor = const Color(0xFF00DEBD);

//the main color of the app which put in the primary Color
const MaterialColor primaryColor = MaterialColor(
  0xFF00DEBD,
  <int, Color>{
    50: Color(0xFF00DEBD),
    100: Color(0xFF00DEBD),
    200: Color(0xFF00DEBD),
    300: Color(0xFF00DEBD),
    400: Color(0xFF00DEBD),
    500: Color(0xFF00DEBD),
    600: Color(0xFF00DEBD),
    700: Color(0xFF00DEBD),
    800: Color(0xFF00DEBD),
    900: Color(0xFF00DEBD),
  },
);

void showToast({
  required String? text,
  required ToastStates state,
  int time = 5,
}) =>
    Fluttertoast.showToast(
      msg: text!,
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: time,
      backgroundColor: chooseToastColor(state), //main color of the app
      textColor: Colors.white,
      fontSize: 16.0,
    );

// enum
// ignore: constant_identifier_names
enum ToastStates { SUCCESS, ERROR, WARNING }

Color chooseToastColor(ToastStates state) {
  Color color;

  switch (state) {
    case ToastStates.SUCCESS:
      color = Colors.green;
      break;
    case ToastStates.ERROR:
      color = Colors.red;
      break;
    case ToastStates.WARNING:
      color = Colors.yellow.shade800;
      break;
  }

  return color;
}

showSnackBar(context, msg) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      backgroundColor: Colors.red,
      content: Text(
        msg,
        style: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      )));
}

void navigateTo(context, widget) {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => widget,
    ),
  );
}

void navigateAndFinish(context, widget) {
  Navigator.pushAndRemoveUntil(
    context,
    MaterialPageRoute(
      builder: (context) => widget,
    ),
    (Route<dynamic> route) => false,
  );
}

void printFullText(String text) {
  final pattern = RegExp('.{1,800}'); // 800 is the size of each chunk
  pattern.allMatches(text).forEach(
    (match) {
      if (kDebugMode) {
        return print(match.group(0));
      }
    },
  );
}

class MyDivider extends StatelessWidget {
  const MyDivider({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey[300],
      height: 1,
      width: double.infinity,
    );
  }
}

mediaQuery(context) => MediaQuery.of(context).size;
