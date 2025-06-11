import 'dart:async';

import 'package:flutter/material.dart';
import 'package:quizzes/minhthan/pages/take_quiz/quiz_result.dart';

import '../../../users/services/user_service.dart';
import '../../models/take_quiz/take_quiz_dto.dart';
import '../../repositories/take_quiz_repository.dart';
import '../widgets/app_bar_take_quiz.dart';

class TakeQuizPage extends StatefulWidget {
  final int quizId;

  const TakeQuizPage({
    super.key,
    required this.quizId,
  });

  @override
  State<TakeQuizPage> createState() => _TakeQuizPageState();
}

class _TakeQuizPageState extends State<TakeQuizPage> {
  final TakeQuizRepository _repository = TakeQuizRepository();
  final UserService _userService = UserService();

  TakeQuizDto? _quizData;
  bool _isLoading = true;
  bool _isSubmittingTimeout = false;
  Map<int, List<int>> _selectedAnswers = {};
  int _currentQuestionIndex = 0;
  Timer? _timer;
  int _remainingSeconds = 0;
  int _timeoutRetryCount = 0;
  final int _maxTimeoutRetries = 3;

  //--------------------------------------------------
  // LIFECYCLE METHODS
  //--------------------------------------------------

  @override
  void initState() {
    super.initState();
    _loadQuizData();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  //--------------------------------------------------
  // DATA LOADING
  //--------------------------------------------------

  Future<void> _loadQuizData() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final user = await _userService.getUser();
      if (user != null) {
        final quiz = await _repository.getTakeQuiz(widget.quizId, user.userId!);

        if (quiz != null) {
          setState(() {
            _quizData = quiz;
            _remainingSeconds = quiz.remainingTime ?? 0;
            _isLoading = false;

            // Nạp sẵn các câu trả lời đã có
            if (quiz.userAnswers != null) {
              for (var userAnswer in quiz.userAnswers!) {
                _selectedAnswers[userAnswer.questionId!] =
                    userAnswer.answerIds ?? [];
              }
            }
          });

          // Kiểm tra nếu đã hết thời gian khi tải lại
          if (_remainingSeconds <= 0) {
            Future.delayed(Duration(milliseconds: 300), () {
              _showTimeoutDialog();
            });
          } else {
            // Còn thời gian thì bắt đầu đếm ngược
            _startTimer();
          }
        } else {
          _showError("Unable to load quiz data.");
        }
      } else {
        _showError("User information not found. Please login again.");
      }
    } catch (e) {
      _showError("Error loading quiz: $e");
    }
  }

  //--------------------------------------------------
  // TIMER HANDLING
  //--------------------------------------------------

  void _startTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        if (_remainingSeconds > 0) {
          _remainingSeconds--;
        } else {
          timer.cancel();
          _showTimeoutDialog();
        }
      });
    });
  }

  void _showTimeoutDialog() {
    // Đảm bảo hủy timer nếu còn chạy
    _timer?.cancel();

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => WillPopScope(
        onWillPop: () async => false,
        // Ngăn không cho back button đóng dialog
        child: AlertDialog(
          title: Text('Time\'s Up'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.timer_off,
                size: 50,
                color: Colors.red,
              ),
              SizedBox(height: 16),
              Text('Your quiz time has ended.'),
              SizedBox(height: 8),
              Text(
                'You\'ve answered ${_getAnsweredQuestionsCount()}/${_quizData?.questions?.length ?? 0} questions.',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 16),
              Text(
                'Please submit your quiz to see the results.',
                style: TextStyle(fontStyle: FontStyle.italic),
              ),
            ],
          ),
          actions: [
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                minimumSize: Size(double.infinity, 50),
              ),
              onPressed:
                  _isSubmittingTimeout ? null : () => _handleQuizTimeout(),
              child: _isSubmittingTimeout
                  ? Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2,
                          ),
                        ),
                        SizedBox(width: 12),
                        Text('Processing...'),
                      ],
                    )
                  : Text('Submit Quiz', style: TextStyle(fontSize: 16)),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _handleQuizTimeout() async {
    if (_quizData?.attemptId == null) return;
    setState(() {
      _isSubmittingTimeout = true;
    });
    try {
      final result = await _repository.handleTimeout(
        widget.quizId,
        _quizData!.attemptId!,
      );
      if (result != null) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) =>
                QuizResultPage(attemptId: _quizData!.attemptId!),
          ),
        );
      } else {
        if (_timeoutRetryCount < _maxTimeoutRetries) {
          _timeoutRetryCount++;
          _handleQuizTimeout();
        } else {
          _showError("Failed to submit your quiz. Please try again.");
          setState(() {
            _isSubmittingTimeout = false;
          });
        }
      }
    } catch (e) {
      _showError("Error submitting quiz: $e");
      setState(() {
        _isSubmittingTimeout = false;
      });
    }
  }
  //--------------------------------------------------
  // NAVIGATION
  //--------------------------------------------------

  void _previousQuestion() {
    if (_currentQuestionIndex > 0) {
      setState(() {
        _currentQuestionIndex--;
      });
    }
  }

  void _nextQuestion() {
    if (_quizData != null &&
        _quizData!.questions != null &&
        _currentQuestionIndex < _quizData!.questions!.length - 1) {
      setState(() {
        _currentQuestionIndex++;
      });
    }
  }

  //--------------------------------------------------
  // ANSWER HANDLING
  //--------------------------------------------------

  Future<void> _selectAnswer(
      int questionId, int answerId, bool isMultipleChoice) async {
    List<int> currentAnswers = _selectedAnswers[questionId] ?? [];

    // Với câu hỏi một đáp án, thay thế câu trả lời
    // Với câu hỏi nhiều đáp án, bật/tắt lựa chọn
    if (isMultipleChoice) {
      if (currentAnswers.contains(answerId)) {
        currentAnswers.remove(answerId);
      } else {
        currentAnswers.add(answerId);
      }
    } else {
      currentAnswers = [answerId];
    }

    setState(() {
      _selectedAnswers[questionId] = currentAnswers;
    });

    // Save answer to server (call API)
    try {
      final success = await _repository.saveAnswer(
        widget.quizId,
        _quizData!.attemptId!,
        questionId,
        currentAnswers,
      );
      if (!success) {
        _showError("Failed to save your answer. Please try again.");
      }
    } catch (e) {
      _showError("Error saving answer: $e");
    }
  }

  Future<void> _submitQuiz() async {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Submit Quiz'),
        content: Text('Are you sure you want to submit your quiz?'),
        actions: [
          TextButton(
            child: Text('Cancel'),
            onPressed: () => Navigator.of(context).pop(),
          ),
          TextButton(
            child: Text('Submit'),
            onPressed: () {
              Navigator.of(context).pop();
              _submitQuizToServer();
            },
          ),
        ],
      ),
    );
  }

  Future<void> _submitQuizToServer() async {
    if (_quizData?.attemptId == null) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final result = await _repository.submitQuiz(
        widget.quizId,
        _quizData!.attemptId!,
      );

      if (result != null) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) =>
                QuizResultPage(attemptId: _quizData!.attemptId!),
          ),
        );
      } else {
        _showError("Failed to submit your quiz. Please try again.");
      }
    } catch (e) {
      _showError("Error submitting quiz: $e");
    }
  }

  //--------------------------------------------------
  // UTILITY METHODS
  //--------------------------------------------------

  void _showError(String message) {
    setState(() {
      _isLoading = false;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.red),
    );
  }

  // Tính toán tiến độ (số câu hỏi đã trả lời)
  int _getAnsweredQuestionsCount() {
    return _selectedAnswers.keys.length;
  }

  String _formatTime(int seconds) {
    int minutes = seconds ~/ 60;
    int remainingSeconds = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}';
  }

  //--------------------------------------------------
  // UI BUILDING
  //--------------------------------------------------

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: quizAppBar(
        title: _quizData?.title ?? "Quiz",
        context: context,
        titleWidget: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              _quizData?.title ?? "Quiz",
              style: TextStyle(
                color: Colors.black87,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            if (_quizData != null && _quizData!.questions != null)
              Text(
                'Question ${_currentQuestionIndex + 1} / ${_quizData!.questions!.length}',
                style: TextStyle(
                  color: Colors.grey.shade600,
                  fontSize: 14,
                ),
              ),
          ],
        ),
        onSubmit: _submitQuiz,
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : _buildQuizContent(),
      bottomNavigationBar: _isLoading ? null : _buildBottomNavBar(),
    );
  }

  Widget _buildQuizContent() {
    if (_quizData == null ||
        _quizData!.questions == null ||
        _quizData!.questions!.isEmpty) {
      return Center(child: Text('No questions available'));
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _buildProgressIndicator(),
        SizedBox(height: 16),
        _buildQuestionNavigator(),
        SizedBox(height: 16),
        Expanded(child: _buildCurrentQuestion()),
      ],
    );
  }

  Widget _buildTimerDisplay() {
    return Container(
      constraints: BoxConstraints(maxWidth: 150),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Time: ${_formatTime(_remainingSeconds)}',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: _remainingSeconds < 60 ? Colors.red : Colors.black,
            ),
          ),
          const SizedBox(height: 4),
          Container(
            width: 120,
            child: LinearProgressIndicator(
              value: _quizData?.timeLimit != null && _quizData!.timeLimit! > 0
                  ? 1 - (_remainingSeconds / (_quizData!.timeLimit! * 60))
                  : 0,
              backgroundColor: Colors.grey[300],
              valueColor: AlwaysStoppedAnimation<Color>(
                _remainingSeconds < 60 ? Colors.red : Colors.blue,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProgressIndicator() {
    if (_quizData == null || _quizData!.questions == null) {
      return SizedBox.shrink();
    }

    final totalQuestions = _quizData!.questions!.length;
    final answeredQuestions = _getAnsweredQuestionsCount();
    final progress =
        totalQuestions > 0 ? answeredQuestions / totalQuestions : 0.0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Chiều rộng giới hạn cho text
              Container(
                width: 150,
                child: Text(
                  'Progress: $answeredQuestions/$totalQuestions',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Expanded(
                child: Align(
                  alignment: Alignment.centerRight,
                  child: _buildTimerDisplay(),
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 8),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: LinearProgressIndicator(
            value: progress,
            backgroundColor: Colors.grey.shade200,
            valueColor: AlwaysStoppedAnimation<Color>(
              progress < 0.3
                  ? Colors.red
                  : (progress < 0.7 ? Colors.orange : Colors.green),
            ),
            minHeight: 10,
          ),
        ),
      ],
    );
  }

  Widget _buildQuestionNavigator() {
    if (_quizData == null || _quizData!.questions == null) {
      return SizedBox.shrink();
    }

    final double buttonSize = 48.0;
    final double horizontalSpacing = 12.0;
    final double verticalSpacing = 8.0;

    return LayoutBuilder(
      builder: (context, constraints) {
        // Tính số lượng nút tối đa trên mỗi hàng (6 nút)
        final int buttonsPerRow = 6;

        // Tính số hàng cần thiết
        final int totalQuestions = _quizData!.questions!.length;
        final int rowCount = (totalQuestions / buttonsPerRow).ceil();

        // Tính chiều cao của container dựa trên số hàng
        final double containerHeight = (buttonSize * rowCount) +
            (verticalSpacing * (rowCount - 1)) +
            verticalSpacing;

        return Container(
          height: containerHeight,
          alignment: Alignment.center,
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Wrap(
            spacing: horizontalSpacing,
            runSpacing: verticalSpacing,
            alignment: WrapAlignment.start,
            children: List.generate(_quizData!.questions!.length, (index) {
              final questionId = _quizData!.questions![index].questionId;
              final isAnswered = questionId != null &&
                  _selectedAnswers.containsKey(questionId);
              final isCurrentQuestion = index == _currentQuestionIndex;
              return Container(
                width: buttonSize,
                height: buttonSize,
                decoration: BoxDecoration(
                  color: isCurrentQuestion
                      ? Colors.blue
                      : (isAnswered ? Colors.green : Colors.grey.shade300),
                  shape: BoxShape.circle,
                  border: isCurrentQuestion
                      ? Border.all(color: Colors.blue.shade700, width: 2)
                      : null,
                  boxShadow: isCurrentQuestion
                      ? [
                          BoxShadow(
                            color: Colors.blue.withOpacity(0.3),
                            blurRadius: 4,
                            spreadRadius: 1,
                            offset: Offset(0, 2),
                          )
                        ]
                      : null,
                ),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: () {
                      setState(() {
                        _currentQuestionIndex = index;
                      });
                    },
                    customBorder: CircleBorder(),
                    child: Center(
                      child: Text(
                        '${index + 1}',
                        style: TextStyle(
                          color: isCurrentQuestion || isAnswered
                              ? Colors.white
                              : Colors.black87,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
              );
            }),
          ),
        );
      },
    );
  }

  Widget _buildCurrentQuestion() {
    if (_quizData == null ||
        _quizData!.questions == null ||
        _currentQuestionIndex >= _quizData!.questions!.length) {
      return Center(child: Text('Question not available'));
    }
    final currentQuestion = _quizData!.questions![_currentQuestionIndex];
    final questionId = currentQuestion.questionId;
    final isMultipleChoice = currentQuestion.questionType == 'MULTIPLE_CHOICE';
    if (questionId == null) {
      return Center(child: Text('Invalid question data'));
    }

    return SingleChildScrollView(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            currentQuestion.questionText ??
                'Question ${_currentQuestionIndex + 1}',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 8),
          Text(
            isMultipleChoice
                ? 'Select all correct answers'
                : 'Select the correct answer',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey.shade700,
              fontStyle: FontStyle.italic,
            ),
          ),
          SizedBox(height: 16),
          // Answers
          if (currentQuestion.answers != null)
            ...currentQuestion.answers!.map((answer) {
              final answerId = answer.answerId;
              if (answerId == null) return SizedBox.shrink();

              final isSelected =
                  _selectedAnswers[questionId]?.contains(answerId) ?? false;
              return Card(
                elevation: isSelected ? 3 : 1,
                margin: EdgeInsets.only(bottom: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                  side: BorderSide(
                    color: isSelected ? Colors.blue : Colors.transparent,
                    width: 2,
                  ),
                ),
                child: InkWell(
                  onTap: () =>
                      _selectAnswer(questionId, answerId, isMultipleChoice),
                  child: Padding(
                    padding: EdgeInsets.all(16),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          margin: EdgeInsets.only(right: 12),
                          padding: EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color:
                                isSelected ? Colors.blue : Colors.grey.shade200,
                          ),
                          child: Icon(
                            isMultipleChoice
                                ? (isSelected
                                    ? Icons.check_box
                                    : Icons.check_box_outline_blank)
                                : (isSelected
                                    ? Icons.radio_button_checked
                                    : Icons.radio_button_unchecked),
                            color: isSelected
                                ? Colors.white
                                : Colors.grey.shade700,
                            size: 20,
                          ),
                        ),
                        Expanded(
                          child: Text(
                            answer.answerText ?? '',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.black87,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }),
        ],
      ),
    );
  }

  Widget _buildBottomNavBar() {
    final totalQuestions = _quizData?.questions?.length ?? 0;
    final currentQuestion = _currentQuestionIndex + 1;
    final progress =
        totalQuestions > 0 ? currentQuestion / totalQuestions : 0.0;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            offset: Offset(0, -3),
            blurRadius: 6,
          ),
        ],
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Nút Previous được thiết kế lại
          Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              boxShadow: _currentQuestionIndex > 0
                  ? [
                      BoxShadow(
                        color: Colors.blue.withOpacity(0.3),
                        blurRadius: 8,
                        offset: Offset(0, 2),
                      )
                    ]
                  : [],
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: _currentQuestionIndex > 0 ? _previousQuestion : null,
                customBorder: CircleBorder(),
                child: Ink(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: _currentQuestionIndex > 0
                        ? Colors.blue
                        : Colors.grey.shade300,
                  ),
                  child: Container(
                    padding: EdgeInsets.all(16),
                    child: Icon(
                      Icons.arrow_back_rounded,
                      color: _currentQuestionIndex > 0
                          ? Colors.white
                          : Colors.grey.shade700,
                      size: 24,
                    ),
                  ),
                ),
              ),
            ),
          ),

          // Widget hiển thị vị trí câu hỏi ở giữa
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 4,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Question $currentQuestion of $totalQuestions',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.grey.shade800,
                  ),
                ),
                SizedBox(height: 6),
                Container(
                  width: 100,
                  height: 4,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.grey.shade300,
                  ),
                  child: FractionallySizedBox(
                    alignment: Alignment.centerLeft,
                    widthFactor: progress,
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        gradient: LinearGradient(
                          colors: [Colors.blue.shade300, Colors.blue.shade600],
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              boxShadow: _quizData != null &&
                      _quizData!.questions != null &&
                      _currentQuestionIndex < _quizData!.questions!.length - 1
                  ? [
                      BoxShadow(
                        color: Colors.blue.withOpacity(0.3),
                        blurRadius: 8,
                        offset: Offset(0, 2),
                      )
                    ]
                  : [],
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: _quizData != null &&
                        _quizData!.questions != null &&
                        _currentQuestionIndex < _quizData!.questions!.length - 1
                    ? _nextQuestion
                    : null,
                customBorder: CircleBorder(),
                child: Ink(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: _quizData != null &&
                            _quizData!.questions != null &&
                            _currentQuestionIndex <
                                _quizData!.questions!.length - 1
                        ? Colors.blue
                        : Colors.grey.shade300,
                  ),
                  child: Container(
                    padding: EdgeInsets.all(16),
                    child: Icon(
                      Icons.arrow_forward_rounded,
                      color: _quizData != null &&
                              _quizData!.questions != null &&
                              _currentQuestionIndex <
                                  _quizData!.questions!.length - 1
                          ? Colors.white
                          : Colors.grey.shade700,
                      size: 24,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
