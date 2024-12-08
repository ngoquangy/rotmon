class Lesson {
  final int id;
  final String name;
  final String videoUrl;
  final int courseId;

  Lesson({required this.id, required this.name, required this.videoUrl, required this.courseId});

  factory Lesson.fromJson(Map<String, dynamic> json) {
    return Lesson(
      id: json['id'],
      name: json['ten_bai_hoc'],
      videoUrl: json['video'],
      courseId: int.parse(json['id_khoahoc']),
    );
  }
}