import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';
import 'package:training_flutter_app/model/post.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:training_flutter_app/provider/posts_provider.dart';
import 'package:training_flutter_app/theme/theme_provider.dart';
import 'package:training_flutter_app/utils/center_toast.dart';

class CreatePost extends StatefulWidget {
  // Attribute
  final String appBarTitle;
  final Post post;

  const CreatePost({super.key, required this.appBarTitle, required this.post});

  @override
  State<CreatePost> createState() => _CreatePostState();
}

class _CreatePostState extends State<CreatePost> {
  late String appBarTitle;
  late Post post;

  /// ================= FORM =================
  final _formKey = GlobalKey<FormState>();

  /// ================= DATA =================
  // List object of Author, Post Type, Category, Tag
  final List<String> _author = ['Author 1', 'Author 2', 'Author 3'];
  final List<String> _postType = ['News', 'Blog'];
  final _category = ['Game', 'Phần Mềm', 'Học Lập Trình'];
  final _tags = [
    'Hành động',
    'Thể thao',
    'Chiến thuật',
    'Nhập vai',
    'Lập trình',
    'Học tập',
    'Công cụ',
    'Python',
    'Java',
  ];

  /// ================= VALUES =================
  String? authorDropdownValue;
  String? postTypeDropdownValue;
  String? categoryDropdownValue;
  List<String> tagsDropdownValue = [];

  /// ================= VALIDATION FLAGS =================
  bool _hasImageError = false;

  /// ================= IMAGE =================
  File? _image; // mobile
  Uint8List? _webImage; // web

  // Controller for title, description, content, url
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();
  final TextEditingController _urlController = TextEditingController();

  final ScrollController _scrollController = ScrollController();
  AutovalidateMode _autoValidateMode = AutovalidateMode.disabled;

