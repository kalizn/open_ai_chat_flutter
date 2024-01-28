import 'package:flutter/material.dart';

const kPrimaryGradientColor = LinearGradient(
  begin: Alignment.topLeft,
  end: Alignment.bottomRight,
  colors: [
    Color(0xFF7555ae),
    Color(0xFFd6cde7)]
  ,
);
const kPrimaryColor = Color(0xFF7555ae);
const kSecondaryColor = Color(0xFFd6cde7);
const kTertiaryColor = Color(0xFFa28dc8);
const kQuaternaryColor = Color(0xFFb4a3d4);
const kQuinaryColor = Color(0xFF947cc4);
const kTextColor = Colors.white;
const kTextDescription = Color(0xFF8A8A8A);
const kAnimationDuration = Duration(milliseconds: 200);

const defaultDuration = Duration(milliseconds: 250);

final otpInputDecoration = InputDecoration(
  contentPadding: const EdgeInsets.symmetric(vertical: 16),
  border: outlineInputBorder(),
  focusedBorder: outlineInputBorder(),
  enabledBorder: outlineInputBorder(),
);

OutlineInputBorder outlineInputBorder() {
  return OutlineInputBorder(
    borderRadius: BorderRadius.circular(16),
    borderSide: const BorderSide(color: kTextColor),
  );
}
