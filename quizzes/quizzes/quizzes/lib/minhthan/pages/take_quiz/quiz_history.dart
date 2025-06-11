import 'package:flutter/material.dart';

import '../../models/quiz_result/quiz_history_dto.dart';
import '../../models/quiz_result/quiz_result_dto.dart';
import '../../models/take_quiz/question_data_dto.dart';
import '../../models/take_quiz/take_quiz_dto.dart';
import '../../models/take_quiz/user_answer_data_dto.dart';
import '../../repositories/take_quiz_repository.dart';
import '../widgets/app_bar_take_quiz.dart';

class QuizHistoryPage extends StatefulWidget {
  final QuizHistoryDTO historyDTO;

  const QuizHistoryPage({super.key, required this.historyDTO});

  @override
  State<QuizHistoryPage> createState() => _QuizHistoryPageState();
}

class _QuizHistoryPageState extends State<QuizHistoryPage> {
  final TakeQuizRepository _repository = TakeQuizRepository();
  bool _isLoading = true;
  QuizResultDto? _resultData;
  TakeQuizDto? _quizData;

  int _currentQuestionIndex = 0;

  @override
  void initState() {
    super.initState();
    _loadHistoryData();
  }

  Future<void> _loadHistoryData() async {
    setState(() {
      _isLoading = true;
    });

    try {
      QuizHistoryDTO historyDto = widget.historyDTO;
      final result = await _repository.getQuizResult(historyDto.attemptId!);
      final quizData = await _repository.getQuizHistory(
          historyDto.userId!, historyDto.quizId!, historyDto.attemptId!);
      if (result != null && quizData != null) {
        setState(() {
          _resultData = result;
          _quizData = quizData;
          _isLoading = false;
        });
      } else {
        _showError("Failed to load quiz history");
      }
    } catch (e) {
      _showError("Error loading quiz history");
    }
  }

  void _showError(String message) {
    setState(() {
      _isLoading = false;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.red),
    );
  }

