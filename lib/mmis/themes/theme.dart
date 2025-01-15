import 'package:flutter_app/mmis/utils/my_color.dart';
import 'package:flutter_app/mmis/utils/style.dart';
import 'package:flutter/material.dart';

final lightTheme = ThemeData(
  fontFamily: 'OpenSans',
  appBarTheme: AppBarTheme(
      backgroundColor: MyColor.getAppbarBgColor(),
      elevation: 0,
      titleTextStyle: interRegularLarge.copyWith(color: MyColor.colorWhite),
      iconTheme: const IconThemeData(
          size: 20,
          color: MyColor.colorWhite
      )
  ),
  brightness: Brightness.light,
  colorScheme: ColorScheme.light(
    background: Colors.white,
    primary: Colors.grey.shade200,
    secondary: Colors.white,
    inversePrimary: Colors.grey.shade700,
  ),
);

final darkTheme = ThemeData(
    fontFamily: 'OpenSans',
    primaryColor: MyColor.getPrimaryColor(),
    brightness: Brightness.dark,
    scaffoldBackgroundColor: MyColor.getScreenBgColor(),
    hintColor: MyColor.hintTextColor,
    focusColor: MyColor.fieldEnableBorderColor,
    buttonTheme: ButtonThemeData(
      buttonColor: MyColor.getPrimaryColor(),
    ),
    colorScheme: ColorScheme.dark(
      background: Colors.black, // Using provided dark background color
      primary: Colors.grey.shade800,
      secondary: Colors.grey.shade700,
      surface: Colors.grey.shade600,
      onBackground: Colors.white,
      onPrimary: Colors.white,
      onSecondary: Colors.white,
      onSurface: Colors.white,
    ),
    cardColor: MyColor.cardBgColor,
    appBarTheme: AppBarTheme(
        backgroundColor: MyColor.getAppbarBgColor(),
        elevation: 0,
        titleTextStyle: interRegularLarge.copyWith(color: MyColor.colorWhite),
        iconTheme: const IconThemeData(
            size: 20,
            color: MyColor.colorWhite
        )
    ),
    checkboxTheme: CheckboxThemeData(
      checkColor: MaterialStateProperty.all(MyColor.colorWhite),
      fillColor: MaterialStateProperty.all(MyColor.colorWhite),
      overlayColor: MaterialStateProperty.all(MyColor.transparentColor),
    )
);