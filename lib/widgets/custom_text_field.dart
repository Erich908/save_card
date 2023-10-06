import 'package:flutter/material.dart';
import 'package:save_card/utils/theme.dart';

class CustomTextField extends StatelessWidget {
  const CustomTextField(
      {super.key, required this.title, this.onChanged, this.textInputType, this.maxLength, this.controller, this.textCapitalization, this.onTap});

  final String title;
  final ValueChanged<String>? onChanged;
  final TextInputType? textInputType;
  final int? maxLength;
  final TextEditingController? controller;
  final TextCapitalization? textCapitalization;
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
