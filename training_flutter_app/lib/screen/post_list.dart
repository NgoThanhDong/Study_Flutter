import 'package:flutter/material.dart';
import 'package:training_flutter_app/screen/create_post.dart';
import 'package:training_flutter_app/screen/post_detail.dart';

enum PostFilter { all, news, blog }

class PostList extends StatefulWidget {
  const PostList({super.key});

  @override
  State<PostList> createState() => _PostListState();
}

class _PostListState extends State<PostList> {
  /// SEARCH APP BAR
  final _searchController = TextEditingController();
  Widget _appBarTitle = const Text('Search for posts');
  Icon _searchIcon = const Icon(Icons.search);
  Icon _arrowDrop = const Icon(Icons.arrow_drop_up);

  /// BOTTOM APP BAR HEIGHT
  double _heightBottomAppBar = 90.0;

  /// DROPDOWN DATA
  final List<String> _categories = ['All', 'Category 1', 'Category 2'];
  final List<String> _tags = ['All', 'Tag 1', 'Tag 2', 'Tag 3', 'Tag 4'];

  String? categoryDropdownValue;
  String? tagDropdownValue;

  /// FILTER STATE
  PostFilter _selectedFilter = PostFilter.all;

  /// STYLES
  final BoxDecoration _boxDecorationWhiteColor = const BoxDecoration(
    color: Colors.blue,
    border: Border(bottom: BorderSide(color: Colors.white, width: 4)),
  );

  final BoxDecoration _boxDecorationBlueColor = const BoxDecoration(
    color: Colors.blue,
    border: Border(bottom: BorderSide(color: Colors.blue, width: 4)),
  );

  final ButtonStyle _textButtonStyle = TextButton.styleFrom(
    foregroundColor: Colors.white,
    padding: EdgeInsets.zero,
    shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
  );

  final TextStyle _textStyleSelected = const TextStyle(
    fontWeight: FontWeight.w900,
  );
  final TextStyle _textStyleUnselected = const TextStyle(
    fontWeight: FontWeight.w400,
  );

  /// SAMPLE DATA
  final List _postListData = [
    {
      'title': '1 title title title title title title title title title',
      'image': 'images/sample.jpg',
      'description':
          '1 Description, description, description, description, description, description, description, description, description, description',
    },
    {
      'title': '2 title title title title title title title title title',
      'image': 'images/sample.jpg',
      'description':
          '2 Description, description, description, description, description, description, description, description, description, description',
    },
    {
      'title': '3 title title title title title title title title title',
      'image': 'images/sample.jpg',
      'description':
          '3 Description, description, description, description, description, description, description, description, description, description',
    },
    {
      'title': '4 title title title title title title title title title',
      'image': 'images/sample.jpg',
      'description':
          '4 Description, description, description, description, description, description, description, description, description, description',
    },
    {
      'title': '5 title title title title title title title title title',
      'image': 'images/sample.jpg',
      'description':
          '5 Description, description, description, description, description, description, description, description, description, description',
    },
    {
      'title': '6 title title title title title title title title title',
      'image': 'images/sample.jpg',
      'description':
          '6 Description, description, description, description, description, description, description, description, description, description',
    },
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  /// ================= UI =================

  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: _buildAppBar(), body: _buildBody());
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

  Widget _bottomAppBar() {
    return SizedBox(
      height: _heightBottomAppBar,
      child: Column(
        children: [
          // Category - Tag
          SizedBox(
            height: 48,
            child: Row(
              children: [
                const Spacer(),
                Expanded(
                  flex: 5,
                  child: _buildDropdown(
                    hint: 'Category',
                    value: categoryDropdownValue,
                    items: _categories,
                    onChanged: (v) => setState(() => categoryDropdownValue = v),
                  ),
                ),
                const Spacer(),
                Expanded(
                  flex: 5,
                  child: _buildDropdown(
                    hint: 'Tag',
                    value: tagDropdownValue,
                    items: _tags,
                    onChanged: (v) => setState(() => tagDropdownValue = v),
                  ),
                ),
                const Spacer(),
              ],
            ),
          ),

          // All, News, Blog button
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
  }

  Widget _buildFilterButton(String text, PostFilter filter) {
    final bool isSelected = _selectedFilter == filter;

    return Expanded(
      child: Container(
        decoration: isSelected
            ? _boxDecorationWhiteColor
            : _boxDecorationBlueColor,
        child: TextButton(
          style: _textButtonStyle,
          onPressed: () => _onFilterPressed(filter),
          child: Text(
            text,
            style: isSelected ? _textStyleSelected : _textStyleUnselected,
          ),
        ),
      ),
    );
  }

  Widget _buildDropdown({
    required String hint,
    required String? value,
    required List<String> items,
    required ValueChanged<String?> onChanged,
  }) {
    return DropdownButton<String>(
      isExpanded: true,
      value: value,
      style: const TextStyle(color: Colors.white, fontSize: 16),
      dropdownColor: Colors.lightBlueAccent,
      focusColor: Colors.blue.withAlpha((0.1 * 255).round()),
      hint: Text(hint, style: const TextStyle(color: Colors.white)),
      icon: const Icon(Icons.arrow_drop_down, color: Colors.white),
      underline: Container(height: 1, color: Colors.white),
      items: items
          .map((e) => DropdownMenuItem(value: e, child: Text(e)))
          .toList(),
      onChanged: onChanged,
    );
  }

  Widget _buildBody() {
    return Column(
      children: [
        Expanded(child: _buildPostList()),
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

  Widget _buildPostList() {
    return ListView.builder(
      itemCount: _postListData.length,
      itemBuilder: (_, index) {
        final post = _postListData[index];
        return ListTile(
          title: Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    post['title'],
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Image.asset(post['image'], width: 100, height: 100),
                      const SizedBox(width: 16),
                      Expanded(child: Text(post['description'])),
                    ],
                  ),
                ],
              ),
            ),
          ),
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const PostDetail()),
          ),
        );
      },
    );
  }

  /// ================= EVENTS =================

  void _onFilterPressed(PostFilter filter) {
    setState(() => _selectedFilter = filter);
  }

  void _searchPressed() {
    setState(() {
      if (_searchIcon.icon == Icons.search) {
        _searchIcon = const Icon(Icons.close);
        _appBarTitle = TextField(
          controller: _searchController,
          autofocus: true,
          style: const TextStyle(color: Colors.white),
          decoration: const InputDecoration(
            hintText: 'Search...',
            hintStyle: TextStyle(color: Colors.white),
          ),
        );
      } else {
        _searchIcon = const Icon(Icons.search);
        _appBarTitle = const Text('Search for posts');
        _searchController.clear();
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

  void _createPostPressed() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const CreatePost()),
    );
  }
}
