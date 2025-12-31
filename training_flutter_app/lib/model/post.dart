class Post {
  // Attribute
  int? id;
  String? title;
  String? image;
  String? description;
  String? content;
  String? author;
  String? postType;
  String? category;
  List<String>? tags;
  String? url;
  String? createdDate;

  // Constructor
  Post({
    this.id,
    this.title,
    this.image,
    this.description,
    this.content,
    this.author,
    this.postType,
    this.category,
    this.tags,
    this.url,
    this.createdDate,
  });

  /// 🔥 Post rỗng cho Create
  factory Post.empty() {
    return Post(
      title: '',
      image: '',
      description: '',
      content: '',
      author: '',
      postType: '',
      category: '',
      tags: [],
      url: '',
      createdDate: '',
    );
  }
}
