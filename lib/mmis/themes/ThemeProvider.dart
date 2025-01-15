import 'package:flutter/material.dart';

const typeTheme = Typography.blackCupertino;

class ThemeProvider {
  static const appColor = Colors.indigo;
  static const secondaryAppColor = Colors.indigo;
  //static const appColor = Color.fromARGB(255, 16, 169, 31);
  //static const secondaryAppColor = Color.fromARGB(255, 22, 202, 40);
  static const whiteColor = Colors.white;
  static const blackColor = Color(0xFF000000);
  static const greyColor = Colors.grey;
  static const orangeColor = Colors.orange;
  static const titleStyle = TextStyle(fontSize: 14, fontFamily: 'OpenSans', color: whiteColor);
}

TextTheme txtTheme = Typography.blackCupertino.copyWith(
  bodyLarge: typeTheme.bodyLarge?.copyWith(fontSize: 16),
  bodyMedium: typeTheme.bodyMedium?.copyWith(fontSize: 14),
  displayLarge: typeTheme.displayLarge?.copyWith(fontSize: 32),
  displayMedium: typeTheme.displayMedium?.copyWith(fontSize: 28),
  displaySmall: typeTheme.displaySmall?.copyWith(fontSize: 24),
  headlineMedium: typeTheme.headlineMedium?.copyWith(fontSize: 21),
  headlineSmall: typeTheme.headlineSmall?.copyWith(fontSize: 18),
  titleLarge: typeTheme.titleLarge?.copyWith(fontSize: 16),
  titleMedium: typeTheme.titleMedium?.copyWith(fontSize: 24),
  titleSmall: typeTheme.titleSmall?.copyWith(fontSize: 21),
);

ThemeData light = ThemeData(
    fontFamily: 'OpenSans',
    primaryColor: ThemeProvider.appColor,
    secondaryHeaderColor: ThemeProvider.secondaryAppColor,
    disabledColor: const Color(0xFFBABFC4),
    brightness: Brightness.light,
    hintColor: const Color(0xFF9F9F9F),
    cardColor: ThemeProvider.appColor,
    textButtonTheme: TextButtonThemeData(style: TextButton.styleFrom(foregroundColor: ThemeProvider.appColor)),
    textTheme: txtTheme,
    colorScheme: const ColorScheme.light(primary: ThemeProvider.appColor, secondary: ThemeProvider.secondaryAppColor).copyWith(surface: const Color(0xFFF3F3F3)).copyWith(error: const Color(0xFFE84D4F)));

ThemeData dark = ThemeData(
    fontFamily: 'OpenSans',
    primaryColor: ThemeProvider.blackColor,
    secondaryHeaderColor: const Color(0xFF009f67),
    disabledColor: const Color(0xffa2a7ad),
    brightness: Brightness.dark,
    hintColor: const Color(0xFFbebebe),
    cardColor: Colors.black,
    textButtonTheme: TextButtonThemeData(style: TextButton.styleFrom(foregroundColor: ThemeProvider.blackColor)),
    textTheme: txtTheme,
    colorScheme: const ColorScheme.dark(primary: ThemeProvider.blackColor, secondary: Color(0xFFffbd5c)).copyWith(surface: const Color(0xFF343636)).copyWith(error: const Color(0xFFdd3135)));
