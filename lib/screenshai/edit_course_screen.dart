import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../serviceshai/api_khoahoc.dart';
import '../models/course.dart';

class EditCourseScreen extends StatefulWidget {
  final Course course;

  const EditCourseScreen({Key? key, required this.course}) : super(key: key);

  @override
  _EditCourseScreenState createState() => _EditCourseScreenState();
}

class _EditCourseScreenState extends State<EditCourseScreen> {
  late TextEditingController _nameController;
  late TextEditingController _descriptionController;
  File? _newImage;
  final ApiKhoaHocService apiService = ApiKhoaHocService();

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.course.name);
    _descriptionController = TextEditingController(text: widget.course.description);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _newImage = File(pickedFile.path);
      });
    }
  }

  Future<void> _updateCourse() async {
    if (_nameController.text.isEmpty &&
        _descriptionController.text.isEmpty &&
        _newImage == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('No changes made')),
      );
      return;
    }

    try {
      await apiService.updateCourse(
        widget.course.id,
        _nameController.text.isEmpty ? null : _nameController.text,
        _descriptionController.text.isEmpty ? null : _descriptionController.text,
        _newImage?.path,
      );
      Navigator.pop(context, true); // Trả về `true` để báo thành công
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to update course')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Sửa khóa học')),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _nameController,
              decoration: InputDecoration(
                labelText: 'Tên khóa học',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16.0),
            TextField(
              controller: _descriptionController,
              maxLines: 3,
              decoration: InputDecoration(
                labelText: 'Mô tả',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16.0),
            Text('Hình ảnh hiện tại:', style: TextStyle(fontWeight: FontWeight.bold)),
            SizedBox(height: 8.0),
            _newImage != null
                ? Image.file(
                    _newImage!,
                    height: 150,
                    width: 150,
                    fit: BoxFit.cover,
                  )
                : Image.network(
                    widget.course.imageUrl,
                    height: 150,
                    width: 150,
                    fit: BoxFit.cover,
                  ),
            SizedBox(height: 16.0),
            ElevatedButton.icon(
              onPressed: _pickImage,
              icon: Icon(Icons.image),
              label: Text('Chọn ảnh mới'),
            ),
            SizedBox(height: 32.0),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _updateCourse,
                child: Text('Lưu thay đổi'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
