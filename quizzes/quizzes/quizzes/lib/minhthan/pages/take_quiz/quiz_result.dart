import 'package:flutter/material.dart';
import 'package:quizzes/minhthan/pages/take_quiz/quiz_history.dart';
import 'package:quizzes/users/pages/home.dart';

import '../../../huy/users_quizzes/welcome.dart';
import '../../models/quiz_result/quiz_history_dto.dart';
import '../../models/quiz_result/quiz_result_dto.dart';
import '../../repositories/take_quiz_repository.dart';

class QuizResultPage extends StatefulWidget {
  final int attemptId;

  const QuizResultPage({
    super.key,
    required this.attemptId,
  });

  @override
  State<QuizResultPage> createState() => _QuizResultPageState();
}

class _QuizResultPageState extends State<QuizResultPage> {
  bool _isLoading = true;
  QuizResultDto? _resultData;
  final TakeQuizRepository _repository = TakeQuizRepository();

  @override
  void initState() {
    super.initState();
    _loadResultData();
  }

  Future<void> _loadResultData() async {
    setState(() {
      _isLoading = true;
    });
    try {
      final result = await _repository.getQuizResult(widget.attemptId);
      if (result != null) {
        setState(() {
          _resultData = result;
          _isLoading = false;
        });
      } else {
        _showError("Could not load quiz results");
      }
    } catch (e) {
      print("Lỗi khi tải kết quả: $e");
      _showError("Error loading results");
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(_isLoading
            ? "Loading Results..."
            : "Results: ${(_resultData?.quizTitle ?? "Quiz Results")}"),
        centerTitle: true,
        backgroundColor: Colors.white,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _buildResultContent(),
    );
  }

  Widget _buildResultContent() {
    if (_resultData == null) {
      return const Center(child: Text('No result data available'));
    }
    final answeredPercentage = _resultData!.totalQuestions! > 0
        ? (_resultData!.totalAnswered! / _resultData!.totalQuestions! * 100)
            .toInt()
        : 0;
    final scorePercentage = _resultData!.totalScore! > 0
        ? (_resultData!.userScore! / _resultData!.totalScore! * 100).toInt()
        : 0;
    final Color resultColor = _getScoreColor(scorePercentage);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Card hiển thị kết quả chính
          Card(
            elevation: 4,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  // Vòng tròn điểm số
                  Container(
                    width: 150,
                    height: 150,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: resultColor.withOpacity(0.1),
                      border: Border.all(color: resultColor, width: 4),
                    ),
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            '${_resultData!.userScore}',
                            style: TextStyle(
                              fontSize: 42,
                              fontWeight: FontWeight.bold,
                              color: resultColor,
                            ),
                          ),
                          Text(
                            'Points',
                            style: TextStyle(
                                fontSize: 16,
                                color: Colors.black87,
                                fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Thông tin điểm số
                  Text(
                    _getScoreMessage(scorePercentage),
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: resultColor,
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Thanh tiến trình câu trả lời
                  const Text(
                    'Questions Answered',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(height: 8),

                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: LinearProgressIndicator(
                      value: answeredPercentage / 100,
                      backgroundColor: Colors.grey[200],
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
                      minHeight: 10,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '${_resultData!.totalAnswered} of ${_resultData!.totalQuestions} questions ($answeredPercentage%)',
                    style: TextStyle(
                      color: Colors.grey[700],
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          // Card hiển thị thống kê
          Card(
            elevation: 4,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Statistics',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Divider(),
                  _buildStatItem(
                    'Total Questions',
                    '${_resultData!.totalQuestions}',
                    Icons.help_outline,
                  ),
                  _buildStatItem(
                    'Questions Answered',
                    '${_resultData!.totalAnswered}',
                    Icons.check_circle_outline,
                  ),
                  _buildStatItem(
                    'Correct Answers',
                    '${_resultData!.totalQuestionCorrect}',
                    Icons.thumb_up_alt_outlined,
                  ),
                  _buildStatusBadge(_resultData!.status ?? 'Unknown'),
                  _buildTimeSpentItem(),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),
          // Nút điều hướng
          Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () {
                    QuizHistoryDTO quizHistoryDto = QuizHistoryDTO(
                        userId: _resultData!.userId,
                        attemptId: widget.attemptId,
                        quizId: _resultData!.quizId);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            QuizHistoryPage(historyDTO: quizHistoryDto),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                  icon: const Icon(
                    Icons.history,
                    color: Colors.black87,
                  ),
                  label: const Text(
                    'View History',
                    style: TextStyle(
                      color: Colors.black87,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.6,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () {
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                        builder: (context) => WelcomeScreen(userId: _resultData!.userId),
                      ),
                      (route) => false,
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                  icon: const Icon(
                    Icons.home,
                    color: Colors.black,
                  ),
                  label: const Text(
                    'Continue',
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.6,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // Widget hiển thị thông tin thời gian làm bài
  Widget _buildTimeSpentItem() {
    final isTimeout = _resultData?.status?.toUpperCase() == 'TIMEOUT';
    final String timeDisplay;
    if (isTimeout) {
      timeDisplay = _formatTime(_resultData?.timeLimit ?? 0);
    } else {
      timeDisplay = _formatTime(_resultData?.timeSpent ?? 0);
    }
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(Icons.timer_outlined, color: Colors.blue, size: 20),
          const SizedBox(width: 12),
          const Text(
            'Time Spent',
            style: TextStyle(fontSize: 16),
          ),
          const Spacer(),
          Text(
            timeDisplay,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  // Widget hiển thị Status dạng badge
  Widget _buildStatusBadge(String status) {
    final statusText = status.toUpperCase() == 'COMPLETED'
        ? 'SUBMITTED'
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
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(Icons.stacked_bar_chart, color: Colors.blue, size: 20),
          const SizedBox(width: 12),
          const Text(
            'Status',
            style: TextStyle(fontSize: 16),
          ),
          const Spacer(),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: badgeColor.withOpacity(0.1),
              border: Border.all(color: badgeColor),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(icon, size: 14, color: badgeColor),
                const SizedBox(width: 4),
                Text(
                  statusText,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: badgeColor,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Widget hiển thị thông tin thống kê
  Widget _buildStatItem(String label, String value, IconData icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(icon, color: Colors.blue, size: 20),
          const SizedBox(width: 12),
          Text(
            label,
            style: const TextStyle(fontSize: 16),
          ),
          const Spacer(),
          Text(
            value,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  // Định dạng thời gian từ giây sang phút:giây
  String _formatTime(int seconds) {
    final minutes = seconds ~/ 60;
    final remainingSeconds = seconds % 60;
    final timeString =
        '$minutes:${remainingSeconds.toString().padLeft(2, '0')}';

    final minuteLabel = minutes == 1 ? 'minute' : 'minutes';
    return '$timeString $minuteLabel';
  }

  // Màu sắc dựa trên điểm số
  Color _getScoreColor(int percentage) {
    if (percentage >= 80) return Colors.green;
    if (percentage >= 60) return Colors.blue;
    if (percentage >= 40) return Colors.orange;
    return Colors.red;
  }

  // Thông báo dựa trên điểm số
  String _getScoreMessage(int percentage) {
    if (percentage >= 80) return 'Excellent!';
    if (percentage >= 60) return 'Good job!';
    if (percentage >= 40) return 'Not bad!';
    return 'Keep practicing!';
  }
}
