// ignore_for_file: public_member_api_docs, sort_constructors_first
// ignore_for_file: prefer_const_constructors
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../Constants/colors.dart';
import '../../Controller/theme_controller.dart';

class InputTextField extends StatelessWidget {
  const InputTextField({
    Key? key,
    this.controller,
    required this.onValidator,
    required this.keyBoardType,
    required this.hintText,
    required this.obscureText,
    this.autoFocus = true,
    this.icon,
    this.fillColor,
    this.maxLines,
    this.focusNode,
    this.maxLength,
    this.inputFormatters,
    this.initialValue,
    this.suffixIcon,
  }) : super(key: key);

  final TextEditingController? controller;
  final FocusNode? focusNode;
  final FormFieldValidator onValidator;
  final TextInputType keyBoardType;

  final String hintText;
  final String? initialValue;
  final bool obscureText;
  final bool autoFocus;

  final Icon? icon;
  final Color? fillColor;
  final int? maxLines, maxLength;
  final List<TextInputFormatter>? inputFormatters;

  final Widget? suffixIcon;

  @override
  Widget build(BuildContext context) {
    final ThemeController themeController = Get.find();
    final isDark = themeController.isDarkMode.value;
    return Container(
      decoration: BoxDecoration(
        color: isDark ? darkInputText : tWhiteColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: TextFormField(
        controller: controller,
        validator: onValidator,
        keyboardType: keyBoardType,
        obscureText: obscureText,
        maxLines: maxLines,
        maxLength: maxLength,
        inputFormatters: inputFormatters,
        initialValue: initialValue,
        decoration: InputDecoration(
          suffixIcon: suffixIcon,
          hintText: hintText,
          contentPadding: EdgeInsets.all(12),
          labelStyle: GoogleFonts.inter(
            color: isDark ? whiteColor : darkInputText,
            fontSize: 16,
          ),
          hintStyle: GoogleFonts.inter(
            color: isDark ? whiteColor : darkInputText,
            fontSize: 16,
          ),
          border: OutlineInputBorder(
            borderSide: BorderSide.none,
            borderRadius: BorderRadius.circular(12),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: tPrimaryColor, width: 2),
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }
}
