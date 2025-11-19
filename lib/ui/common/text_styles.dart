/// Centralized text style definitions using Google Fonts (Nunito Sans) with responsive sizing and theme-aware colors.
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sizer/sizer.dart';

class AppTextStyles {
  static TextStyle heading1(BuildContext context, {Color? color}) =>
      GoogleFonts.nunitoSans(
        fontWeight: FontWeight.w600,
        fontSize: 28.sp,
        color: color ?? _textColor(context),
      );

  static TextStyle heading2(BuildContext context, {Color? color}) =>
      GoogleFonts.nunitoSans(
        fontWeight: FontWeight.w600,
        fontSize: 24.sp,
        color: color ?? _textColor(context),
      );

  static TextStyle heading3(BuildContext context, {Color? color}) =>
      GoogleFonts.nunitoSans(
        fontWeight: FontWeight.w600,
        fontSize: 15.sp,
        color: color ?? _textColor(context),
      );

  static TextStyle subheading(BuildContext context, {Color? color}) =>
      GoogleFonts.nunitoSans(
        fontWeight: FontWeight.w500,
        fontSize: 16.sp,
        color: color ?? _textColor(context),
      );

  static TextStyle caption(BuildContext context, {Color? color}) =>
      GoogleFonts.nunitoSans(
        fontWeight: FontWeight.w400,
        fontSize: 14.sp,
        color: color ?? _textColor(context),
      );

  static TextStyle body(BuildContext context, {Color? color}) =>
      GoogleFonts.nunitoSans(
        fontWeight: FontWeight.normal,
        fontSize: 15.sp,
        color: color ?? _textColor(context),
      );

  static Color _textColor(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark
        ? Colors.white
        : Colors.black;
  }
}
