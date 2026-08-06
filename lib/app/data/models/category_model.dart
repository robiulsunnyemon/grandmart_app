// ════════════════════════════════════════════════════════════════════════════
//  GRANDMART — Category Model
// ════════════════════════════════════════════════════════════════════════════

class CategoryModel {
  final int id;
  final String name;
  final String slug;
  final String? description;
  final String? iconUrl;
  final int? parentId;
  final List<CategoryModel> children;

  CategoryModel({
    required this.id,
    required this.name,
    required this.slug,
    this.description,
    this.iconUrl,
    this.parentId,
    this.children = const [],
  });

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      slug: json['slug'] ?? '',
      description: json['description'],
      iconUrl: json['icon_url'],
      parentId: json['parent_id'],
      children: (json['children'] as List<dynamic>?)
              ?.map((item) => CategoryModel.fromJson(item as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'slug': slug,
      'description': description,
      'icon_url': iconUrl,
      'parent_id': parentId,
      'children': children.map((c) => c.toJson()).toList(),
    };
  }
}
