import 'package:flutter/material.dart';
import 'add_lesson_screen.dart';
import 'edit_lesson_screen.dart';
import '../models/lesson.dart';
import '../service/api_service.dart';

class LessonListScreen extends StatefulWidget {
  @override
  _LessonListScreenState createState() => _LessonListScreenState();
}

class _LessonListScreenState extends State<LessonListScreen> {
  late Future<List<Lesson>> lessons;
  final ApiService apiService = ApiService();

  @override
  void initState() {
    super.initState();
    lessons = apiService.fetchLessons();
  }

  void _refreshLessons() {
    setState(() {
      lessons = apiService.fetchLessons();
    });
  }

  Future<void> _deleteLesson(int id) async {
    try {
      await apiService.deleteLesson(id);
      _refreshLessons();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to delete lesson')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Danh sách bài học'),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AddLessonScreen(courseId: '1')),
              ).then((_) => _refreshLessons());
            },
          ),
        ],
      ),
      body: FutureBuilder<List<Lesson>>(
        future: lessons,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Failed to load lessons'));
          } else {
            final lessons = snapshot.data!;
            return ListView.builder(
              itemCount: lessons.length,
              itemBuilder: (context, index) {
                final lesson = lessons[index];
                return ListTile(
                  title: Text(lesson.name),
                  subtitle: Text(lesson.videoUrl),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(Icons.edit, color: Colors.blue),
                        onPressed: () async {
                          final result = await Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => EditLessonScreen(lesson: lesson)),
                          );
                          if (result == true) {
                            _refreshLessons();
                          }
                        },
                      ),
                      IconButton(
                        icon: Icon(Icons.delete, color: Colors.red),
                        onPressed: () => _deleteLesson(lesson.id),
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