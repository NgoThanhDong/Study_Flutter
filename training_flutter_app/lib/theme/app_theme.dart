import 'package:flutter/material.dart';

class AppTheme {
  AppTheme._();

  /// ================= LIGHT THEME =================
  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    fontFamily: 'Comfortaa', 

    colorScheme: ColorScheme.fromSeed(
      seedColor: Colors.blue,
      brightness: Brightness.light,
    ),

    /// ================= APP BAR =================
    appBarTheme: const AppBarTheme(
      centerTitle: true,
      elevation: 1,
      backgroundColor: Colors.blue,
      foregroundColor: Colors.white,
    ),

    /// ================= TEXT =================
    textTheme: const TextTheme(
      bodyMedium: TextStyle(fontSize: 14, color: Colors.black87),
      bodyLarge: TextStyle(fontSize: 16, color: Colors.black87),
      titleLarge: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
        color: Colors.black,
      ),
    ),

    /// ================= TEXT BUTTON =================
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: Colors.black87,
        textStyle: const TextStyle(fontSize: 14),
      ),
    ),

    /// ================= ELEVATED BUTTON =================
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        minimumSize: const Size.fromHeight(48),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
      ),
    ),

    /// ================= INPUT =================
    inputDecorationTheme: const InputDecorationTheme(
      border: OutlineInputBorder(),
      labelStyle: TextStyle(fontSize: 16, color: Colors.black87),
    ),

    /// ================= CARD (FIX TYPE) =================
    cardTheme: const CardThemeData(
      color: Colors.white,
      elevation: 2,
      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
    ),

    /// ================= DIALOG (FIX TYPE) =================
    dialogTheme: const DialogThemeData(
      backgroundColor: Colors.white,
      titleTextStyle: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: Colors.black,
      ),
      contentTextStyle: TextStyle(color: Colors.black87),
    ),
  );


  /// ================= DARK THEME =================
  static ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    fontFamily: 'Comfortaa', 

    colorScheme: ColorScheme.fromSeed(
      seedColor: Colors.blue,
      brightness: Brightness.dark,
    ),

    /// ================= APP BAR =================
    appBarTheme: const AppBarTheme(
      centerTitle: true,
      elevation: 1,
      backgroundColor: Color(0xFF1E1E1E),
      foregroundColor: Colors.white,
    ),

    /// ================= TEXT =================
    textTheme: const TextTheme(
      bodyMedium: TextStyle(fontSize: 14, color: Colors.white70),
      bodyLarge: TextStyle(fontSize: 16, color: Colors.white),
      titleLarge: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
    ),

    /// ================= TEXT BUTTON =================
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: Colors.white70,
        textStyle: const TextStyle(fontSize: 14),
      ),
    ),

    /// ================= ELEVATED BUTTON =================
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        minimumSize: const Size.fromHeight(48),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
      ),
    ),

    /// ================= INPUT =================
    inputDecorationTheme: const InputDecorationTheme(
      border: OutlineInputBorder(),
      labelStyle: TextStyle(fontSize: 16, color: Colors.white70),
    ),

    /// ================= CARD (FIX TYPE) =================
    cardTheme: const CardThemeData(
      color: Color(0xFF1F1F1F),
      elevation: 2,
      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
    ),

    /// ================= DIALOG (FIX TYPE) =================
    dialogTheme: const DialogThemeData(
      backgroundColor: Color(0xFF2A2A2A),
      titleTextStyle: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
      contentTextStyle: TextStyle(color: Colors.white70),
    ),
  );
}
