import 'package:flutter/material.dart';
import '../apis/quizzes_api.dart';
import '../models_user/question_model.dart';
import 'AddQuestionPage.dart';
import 'EditQuestionPage.dart';
import 'QuizList.dart';

class QuestionListPage extends StatefulWidget {
  final int quizzId;
  final int userId;

  QuestionListPage({required this.quizzId, required this.userId});

  @override
  _QuestionListPageState createState() => _QuestionListPageState();
}

class _QuestionListPageState extends State<QuestionListPage> {
  final QuizzesApi _quizzesApi = QuizzesApi();
  List<QuestionModel> questions = [];
  bool _isLoading = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _fetchQuestions();
  }

  Future<void> _fetchQuestions() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });
    try {
      questions = await _quizzesApi.getQuestionsByQuizId(widget.quizzId, widget.userId);
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

  Future<void> _deleteQuestion(int questionId) async {
    setState(() {
      _isLoading = true; // Hiển thị loading khi bắt đầu xóa
    });
    try {
      await _quizzesApi.deleteQuestion(
        quizzId: widget.quizzId,
        questionId: questionId,
        userId: widget.userId,
      );
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Xóa câu hỏi thành công!'),
          backgroundColor: Colors.green,
          duration: Duration(seconds: 2),
        ),
      );
    } catch (e) {
      // Không hiển thị lỗi, chỉ im lặng
    } finally {
      await _fetchQuestions(); // Làm mới danh sách bất kể thành công hay thất bại
      setState(() {
        _isLoading = false; // Tắt loading sau khi hoàn tất
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        title: Text('Danh sách Câu hỏi - Quiz ID: ${widget.quizzId}'),
        backgroundColor: Colors.blue.shade900,
        foregroundColor: Colors.white,
      ),
      body: Container(
        color: Colors.grey.shade900,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Center(
                child: Column(
                  children: [
                    Text(
                      'Danh sách Câu hỏi',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue.shade900,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      'Khám phá và quản lý các câu hỏi trong quiz',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey.shade400,
                      ),
                    ),
                    const SizedBox(height: 10),
                    ElevatedButton(
                      onPressed: _isLoading
                          ? null // Vô hiệu hóa nút khi đang loading
                          : () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => AddQuestionPage(
                              quizzId: widget.quizzId,
                              userId: widget.userId,
                            ),
                          ),
                        ).then((result) {
                          if (result == true) {
                            _fetchQuestions(); // Làm mới danh sách sau khi thêm
                          }
                        });
                      },
                      child: Text('Thêm câu hỏi mới', style: TextStyle(color: Colors.white)),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue.shade900,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Expanded(
                child: _isLoading
                    ? const Center(child: CircularProgressIndicator(color: Colors.blue))
                    : _errorMessage != null
                    ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        _errorMessage!,
                        style: TextStyle(color: Colors.redAccent, fontSize: 16),
                      ),
                      const SizedBox(height: 10),
                      ElevatedButton(
                        onPressed: _fetchQuestions,
                        child: Text('Thử lại'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue.shade900,
                          foregroundColor: Colors.white,
                        ),
                      ),
                    ],
                  ),
                )
                    : questions.isEmpty
                    ? Center(
                  child: Text(
                    'Chưa có câu hỏi nào trong quiz này.',
                    style: TextStyle(
                      color: Colors.redAccent,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                )
                    : GridView.builder(
                  padding: const EdgeInsets.all(4.0),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 12,
                    crossAxisSpacing: 12,
                    childAspectRatio: screenWidth > 600 ? 0.7 : 0.55,
                  ),
                  itemCount: questions.length,
                  itemBuilder: (context, index) {
                    final question = questions[index];
                    return ConstrainedBox(
                      constraints: BoxConstraints(
                        maxHeight: screenHeight * 0.5,
                      ),
                      child: Card(
                        color: Colors.grey.shade800,
                        elevation: 6,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Icon(
                                    Icons.help_outline,
                                    color: Colors.blue.shade900,
                                    size: 24,
                                  ),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: Text(
                                      question.questionText,
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Loại: ${question.questionType}',
                                style: TextStyle(
                                  color: Colors.grey.shade400,
                                  fontSize: 13,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Điểm: ${question.score?.toString() ?? 'N/A'}',
                                style: TextStyle(
                                  color: Colors.grey.shade400,
                                  fontSize: 14,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Đáp án:',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Expanded(
                                child: SingleChildScrollView(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: question.answers.map((answer) {
                                      return Padding(
                                        padding: const EdgeInsets.symmetric(vertical: 3.0),
                                        child: Text(
                                          '${answer.answerText} (${answer.isCorrect == true ? 'Đúng' : 'Sai'})',
                                          style: TextStyle(
                                            color: answer.isCorrect == true
                                                ? Colors.green.shade400
                                                : Colors.red.shade400,
                                            fontSize: 14,
                                          ),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      );
                                    }).toList(),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 12),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  ElevatedButton(
                                    onPressed: _isLoading
                                        ? null // Vô hiệu hóa nút khi đang loading
                                        : () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => EditQuestionPage(
                                            question: question,
                                            quizzId: widget.quizzId,
                                            userId: widget.userId,
                                            questionId: question.questionId!,
                                          ),
                                        ),
                                      ).then((result) {
                                        if (result == true) {
                                          _fetchQuestions();
                                        }
                                      });
                                    },
                                    child: Text('Sửa', style: TextStyle(color: Colors.white)),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.blue.shade700,
                                      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  ElevatedButton(
                                    onPressed: _isLoading
                                        ? null // Vô hiệu hóa nút khi đang loading
                                        : () async {
                                      bool? confirm = await showDialog(
                                        context: context,
                                        builder: (context) => AlertDialog(
                                          title: Text('Xác nhận xóa'),
                                          content: Text('Bạn có chắc chắn muốn xóa câu hỏi này không?'),
                                          actions: [
                                            TextButton(
                                              onPressed: () => Navigator.pop(context, false),
                                              child: Text('Hủy', style: TextStyle(color: Colors.grey)),
                                            ),
                                            TextButton(
                                              onPressed: () => Navigator.pop(context, true),
                                              child: Text('Xóa', style: TextStyle(color: Colors.red)),
                                            ),
                                          ],
                                        ),
                                      );
                                      if (confirm == true) {
                                        await _deleteQuestion(question.questionId!);
                                      }
                                    },
                                    child: Text('Xóa', style: TextStyle(color: Colors.white)),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.red.shade700,
                                      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}