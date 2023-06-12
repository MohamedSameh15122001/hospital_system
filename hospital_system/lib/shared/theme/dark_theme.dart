import 'package:flutter/material.dart';

import '../components/constants.dart';

ThemeData darkTheme = ThemeData(
  // scaffoldBackgroundColor: Colors.grey.shade200,
  primarySwatch: primaryColor,
  brightness: Brightness.dark,
  appBarTheme: const AppBarTheme(
    backgroundColor: Colors.black,
  ),
  colorScheme: const ColorScheme.dark(
    background: Colors.black,
    primary: primaryColor,
    secondary: primaryColor,
    //text
    surface: Colors.white,
    //text
    //container
    onPrimaryContainer: Colors.black,
    shadow: Colors.white,
    //container
  ),
);

// theme.of(context).colortheme.backround