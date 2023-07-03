class Post {
  final String title;
  final String description;
  final double id;
  final DateTime createdAt;

  Post({
    required this.id,
    required this.title,
    required this.description,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();
}
