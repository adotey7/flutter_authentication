import 'package:flutter/material.dart';

import 'app_pallete.dart';

OutlineInputBorder outlineBorder([Color? borderColor]) {
  return OutlineInputBorder(
    borderRadius: BorderRadius.circular(15),
    borderSide: BorderSide(
      color: borderColor ?? Pallete.borderColor,
    ),
  );
}

ButtonStyle buttonStyle(
    {Color? backgroundColor,
    required Color splashColor,
    MaterialStateProperty<BorderSide>? borderSide}) {
  return ButtonStyle(
    elevation: MaterialStateProperty.all<double>(0),
    minimumSize: MaterialStateProperty.all<Size>(
      const Size(double.infinity, 50),
    ),
    backgroundColor: MaterialStateProperty.resolveWith<Color?>((states) {
      if (states.contains(MaterialState.disabled)) {
        return Colors.grey;
      }
      return backgroundColor; // Use the component's default.
    }),
    side: borderSide,
    overlayColor: MaterialStateProperty.resolveWith<Color>((states) {
      if (states.contains(MaterialState.pressed)) {
        return splashColor; // Custom splash color
      }
      return Pallete.primaryColor; // No splash color
    }),
  );
}

final ThemeData themeData = ThemeData(
  inputDecorationTheme: InputDecorationTheme(
    enabledBorder: outlineBorder(),
    errorBorder: outlineBorder(Colors.red),
    focusedBorder: outlineBorder(Pallete.primaryColor),
    border: const OutlineInputBorder(
      borderSide: BorderSide(
        style: BorderStyle.solid,
      ),
    ),
  ),
  useMaterial3: true,
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: buttonStyle(
      splashColor: const Color.fromARGB(255, 20, 84, 168),
      backgroundColor: Pallete.primaryColor,
    ),
  ),
  outlinedButtonTheme: OutlinedButtonThemeData(
    style: buttonStyle(
        splashColor: Pallete.primaryColor.withOpacity(0.1),
        borderSide: MaterialStateProperty.all<BorderSide>(
          const BorderSide(
            color: Pallete.primaryColor,
            width: 1.5,
          ),
        )),
  ),
);
