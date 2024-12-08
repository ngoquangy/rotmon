import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/lesson.dart';

class ApiService {
  static const String _baseUrl = 'http://127.0.0.1:8000/api/v1/baihoc';

  Future<List<Lesson>> fetchLessons() async {
  final response = await http.get(Uri.parse(_baseUrl));
  if (response.statusCode == 200) {
    final data = jsonDecode(response.body);
    return (data['data'] as List)
        .map((lessonJson) => Lesson.fromJson(lessonJson))
        .toList();
  } else {
    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');
    throw Exception('Failed to load lessons');
  }
}

  // Lấy bài học theo ID khóa học
  Future<List<Lesson>> fetchLessonsByCourseId(String courseId) async {
    final response = await http.get(Uri.parse('$_baseUrl?course_id=$courseId'));
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return (data['data'] as List)
          .map((lessonJson) => Lesson.fromJson(lessonJson))
          .toList();
    } else {
      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');
      throw Exception('Failed to load lessons for course ID: $courseId');
    }
  }

  Future<void> addLesson(String name, String videoPath, String courseId) async {
    var request = http.MultipartRequest('POST', Uri.parse(_baseUrl));
    request.fields['ten_bai_hoc'] = name;
    request.fields['id_khoahoc'] = courseId;
    request.files.add(await http.MultipartFile.fromPath('video', videoPath));

    final response = await request.send();
    if (response.statusCode != 201) {
      throw Exception('Failed to add lesson');
    }
  }

  Future<void> updateLesson(int id, String name, String? videoPath, int? courseId) async {
    var request = http.MultipartRequest('POST', Uri.parse('$_baseUrl/$id'));
    request.fields['_method'] = 'PUT';
    if (name.isNotEmpty) request.fields['ten_bai_hoc'] = name;
    if (courseId != null) request.fields['id_khoahoc'] = courseId.toString();
    if (videoPath != null) {
      request.files.add(await http.MultipartFile.fromPath('video', videoPath));
    }

    final response = await request.send();
    if (response.statusCode != 200) {
      throw Exception('Failed to update lesson');
    }
  }

  Future<void> deleteLesson(int id) async {
    final response = await http.delete(Uri.parse('$_baseUrl/$id'));
    if (response.statusCode != 200) {
      throw Exception('Failed to delete lesson');
    }
  }
}