import 'dart:convert';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rive/rive.dart';
import 'package:training_flutter_app/animation/fading_circle.dart';
import 'package:training_flutter_app/animation/slide_right_route.dart';

import 'package:training_flutter_app/provider/posts_provider.dart';
import 'package:training_flutter_app/screen/create_post.dart';
import 'package:training_flutter_app/screen/post_detail.dart';
import 'package:training_flutter_app/model/post.dart';
import 'package:training_flutter_app/theme/theme_provider.dart';
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
  bool get _isDark => Theme.of(context).brightness == Brightness.dark;

  bool _isLoading = true;

  @override
  void initState() {
    super.initState();

    Future.delayed(const Duration(seconds: 2), () {
      if (!mounted) return;
      setState(() {
        _isLoading = false;
      });
    });
  }

  BoxDecoration _buildBoxDecoration(bool isSelected) {
    if (_isDark) {
      return BoxDecoration(
        color: const Color(0xFF1E1E1E),
        border: Border(
          bottom: BorderSide(
            color: isSelected ? Colors.white70 : Colors.transparent,
            width: 4,
          ),
        ),
      );
    }

    // LIGHT MODE (GIỮ Y NGUYÊN)
    return BoxDecoration(
      color: Colors.blue,
      border: Border(
        bottom: BorderSide(
          color: isSelected ? Colors.white : Colors.blue,
          width: 4,
        ),
      ),
    );
  }

  ButtonStyle _buildTextButtonStyle() {
    return TextButton.styleFrom(
      foregroundColor: Colors.white,
      padding: EdgeInsets.zero,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
    );
  }

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
      actions: [
        IconButton(icon: _arrowDrop, onPressed: _arrowDropPressed),
        Consumer<ThemeProvider>(
          builder: (context, themeProvider, _) {
            return IconButton(
              tooltip: themeProvider.isDarkMode ? 'Dark mode' : 'Light mode',
              icon: AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                transitionBuilder: (child, anim) =>
                    RotationTransition(turns: anim, child: child),
                child: Icon(
                  themeProvider.isDarkMode ? Icons.dark_mode : Icons.light_mode,
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
                        context: context,
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
                        context: context,
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
        decoration: _buildBoxDecoration(isSelected),
        child: TextButton(
          style: _buildTextButtonStyle(),
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
    required BuildContext context,
    required String hint,
    required String value,
    required List<String> items,
    required ValueChanged<String?> onChanged,
  }) {
    final dropdownBgColor = _isDark
        ? Colors.grey.shade800
        : Colors.lightBlueAccent;

    final textColor = Colors.white;
    final underlineColor = Colors.white;

    return DropdownButton<String>(
      isExpanded: true,
      value: value,
      style: TextStyle(color: textColor, fontSize: 16),
      dropdownColor: dropdownBgColor,
      hint: Text(hint, style: TextStyle(color: textColor)),
      icon: Icon(Icons.arrow_drop_down, color: textColor),
      underline: Container(height: 1, color: underlineColor),
      items: items
          .map((e) => DropdownMenuItem(value: e, child: Text(e)))
          .toList(),
      onChanged: onChanged,
    );
  }

  /// ================= BODY =================

  Widget _buildBody(List<Post> postList) {
    if (_isLoading) {
      final colorScheme = Theme.of(context).colorScheme;
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Loading...', style: Theme.of(context).textTheme.titleLarge),
            SizedBox(height: 50),
            SpinKitFadingCircle(
              color: colorScheme.primary,
              size: 100,
              shape: SpinKitShape.square,
            ),
          ],
        ),
      );
    }

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
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('No data', style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: 50),
              const SizedBox(
                width: 300,
                height: 300,
                child: RiveAnimation.asset(
                  'assets/animations/nodata.riv',
                  animations: ['idle'],
                  fit: BoxFit.contain,
                ),
              ),
            ],
          ),
        ),
      );
    }

    return ListView.builder(
      controller: _listScrollController,
      itemCount: postList.length,
      itemBuilder: (_, index) {
        final post = postList[index];

        return GestureDetector(
          child: ListTile(
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
                          onSelected: (value) => _showMenuSelection(
                            context,
                            value,
                            postList[index],
                          ),
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
                        Hero(
                          tag: "${post.id}",
                          flightShuttleBuilder:
                              (
                                BuildContext flightContext,
                                Animation<double> animation,
                                HeroFlightDirection flightDirection,
                                BuildContext fromHeroContext,
                                BuildContext toHeroContext,
                              ) {
                                final Hero toHero =
                                    toHeroContext.widget as Hero;

                                return ScaleTransition(
                                  scale: animation.drive(
                                    Tween<double>(begin: 0.0, end: 1.0).chain(
                                      CurveTween(
                                        curve: Interval(
                                          0.0,
                                          1.0,
                                          curve: PeakQuadraticCurve(),
                                        ),
                                      ),
                                    ),
                                  ),
                                  child:
                                      flightDirection ==
                                          HeroFlightDirection.push
                                      ? RotationTransition(
                                          turns: animation,
                                          child: toHero.child,
                                        )
                                      : FadeTransition(
                                          opacity: animation.drive(
                                            Tween<double>(
                                              begin: 0.0,
                                              end: 1.0,
                                            ).chain(
                                              CurveTween(
                                                curve: Interval(
                                                  0.0,
                                                  1.0,
                                                  curve: ValleyQuadraticCurve(),
                                                ),
                                              ),
                                            ),
                                          ),
                                          child: toHero.child,
                                        ),
                                );
                              },

                          child: Image.memory(
                            Base64Decoder().convert(post.image!),
                            width: 100,
                            height: 100,
                          ),
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
              SlideRightRoute(page: PostDetail(post: post)),
              // MaterialPageRoute(builder: (_) => PostDetail(post: post)),
            ),
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
      SlideRightRoute(page: CreatePost(appBarTitle: 'Create Post', post: Post.empty())),
      // MaterialPageRoute(
      //   builder: (_) =>
      //       CreatePost(appBarTitle: 'Create Post', post: Post.empty()),
      // ),
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
        SlideRightRoute(page: CreatePost(appBarTitle: 'Edit Post', post: post)),
        // MaterialPageRoute(
        //   builder: (_) => CreatePost(appBarTitle: 'Edit Post', post: post),
        // ),
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

class ValleyQuadraticCurve extends Curve {
  @override
  double transform(double t) {
    assert(t >= 0.0 && t <= 1.0);
    return 4 * math.pow(t - 0.5, 2).toDouble();
  }
}

class PeakQuadraticCurve extends Curve {
  @override
  double transform(double t) {
    assert(t >= 0.0 && t <= 1.0);
    return -15 * math.pow(t, 2) + 15 * t + 1;
  }
}
