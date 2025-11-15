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
  static TextStyle heading1Red(BuildContext context, {Color? color}) =>
      GoogleFonts.nunitoSans(
        fontWeight: FontWeight.w800,
        fontSize: 28.sp,
        color: color ?? _textColor(context),
      );
  static TextStyle headingReciept(BuildContext context, {Color? color}) =>
      GoogleFonts.nunitoSans(
        fontWeight: FontWeight.w500,
        fontSize: 28.sp,
        color: color ?? _textColor(context),
      );
  static TextStyle fieldFont(BuildContext context, {Color? color}) =>
      GoogleFonts.nunitoSans(
        fontWeight: FontWeight.w300,
        fontSize: 20.sp,
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
        fontSize: 18.sp,
        color: color ?? _textColor(context),
      );

  static TextStyle moneyFont(BuildContext context, {Color? color}) =>
      GoogleFonts.nunitoSans(
        fontWeight: FontWeight.w800,
        fontSize: 20.sp,
        color: color ?? _textColor(context),
      );

  static TextStyle moneyFellix(BuildContext context, {Color? color}) =>
      GoogleFonts.nunitoSans(
        fontWeight: FontWeight.w600,
        fontSize: 30.sp,
        color: color ?? _textColor(context),
      );

  static TextStyle headline(BuildContext context, {Color? color}) =>
      GoogleFonts.shadowsIntoLight(
        fontWeight: FontWeight.w800,
        fontSize: 24.sp,
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
        fontSize: 16.sp,
        color: color ?? _textColor(context),
      );

  static Color _textColor(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark
        ? Colors.white
        : Colors.black;
  }
}
