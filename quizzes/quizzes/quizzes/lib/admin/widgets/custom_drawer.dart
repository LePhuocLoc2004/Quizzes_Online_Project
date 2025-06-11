import 'package:flutter/material.dart';
import 'package:quizzes/admin/screens/login_screen.dart'; // Thêm import cho UserLoginPage

import '../../users/pages/auth/login.dart';
import '../screens/category_management_screen.dart';
import '../screens/dashboard_screen.dart';
import '../screens/question_management_screen.dart';
import '../screens/quiz_management_screen.dart';
import '../screens/user_management_screen.dart';

class CustomDrawer extends StatelessWidget {
  final VoidCallback onLogout;
  final int selectedIndex;

  const CustomDrawer({required this.onLogout, required this.selectedIndex});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.blue[100],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/img/logo-ct-dark.png',
                  width: 60,
                  height: 60,
                ),
                const SizedBox(height: 10),
                const Text(
                  'Quiz Admin',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
                    fontFamily: 'Times New Roman',
                  ),
                ),
              ],
            ),
          ),
          ListTile(
            leading: const Icon(Icons.dashboard),
            title: const Text(
              'Dashboard',
              style: TextStyle(
                fontFamily: 'Times New Roman',
                fontWeight: FontWeight.w700,
              ),
            ),
            selected: selectedIndex == 0,
            onTap: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => DashboardScreen()),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.person),
            title: const Text(
              'Users',
              style: TextStyle(
                fontFamily: 'Times New Roman',
                fontWeight: FontWeight.w700,
              ),
            ),
            selected: selectedIndex == 1,
            onTap: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => UserManagementScreen()),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.quiz),
            title: const Text(
              'Quizzes',
              style: TextStyle(
                fontFamily: 'Times New Roman',
                fontWeight: FontWeight.w700,
              ),
            ),
            selected: selectedIndex == 2,
            onTap: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => QuizManagementScreen()),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.category),
            title: const Text(
              'Categories',
              style: TextStyle(
                fontFamily: 'Times New Roman',
                fontWeight: FontWeight.w700,
              ),
            ),
            selected: selectedIndex == 3,
            onTap: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => CategoryManagementScreen()),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.question_answer),
            title: const Text(
              'Questions',
              style: TextStyle(
                fontFamily: 'Times New Roman',
                fontWeight: FontWeight.w700,
              ),
            ),
            selected: selectedIndex == 4,
            onTap: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => QuestionManagementScreen()),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text(
              'Logout',
              style: TextStyle(
                fontFamily: 'Times New Roman',
                fontWeight: FontWeight.w700,
              ),
            ),
            onTap: () {
            // Gọi hàm đăng xuất từ widget cha
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const UserLoginPage()),
              );
            },
          ),
        ],
      ),
    );
  }
}