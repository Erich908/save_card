/// {@category Widgets}
library custom_text_field;

import 'package:flutter/material.dart';
import 'package:save_card/utils/theme.dart';

///The text field used across the app for consistency.
class CustomTextField extends StatelessWidget {
  const CustomTextField(
      {super.key, required this.title, this.onChanged, this.textInputType, this.maxLength, this.controller, this.textCapitalization, this.onTap});

  ///The label for the text field that would float when you type.
  final String title;

  ///What to do when the text input has changed.
  final ValueChanged<String>? onChanged;

  ///What type of keyboard should display.
  final TextInputType? textInputType;

  ///The maximum amount of characters.
  final int? maxLength;

  ///Controller for the text field.
  final TextEditingController? controller;

  ///The type of capitalization used for this text field.
  final TextCapitalization? textCapitalization;

  ///Action triggered when text field is tapped
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return TextField(
      onTap: onTap,
      textCapitalization: textCapitalization ?? TextCapitalization.none,
      controller: controller,
      maxLength: maxLength,
      cursorColor: ColorPalette.primary,
      keyboardType: textInputType,
      decoration: InputDecoration(
        counter: Container(),
        border: MaterialStateUnderlineInputBorder.resolveWith((states) =>
            UnderlineInputBorder(
                borderSide: BorderSide(color: ColorPalette.tertiaryLight))),
        floatingLabelBehavior: FloatingLabelBehavior.auto,
        labelText: title,
        labelStyle: TextStyle(
            fontWeight: FontWeight.w500, color: ColorPalette.tertiaryLight),
        floatingLabelStyle: TextStyle(
            fontWeight: FontWeight.w500, color: ColorPalette.tertiaryDark),
      ),
      onChanged: (text) {
        if (onChanged != null) {
          onChanged!(text);
        }
      },
    );
  }
}
