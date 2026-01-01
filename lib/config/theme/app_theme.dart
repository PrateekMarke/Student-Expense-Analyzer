import 'package:flutter/material.dart';

import 'package:student_expense_analyzer/config/theme/colors.dart';

class AppTheme {
  static OutlineInputBorder _border({
    Color color = AppColors.purple,
    double width = 1,
  }) =>
      OutlineInputBorder(
        borderSide: BorderSide(
          color: color,
          width: width,
        ),
        borderRadius: BorderRadius.circular(10),
      );

  static final lightTheme = ThemeData().copyWith(
    appBarTheme: const AppBarTheme(
      backgroundColor: Color(0xffffffff),
    ),
    colorScheme: ColorScheme.light(
      surface: Colors.grey.shade100,
      error: const Color(0xffb00020),
      errorContainer: const Color(0xffb00020),
      inversePrimary: const Color(0xffffffff),
      inverseSurface: const Color(0xff000000),
      onPrimary: Colors.white,
      primary: AppColors.purple,
      secondary: AppColors.darkPurple,
      shadow: const Color(0xff000000),
      surfaceTint: const Color(0xff6200ee),
      tertiary: const Color(0xff03dac6),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        elevation: 5,
        minimumSize: const Size.fromHeight(50),
        backgroundColor: AppColors.purple,
        foregroundColor: AppColors.bgColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    ),
    scaffoldBackgroundColor: Colors.white,
    inputDecorationTheme: InputDecorationTheme(
      border: _border(),
      enabledBorder: _border(),
      errorBorder: _border(
        color: AppColors.errorColor,
      ),
      contentPadding: const EdgeInsets.all(15),
    ),
    datePickerTheme: DatePickerThemeData(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),

      // dayColor: AppColors.purple,
      // selectedDayColor: AppColors.darkPurple,
      // todayColor: AppColors.lightPurple,
    ),
  );
}
