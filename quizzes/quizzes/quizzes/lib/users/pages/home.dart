import 'package:flutter/material.dart';
import 'package:quizzes/Loc/pages/history.dart';

import '../../loc/pages/ranking_page.dart';
import '../../minhthan/pages/take_quiz/take_quiz.dart';
import '../services/user_service.dart';
import 'auth/login.dart';
import 'auth/profile.dart';

class HomePage extends StatefulWidget {
  final String username;

  const HomePage({super.key, required this.username});

  @override
  State<StatefulWidget> createState() {
    return HomePageState();
  }
}

class HomePageState extends State<HomePage> {
  final userService = UserService();
  int? userId; // ✅ Biến lưu userId

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  /// 📌 Lấy thông tin User từ SharedPreferences
  Future<void> _loadUserData() async {
    try {
      final user = await userService.getUser();
      if (user != null) {
        setState(() {
          userId = user.userId; // ✅ Gán userId
        });

        print('===== THÔNG TIN USER ĐÃ LƯU =====');
        print('Username: ${user.username}');
        print('User ID: ${user.userId}');
        print('Email: ${user.email}');
        print('==================================');
      } else {
        print('⚠ Không tìm thấy dữ liệu user trong bộ nhớ');
      }
    } catch (e) {
      print('❌ Lỗi khi đọc thông tin user: $e');
    }
  }

  /// 📌 Chuyển đến trang lịch sử thi
  void _navigateToHistory() async {
    final user = await userService.getUser();
    if (user != null && user.userId != null) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => HistoryPage(
            username: user.username ?? "Unknown",
            userId: user.userId!,
          ),
        ),
      );
    } else {
      print("⚠ Không thể lấy userId, kiểm tra đăng nhập!");
    }
  }

  /// 📌 Chuyển đến trang bảng xếp hạng
  void _navigateToRanking() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => RankingPage(), // 🔥 Trang Ranking
      ),
    );
  }

  void _navigateToQuiz(int quizId) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => TakeQuizPage(quizId: quizId),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Home Page",
          style: TextStyle(color: Colors.white, fontSize: 30, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.blue,
        actions: [
          PopupMenuButton(
            itemBuilder: (context) {
              return [
                PopupMenuItem(
                  value: 1,
                  child: const ListTile(
                    leading: Icon(Icons.account_box),
                    title: Text("Profile"),
                  ),
                  onTap: () => profile(),
                ),
                PopupMenuItem(
                  value: 2,
                  child: const ListTile(
                    leading: Icon(Icons.history),
                    title: Text("History"),
                  ),
                  onTap: () => _navigateToHistory(),
                ),
                PopupMenuItem(
                  value: 3,
                  child: const ListTile(
                    leading: Icon(Icons.leaderboard), // ✅ Icon Ranking
                    title: Text("Ranking"),
                  ),
                  onTap: () => _navigateToRanking(), // ✅ Chuyển sang ranking
                ),
                PopupMenuItem(
                  value: 4,
                  child: const ListTile(
                    leading: Icon(Icons.logout),
                    title: Text("Logout"),
                  ),
                  onTap: () => logout(),
                ),
              ];
            },
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
              child: Text(
                "Xin chào ${widget.username}, chọn bài quiz để làm",
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),

            // ✅ Nút vào lịch sử thi
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10.0),
              child: ElevatedButton.icon(
                icon: const Icon(Icons.history),
                label: const Text("Xem Lịch Sử"),
                onPressed: _navigateToHistory,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueAccent,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                ),
              ),
            ),

            // ✅ Nút vào bảng xếp hạng (Ranking)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10.0),
              child: ElevatedButton.icon(
                icon: const Icon(Icons.leaderboard),
                label: const Text("Xem Xếp Hạng"),
                onPressed: _navigateToRanking,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orangeAccent,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                ),
              ),
            ),

            Expanded(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 16.0),
                child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 4,
                    childAspectRatio: 1.5,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                  ),
                  itemCount: 20,
                  itemBuilder: (BuildContext context, int index) {
                    final quizId = index + 1;
                    return InkWell(
                      onTap: () => _navigateToQuiz(quizId),
                      child: Card(
                        elevation: 3,
                        child: Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [Colors.blue.shade100, Colors.blue.shade200],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'Quiz $quizId',
                                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(height: 5),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// 📌 Chuyển đến Profile
  profile() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (ctx) => ProfilePage(username: widget.username),
      ),
    );
  }

  /// 📌 Đăng xuất
  logout() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (ctx) => UserLoginPage()),
    );
  }
}
