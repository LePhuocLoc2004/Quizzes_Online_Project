import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:quizzes/admin/screens/question_details_screen.dart';
import '../../users/services/user_service.dart';
import '../apis/quiz_api.dart';
import '../helpers/auth_helper.dart';
import '../helpers/http_helper.dart';
import '../models/quiz_model.dart';
import '../widgets/custom_drawer.dart';
import 'add_edit_quiz_screen.dart';
import 'login_screen.dart';

class QuizManagementScreen extends StatefulWidget {
  @override
  _QuizManagementScreenState createState() => _QuizManagementScreenState();
}

class _QuizManagementScreenState extends State<QuizManagementScreen> {
  List<QuizModel> quizzes = [];
  Map<int, String> categoryMap = {};
  Map<int, String> userMap = {};
  int currentPage = 1;
  int totalPages = 1;
  int totalQuizzes = 0;
  int pageSize = 6;
  bool _isLoading = true;
  final UserService _userService = UserService(); // Khởi tạo UserService
  int? _currentUserId; // Lưu userId hiện tại

  @override
  void initState() {
    super.initState();
    _fetchCurrentUserId(); // Lấy userId khi khởi tạo
    _fetchQuizzes();
  }

  Future<void> _fetchCurrentUserId() async {
    final user = await _userService.getUser();
    setState(() {
      _currentUserId = user?.userId;
    });
  }

  void _fetchQuizzes() async {
    setState(() {
      _isLoading = true;
    });
    try {
      final response = await QuizApi.getAllQuizzes(currentPage);
      setState(() {
        quizzes = (response['data']['quizzes'] as List<dynamic>)
            .map((e) => QuizModel.fromJson(e))
            .toList();
        categoryMap = (response['data']['categoryMap'] as Map<String, dynamic>)
            .map((key, value) => MapEntry(int.parse(key), value.toString()));
        userMap = (response['data']['userMap'] as Map<String, dynamic>)
            .map((key, value) => MapEntry(int.parse(key), value.toString()));
        currentPage = response['data']['currentPage'] ?? 1;
        totalPages = response['data']['totalPages'] ?? 1;
        totalQuizzes = response['data']['totalQuizzes'] ?? 0;
        pageSize = response['data']['pageSize'] ?? 6;
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
    await _userService.logout(); // Đăng xuất cả UserService
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => LoginScreen()),
    );
  }

  void _goToPage(int page) {
    if (page >= 1 && page <= totalPages) {
      setState(() {
        currentPage = page;
      });
      _fetchQuizzes();
    }
  }

  void _deleteQuiz(int quizzId) async {
    try {
      final response = await QuizApi.deleteQuiz(quizzId);
      HttpHelper.showSuccess(context, response['message']);
      _fetchQuizzes();
    } catch (e) {
      HttpHelper.handleError(context, e);
    }
  }

  void _restoreQuiz(int quizzId) async {
    try {
      final response = await QuizApi.restoreQuiz(quizzId);
      HttpHelper.showSuccess(context, response['message']);
      _fetchQuizzes();
    } catch (e) {
      HttpHelper.handleError(context, e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Quiz Management',
          style: TextStyle(
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
        selectedIndex: 2,
      ),
      body: Container(
        color: Colors.white,
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : Stack(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'All Quizzes',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      ElevatedButton.icon(
                        onPressed: () => Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => AddEditQuizScreen()),
                        ).then((_) => _fetchQuizzes()),
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
                    ],
                  ),
                  const SizedBox(height: 10),
                  Expanded(
                    child: quizzes.isEmpty
                        ? const Center(child: Text('No quizzes available'))
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
                              onBackgroundImageError: (exception, stackTrace) =>
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
                                  ).then((_) => _fetchQuizzes());
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
                                          backgroundColor:
                                          quiz.visibility == 'PUBLIC' ? Colors.green : Colors.grey,
                                          labelStyle: const TextStyle(
                                              color: Colors.white, fontSize: 14),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 10),
                                    Text(
                                      'Quiz ID: ${quiz.quizzId}',
                                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                                    ),
                                    const SizedBox(height: 10),
                                    Text(
                                      'Created By: ${userMap[quiz.createdBy] ?? 'N/A'} (ID: ${quiz.createdBy})',
                                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                                    ),
                                    const SizedBox(height: 10),
                                    Text(
                                      'Category: ${categoryMap[quiz.categoryId] ?? 'N/A'}',
                                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                                    ),
                                    const SizedBox(height: 10),
                                    Text(
                                      'Created At: ${quiz.createdAt != null ? DateFormat('dd/MM/yyyy').format(quiz.createdAt!) : 'N/A'}',
                                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                                    ),
                                    const SizedBox(height: 10),
                                    Text(
                                      'Updated At: ${quiz.updatedAt != null ? DateFormat('dd/MM/yyyy').format(quiz.updatedAt!) : 'N/A'}',
                                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
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
                  ),
                ],
              ),
            ),
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: Container(
                color: Colors.white,
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      onPressed: currentPage > 1 ? () => _goToPage(currentPage - 1) : null,
                      icon: const Icon(Icons.arrow_back, size: 24),
                      disabledColor: Colors.grey,
                    ),
                    Text(
                      'Page $currentPage of $totalPages',
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    IconButton(
                      onPressed: currentPage < totalPages ? () => _goToPage(currentPage + 1) : null,
                      icon: const Icon(Icons.arrow_forward, size: 24),
                      disabledColor: Colors.grey,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}