  void _navigateToQuestion(int index) {
    if (index >= 0 && index < (_quizData?.questions?.length ?? 0)) {
      setState(() {
        _currentQuestionIndex = index;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppBar(
        title: _isLoading
            ? "Loading History..."
            : "History: ${_resultData?.quizTitle ?? 'Quiz'}",
        context: context,
        showBackButton: true,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _buildHistoryContent(),
    );
  }

  Widget _buildHistoryContent() {
    if (_quizData?.questions == null || _quizData!.questions!.isEmpty) {
      return const Center(
        child: Text("No question history available"),
      );
    }
    return Column(
      children: [
        // Thông tin tóm tắt
        _buildSummaryCard(),
        // Bộ điều hướng câu hỏi
        _buildQuestionNavigator(),
        // Tóm tắt số câu đúng/sai
        _buildQuestionSummary(),
        // Hiển thị câu hỏi hiện tại
        Expanded(
          child:
              _buildQuestionCard(_quizData!.questions![_currentQuestionIndex]),
        ),
        _buildNavigationButtons(),
      ],
    );
  }

  Widget _buildSummaryCard() {
    final scorePercentage = _resultData!.totalScore! > 0
        ? (_resultData!.userScore! / _resultData!.totalScore! * 100).toInt()
        : 0;

    return Card(
      margin: const EdgeInsets.all(8),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: _getScoreColor(scorePercentage),
                  width: 3.0,
                ),
              ),
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      '${_resultData!.userScore!}',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: _getScoreColor(scorePercentage),
                      ),
                    ),
                    Text(
                      'Points',
                      style: TextStyle(
                        fontSize: 12,
                        color: _getScoreColor(scorePercentage),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _resultData?.quizTitle ?? 'Quiz Result',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  // Hiển thị thời gian làm bài
                  Row(
                    children: [
                      const Icon(Icons.timer, size: 14),
                      const SizedBox(width: 4),
                      Text(
                        _resultData?.timeSpent != null
                            ? 'Time Spent: ${_formatTime(_resultData!.status!.toUpperCase() == 'TIMEOUT' ? _resultData!.timeLimit! : _resultData!.timeSpent!)}'
                            : 'Time Spent: N/A',
                        style: const TextStyle(fontSize: 12),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(Icons.timer, size: 14),
                      const SizedBox(width: 4),
                      Text(
                        'Time limit: ${_formatTime(_resultData!.timeLimit!)}',
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const Spacer(),
                      _buildStatusBadge(_resultData?.status ?? 'Unknown'),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatTime(int seconds) {
    final minutes = seconds ~/ 60;
    final remainingSeconds = seconds % 60;
    final timeString =
        '$minutes:${remainingSeconds.toString().padLeft(2, '0')}';

    final minuteLabel = minutes == 1 ? 'minute' : 'minutes';
    return '$timeString $minuteLabel';
  }

// icon điều hướng câu hỏi
  Widget _buildQuestionNavigator() {
    final questionCount = _quizData?.questions?.length ?? 0;
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 6,
              childAspectRatio: 1.2,
              crossAxisSpacing: 4,
              mainAxisSpacing: 4,
            ),
            itemCount: questionCount,
            itemBuilder: (context, index) {
              final isCurrentQuestion = index == _currentQuestionIndex;
              final question = _quizData!.questions![index];

              final questionResult = _resultData?.questionResults?.firstWhere(
                (result) => result.questionId == question.questionId,
                orElse: () => QuestionResultDto(),
              );

              // Xác định màu nút dựa trên trạng thái câu trả lời
              Color backgroundColor = Colors.white;
              Color borderColor = Colors.black87;
              if (questionResult!.userAnswerIds!.isNotEmpty) {
                if (questionResult.isCorrect!) {
                  backgroundColor = Colors.green.withOpacity(0.3);
                  borderColor = Colors.green;
                } else {
                  backgroundColor = Colors.red.withOpacity(0.3);
                  borderColor = Colors.red;
                }
              }
              return GestureDetector(
                onTap: () => _navigateToQuestion(index),
                child: Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: backgroundColor,
                    border: Border.all(
                      color: borderColor,
                      width: isCurrentQuestion ? 2 : 1,
                    ),
                  ),
                  child: Center(
                    child: Text(
                      '${index + 1}',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: isCurrentQuestion
                            ? FontWeight.bold
                            : FontWeight.normal,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildQuestionSummary() {
    if (_resultData == null) {
      return const SizedBox.shrink();
    }
    final int correctCount = _resultData!.totalQuestionCorrect ?? 0;
    final int totalQuestions = _resultData!.totalQuestions ?? 0;
    final int totalAnswered = _resultData!.totalAnswered ?? 0;

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Row(
          children: [
            // Số câu trả lời đúng
            Row(
              children: [
                Icon(Icons.check_circle, color: Colors.green, size: 22),
                const SizedBox(width: 4),
                Text(
                  '$correctCount Correct',
                  style: TextStyle(
                      color: Colors.green, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(width: 16),
            // Số câu trả lời sai
            Row(
              children: [
                Icon(Icons.cancel, color: Colors.red, size: 20),
                const SizedBox(width: 4),
                Text(
                  '${totalAnswered - correctCount} Incorrect',
                  style:
                      TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const Spacer(),
            // Tổng số câu
            Text(
              'Answered: $totalAnswered/$totalQuestions',
              style: TextStyle(fontWeight: FontWeight.w500),
            ),
          ],
        ),
      ),
    );
  }

// Question information card
  Widget _buildQuestionCard(QuestionDataDto question) {
    if (question.questionId == null) {
      return const Center(child: Text("Question data not available"));
    }
    final questionResult = _resultData?.questionResults?.firstWhere(
      (result) => result.questionId == question.questionId,
      orElse: () => QuestionResultDto(),
    );

    // Tìm câu trả lời của người dùng
    final userAnswer = _quizData?.userAnswers?.firstWhere(
      (answer) => answer?.questionId == question.questionId,
      orElse: () => UserAnswerDataDto(),
    );

    return Card(
      margin: const EdgeInsets.all(8),
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Question ${_currentQuestionIndex + 1}/${_quizData?.questions?.length ?? 0}",
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: Colors.blue.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.blue),
                  ),
                  child: Text(
                    "${questionResult?.score ?? 0} points",
                    style: const TextStyle(
                      color: Colors.blue,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Nội dung câu hỏi
            Text(
              question.questionText ?? "No question content",
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 24),
            // Các phương án trả lời
            ..._buildAnswerOptions(question, questionResult, userAnswer),
          ],
        ),
      ),
    );
  }

  // UI for answer options
  List<Widget> _buildAnswerOptions(QuestionDataDto question,
      QuestionResultDto? questionResult, UserAnswerDataDto? userAnswer) {
    if (question.answers == null || question.answers!.isEmpty) {
      return [const Text("No answer choices available")];
    }

    final List<int> userAnswerIds = questionResult?.userAnswerIds ?? [];
    final List<int> correctAnswerIds = questionResult?.correctAnswerIds ?? [];

    final String questionType = question.questionType ?? "SINGLE_CHOICE";
    final bool isMultipleChoice = questionType == "MULTIPLE_CHOICE";

    return question.answers!.map((answer) {
      final isSelected = userAnswerIds.contains(answer.answerId);
      final isCorrect = correctAnswerIds.contains(answer.answerId);

      Color borderColor;
      Color backgroundColor;
      Color textColor;

      if (isSelected) {
        if (isCorrect) {
          // Correct user selection
          borderColor = Colors.green;
          backgroundColor = Colors.green.withOpacity(0.1);
          textColor = Colors.green;
        } else {
          // Incorrect user selection
          borderColor = Colors.red;
          backgroundColor = Colors.red.withOpacity(0.1);
          textColor = Colors.red;
        }
      } else {
        if (isCorrect) {
          // Correct answer not selected
          borderColor = Colors.green.withOpacity(0.5);
          backgroundColor = Colors.white;
          textColor = Colors.green;
        } else {
          // Regular answer (not selected, not correct)
          borderColor = Colors.grey.withOpacity(0.5);
          backgroundColor = Colors.white;
          textColor = Colors.black87;
        }
      }

      // user selection color
      final Color selectionColor = isSelected
          ? (isCorrect ? Colors.green : Colors.red)
          : Colors.grey.withOpacity(0.5);

      return Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
              color: borderColor, width: isSelected || isCorrect ? 2.0 : 1.0),
        ),
        child: Row(
          children: [
            if (isMultipleChoice)
              Icon(
                isSelected ? Icons.check_box : Icons.check_box_outline_blank,
                color: selectionColor,
                size: 20,
              )
            else
              Icon(
                isSelected
                    ? Icons.radio_button_checked
                    : Icons.radio_button_unchecked,
                color: selectionColor,
                size: 20,
              ),

            const SizedBox(width: 8),
            // Middle: Answer text
            Expanded(
              child: Text(
                answer.answerText ?? "No answer content",
                style: TextStyle(
                  color: textColor,
                  fontWeight: isCorrect || isSelected
                      ? FontWeight.bold
                      : FontWeight.normal,
                ),
              ),
            ),
            // Right side: Correct answer indicator
            if (isCorrect)
              Icon(
                Icons.check_circle,
                color: Colors.green,
                size: 20,
              ),
          ],
        ),
      );
    }).toList();
  }

  Widget _buildNavigationButtons() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          ElevatedButton.icon(
            onPressed: _currentQuestionIndex > 0
                ? () => _navigateToQuestion(_currentQuestionIndex - 1)
                : null,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.grey[200],
              foregroundColor: Colors.black87,
              disabledBackgroundColor: Colors.grey[300],
            ),
            icon: const Icon(Icons.arrow_back),
            label: const Text('Previous'),
          ),
          ElevatedButton.icon(
            onPressed:
                _currentQuestionIndex < (_quizData?.questions?.length ?? 0) - 1
                    ? () => _navigateToQuestion(_currentQuestionIndex + 1)
                    : null,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
              foregroundColor: Colors.white,
              disabledBackgroundColor: Colors.grey[300],
            ),
            icon: const Icon(Icons.arrow_forward),
            label: const Text('Next'),
          ),
        ],
      ),
    );
  }

  // Widget hiển thị Status dạng badge
  Widget _buildStatusBadge(String status) {
    final statusText = status.toUpperCase() == 'COMPLETED'
        ? 'SUBMITTED'
        : status.toUpperCase() == 'TIMEOUT'
            ? 'TIMEOUT'
            : status.toUpperCase();
    Color badgeColor;
    IconData icon;

    switch (statusText) {
      case 'SUBMITTED':
        badgeColor = Colors.green;
        icon = Icons.check_circle;
        break;
      case 'TIMEOUT':
        badgeColor = Colors.red;
        icon = Icons.timer_off;
        break;
      default:
        badgeColor = Colors.orange;
        icon = Icons.info;
    }
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: badgeColor.withOpacity(0.1),
        border: Border.all(color: badgeColor),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: badgeColor),
          const SizedBox(width: 4),
          Text(
            statusText,
            style: TextStyle(
              color: badgeColor,
              fontSize: 10,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  // Màu sắc dựa trên điểm số
  Color _getScoreColor(int percentage) {
    if (percentage >= 80) return Colors.green;
    if (percentage >= 60) return Colors.blue;
    if (percentage >= 40) return Colors.orange;
    return Colors.red;
  }
}
