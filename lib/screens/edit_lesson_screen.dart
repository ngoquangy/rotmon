import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../models/lesson.dart';
import '../service/api_service.dart';

class EditLessonScreen extends StatefulWidget {
  final Lesson lesson;

  const EditLessonScreen({Key? key, required this.lesson}) : super(key: key);

  @override
  _EditLessonScreenState createState() => _EditLessonScreenState();
}

class _EditLessonScreenState extends State<EditLessonScreen> {
  late TextEditingController _nameController;
  XFile? _videoFile;
  final ApiService apiService = ApiService();

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.lesson.name);
  }

  Future<void> _updateLesson() async {
    try {
      await apiService.updateLesson(
        widget.lesson.id,
        _nameController.text,
        _videoFile?.path,
        widget.lesson.courseId, // Giữ nguyên courseId của bài học
      );
      Navigator.pop(context, true);
    } catch (e) {
      print(e);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to update lesson')));
    }
  }

  Future<void> _pickVideo() async {
    final ImagePicker picker = ImagePicker();
    final video = await picker.pickVideo(source: ImageSource.gallery);
    setState(() {
      _videoFile = video;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Sửa bài học')),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _nameController,
              decoration: InputDecoration(labelText: 'Tên bài học'),
            ),
            SizedBox(height: 10),
            Text('Course ID: ${widget.lesson.courseId}'), // Hiển thị courseId
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: _pickVideo,
              child: Text('Chọn video mới'),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: _updateLesson,
              child: Text('Lưu thay đổi'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }
}