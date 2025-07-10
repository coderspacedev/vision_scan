import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'app_colors.dart';

class AppTheme {
  static ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    useMaterial3: false,
    fontFamily: 'Montserrat',
    scaffoldBackgroundColor: colorBackground,
    canvasColor: colorBackground,
    cardColor: colorCard,
    primaryColor: colorPrimary,
    splashColor: Colors.transparent,
    highlightColor: colorAccent.withAlpha(50),
    hoverColor: Colors.transparent,
    appBarTheme: AppBarTheme(
      backgroundColor: colorBackground,
      foregroundColor: colorText,
      toolbarHeight: 56.0,
      elevation: 0,
      centerTitle: false,
      titleTextStyle: TextStyle(
        fontFamily: 'Montserrat',
        fontSize: 16.sp,
        fontWeight: FontWeight.bold,
        color: colorText,
      ),
    ),
    textTheme: TextTheme(
      headlineLarge: TextStyle(
        fontSize: 36.sp,
        fontWeight: FontWeight.bold,
        fontFamily: 'Montserrat',
      ),
      titleLarge: TextStyle(
        fontSize: 24.sp,
        fontWeight: FontWeight.w600,
        fontFamily: 'Montserrat',
      ),
      bodyLarge: TextStyle(fontSize: 16.sp, fontFamily: 'Montserrat'),
      bodyMedium: TextStyle(fontSize: 14.sp, fontFamily: 'Montserrat'),
      labelLarge: TextStyle(
        fontSize: 14.sp,
        fontWeight: FontWeight.w600,
        fontFamily: 'Montserrat',
      ),
    ),
    textSelectionTheme: TextSelectionThemeData(
      cursorColor: colorAccent,
      selectionColor: colorAccent.withAlpha(50),
      selectionHandleColor: colorAccent,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        foregroundColor: colorText,
        backgroundColor: colorPrimary,
        textStyle: TextStyle(fontWeight: FontWeight.w600, fontSize: 16.sp),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.r),
        ),
      ),
    ),
    cardTheme: CardThemeData(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.r)),
      color: colorCard,
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: colorCard,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.r),
        borderSide: BorderSide.none,
      ),
      contentPadding: EdgeInsets.symmetric(vertical: 14.h, horizontal: 16.w),
    ),
  );
}
