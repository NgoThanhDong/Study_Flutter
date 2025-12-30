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

class CreatePost extends StatefulWidget {
  const CreatePost({super.key});

  @override
  State<CreatePost> createState() => _CreatePostState();
}

class _CreatePostState extends State<CreatePost> {
  /// ================= FORM =================
  final _formKey = GlobalKey<FormState>();
  final ScrollController _scrollController = ScrollController();
  AutovalidateMode _autoValidateMode = AutovalidateMode.disabled;

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
  bool _tagHasError = false;
  bool _hasImageError = false;

  /// ================= IMAGE =================
  File? _image; // mobile
  Uint8List? _webImage; // web

  late final Post post = Post(); // Post object

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  // ========================= UI =========================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Create Post')),
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
                decoration: const InputDecoration(
                  labelText: 'Title',
                  border: OutlineInputBorder(),
                ),
                validator: (v) =>
                    v == null || v.isEmpty ? 'Please enter title' : null,
                onSaved: (text) => setState(() => post.title = text),
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
                minLines: 3,
                maxLines: 10,
                decoration: const InputDecoration(
                  labelText: 'Description',
                  border: OutlineInputBorder(),
                ),
                validator: (v) =>
                    v == null || v.isEmpty ? 'Please enter description' : null,
                onSaved: (text) => setState(() => post.description = text),
              ),

              const SizedBox(height: 16),

              /// CONTENT
              TextFormField(
                minLines: 8,
                maxLines: 100,
                decoration: const InputDecoration(
                  labelText: 'Content',
                  border: OutlineInputBorder(),
                ),
                validator: (v) =>
                    v == null || v.isEmpty ? 'Please enter content' : null,
                onSaved: (text) => setState(() => post.content = text),
              ),

              const SizedBox(height: 16),

              /// AUTHOR
              DropdownButtonFormField<String>(
                isExpanded: true,
                decoration: const InputDecoration(
                  labelText: 'Author',
                  border: OutlineInputBorder(),
                ),
                items: _author
                    .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                    .toList(),
                onChanged: (v) => setState(() => authorDropdownValue = v),
                validator: (v) => v == null ? 'Please select author' : null,
                onSaved: (v) => setState(() => post.author = v),
              ),

              const SizedBox(height: 16),

              /// POST TYPE
              DropdownButtonFormField<String>(
                isExpanded: true,
                decoration: const InputDecoration(
                  labelText: 'Post Type',
                  border: OutlineInputBorder(),
                ),
                items: _postType
                    .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                    .toList(),
                onChanged: (v) => setState(() => postTypeDropdownValue = v),
                validator: (v) => v == null ? 'Please select post type' : null,
                onSaved: (v) => setState(() => post.postType = v),
              ),

              const SizedBox(height: 16),

              /// CATEGORY
              DropdownButtonFormField<String>(
                isExpanded: true,
                decoration: const InputDecoration(
                  labelText: 'Category',
                  border: OutlineInputBorder(),
                ),
                items: _category
                    .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                    .toList(),
                onChanged: (v) => setState(() => categoryDropdownValue = v),
                validator: (v) => v == null ? 'Please select category' : null,
                onSaved: (v) => setState(() => post.category = v),
              ),

              const SizedBox(height: 16),

              /// TAGS
              MultiSelectDialogField<String>(
                decoration: BoxDecoration(
                  border: Border.all(
                    color: _tagHasError
                        ? Theme.of(context).colorScheme.error
                        : Theme.of(context).dividerColor,
                  ),
                  borderRadius: BorderRadius.circular(4),
                ),
                items: _tags.map((e) => MultiSelectItem(e, e)).toList(),
                title: const Text('Tags'),
                buttonText: Text(
                  'Select tags',
                  style: TextStyle(
                    fontSize: 16,
                    color: _tagHasError
                        ? Theme.of(context).colorScheme.error
                        : Theme.of(context).textTheme.bodyLarge?.color,
                  ),
                ),
                listType: MultiSelectListType.LIST,
                onConfirm: (values) => setState(() {
                  tagsDropdownValue = values;
                  _tagHasError = tagsDropdownValue.isEmpty;
                }),
                validator: (values) => values == null || values.isEmpty
                    ? '\t\t\t\tPlease select tags'
                    : null,
                onSaved: (v) => setState(() => post.tags = v),
              ),

              const SizedBox(height: 16),

              /// URL
              TextFormField(
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
                onSaved: (text) => setState(() => post.url = text),
              ),

              const SizedBox(height: 32),

              /// SUBMIT
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  onPressed: _saveForm,
                  child: const Text('Create Post'),
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
      _tagHasError = tagsDropdownValue.isEmpty;
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

    final provider = context.read<PostsProvider>();

    provider.addPost(post);
    provider.resetFilter();

    Navigator.pop(context, true); // ⬅️ gửi signal về
  }
}
