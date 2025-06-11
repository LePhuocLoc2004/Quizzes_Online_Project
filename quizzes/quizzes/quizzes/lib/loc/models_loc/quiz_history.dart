class QuizHistory {
  final int attemptId;
  final int quizzId;
  final int userId;
  final String quizName;
  final int score;
  final String date;
  final String status;
  final int durationMinutes; // ✅ Tính thời gian làm bài

  QuizHistory({
    required this.attemptId,
    required this.quizzId,
    required this.userId,
    required this.quizName,
    required this.score,
    required this.date,
    required this.status,
    required this.durationMinutes,
  });

  factory QuizHistory.fromJson(Map<String, dynamic> json) {
    return QuizHistory(
      attemptId: json['attemptId'] ?? 0, // ✅ Xử lý null -> 0
      quizzId: json['quizzId'] ?? 0,     // ✅ ID bài thi
      userId: json['userId'] ?? 0,       // ✅ ID người dùng
      quizName: json['quizName'] ?? "Không có tên", // ✅ Tên bài thi
      score: json['score'] ?? 0,         // ✅ Điểm số (nếu null thì là 0)
      date: json['createdAt'] ?? "N/A",  // ✅ Ngày làm bài (API trả về `createdAt`)
      status: json['status'] ?? "UNKNOWN", // ✅ Trạng thái bài thi
      durationMinutes: json['durationMinutes'] ?? 0, // ✅ Thời gian làm bài
    );
  }
}
