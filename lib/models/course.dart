class Course {
  final int id;
  final String name;
  final String description;
  final String imageUrl;
  final String createdAt;
  final String updatedAt;

  Course({
    required this.id,
    required this.name,
    required this.description,
    required this.imageUrl,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Course.fromJson(Map<String, dynamic> json) {
    return Course(
      id: json['id'],
      name: json['ten_khoa_hoc'],
      description: json['mota'],
      imageUrl: json['image'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
    );
  }
}
