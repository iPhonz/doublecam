import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // Colors
  static const Color primaryColor = Color(0xFF0952CA);
  static const Color accentColor = Color(0xFF1E88E5);
  static const Color darkBlue = Color(0xFF0A1931);
  static const Color lightBlue = Color(0xFF1E88E5);
  static const Color redColor = Color(0xFFFF3B30);
  static const Color darkGrey = Color(0xFF121212);
  static const Color mediumGrey = Color(0xFF2C2C2C);
  static const Color lightGrey = Color(0xFF3D3D3D);
  static const Color textColor = Color(0xFFFFFFFF);
  static const Color textColorSecondary = Color(0xFFB3B3B3);

  // Text styles
  static final TextStyle headingStyle = GoogleFonts.montserrat(
    fontSize: 24,
    fontWeight: FontWeight.bold,
    color: textColor,
  );
  
  static final TextStyle subheadingStyle = GoogleFonts.montserrat(
    fontSize: 18,
    fontWeight: FontWeight.w600,
    color: textColor,
  );
  
  static final TextStyle bodyStyle = GoogleFonts.montserrat(
    fontSize: 14,
    fontWeight: FontWeight.normal,
    color: textColor,
  );
  
  static final TextStyle buttonStyle = GoogleFonts.montserrat(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: textColor,
  );
  
  static final TextStyle captionStyle = GoogleFonts.montserrat(
    fontSize: 12,
    fontWeight: FontWeight.normal,
    color: textColorSecondary,
  );

  // Theme data
  static final ThemeData darkTheme = ThemeData(
    primaryColor: primaryColor,
    scaffoldBackgroundColor: Colors.black,
    canvasColor: Colors.black,
    brightness: Brightness.dark,
    colorScheme: ColorScheme.dark(
      primary: primaryColor,
      secondary: accentColor,
      background: Colors.black,
      surface: darkGrey,
      onSurface: textColor,
      onBackground: textColor,
      onPrimary: textColor,
      onSecondary: textColor,
      error: redColor,
      brightness: Brightness.dark,
    ),
    textTheme: TextTheme(
      displayLarge: headingStyle,
      displayMedium: subheadingStyle,
      bodyLarge: bodyStyle,
      bodyMedium: bodyStyle.copyWith(fontSize: 14),
      bodySmall: captionStyle,
      labelLarge: buttonStyle,
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: Colors.black,
      elevation: 0,
      titleTextStyle: subheadingStyle,
      iconTheme: const IconThemeData(
        color: textColor,
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: primaryColor,
        foregroundColor: textColor,
        textStyle: buttonStyle,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        padding: const EdgeInsets.symmetric(
          vertical: 12,
          horizontal: 24,
        ),
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: accentColor,
        textStyle: buttonStyle,
      ),
    ),
    iconTheme: const IconThemeData(
      color: textColor,
      size: 24,
    ),
    dividerTheme: const DividerThemeData(
      color: lightGrey,
      thickness: 1,
    ),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: darkGrey,
      selectedItemColor: primaryColor,
      unselectedItemColor: textColorSecondary,
      type: BottomNavigationBarType.fixed,
      showUnselectedLabels: true,
    ),
    cardTheme: CardTheme(
      color: darkGrey,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      elevation: 0,
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: mediumGrey,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(
          color: primaryColor,
          width: 1,
        ),
      ),
      labelStyle: bodyStyle.copyWith(color: textColorSecondary),
      hintStyle: bodyStyle.copyWith(color: textColorSecondary),
    ),
    switchTheme: SwitchThemeData(
      thumbColor: MaterialStateProperty.resolveWith<Color>((states) {
        if (states.contains(MaterialState.selected)) {
          return primaryColor;
        }
        return lightGrey;
      }),
      trackColor: MaterialStateProperty.resolveWith<Color>((states) {
        if (states.contains(MaterialState.selected)) {
          return primaryColor.withOpacity(0.5);
        }
        return mediumGrey;
      }),
    ),
    sliderTheme: SliderThemeData(
      activeTrackColor: primaryColor,
      inactiveTrackColor: mediumGrey,
      thumbColor: primaryColor,
      overlayColor: primaryColor.withOpacity(0.2),
    ),
    checkboxTheme: CheckboxThemeData(
      fillColor: MaterialStateProperty.resolveWith<Color>((states) {
        if (states.contains(MaterialState.selected)) {
          return primaryColor;
        }
        return lightGrey;
      }),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(4),
      ),
    ),
    radioTheme: RadioThemeData(
      fillColor: MaterialStateProperty.resolveWith<Color>((states) {
        if (states.contains(MaterialState.selected)) {
          return primaryColor;
        }
        return lightGrey;
      }),
    ),
    dialogTheme: DialogTheme(
      backgroundColor: darkGrey,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      titleTextStyle: subheadingStyle,
      contentTextStyle: bodyStyle,
    ),
  );
}