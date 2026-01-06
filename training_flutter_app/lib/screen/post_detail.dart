import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:training_flutter_app/model/post.dart';
import 'package:training_flutter_app/provider/posts_provider.dart';
import 'package:training_flutter_app/theme/theme_provider.dart';

class PostDetail extends StatelessWidget {
  final Post post;

  const PostDetail({super.key, required this.post});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Post Detail'),
        actions: [
          Consumer<ThemeProvider>(
            builder: (context, themeProvider, _) {
              return IconButton(
                tooltip: themeProvider.isDarkMode ? 'Dark mode' : 'Light mode',
                icon: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 300),
                  transitionBuilder: (child, anim) =>
                      RotationTransition(turns: anim, child: child),
                  child: Icon(
                    themeProvider.isDarkMode
                        ? Icons.dark_mode
                        : Icons.light_mode,
                    key: ValueKey(themeProvider.isDarkMode),
                    color: Colors.white,
                  ),
                ),
                onPressed: () {
                  themeProvider.toggleTheme(!themeProvider.isDarkMode);
                },
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// TITLE
            Text(
              post.title!,
              style: textTheme.titleLarge?.copyWith(fontSize: 24),
            ),

            const SizedBox(height: 8),

            /// AUTHOR & DATE
            Align(
              alignment: Alignment.centerRight,
              child: Text(
                'Author: ${post.author} - Create date: ${post.createdDate}',
              ),
            ),

            const SizedBox(height: 16),

            /// IMAGE
            SizedBox(
              width: double.infinity,
              child: Image.memory(
                Base64Decoder().convert(post.image!),
                fit: BoxFit.contain,
              ),
            ),

            const SizedBox(height: 16),

            /// CONTENT
            Text(post.content!),

            const SizedBox(height: 32),

            /// CATEGORY
            _buildCategory(context),

            const SizedBox(height: 8),

            /// TAGS
            _buildTags(context),
          ],
        ),
      ),
    );
  }

  // ================= UI SECTIONS =================

  Widget _buildCategory(BuildContext context) {
    return Wrap(
      children: [
        const Text('Category: ', style: TextStyle(fontWeight: FontWeight.bold)),
        _buildLink(
          text: post.category!,
          onPressed: () => _applyFilter(context, category: post.category),
        ),
      ],
    );
  }

  Widget _buildTags(BuildContext context) {
    final tags = post.tags!.cast<String>();

    return Wrap(
      children: [
        const Text('Tags: ', style: TextStyle(fontWeight: FontWeight.bold)),
        ...List.generate(tags.length, (index) {
          final tag = tags[index];
          final text = index == tags.length - 1 ? tag : '$tag,';

          return Padding(
            padding: const EdgeInsets.only(right: 4),
            child: _buildLink(
              text: text,
              onPressed: () => _applyFilter(context, tag: tag),
            ),
          );
        }),
      ],
    );
  }

  Widget _buildLink({required String text, required VoidCallback onPressed}) {
    return InkWell(
      onTap: onPressed,
      child: Text(
        text,
        style: const TextStyle(
          color: Colors.blueAccent,
          decoration: TextDecoration.underline,
        ),
      ),
    );
  }

  // ================= LOGIC =================

  void _applyFilter(BuildContext context, {String? category, String? tag}) {
    final provider = context.read<PostsProvider>();

    if (category != null) {
      provider.updateCategory(category);
    }

    if (tag != null) {
      provider.updateTag(tag);
    }

    Navigator.pop(context);
  }
}
