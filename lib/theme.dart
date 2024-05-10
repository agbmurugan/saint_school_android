import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

getHeight(BuildContext context) => MediaQuery.of(context).size.height;
getWidth(BuildContext context) => MediaQuery.of(context).size.width;
TextTheme getText(BuildContext context) => Theme.of(context).textTheme;
ColorScheme getColor(BuildContext context) => Theme.of(context).colorScheme;

const seed = Color(0xFF6750A4);

const lightColorScheme = ColorScheme(
  brightness: Brightness.light,
  primary: Color(0xFF09447E),
  onPrimary: Color(0xFFFFFFFF),
  primaryContainer: Color(0xFF09447E),
  onPrimaryContainer: Color(0xFF001E2D),
  secondary: Color(0xFF1460A4),
  onSecondary: Color(0xFFFFFFFF),
  secondaryContainer: Color(0xFFD2E4FF),
  onSecondaryContainer: Color(0xFF001C39),
  tertiary: Color(0xFF006A67),
  onTertiary: Color(0xFFFFFFFF),
  tertiaryContainer: Color(0xFF6FF7F2),
  onTertiaryContainer: Color(0xFF00201F),
  error: Color(0xFFB3261E),
  errorContainer: Color(0xFFF9DEDC),
  onError: Color(0xFFFFFFFF),
  onErrorContainer: Color(0xFF410E0B),
  background: Color(0xFFFFFBFE),
  onBackground: Color(0xFF1C1B1F),
  surface: Color(0xFFFFFBFE),
  onSurface: Color(0xFF1C1B1F),
  surfaceVariant: Color(0xFFE7E0EC),
  onSurfaceVariant: Color(0xFF49454F),
  outline: Color(0xFF79747E),
  onInverseSurface: Color(0xFFF4EFF4),
  inverseSurface: Color(0xFF313033),
  inversePrimary: Color(0xFF7BD0FF),
  shadow: Color(0xFF000000),
);

const darkColorScheme = ColorScheme(
  brightness: Brightness.dark,
  primary: Color(0xFF7BD0FF),
  onPrimary: Color(0xFF00344B),
  primaryContainer: Color(0xFF004C6B),
  onPrimaryContainer: Color(0xFFC3E7FF),
  secondary: Color(0xFFA0C9FF),
  onSecondary: Color(0xFF00315D),
  secondaryContainer: Color(0xFF004883),
  onSecondaryContainer: Color(0xFFD2E4FF),
  tertiary: Color(0xFF4EDAD6),
  onTertiary: Color(0xFF003735),
  tertiaryContainer: Color(0xFF00504E),
  onTertiaryContainer: Color(0xFF6FF7F2),
  error: Color(0xFFF2B8B5),
  errorContainer: Color(0xFF8C1D18),
  onError: Color(0xFF601410),
  onErrorContainer: Color(0xFFF9DEDC),
  background: Color(0xFF1C1B1F),
  onBackground: Color(0xFFE6E1E5),
  surface: Color(0xFF1C1B1F),
  onSurface: Color(0xFFE6E1E5),
  surfaceVariant: Color(0xFF49454F),
  onSurfaceVariant: Color(0xFFCAC4D0),
  outline: Color(0xFF938F99),
  onInverseSurface: Color(0xFF1C1B1F),
  inverseSurface: Color(0xFFE6E1E5),
  inversePrimary: Color(0xFF00658C),
  shadow: Color(0xFF000000),
);

TextTheme myTexTheme = TextTheme(
  headline1: GoogleFonts.roboto(fontSize: 96, fontWeight: FontWeight.w300, letterSpacing: -1.5),
  headline2: GoogleFonts.roboto(fontSize: 60, fontWeight: FontWeight.w300, letterSpacing: -0.5),
  headline3: GoogleFonts.roboto(fontSize: 48, fontWeight: FontWeight.w400),
  headline4: GoogleFonts.roboto(fontSize: 34, fontWeight: FontWeight.w400, letterSpacing: 0.25),
  headline5: GoogleFonts.roboto(fontSize: 24, fontWeight: FontWeight.w400),
  headline6: GoogleFonts.roboto(fontSize: 20, fontWeight: FontWeight.w500, letterSpacing: 0.15),
  subtitle1: GoogleFonts.roboto(fontSize: 16, fontWeight: FontWeight.w400, letterSpacing: 0.15),
  subtitle2: GoogleFonts.roboto(fontSize: 14, fontWeight: FontWeight.w500, letterSpacing: 0.1),
  bodyText1: GoogleFonts.roboto(fontSize: 16, fontWeight: FontWeight.w400, letterSpacing: 0.5),
  bodyText2: GoogleFonts.roboto(fontSize: 14, fontWeight: FontWeight.w400, letterSpacing: 0.25),
  button: GoogleFonts.roboto(fontSize: 14, fontWeight: FontWeight.w500, letterSpacing: 1.25),
  caption: GoogleFonts.roboto(fontSize: 12, fontWeight: FontWeight.w400, letterSpacing: 0.4),
  overline: GoogleFonts.roboto(fontSize: 10, fontWeight: FontWeight.w400, letterSpacing: 1.5),
);
