class Category {
  final int? categoryId;
  final String name;
  final String? description;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final DateTime? deletedAt;

  Category({
    this.categoryId,
    required this.name,
    this.description,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
  });
}