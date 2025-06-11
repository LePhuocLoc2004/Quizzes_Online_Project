import 'package:flutter/material.dart';
import '../../Loc/pages/history.dart';
import '../../loc/pages/ranking_page.dart';
import '../../users/pages/auth/login.dart';
import 'CreateQuiz.dart';
import 'MyQuizzes.dart';
import 'QuizList.dart';

class WelcomeScreen extends StatefulWidget {
  final int? userId;

  WelcomeScreen({required this.userId});

  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  int _index = 0;

  @override
  void initState() {
    super.initState();
    if (widget.userId == null) {
      _handleNullUserId();
    }
    print(">> user id from welcome: ${widget.userId!}");
  }

  void _handleNullUserId() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Error', style: TextStyle(color: Colors.white)),
          content: Text('User ID is null. Please log in again.', style: TextStyle(color: Colors.white)),
          backgroundColor: Colors.grey.shade800,
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => UserLoginPage()),
                );
              },
              child: Text('OK', style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      );
    });
  }

  List<Widget> _getPages() {
    return [
      QuizListPage(),
      MyQuizzesPage(userId: widget.userId!),
      CreateQuizPage(userId: widget.userId!),
    ];
  }

  void _changeScreen(int selectedIndex) {
    setState(() {
      _index = selectedIndex;
    });
  }

  /// 📌 Chuyển đến trang Xếp Hạng (Ranking)
  void _navigateToRanking() {
    if (widget.userId != null) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => RankingPage(),
        ),
      );
    }
  }

  /// 📌 Chuyển đến trang Lịch Sử (History)
  void _navigateToHistory() {
    if (widget.userId != null) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => HistoryPage(
            username: "User ${widget.userId}",
            userId: widget.userId!,
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.userId == null) {
      return Container(); // Tránh lỗi trước khi dialog hiển thị
    }

    return Scaffold(
      backgroundColor: Colors.grey.shade900,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        title: Row(
          children: [
            Icon(Icons.quiz, color: Colors.cyanAccent, size: 30),
            SizedBox(width: 8),
            Text(
              "Quizz Man",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
          ],
        ),
        actions: [
          // 🔥 Nút Xếp Hạng
          IconButton(
            icon: Icon(Icons.emoji_events, color: Colors.orangeAccent),
            tooltip: "Xếp Hạng",
            onPressed: _navigateToRanking,
          ),
          // 🔥 Nút Lịch Sử
          IconButton(
            icon: Icon(Icons.history, color: Colors.blueAccent),
            tooltip: "Lịch Sử",
            onPressed: _navigateToHistory,
          ),
          // 🔥 Hồ sơ cá nhân
          IconButton(
            icon: Icon(Icons.account_circle, color: Colors.white),
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: Text('User Profile', style: TextStyle(color: Colors.white)),
                  content: Text(
                    'User ID: ${widget.userId ?? "Not available"}\nLogged in successfully!',
                    style: TextStyle(color: Colors.white),
                  ),
                  backgroundColor: Colors.grey.shade800,
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: Text('Close', style: TextStyle(color: Colors.white)),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
      body: _getPages()[_index],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _index,
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.blueAccent,
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.grey.shade400,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.list_alt),
            label: "Quiz List",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: "My Quizzes",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add_circle),
            label: "Create Quiz",
          ),
        ],
        onTap: _changeScreen,
      ),
    );
  }
}
