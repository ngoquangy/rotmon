import 'package:flutter/material.dart';
import '../serviceshai/api_khoahoc.dart';
import '../models/course.dart';

class CourseListScreen extends StatefulWidget {
  @override
  _CourseListScreenState createState() => _CourseListScreenState();
}

class _CourseListScreenState extends State<CourseListScreen> {
  late Future<List<Course>> courses;
  final ApiKhoaHocService apiService = ApiKhoaHocService();

  @override
  void initState() {
    super.initState();
    courses = apiService.fetchCourses();
  }

  void _refreshCourses() {
    setState(() {
      courses = apiService.fetchCourses();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Danh sách khóa học'),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              Navigator.pushNamed(context, '/add-course').then((_) => _refreshCourses());
            },
          ),
        ],
      ),
      body: FutureBuilder<List<Course>>(
        future: courses,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Failed to load courses'));
          } else {
            final courses = snapshot.data!;
            return ListView.builder(
              itemCount: courses.length,
              itemBuilder: (context, index) {
                final course = courses[index];
                return ListTile(
                  leading: Image.network(course.imageUrl, width: 50, height: 50),
                  title: Text(course.name),
                  subtitle: Text(course.description),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(Icons.edit, color: Colors.blue),
                        onPressed: () async {
                          final result = await Navigator.pushNamed(
                            context,
                            '/edit-course',
                            arguments: course,
                          );
                          if (result == true) {
                            _refreshCourses();
                          }
                        },
                      ),
                      IconButton(
                        icon: Icon(Icons.delete, color: Colors.red),
                        onPressed: () async {
                          await apiService.deleteCourse(course.id);
                          _refreshCourses();
                        },
                      ),
                    ],
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
