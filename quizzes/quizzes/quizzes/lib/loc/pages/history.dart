import 'package:flutter/material.dart';
import '../services_loc/history_service.dart';
import '../models_Loc/quiz_history.dart';

class HistoryPage extends StatefulWidget {
  final String username;
  final int userId; // ✅ Đảm bảo có userId để fetch đúng dữ liệu

  const HistoryPage({super.key, required this.username, required this.userId});

  @override
  _HistoryPageState createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  final HistoryService historyService = HistoryService();
  late Future<List<QuizHistory>> futureHistory;

  @override
  void initState() {
    super.initState();
    futureHistory = historyService.fetchHistory(widget.userId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Lịch Sử Thi"),
        backgroundColor: Colors.blue,
      ),
      body: FutureBuilder<List<QuizHistory>>(
        future: futureHistory,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Lỗi: ${snapshot.error}"));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text("Không có dữ liệu lịch sử"));
          }

          List<QuizHistory> historyList = snapshot.data!;

          return SingleChildScrollView(
            scrollDirection: Axis.horizontal, // ✅ Cho phép kéo ngang nếu cần
            child: DataTable(
              columnSpacing: 20,
              columns: const [
                DataColumn(label: Text("📅 Ngày thi", style: TextStyle(fontWeight: FontWeight.bold))),
                DataColumn(label: Text("📖 Bài thi", style: TextStyle(fontWeight: FontWeight.bold))),
                DataColumn(label: Text("👤 Người thi", style: TextStyle(fontWeight: FontWeight.bold))),
                DataColumn(label: Text("⭐ Điểm số", style: TextStyle(fontWeight: FontWeight.bold))),
                DataColumn(label: Text("⏳ Thời gian làm", style: TextStyle(fontWeight: FontWeight.bold))),
                DataColumn(label: Text("ℹ Trạng thái", style: TextStyle(fontWeight: FontWeight.bold))),
              ],
              rows: historyList.map((history) {
                return DataRow(cells: [
                  DataCell(Text(history.date)),
                  DataCell(Text(history.quizName)),
                  DataCell(Text(widget.username)), // ✅ Hiển thị username từ widget
                  DataCell(
                    history.score == null || history.score == 0
                        ? Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: const Text("null điểm", style: TextStyle(color: Colors.white)),
                    )
                        : Text("${history.score}"),
                  ),
                  DataCell(Text(history.durationMinutes > 0 ? "${history.durationMinutes} phút" : "N/A")),
                  DataCell(
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: history.status == "IN_PROGRESS" ? Colors.orange : Colors.green,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        history.status,
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ]);
              }).toList(),
            ),
          );
        },
      ),
    );
  }
}
