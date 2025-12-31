import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:training_flutter_app/provider/posts_provider.dart';
import 'package:training_flutter_app/screen/create_post.dart';
import 'package:training_flutter_app/screen/post_detail.dart';
import 'package:training_flutter_app/model/post.dart';
import 'package:training_flutter_app/utils/center_toast.dart';

enum PostFilter { all, news, blog }

class PostList extends StatefulWidget {
  const PostList({super.key});

  @override
  State<PostList> createState() => _PostListState();
}

class _PostListState extends State<PostList> {
  final ScrollController _listScrollController = ScrollController();

  /// SEARCH APP BAR
  final TextEditingController _searchController = TextEditingController();
  Widget _appBarTitle = const Text('Search for posts');
  Icon _searchIcon = const Icon(Icons.search);
  Icon _arrowDrop = const Icon(Icons.arrow_drop_up);

  /// BOTTOM APP BAR
  double _heightBottomAppBar = 90.0;

  /// DROPDOWN DATA
  final List<String> _categories = ['All', 'Game', 'Phần Mềm', 'Học Lập Trình'];
  final List<String> _tags = [
    'All',
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

  /// FILTER UI STATE
  PostFilter _selectedFilter = PostFilter.all;

  /// STYLES
  final BoxDecoration _boxDecorationSelected = const BoxDecoration(
    color: Colors.blue,
    border: Border(bottom: BorderSide(color: Colors.white, width: 4)),
  );

  final BoxDecoration _boxDecorationUnselected = const BoxDecoration(
    color: Colors.blue,
    border: Border(bottom: BorderSide(color: Colors.blue, width: 4)),
  );

  final ButtonStyle _textButtonStyle = TextButton.styleFrom(
    foregroundColor: Colors.white,
    padding: EdgeInsets.zero,
    shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
  );

  @override
  void dispose() {
    _searchController.dispose();
    _listScrollController.dispose();
    super.dispose();
  }

  /// ================= UI =================

  @override
  Widget build(BuildContext context) {
    final posts = context.watch<PostsProvider>().posts;

    return Scaffold(appBar: _buildAppBar(), body: _buildBody(posts));
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      centerTitle: true,
      title: _appBarTitle,
      leading: IconButton(icon: _searchIcon, onPressed: _searchPressed),
      actions: [IconButton(icon: _arrowDrop, onPressed: _arrowDropPressed)],
      bottom: PreferredSize(
        preferredSize: Size.fromHeight(_heightBottomAppBar),
        child: _bottomAppBar(),
      ),
    );
  }

  /// ================= BOTTOM APP BAR =================

