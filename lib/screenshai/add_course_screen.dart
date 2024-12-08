import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../serviceshai/api_khoahoc.dart';

class AddCourseScreen extends StatefulWidget {
  @override
  _AddCourseScreenState createState() => _AddCourseScreenState();
}

class _AddCourseScreenState extends State<AddCourseScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  File? _image;
  final ApiKhoaHocService apiService = ApiKhoaHocService();

  Future<void> _pickImage() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  Future<void> _addCourse() async {
    if (_nameController.text.isEmpty || _descriptionController.text.isEmpty || _image == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please fill all fields and pick an image')),
      );
      return;
    }

    try {
      await apiService.addCourse(
        _nameController.text,
        _descriptionController.text,
        _image!.path,
      );
      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to add course')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Thêm khóa học')),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _nameController,
              decoration: InputDecoration(labelText: 'Tên khóa học'),
            ),
            TextField(
              controller: _descriptionController,
              decoration: InputDecoration(labelText: 'Mô tả'),
            ),
            SizedBox(height: 10),
            _image != null
                ? Image.file(_image!, height: 150, width: 150, fit: BoxFit.cover)
                : SizedBox(),
            ElevatedButton(
              onPressed: _pickImage,
              child: Text('Chọn ảnh'),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: _addCourse,
              child: Text('Thêm khóa học'),
            ),
          ],
        ),
      ),
    );
  }
}
