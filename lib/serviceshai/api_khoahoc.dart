import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/course.dart';

class ApiKhoaHocService {
  static const String _baseUrl = 'http://127.0.0.1:8000/api/v1/khoahoc';

  Future<List<Course>> fetchCourses() async {
    final response = await http.get(Uri.parse(_baseUrl));
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return (data['data'] as List)
          .map((courseJson) => Course.fromJson(courseJson))
          .toList();
    } else {
      throw Exception('Failed to load courses');
    }
  }

  Future<void> addCourse(String name, String description, String imagePath) async {
    final request = http.MultipartRequest('POST', Uri.parse(_baseUrl));
    request.fields['ten_khoa_hoc'] = name;
    request.fields['mota'] = description;
    request.files.add(await http.MultipartFile.fromPath('image', imagePath));

    final response = await request.send();
    if (response.statusCode != 201) {
      throw Exception('Failed to add course');
    }
  }

  Future<void> updateCourse(int id, String? name, String? description, String? imagePath) async {
    final request = http.MultipartRequest('POST', Uri.parse('$_baseUrl/$id'));
    request.fields['_method'] = 'PUT';
    if (name != null) request.fields['ten_khoa_hoc'] = name;
    if (description != null) request.fields['mota'] = description;
    if (imagePath != null) {
      request.files.add(await http.MultipartFile.fromPath('image', imagePath));
    }

    final response = await request.send();
    if (response.statusCode != 200) {
      throw Exception('Failed to update course');
    }
  }

  Future<void> deleteCourse(int id) async {
    final response = await http.delete(Uri.parse('$_baseUrl/$id'));
    if (response.statusCode != 200) {
      throw Exception('Failed to delete course');
    }
  }

  
}
