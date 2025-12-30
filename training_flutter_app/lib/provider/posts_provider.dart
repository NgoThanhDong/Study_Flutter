import 'package:flutter/material.dart';
import '../model/post.dart';
import '../repository/posts_repository.dart';

class PostsProvider extends ChangeNotifier {
  final PostsRepository _repository = PostsRepository();
  List<Post> _posts = [];

  List<Post> get posts => _posts;

  /// FILTER STATE
  String searchText = '';
  String categorySelect = '';
  String tagSelect = '';
  String postTypeSelect = '';

  PostsProvider() {
    _loadPosts();
  }

  void _loadPosts() {
    _posts = _repository.loadPosts(
      searchText,
      categorySelect,
      tagSelect,
      postTypeSelect,
    );
    notifyListeners();
  }

  void updateSearch(String value) {
    searchText = value;
    _loadPosts();
  }

  void updateCategory(String value) {
    categorySelect = value == 'All' ? '' : value;
    _loadPosts();
  }

  void updateTag(String value) {
    tagSelect = value == 'All' ? '' : value;
    _loadPosts();
  }

  void updatePostType(String value) {
    postTypeSelect = value == 'All' ? '' : value;
    _loadPosts();
  }

  void addPost(Post post) {
    post.id = _repository.allPosts.length + 1;
    _repository.allPosts.add(post);
    _loadPosts();
  }

  void resetFilter() {
    searchText = '';
    categorySelect = '';
    tagSelect = '';
    postTypeSelect = '';
    notifyListeners();
  }

}
