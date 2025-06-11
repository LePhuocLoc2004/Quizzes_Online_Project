import 'package:flutter/material.dart';
import 'package:quizzes/admin/screens/question_management_screen.dart';
import 'package:quizzes/admin/screens/quiz_management_screen.dart';
import 'package:quizzes/admin/screens/user_management_screen.dart';

import '../apis/quiz_api.dart';
import '../helpers/auth_helper.dart';
import '../helpers/http_helper.dart';
import '../widgets/custom_drawer.dart';
import 'category_management_screen.dart';
import 'login_screen.dart';

class DashboardScreen extends StatefulWidget {
  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  Map<String, dynamic>? dashboardData;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchDashboardData();
  }

  void _fetchDashboardData() async {
    setState(() {
      _isLoading = true;
    });
    try {
      final response = await QuizApi.getDashboard();
      setState(() {
        dashboardData = response['data'];
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

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Admin Dashboard',
          style: TextStyle(
            fontSize: 26, // Tăng kích thước font
            fontWeight: FontWeight.w800, // Font dày nhất
            color: Colors.black,
            fontFamily: 'Times New Roman',// Giữ màu đen
          ),
        ),
        backgroundColor: Colors.blue[100],
        elevation: 0,
        centerTitle: true, // Căn giữa tiêu đề
      ),
      drawer: CustomDrawer(
        onLogout: _logout,
        selectedIndex: 0,
      ),
      body: Container(
        color: Colors.blue[100], // Giữ nguyên màu nền xanh biển nhạt
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : Padding(
          padding: const EdgeInsets.all(6), // Giảm padding ngoài
          child: SizedBox(
            height: screenHeight - 60, // Chiều cao vừa màn hình sau khi trừ AppBar
            child: _buildStatsSection(screenWidth),
          ),
        ),
      ),
    );
  }

  Widget _buildStatsSection(double screenWidth) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        color: Colors.white,

        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 3,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: GridView.count(
        crossAxisCount: screenWidth > 700 ? 4 : 2, // 2 cột trên điện thoại
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        crossAxisSpacing: 20, // Khoảng cách ngang
        mainAxisSpacing: 30, // Khoảng cách dọc
        padding: const EdgeInsets.all(10),
        // Padding trong GridView
        children: [
          _buildStatCard(
            title: 'Total Users',
            value: dashboardData?['totalUsers'].toString() ?? '0',
            icon: Icons.person,
            color: Colors.blueAccent,
            onTap: () => Navigator.push(
                context, MaterialPageRoute(builder: (context) => UserManagementScreen())),
          ),
          _buildStatCard(
            title: 'Total Quizzes',
            value: dashboardData?['totalQuizzes'].toString() ?? '0',
            icon: Icons.quiz,
            color: Colors.green,
            onTap: () => Navigator.push(
                context, MaterialPageRoute(builder: (context) => QuizManagementScreen())),
          ),
          _buildStatCard(
            title: 'Published Quizzes',
            value: dashboardData?['publishedQuizzes'].toString() ?? '0',
            icon: Icons.public,
            color: Colors.orange,
            onTap: () => Navigator.push(
                context, MaterialPageRoute(builder: (context) => QuizManagementScreen())),
          ),
          _buildStatCard(
            title: 'Total Questions',
            value: dashboardData?['totalQuestions'].toString() ?? '0',
            icon: Icons.question_answer,
            color: Colors.teal,
            onTap: () => Navigator.push(
                context, MaterialPageRoute(builder: (context) => QuestionManagementScreen())),
          ),
          _buildStatCard(
            title: 'Categories',
            value: dashboardData?['totalCategories'].toString() ?? '0',
            icon: Icons.category,
            color: Colors.purple,
            onTap: () => Navigator.push(
                context, MaterialPageRoute(builder: (context) => CategoryManagementScreen())),
          ),
          _buildStatCard(
            title: 'Total Quiz Attempts',
            value: dashboardData?['totalQuizAttempts'].toString() ?? '0',
            icon: Icons.play_circle,
            color: Colors.indigo,
            onTap: () => Navigator.push(
                context, MaterialPageRoute(builder: (context) => UserManagementScreen())),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard({
    required String title,
    required String value,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withOpacity(0.3)),
        ),
        padding: const EdgeInsets.all(13), // Padding trong thẻ
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 40, color: color), // Kích thước icon
            const SizedBox(height: 8), // Khoảng cách
            Text(
              title,
              style: const TextStyle(
                fontSize: 16, // Kích thước chữ tiêu đề
                fontWeight: FontWeight.w600,
                color: Colors.black,
              ),
              textAlign: TextAlign.center,
              maxLines: 4,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 9), // Khoảng cách
            Text(
              value,
              style: TextStyle(
                fontSize: 24, // Kích thước số liệu
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }
}