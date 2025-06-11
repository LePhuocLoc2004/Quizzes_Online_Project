import 'package:flutter/material.dart';
import 'package:quizzes/admin/screens/question_details_screen.dart';
import '../apis/quiz_api.dart';
import '../helpers/auth_helper.dart';
import '../helpers/http_helper.dart';
import '../models/question_model.dart';
import '../widgets/custom_drawer.dart';
import 'add_edit_answer_screen.dart';
import 'add_edit_question_screen.dart';
import 'login_screen.dart';

class QuestionManagementScreen extends StatefulWidget {
  @override
  _QuestionManagementScreenState createState() => _QuestionManagementScreenState();
}

class _QuestionManagementScreenState extends State<QuestionManagementScreen> {
  List<QuestionModel> questions = [];
  Map<int, String> quizMap = {};
  Map<int, int> answerCountMap = {};
  int currentPage = 1;
  int totalPages = 1;
  int totalQuestions = 0;
  int pageSize = 6;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchQuestions();
  }

  void _fetchQuestions() async {
    setState(() {
      _isLoading = true;
    });
    try {
      final response = await QuizApi.getAllQuestions(currentPage);
      setState(() {
        questions = (response['data']['questions'] as List<dynamic>)
            .map((e) => QuestionModel.fromJson(e))
            .toList();
        quizMap = (response['data']['quizMap'] as Map<String, dynamic>)
            .map((key, value) => MapEntry(int.parse(key), value.toString()));
        answerCountMap = (response['data']['answerCountMap'] as Map<String, dynamic>)
            .map((key, value) => MapEntry(int.parse(key), value as int));
        currentPage = response['data']['currentPage'] ?? 1;
        totalPages = response['data']['totalPages'] ?? 1;
        totalQuestions = response['data']['totalQuestions'] ?? 0;
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
      _fetchQuestions();
    }
  }

  void _deleteQuestion(int questionId) async {
    try {
      final response = await QuizApi.deleteQuestion(questionId);
      HttpHelper.showSuccess(context, response['message']);
      _fetchQuestions();
    } catch (e) {
      HttpHelper.handleError(context, e);
    }
  }

  void _restoreQuestion(int questionId) async {
    try {
      final response = await QuizApi.restoreQuestion(questionId);
      HttpHelper.showSuccess(context, response['message']);
      _fetchQuestions();
    } catch (e) {
      HttpHelper.handleError(context, e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Question Management',
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
        selectedIndex: 4,
      ),
      body: Container(
        color: Colors.white,
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : Stack(
          children: [
            SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'All Questions',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  ElevatedButton.icon(
                    onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => AddEditQuestionScreen()),
                    ).then((_) => _fetchQuestions()),
                    icon: const Icon(Icons.add, color: Colors.white),
                    label: const Text(
                      'Add New Question',
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black87,
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    ),
                  ),
                  const SizedBox(height: 10),
                  questions.isEmpty
                      ? const Center(child: Text('No questions available'))
                      : ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: questions.length,
                    itemBuilder: (context, index) {
                      final question = questions[index];
                      final answerCount = answerCountMap[question.questionId] ?? 0;
                      final isAnswerLimitReached =
                          (question.questionType == 'TRUE_FALSE' && answerCount >= 2) ||
                              ((question.questionType == 'SINGLE_CHOICE' ||
                                  question.questionType == 'MULTIPLE_CHOICE') &&
                                  answerCount >= 4);
                      final isDeleted = question.deletedAt != null;

                      // Đảm bảo questionId không null trước khi sử dụng
                      if (question.questionId == null || question.quizzId == null) {
                        return const ListTile(
                          title: Text('Invalid Question Data'),
                        );
                      }

                      return Card(
                        elevation: 2,
                        margin: const EdgeInsets.symmetric(vertical: 8),
                        child: ExpansionTile(
                          leading: CircleAvatar(
                            child: Icon(
                              Icons.question_answer,
                              color: isDeleted ? Colors.grey : Colors.black,
                            ),
                            radius: 30,
                            backgroundColor: isDeleted ? Colors.grey[300] : Colors.white,
                          ),
                          title: Text(
                            question.questionText,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                              color: isDeleted ? Colors.grey : Colors.black,
                            ),
                          ),
                          subtitle: Text(
                            quizMap[question.quizzId!] ?? 'N/A',
                            style: TextStyle(
                              fontSize: 16,
                              color: isDeleted ? Colors.grey : Colors.black,
                            ),
                          ),
                          trailing: PopupMenuButton<String>(
                            icon: const Icon(Icons.more_vert),
                            onSelected: (value) {
                              if (value == 'edit') {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        AddEditQuestionScreen(question: question),
                                  ),
                                ).then((_) => _fetchQuestions());
                              } else if (value == 'delete') {
                                _deleteQuestion(question.questionId!);
                              } else if (value == 'restore') {
                                _restoreQuestion(question.questionId!);
                              } else if (value == 'add_answer') {
                                if (!isAnswerLimitReached) {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => AddEditAnswerScreen(
                                        questionId: question.questionId!,
                                        quizzId: question.quizzId!,
                                      ),
                                    ),
                                  ).then((_) => _fetchQuestions());
                                }
                              } else if (value == 'details') {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        QuestionDetailsScreen(quizzId: question.quizzId!),
                                  ),
                                );
                              }
                            },
                            itemBuilder: (context) {
                              if (isDeleted) {
                                return [
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
                                ];
                              } else {
                                return [
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
                                  PopupMenuItem(
                                    value: 'add_answer',
                                    enabled: !isAnswerLimitReached,
                                    child: Row(
                                      children: [
                                        Icon(Icons.add,
                                            color: isAnswerLimitReached
                                                ? Colors.grey
                                                : Colors.green),
                                        SizedBox(width: 8),
                                        Text('Add Answer'),
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
                                ];
                              }
                            },
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
                                        label: Text(question.questionType),
                                        backgroundColor:
                                        question.questionType == 'SINGLE_CHOICE'
                                            ? Colors.blue
                                            : question.questionType ==
                                            'MULTIPLE_CHOICE'
                                            ? Colors.purple
                                            : Colors.green,
                                        labelStyle: const TextStyle(
                                            color: Colors.white, fontSize: 14),
                                      ),
                                      if (isDeleted) ...[
                                        const SizedBox(width: 8),
                                        const Chip(
                                          label: Text('Deleted'),
                                          backgroundColor: Colors.red,
                                          labelStyle: TextStyle(
                                              color: Colors.white, fontSize: 14),
                                        ),
                                      ],
                                    ],
                                  ),
                                  const SizedBox(height: 10),
                                  Text(
                                    'Question ID: ${question.questionId ?? 'N/A'}',
                                    style: const TextStyle(
                                        fontSize: 18, fontWeight: FontWeight.bold),
                                  ),
                                  const SizedBox(height: 10),
                                  Text(
                                    'Quiz ID: ${question.quizzId}',
                                    style: const TextStyle(
                                        fontSize: 18, fontWeight: FontWeight.bold),
                                  ),
                                  const SizedBox(height: 10),
                                  Text(
                                    'Score: ${question.score ?? 0}',
                                    style: const TextStyle(
                                        fontSize: 18, fontWeight: FontWeight.bold),
                                  ),
                                  const SizedBox(height: 10),
                                  Text(
                                    'Order Index: ${question.orderIndex ?? 'N/A'}',
                                    style: const TextStyle(
                                        fontSize: 18, fontWeight: FontWeight.bold),
                                  ),
                                  const SizedBox(height: 10),
                                  Text(
                                    'Answer Count: ${answerCountMap[question.questionId] ?? 0}',
                                    style: const TextStyle(
                                        fontSize: 18, fontWeight: FontWeight.bold),
                                  ),
                                  if (isDeleted) ...[
                                    const SizedBox(height: 10),
                                    Text(
                                      'Deleted At: ${question.deletedAt.toString()}',
                                      style: const TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.red),
                                    ),
                                  ],
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
                      onPressed: currentPage < totalPages
                          ? () => _goToPage(currentPage + 1)
                          : null,
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