  @override
  void initState() {
    super.initState();

    appBarTitle = widget.appBarTitle;
    post = widget.post;

    /// ===== INIT CONTROLLERS (CHỈ 1 LẦN) =====
    _titleController.text = post.title ?? '';
    _descriptionController.text = post.description ?? '';
    _contentController.text = post.content ?? '';
    _urlController.text = post.url ?? '';

    /// ===== INIT DROPDOWN =====
    if (post.author != null && post.author!.isNotEmpty) {
      authorDropdownValue = post.author;
    }
    if (post.postType != null && post.postType!.isNotEmpty) {
      postTypeDropdownValue = post.postType;
    }
    if (post.category != null && post.category!.isNotEmpty) {
      categoryDropdownValue = post.category;
    }
    if (post.tags != null && post.tags!.isNotEmpty) {
      tagsDropdownValue = List<String>.from(post.tags!);
    }

    /// ===== INIT IMAGE =====
    if (post.image != null && post.image!.isNotEmpty) {
      final bytes = base64Decode(post.image!);
      if (kIsWeb) {
        _webImage = bytes;
      } else {
        _image = File.fromRawPath(bytes);
      }
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _titleController.dispose();
    _descriptionController.dispose();
    _contentController.dispose();
    _urlController.dispose();
    super.dispose();
  }

  // ========================= UI =========================

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final fieldTextColor =
        theme.inputDecorationTheme.labelStyle?.color ??
        theme.textTheme.bodyMedium!.color!;

    final isDark = theme.brightness == Brightness.dark;

    final dialogBgColor = isDark ? const Color(0xFF2A2A2A) : Colors.white;
    final dialogTextColor = isDark ? Colors.white70 : Colors.black87;
    final selectedTextColor = isDark ? Colors.white : Colors.black;

    return Scaffold(
      appBar: AppBar(
        title: Text(appBarTitle),
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

      body: Form(
        key: _formKey,

        /// ⚠️ QUAN TRỌNG: KHÔNG auto validate
        autovalidateMode: _autoValidateMode,

        child: SingleChildScrollView(
          controller: _scrollController,
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// TITLE
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(
                  labelText: 'Title',
                  border: OutlineInputBorder(),
                ),
                validator: (v) =>
                    v == null || v.isEmpty ? 'Please enter title' : null,
                onSaved: (text) =>
                    setState(() => post.title = _titleController.text),
              ),

              const SizedBox(height: 16),

              /// IMAGE
              MouseRegion(
                cursor: SystemMouseCursors.click,
                child: GestureDetector(
                  onTap: _showDialog,
                  child: Center(child: _buildImage()),
                ),
              ),
              _buildImageError(),

              const SizedBox(height: 16),

              /// DESCRIPTION
              TextFormField(
                controller: _descriptionController,
                minLines: 3,
                maxLines: 10,
                decoration: const InputDecoration(
                  labelText: 'Description',
                  border: OutlineInputBorder(),
                ),
                validator: (v) =>
                    v == null || v.isEmpty ? 'Please enter description' : null,
                onSaved: (text) => setState(
                  () => post.description = _descriptionController.text,
                ),
              ),

              const SizedBox(height: 16),

              /// CONTENT
              TextFormField(
                controller: _contentController,
                minLines: 8,
                maxLines: 100,
                decoration: const InputDecoration(
                  labelText: 'Content',
                  border: OutlineInputBorder(),
                ),
                validator: (v) =>
                    v == null || v.isEmpty ? 'Please enter content' : null,
                onSaved: (text) =>
                    setState(() => post.content = _contentController.text),
              ),

              const SizedBox(height: 16),

              /// AUTHOR
              DropdownButtonFormField<String>(
                initialValue: authorDropdownValue,
                isExpanded: true,
                decoration: const InputDecoration(
                  labelText: 'Author',
                  border: OutlineInputBorder(),
                ),
                items: _author
                    .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                    .toList(),
                onChanged: (v) => setState(() {
                  authorDropdownValue = v;
                  post.author = authorDropdownValue;
                }),
                validator: (v) => v == null ? 'Please select author' : null,
                onSaved: (v) => setState(() => post.author = v),
              ),

              const SizedBox(height: 16),

              /// POST TYPE
              DropdownButtonFormField<String>(
                initialValue: postTypeDropdownValue,
                isExpanded: true,
                decoration: const InputDecoration(
                  labelText: 'Post Type',
                  border: OutlineInputBorder(),
                ),
                items: _postType
                    .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                    .toList(),
                onChanged: (v) => setState(() {
                  postTypeDropdownValue = v;
                  post.postType = postTypeDropdownValue;
                }),
                validator: (v) => v == null ? 'Please select post type' : null,
                onSaved: (v) => setState(() => post.postType = v),
              ),

              const SizedBox(height: 16),

              /// CATEGORY
              DropdownButtonFormField<String>(
                initialValue: categoryDropdownValue,
                isExpanded: true,
                decoration: const InputDecoration(
                  labelText: 'Category',
                  border: OutlineInputBorder(),
                ),
                items: _category
                    .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                    .toList(),
                onChanged: (v) => setState(() {
                  categoryDropdownValue = v;
                  post.category = categoryDropdownValue;
                }),
                validator: (v) => v == null ? 'Please select category' : null,
                onSaved: (v) => setState(() => post.category = v),
              ),

              const SizedBox(height: 16),

              /// TAGS
              FormField<List<String>>(
                initialValue: tagsDropdownValue,
                validator: (values) {
                  if (values == null || values.isEmpty) {
                    return '\t\t\tPlease select tags';
                  }
                  return null;
                },
                builder: (state) {
                  return InputDecorator(
                    decoration: InputDecoration(
                      // labelText: 'Tags',
                      errorText: state.hasError ? state.errorText : null,
                      border: const OutlineInputBorder(),
                      isDense: true,
                      contentPadding: const EdgeInsets.only(
                        top: 7,
                        bottom: 7,
                        right: 0,
                        left: 2,
                      ),
                    ),
                    child: IconTheme(
                      data: IconThemeData(
                        color: fieldTextColor, // ✅ icon xám giống field khác
                      ),
                      child: MultiSelectDialogField<String>(
                        decoration: const BoxDecoration(), // bỏ padding nội bộ
                        backgroundColor: dialogBgColor, // ✅ nền dialog
                        itemsTextStyle: TextStyle(
                          color: dialogTextColor,
                          fontSize: 16,
                        ),
                        selectedItemsTextStyle: TextStyle(
                          color: selectedTextColor,
                          fontWeight: FontWeight.w600,
                        ),
                        title: Text(
                          'Select Tags',
                          style: TextStyle(
                            color: selectedTextColor,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        confirmText: Text(
                          'OK',
                          style: TextStyle(color: theme.colorScheme.primary),
                        ),
                        cancelText: Text(
                          'CANCEL',
                          style: TextStyle(color: dialogTextColor),
                        ),
                        buttonText: Text(
                          'Select tags',
                          style: TextStyle(
                            fontSize: 16,
                            color:
                                theme.inputDecorationTheme.labelStyle?.color ??
                                theme.textTheme.bodyMedium!.color!,
                          ),
                        ),
                        items: _tags.map((e) => MultiSelectItem(e, e)).toList(),
                        initialValue: tagsDropdownValue,
                        listType: MultiSelectListType.LIST,
                        onConfirm: (values) {
                          setState(() {
                            tagsDropdownValue = values;
                          });
                          state.didChange(values);
                        },
                        onSaved: (v) => setState(() {
                          if (v == null) return;
                          post.tags = v;
                        }),
                      ),
                    ),
                  );
                },
              ),

              const SizedBox(height: 16),

              /// URL
              TextFormField(
                controller: _urlController,
                decoration: const InputDecoration(
                  labelText: 'URL',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter URL';
                  }
                  final reg = RegExp(
                    r'(https?|http)://[-A-Z0-9.]+',
                    caseSensitive: false,
                  );
                  return reg.hasMatch(value)
                      ? null
                      : 'Please enter a valid URL';
                },
                onSaved: (text) =>
                    setState(() => post.url = _urlController.text),
              ),

              const SizedBox(height: 32),

              /// SUBMIT
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  onPressed: _saveForm,
                  child: Text(appBarTitle),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ========================= IMAGE =========================

  Widget _buildImage() {
    final hasImage =
        (kIsWeb && _webImage != null) || (!kIsWeb && _image != null);

    return Container(
      width: 360,
      height: 240,
      decoration: BoxDecoration(
        border: Border.all(
          color: _hasImageError
              ? Theme.of(context).colorScheme.error
              : Theme.of(context).dividerColor,
          width: _hasImageError ? 2.5 : 1,
        ),
      ),
      child: hasImage
          ? (kIsWeb
                ? Image.memory(_webImage!, fit: BoxFit.contain)
                : Image.file(_image!, fit: BoxFit.contain))
          : Image.asset('images/no_image_selected.png', fit: BoxFit.fill),
    );
  }

  Widget _buildImageError() {
    if (!_hasImageError) return const SizedBox.shrink();
    return Padding(
      padding: const EdgeInsets.only(top: 4, left: 16),
      child: Text(
        'Please choose an image',
        style: TextStyle(
          color: Theme.of(context).colorScheme.error,
          fontSize: 12,
        ),
      ),
    );
  }

  // ========================= LOGIC =========================

  Future<void> _getImage(ImageSource source) async {
    final picker = ImagePicker();
    final XFile? file = await picker.pickImage(source: source);
    if (file == null) return;

    if (kIsWeb) {
      final bytes = await file.readAsBytes();
      setState(() {
        _webImage = bytes;
        _hasImageError = false;
      });
      post.image = base64Encode(bytes);
    } else {
      setState(() {
        _image = File(file.path);
        _hasImageError = false;

        List<int> imageBytes = _image!.readAsBytesSync();
        post.image = base64Encode(imageBytes);
      });
    }
  }

  void _showDialog() {
    showDialog(
      context: context,
      builder: (_) => SimpleDialog(
        title: const Text('Select Image'),
        children: [
          SimpleDialogOption(
            onPressed: () {
              Navigator.pop(context);
              _getImage(ImageSource.gallery);
            },
            child: const Text('Pick from Gallery'),
          ),
          if (!kIsWeb)
            SimpleDialogOption(
              onPressed: () {
                Navigator.pop(context);
                _getImage(ImageSource.camera);
              },
              child: const Text('Take a New Picture'),
            ),
        ],
      ),
    );
  }

  void _saveForm() {
    final isValid = _formKey.currentState?.validate() ?? false;

    final hasImage =
        (kIsWeb && _webImage != null) || (!kIsWeb && _image != null);

    setState(() {
      _hasImageError = !hasImage;
    });

    if (!isValid || !hasImage || tagsDropdownValue.isEmpty) {
      _autoValidateMode = AutovalidateMode.onUserInteraction;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _scrollController.animateTo(
          0,
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeOut,
        );
      });
      return;
    }

    _formKey.currentState!.save();

    post.createdDate = DateFormat("yyyy-MM-dd HH:mm").format(DateTime.now());

    Navigator.pop(context, true);

    final provider = context.read<PostsProvider>();

    if (post.id != null) {
      provider.updatePost(post);
    } else {
      provider.addPost(post);
    }
    provider.resetFilter();

    showCenterToast(context, 'Post Saved Successfully');
  }
}
