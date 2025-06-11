import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:quizzes/admin/screens/question_details_screen.dart';
import '../apis/quiz_api.dart';
import '../helpers/auth_helper.dart';
import '../helpers/http_helper.dart';
import '../models/category_model.dart';
import '../models/quiz_model.dart';
import '../widgets/custom_drawer.dart';
import 'add_edit_quiz_screen.dart';
import 'login_screen.dart';

class QuizzesByCategoryScreen extends StatefulWidget {
  final int categoryId;

  QuizzesByCategoryScreen({required this.categoryId});

  @override
  _QuizzesByCategoryScreenState createState() => _QuizzesByCategoryScreenState();
}

class _QuizzesByCategoryScreenState extends State<QuizzesByCategoryScreen> {
  CategoryModel? category;
  List<QuizModel> quizzes = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchQuizzesByCategory();
  }

  void _fetchQuizzesByCategory() async {
    setState(() {
      _isLoading = true;
    });
    try {
      final response = await QuizApi.getQuizzesByCategory(widget.categoryId);
      setState(() {
        category = CategoryModel.fromJson(response['data']['category']);
        quizzes = (response['data']['quizzes'] as List<dynamic>)
            .map((e) => QuizModel.fromJson(e))
            .toList();
        _isLoading = false;
      });
    } catch (e) {
      HttpHelper.handleError(context, e);
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _logout() async {
    await AuthHelper.clearToken();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => LoginScreen()),
    );
  }

  void _deleteQuiz(int quizzId) async {
    try {
      final response = await QuizApi.deleteQuiz(quizzId);
      HttpHelper.showSuccess(context, response['message']);
      _fetchQuizzesByCategory();
    } catch (e) {
      HttpHelper.handleError(context, e);
    }
  }

  void _restoreQuiz(int quizzId) async {
    try {
      final response = await QuizApi.restoreQuiz(quizzId);
      HttpHelper.showSuccess(context, response['message']);
      _fetchQuizzesByCategory();
    } catch (e) {
      HttpHelper.handleError(context, e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Quizzes for ${category?.name ?? "Category"}',
          style: const TextStyle(
            fontSize: 26,
            fontWeight: FontWeight.w800,
            color: Colors.black,
            fontFamily: 'Times New Roman',
          ),
        ),
        backgroundColor: Colors.blue[100],
        elevation: 0,
        centerTitle: true,
      ),
      drawer: CustomDrawer(
        onLogout: _logout,
        selectedIndex: 3,
      ),
      body: Container(
        color: Colors.white,
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Category_Quizzes: ${category?.name ?? "N/A"}',
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 10),
              ElevatedButton.icon(
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AddEditQuizScreen(categoryId: widget.categoryId),
                  ),
                ).then((_) => _fetchQuizzesByCategory()),
                icon: const Icon(Icons.add, color: Colors.white),
                label: const Text(
                  'Add New Quiz',
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black87,
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                ),
              ),
              const SizedBox(height: 10),
              quizzes.isEmpty
                  ? const Center(child: Text('No quizzes available for this category'))
                  : ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: quizzes.length,
                itemBuilder: (context, index) {
                  final quiz = quizzes[index];
                  return Card(
                    elevation: 2,
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    child: ExpansionTile(
                      leading: quiz.photo != null
                          ? CircleAvatar(
                        backgroundImage: NetworkImage(
                          'http://192.168.1.12:8081/assets/img/${quiz.photo}',
                        ),
                        radius: 30,
                        onBackgroundImageError: (_, __) =>
                        const Icon(Icons.image_not_supported),
                      )
                          : const CircleAvatar(
                        child: Icon(Icons.quiz),
                        radius: 30,
                      ),
                      title: Text(
                        quiz.title,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      ),
                      subtitle: Text(
                        quiz.description ?? 'N/A',
                        style: const TextStyle(fontSize: 16),
                      ),
                      trailing: PopupMenuButton<String>(
                        icon: const Icon(Icons.more_vert),
                        onSelected: (value) {
                          if (value == 'edit') {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => AddEditQuizScreen(quiz: quiz),
                              ),
                            ).then((_) => _fetchQuizzesByCategory());
                          } else if (value == 'delete') {
                            _deleteQuiz(quiz.quizzId!);
                          } else if (value == 'restore') {
                            _restoreQuiz(quiz.quizzId!);
                          } else if (value == 'details') {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    QuestionDetailsScreen(quizzId: quiz.quizzId!),
                              ),
                            );
                          }
                        },
                        itemBuilder: (context) => [
                          if (quiz.deletedAt == null) ...[
                            const PopupMenuItem(
                              value: 'edit',
                              child: Row(
                                children: [
                                  Icon(Icons.edit, color: Colors.blue),
                                  SizedBox(width: 8),
                                  Text('Edit'),
                                ],
                              ),
                            ),
                            const PopupMenuItem(
                              value: 'delete',
                              child: Row(
                                children: [
                                  Icon(Icons.delete, color: Colors.red),
                                  SizedBox(width: 8),
                                  Text('Delete'),
                                ],
                              ),
                            ),
                            const PopupMenuItem(
                              value: 'details',
                              child: Row(
                                children: [
                                  Icon(Icons.visibility, color: Colors.green),
                                  SizedBox(width: 8),
                                  Text('View Details'),
                                ],
                              ),
                            ),
                          ] else ...[
                            const PopupMenuItem(
                              value: 'restore',
                              child: Row(
                                children: [
                                  Icon(Icons.restore, color: Colors.green),
                                  SizedBox(width: 8),
                                  Text('Restore'),
                                ],
                              ),
                            ),
                          ],
                        ],
                      ),
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Chip(
                                    label: Text(quiz.status),
                                    backgroundColor: quiz.status == 'PUBLISHED'
                                        ? Colors.green
                                        : quiz.status == 'DRAFT'
                                        ? Colors.grey
                                        : Colors.red,
                                    labelStyle: const TextStyle(
                                        color: Colors.white, fontSize: 14),
                                  ),
                                  const SizedBox(width: 10),
                                  Chip(
                                    label: Text(quiz.visibility),
                                    backgroundColor: quiz.visibility == 'PUBLIC'
                                        ? Colors.green
                                        : Colors.grey,
                                    labelStyle: const TextStyle(
                                        color: Colors.white, fontSize: 14),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 10),
                              Text(
                                'Quiz ID: ${quiz.quizzId}',
                                style: const TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(height: 10),
                              Text(
                                'Total Score: ${quiz.totalScore ?? 0}',
                                style: const TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(height: 10),
                              Text(
                                'Time Limit: ${quiz.timeLimit ?? 0} minutes',
                                style: const TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(height: 10),
                              Text(
                                'Created At: ${quiz.createdAt != null ? DateFormat('dd/MM/yyyy').format(quiz.createdAt!) : 'N/A'}',
                                style: const TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(height: 10),
                              Text(
                                'Updated At: ${quiz.updatedAt != null ? DateFormat('dd/MM/yyyy').format(quiz.updatedAt!) : 'N/A'}',
                                style: const TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(height: 10),
                              Text(
                                'Deleted At: ${quiz.deletedAt != null ? DateFormat('dd/MM/yyyy').format(quiz.deletedAt!) : ''}',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: quiz.deletedAt == null ? Colors.blue : null,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}