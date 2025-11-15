import 'package:flutter/material.dart';

const Color kcPrimaryColor = Color(0xFF9600FF);
const Color kcPrimaryColorDark = Color(0xFF300151);
const Color kcDarkGreyColor = Color(0xFF1A1B1E);
const Color kcDarkGreyColor2 = Color(0xFF2A2B2E);
const Color kcMediumGrey = Color(0xFF474A54);
const Color kcLightGrey = Color.fromARGB(255, 187, 187, 187);
const Color kcVeryLightGrey = Color(0xFFE3E3E3);
const Color kcBackgroundColor = kcDarkGreyColor;
const Color kcBlack = Color(0xFF000000);

// Light Theme
// final ThemeData lightTheme = ThemeData(
//   useMaterial3: true,
//   brightness: Brightness.light,
//   primaryColor: kcPrimaryColor,
//   scaffoldBackgroundColor: Colors.white,
//   colorScheme: const ColorScheme.light(
//     primary: kcPrimaryColor,
//     secondary: kcPrimaryColorDark,
//     surface: Colors.white,
//     error: Colors.red,
//   ),
// );

// // Dark Theme
// final ThemeData darkTheme = ThemeData(
//   useMaterial3: true,
//   brightness: Brightness.dark,
//   primaryColor: kcPrimaryColor,
//   scaffoldBackgroundColor: kcDarkGreyColor,
//   colorScheme: const ColorScheme.dark(
//     primary: kcPrimaryColor,
//     secondary: kcPrimaryColorDark,
//     surface: kcDarkGreyColor,
//     error: Colors.red,
//   ),
// );

final lightTheme = ThemeData(
  brightness: Brightness.light,
  scaffoldBackgroundColor: Colors.white, // light background
);

final darkTheme = ThemeData(
  brightness: Brightness.dark,
  scaffoldBackgroundColor: kcBlack, // your dark background
);
