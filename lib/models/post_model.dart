class Post {
  final int id;
  final int userId;
  final String title;
  final String body;
  final bool isLocal;

  Post({
    required this.id,
    required this.userId,
    required this.title,
    required this.body,
    this.isLocal = false, // new flag
  });

  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      id: json['id'],
      userId: json['userId'],
      title: json['title'],
      body: json['body'],
    );
  }
}
