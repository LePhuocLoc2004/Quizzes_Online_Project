import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:quizzes/huy/apis/quizzes_api.dart';

import '../../base_url.dart';
import '../models_user/quiz_model.dart';
import 'EditQuizPage.dart';
import 'QuestionListPage.dart';

class MyQuizzesPage extends StatefulWidget {
  final int userId;

  MyQuizzesPage({required this.userId});

  @override
  _MyQuizzesPageState createState() => _MyQuizzesPageState();
}

class _MyQuizzesPageState extends State<MyQuizzesPage> {
  final QuizzesApi _quizzesApi = QuizzesApi();
  List<QuizModel> quizzes = [];
  String _keyword = '';
  bool _isLoading = false;
  String? _errorMessage;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _fetchQuizzes();
  }

  Future<void> _fetchQuizzes() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });
    try {
      quizzes = await _quizzesApi.getQuizzesByUser(widget.userId, _keyword);
    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _searchQuizzes() {
    _fetchQuizzes();
  }

  Future<void> _deleteQuiz(int quizId) async {
    setState(() {
      _isLoading = true;
    });
    try {
      await _quizzesApi.deleteQuiz(quizId, widget.userId);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Xóa quiz thành công!')),
      );
      await _fetchQuizzes();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to delete quiz: $e')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _viewQuestions(int quizzId) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => QuestionListPage(
          quizzId: quizzId,
          userId: widget.userId, // Truyền userId từ MyQuizzesPage
        ),
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade900,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Danh sách Quiz',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                letterSpacing: 1.2,
              ),
            ),
            SizedBox(height: 16),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 3,
                  child: TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      labelText: 'Tìm kiếm bài thi...',
                      labelStyle: TextStyle(color: Colors.grey.shade500),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide.none,
                      ),
                      prefixIcon:
                          Icon(Icons.search, color: Colors.blue.shade900),
                      filled: true,
                      fillColor: Colors.grey.shade800,
                      contentPadding:
                          EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    ),
                    style: TextStyle(color: Colors.white),
                    onChanged: (value) => setState(() => _keyword = value),
                  ),
                ),
                SizedBox(width: 10),
                ElevatedButton(
                  onPressed: _searchQuizzes,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.search, color: Colors.white),
                      SizedBox(width: 5),
                      Text('Tìm kiếm', style: TextStyle(color: Colors.white)),
                    ],
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue.shade900,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 24),
            Expanded(
              child: _isLoading
                  ? Center(
                      child: CircularProgressIndicator(
                          color: Colors.blue.shade700))
                  : _errorMessage != null
                      ? Center(
                          child: Text(
                            _errorMessage!,
                            style: TextStyle(
                                color: Colors.redAccent, fontSize: 16),
                          ),
                        )
                      : quizzes.isEmpty
                          ? Center(
                              child: Text(
                                'Không tìm thấy quiz nào.',
                                style: TextStyle(
                                  color: Colors.redAccent,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            )
                          : ListView.builder(
                              itemCount: quizzes.length,
                              itemBuilder: (context, index) {
                                final quiz = quizzes[index];
                                return Card(
                                  color: Colors.grey.shade800,
                                  elevation: 6,
                                  margin: EdgeInsets.symmetric(vertical: 10),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(16.0),
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(12),
                                          child: quiz.photo != null
                                              ? Image.network(
                                                  '${BaseUrl.staticUrl}${quiz.photo}',
                                                  width: 100,
                                                  height: 100,
                                                  fit: BoxFit.cover,
                                                  errorBuilder: (context, error,
                                                          stackTrace) =>
                                                      Image.asset(
                                                    'assets/img/default-quiz.jpg',
                                                    width: 100,
                                                    height: 100,
                                                    fit: BoxFit.cover,
                                                  ),
                                                )
                                              : Image.asset(
                                                  'assets/img/default-quiz.jpg',
                                                  width: 100,
                                                  height: 100,
                                                  fit: BoxFit.cover,
                                                ),
                                        ),
                                        SizedBox(width: 16),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                quiz.title ?? 'Chưa có tiêu đề',
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                              SizedBox(height: 8),
                                              Text(
                                                quiz.description ??
                                                    'Chưa có mô tả',
                                                style: TextStyle(
                                                  color: Colors.grey.shade400,
                                                  fontSize: 14,
                                                  height: 1.3,
                                                ),
                                                maxLines: 2,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                              SizedBox(height: 8),
                                              Row(
                                                children: [
                                                  Icon(Icons.calendar_today,
                                                      color:
                                                          Colors.grey.shade500,
                                                      size: 16),
                                                  SizedBox(width: 6),
                                                  Text(
                                                    quiz.createdAt != null
                                                        ? DateFormat(
                                                                'yyyy-MM-dd HH:mm')
                                                            .format(
                                                                quiz.createdAt!)
                                                        : 'N/A',
                                                    style: TextStyle(
                                                      color:
                                                          Colors.grey.shade500,
                                                      fontSize: 12,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                        SizedBox(width: 16),
                                        Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            IconButton(
                                              icon: Icon(Icons.visibility,
                                                  color: Colors.blue.shade700),
                                              onPressed: () =>
                                                  _viewQuestions(quiz.quizzId!),
                                              tooltip: 'Xem câu hỏi',
                                              splashRadius: 20,
                                            ),
                                            IconButton(
                                              icon: Icon(Icons.edit,
                                                  color:
                                                      Colors.orange.shade700),
                                              onPressed: () {
                                                print(
                                                    'Edit quiz ${quiz.quizzId}');
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (context) =>
                                                        EditQuizPage(
                                                      quiz: quiz,
                                                      userId: widget.userId,
                                                    ),
                                                  ),
                                                ).then((updatedQuiz) {
                                                  if (updatedQuiz != null) {
                                                    _fetchQuizzes();
                                                  }
                                                });
                                              },
                                              tooltip: 'Sửa quiz',
                                              splashRadius: 20,
                                            ),
                                            IconButton(
                                              icon: Icon(Icons.delete,
                                                  color: Colors.red.shade700),
                                              onPressed: () async {
                                                bool? confirm =
                                                    await showDialog(
                                                  context: context,
                                                  builder: (context) =>
                                                      AlertDialog(
                                                    title: Text('Xác nhận xóa'),
                                                    content: Text(
                                                        'Bạn có chắc chắn muốn xóa quiz này không?'),
                                                    actions: [
                                                      TextButton(
                                                        onPressed: () =>
                                                            Navigator.pop(
                                                                context, false),
                                                        child: Text('Hủy',
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .grey)),
                                                      ),
                                                      TextButton(
                                                        onPressed: () =>
                                                            Navigator.pop(
                                                                context, true),
                                                        child: Text('Xóa',
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .red)),
                                                      ),
                                                    ],
                                                  ),
                                                );
                                                if (confirm == true) {
                                                  await _deleteQuiz(
                                                      quiz.quizzId!);
                                                }
                                              },
                                              tooltip: 'Xóa quiz',
                                              splashRadius: 20,
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),
            ),
          ],
        ),
      ),
    );
  }
}
