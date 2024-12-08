import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../service/api_service.dart';



class AddLessonScreen extends StatefulWidget {
  final String courseId;

  const AddLessonScreen({Key? key, required this.courseId}) : super(key: key);

  @override
  _AddLessonScreenState createState() => _AddLessonScreenState();
}

class _AddLessonScreenState extends State<AddLessonScreen> {
  final TextEditingController _nameController = TextEditingController();
  XFile? _videoFile;
  final ApiService apiService = ApiService();

  Future<void> _addLesson() async {
    if (_nameController.text.isEmpty || _videoFile == null) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Please fill all fields')));
      return;
    }

    try {
      await apiService.addLesson(_nameController.text, _videoFile!.path, widget.courseId);
      Navigator.pop(context, true); // Trả về true để thông báo thành công
    } catch (e) {
      print(e);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to add lesson')));
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
      appBar: AppBar(title: Text('Thêm bài học')),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _nameController,
              decoration: InputDecoration(labelText: 'Tên bài học'),
            ),
            SizedBox(height: 10),
            Text('Course ID: ${widget.courseId}'),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: _pickVideo,
              child: Text('Chọn video'),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: _addLesson,
              child: Text('Thêm bài học'),
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