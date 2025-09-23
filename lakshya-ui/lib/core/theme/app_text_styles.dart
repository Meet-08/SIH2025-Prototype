import 'package:flutter/material.dart';

/// Mobile text styles (phone-first). Sizes follow 22/28, 18/22, 16/20, 13/16.
class AppTextStyles {
  AppTextStyles._();

  // h1: 22px / 28px
  static const TextStyle h1 = TextStyle(
    fontSize: 22,
    height: 28 / 22,
    fontWeight: FontWeight.w700,
    letterSpacing: -0.2,
  );

  // h2: 18px / 22px
  static const TextStyle h2 = TextStyle(
    fontSize: 18,
    height: 22 / 18,
    fontWeight: FontWeight.w600,
    letterSpacing: -0.1,
  );

  // body: 16px / 20px
  static const TextStyle body = TextStyle(
    fontSize: 16,
    height: 20 / 16,
    fontWeight: FontWeight.w500,
  );

  // small: 13px / 16px
  static const TextStyle small = TextStyle(
    fontSize: 13,
    height: 16 / 13,
    fontWeight: FontWeight.w500,
    color: Color(0xFF6B7280),
  );
}
