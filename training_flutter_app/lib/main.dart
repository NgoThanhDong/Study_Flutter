import 'package:flutter/material.dart';
import 'screen/post_list.dart';

void main() {
  runApp(const MyApp());
}

/// Root application
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Post Manager',

      /// ================= THEME =================
      theme: ThemeData(
        useMaterial3: true,

        /// Main color system
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),

        /// AppBar global style
        appBarTheme: const AppBarTheme(
          centerTitle: true,
          backgroundColor: Colors.blue,
          foregroundColor: Colors.white,
          elevation: 1,
        ),

        /// ElevatedButton global style
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            minimumSize: const Size.fromHeight(48),
            backgroundColor: Colors.blue,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            textStyle: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),

        /// Input / Form style
        inputDecorationTheme: const InputDecorationTheme(
          border: OutlineInputBorder(),
          labelStyle: TextStyle(fontSize: 16),
        ),

        /// Text style
        textTheme: const TextTheme(
          bodyMedium: TextStyle(fontSize: 14),
          bodyLarge: TextStyle(fontSize: 16),
          titleLarge: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
      ),

      /// ================= ROUTING =================
      home: const PostList(),
    );
  }
}
