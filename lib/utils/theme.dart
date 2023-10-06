/// {@category Utils}
library theme;

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

///The color palette to use colours easily and consistently.
class ColorPalette{
  static const Color primary = Color.fromRGBO(255, 120, 60, 1);
  static const Color secondary = Color.fromRGBO(255, 180, 90, 1);
  static const Color tertiaryLight = Color.fromRGBO(160, 160, 160, 1);
  static const Color tertiaryDark = Color.fromRGBO(140, 140, 140, 1);
}

class Themes {
  static ThemeData lightMode = ThemeData(
    textTheme: GoogleFonts.latoTextTheme()
  );
}