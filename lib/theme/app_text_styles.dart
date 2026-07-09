import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTextStyles {
  AppTextStyles._();

  static TextStyle heading1(Color color) {
    return GoogleFonts.inter(
      fontSize: 32,
      fontWeight: FontWeight.w800,
      color: color,
    );
  }

  static TextStyle heading2(Color color) {
    return GoogleFonts.inter(
      fontSize: 24,
      fontWeight: FontWeight.w700,
      color: color,
    );
  }

  static TextStyle heading3(Color color) {
    return GoogleFonts.inter(
      fontSize: 20,
      fontWeight: FontWeight.w700,
      color: color,
    );
  }

  static TextStyle body(Color color) {
    return GoogleFonts.inter(
      fontSize: 16,
      fontWeight: FontWeight.w500,
      color: color,
    );
  }

  static TextStyle caption(Color color) {
    return GoogleFonts.inter(
      fontSize: 13,
      fontWeight: FontWeight.w500,
      color: color,
    );
  }

  static TextStyle button(Color color) {
    return GoogleFonts.inter(
      fontSize: 16,
      fontWeight: FontWeight.w700,
      color: color,
    );
  }
}