  Widget _bottomAppBar() {
    return Consumer<PostsProvider>(
      builder: (_, provider, _) {
        final categoryValue = provider.categorySelect.isEmpty
            ? 'All'
            : provider.categorySelect;
        final tagValue = provider.tagSelect.isEmpty
            ? 'All'
            : provider.tagSelect;

        return SizedBox(
          height: _heightBottomAppBar,
          child: Column(
            children: [
              SizedBox(
                height: 48,
                child: Row(
                  children: [
                    const Spacer(),
                    Expanded(
                      flex: 5,
                      child: _buildDropdown(
                        hint: 'Category',
                        value: categoryValue,
                        items: _categories,
                        onChanged: (v) =>
                            provider.updateCategory(v == 'All' ? '' : v!),
                      ),
                    ),
                    const Spacer(),
                    Expanded(
                      flex: 5,
                      child: _buildDropdown(
                        hint: 'Tag',
                        value: tagValue,
                        items: _tags,
                        onChanged: (v) =>
                            provider.updateTag(v == 'All' ? '' : v!),
                      ),
                    ),
                    const Spacer(),
                  ],
                ),
              ),
              SizedBox(
                height: 38,
                child: Row(
                  children: [
                    _buildFilterButton('All', PostFilter.all),
                    _buildFilterButton('News', PostFilter.news),
                    _buildFilterButton('Blog', PostFilter.blog),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildFilterButton(String text, PostFilter filter) {
    final isSelected = _selectedFilter == filter;

    return Expanded(
      child: Container(
        decoration: isSelected
            ? _boxDecorationSelected
            : _boxDecorationUnselected,
        child: TextButton(
          style: _textButtonStyle,
          onPressed: () {
            setState(() => _selectedFilter = filter);
            context.read<PostsProvider>().updatePostType(
              filter == PostFilter.all
                  ? ''
                  : '${filter.name[0].toUpperCase()}${filter.name.substring(1)}',
            );
          },
          child: Text(
            text,
            style: TextStyle(
              fontWeight: isSelected ? FontWeight.w900 : FontWeight.w400,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDropdown({
    required String hint,
    required String value,
    required List<String> items,
    required ValueChanged<String?> onChanged,
  }) {
    return DropdownButton<String>(
      isExpanded: true,
      value: value,
      style: const TextStyle(color: Colors.white, fontSize: 16),
      dropdownColor: Colors.lightBlueAccent,
      hint: Text(hint, style: const TextStyle(color: Colors.white)),
      icon: const Icon(Icons.arrow_drop_down, color: Colors.white),
      underline: Container(height: 1, color: Colors.white),
      items: items
          .map((e) => DropdownMenuItem(value: e, child: Text(e)))
          .toList(),
      onChanged: onChanged,
    );
  }

  /// ================= BODY =================

  Widget _buildBody(List<Post> postList) {
    return Column(
      children: [
        Expanded(child: _buildPostList(postList)),
        Padding(
          padding: const EdgeInsets.all(16),
          child: SizedBox(
            width: double.infinity,
            height: 48,
            child: ElevatedButton(
              onPressed: _createPostPressed,
              child: const Text('Create Post'),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPostList(List<Post> postList) {
    if (postList.isEmpty) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Text(
            'No data',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 24),
          ),
        ),
      );
    }

    return ListView.builder(
      controller: _listScrollController,
      itemCount: postList.length,
      itemBuilder: (_, index) {
        final post = postList[index];

        return ListTile(
          title: Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Text(
                          post.title!,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),

                      PopupMenuButton(
                        padding: EdgeInsets.zero,
                        icon: Icon(Icons.more_vert),
                        onSelected: (value) =>
                            _showMenuSelection(context, value, postList[index]),
                        itemBuilder: (context) => <PopupMenuEntry<String>>[
                          const PopupMenuItem<String>(
                            value: 'Edit',
                            child: ListTile(
                              leading: Icon(Icons.edit, color: Colors.blue),
                              title: Text('Edit'),
                            ),
                          ),
                          PopupMenuDivider(height: 8),
                          const PopupMenuItem<String>(
                            value: 'Delete',
                            child: ListTile(
                              leading: Icon(Icons.delete, color: Colors.red),
                              title: Text('Delete'),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),

                  const SizedBox(height: 8),
                  // Image
                  Row(
                    children: [
                      Image.memory(
                        Base64Decoder().convert(post.image!),
                        width: 100,
                        height: 100,
                      ),
                      const SizedBox(width: 16),
                      Expanded(child: Text(post.description!)),
                    ],
                  ),
                ],
              ),
            ),
          ),
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => PostDetail(post: post)),
          ),
        );
      },
    );
  }

  /// ================= EVENTS =================

  void _searchPressed() {
    setState(() {
      if (_searchIcon.icon == Icons.search) {
        _searchController.text = context.read<PostsProvider>().searchText;
        _searchIcon = const Icon(Icons.close);
        _appBarTitle = TextField(
          controller: _searchController,
          autofocus: true,
          style: const TextStyle(color: Colors.white),
          decoration: const InputDecoration(
            hintText: 'Search...',
            hintStyle: TextStyle(color: Colors.white),
          ),
          onChanged: context.read<PostsProvider>().updateSearch,
        );
      } else {
        _searchIcon = const Icon(Icons.search);
        _appBarTitle = const Text('Search for posts');
        _searchController.clear();
        context.read<PostsProvider>().updateSearch('');
      }
    });
  }

  void _arrowDropPressed() {
    setState(() {
      _heightBottomAppBar = _heightBottomAppBar == 0 ? 90 : 0;
      _arrowDrop = Icon(
        _heightBottomAppBar == 0 ? Icons.arrow_drop_down : Icons.arrow_drop_up,
      );
    });
  }

  /// ================= CREATE POST + SCROLL =================

  void _createPostPressed() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) =>
            CreatePost(appBarTitle: 'Create Post', post: Post.empty()),
      ),
    );

    if (result == true && mounted) {
      setState(() {
        _selectedFilter = PostFilter.all;
      });

      // Scroll xuống cuối danh sách
      _scrollToBottom();
    }
  }

  /// 🔥 SCROLL 100% ĐẾN CUỐI DANH SÁCH
  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_listScrollController.hasClients) return;
      final maxScroll = _listScrollController.position.maxScrollExtent + 300;
      _listScrollController.animateTo(
        maxScroll,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeOut,
      );
    });
  }

  // Delete or edit the post
  void _showMenuSelection(BuildContext context, String value, Post post) async {
    if (value == 'Edit') {
      final result = await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => CreatePost(appBarTitle: 'Edit Post', post: post),
        ),
      );

      if (result == true && mounted) {
        setState(() {
          // _selectedFilter = PostFilter.all;
        });
      }
    } else {
      _showDeleteDialog(context, post);
    }
  }

  void _showDeleteDialog(BuildContext context, Post post) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return SimpleDialog(
          title: Text('Are you want to delete?'),
          children: <Widget>[
            SimpleDialogOption(
              onPressed: () async {
                Navigator.pop(context); //close the dialog box
                _deletePost(context, post.id!);
              },
              child: const Text('OK', style: TextStyle(fontSize: 18.0)),
            ),
            SimpleDialogOption(
              onPressed: () async {
                Navigator.pop(context); //close the dialog box
              },
              child: const Text('Cancel', style: TextStyle(fontSize: 18.0)),
            ),
          ],
        );
      },
    );
  }

  void _deletePost(BuildContext context, int postId) {
    final provider = context.read<PostsProvider>();

    provider.deletePost(postId);
    showCenterToast(context, 'Post Deleted Successfully');
  }
}
