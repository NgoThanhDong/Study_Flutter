import 'dart:io';

import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import 'src/adaptive_playlists.dart';                          // Add this import
import 'src/app_state.dart';
import 'src/playlist_details.dart';
// Remove the src/playlists.dart import

// From https://www.youtube.com/channel/UCwXdFgeE9KYzlDdR7TG9cMw
const flutterDevAccountId = 'UCwXdFgeE9KYzlDdR7TG9cMw';

// TODO: Replace with your YouTube API Key
const youTubeApiKey = 'AIzaSyABvp0DrISji24pTZbU9-o3jj2ynIBnyLY';

final _router = GoRouter(
  routes: <RouteBase>[
    GoRoute(
      path: '/',
      builder: (context, state) {
        return const AdaptivePlaylists();                      // Modify this line
      },
      routes: <RouteBase>[
        GoRoute(
          path: 'playlist/:id',
          builder: (context, state) {
            final title = state.uri.queryParameters['title']!;
            final id = state.pathParameters['id']!;
            return Scaffold(                                   // Modify from here
              appBar: AppBar(title: Text(title)),
              body: PlaylistDetails(playlistId: id, playlistName: title),
            );                                                 // To here.
          },
        ),
      ],
    ),
  ],
);

void main() {
  if (youTubeApiKey == 'AIzaNotAnApiKey') {
    print('youTubeApiKey has not been configured.');
    exit(1);
  }

  runApp(
    ChangeNotifierProvider<FlutterDevPlaylists>(
      create: (context) => FlutterDevPlaylists(
        flutterDevAccountId: flutterDevAccountId,
        youTubeApiKey: youTubeApiKey,
      ),
      child: const PlaylistsApp(),
    ),
  );
}

class PlaylistsApp extends StatelessWidget {
  const PlaylistsApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'FlutterDev Playlists',
      theme: FlexColorScheme.light(scheme: FlexScheme.red).toTheme,
      darkTheme: FlexColorScheme.dark(scheme: FlexScheme.red).toTheme,
      themeMode: ThemeMode.dark, // Or ThemeMode.System if you'd prefer
      debugShowCheckedModeBanner: false,
      routerConfig: _router,
    );
  }
}