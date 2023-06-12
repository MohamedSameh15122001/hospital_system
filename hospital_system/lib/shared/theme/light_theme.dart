import 'package:flutter/material.dart';

import '../components/constants.dart';

ThemeData lightTheme = ThemeData(
  scaffoldBackgroundColor: Colors.grey.shade200,
  brightness: Brightness.light,
  appBarTheme: const AppBarTheme(
      backgroundColor: Colors.transparent,
      elevation: 0,
      iconTheme: IconThemeData(color: Colors.black),
      titleTextStyle: TextStyle(color: Colors.black, fontSize: 20)),
  colorScheme: ColorScheme.light(
    //container
    onPrimaryContainer: Colors.white,
    shadow: Colors.grey.shade300,
    //container
    background: Colors.grey[200]!,
    primary: primaryColor,
    //text
    surface: Colors.grey.shade700,
    //text
    secondary: primaryColor,
  ),
);
