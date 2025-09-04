class Group {
  final String id;
  final String name;
  final String description;
  final int memberCount;
  final DateTime createdAt;
  final String? category;
  final String? privacy;
  final bool? trending;
  final String? recentActivity;

  Group({
    required this.id,
    required this.name,
    required this.description,
    required this.memberCount,
    required this.createdAt,
    this.category,
    this.privacy,
    this.trending,
    this.recentActivity,
  });

  factory Group.fromJson(Map<String, dynamic> json) {
    return Group(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      memberCount: json['memberCount'],
      createdAt: DateTime.parse(json['createdAt']),
      category: json['category'],
      privacy: json['privacy'],
      trending: json['trending'],
      recentActivity: json['recentActivity'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'memberCount': memberCount,
      'createdAt': createdAt.toIso8601String(),
      'category': category,
      'privacy': privacy,
      'trending': trending,
      'recentActivity': recentActivity,
    };
  }
}