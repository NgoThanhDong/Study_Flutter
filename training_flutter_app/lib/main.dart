import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
// import 'package:flutter/scheduler.dart' show timeDilation;

import 'provider/posts_provider.dart';
import 'theme/app_theme.dart';
import 'theme/theme_provider.dart';
import 'screen/post_list.dart';

void main() {
  // assert(() {
  //   timeDilation = 2;
  //   return true;
  // }());

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => PostsProvider()),
        ChangeNotifierProvider(create: (_) => ThemeProvider()), // 👈 NEW
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = context.watch<ThemeProvider>();

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Post Manager',

      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: themeProvider.themeMode, // 👈 QUAN TRỌNG

      home: const PostList(),
    );
  }
}
