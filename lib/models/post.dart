class Post {
  final String id;
  final String groupId;
  final String authorId;
  final String authorName;
  final String content;
  final DateTime createdAt;

  Post({
    required this.id,
    required this.groupId,
    required this.authorId,
    required this.authorName,
    required this.content,
    required this.createdAt,
  });

  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      id: json['id'],
      groupId: json['groupId'],
      authorId: json['authorId'],
      authorName: json['authorName'],
      content: json['content'],
      createdAt: DateTime.parse(json['createdAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'groupId': groupId,
      'authorId': authorId,
      'authorName': authorName,
      'content': content,
      'createdAt': createdAt.toIso8601String(),
    };
  }
}