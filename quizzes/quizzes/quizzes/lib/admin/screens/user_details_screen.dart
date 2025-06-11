import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../apis/user_api.dart';
import '../helpers/auth_helper.dart';
import '../helpers/http_helper.dart';
import '../models/quiz_attempt_model.dart';
import '../models/ranking_model.dart';
import '../models/user_model.dart';
import '../widgets/custom_drawer.dart';
import 'attempt_details_screen.dart';
import 'login_screen.dart';

class UserDetailsScreen extends StatefulWidget {
  final int userId;

  const UserDetailsScreen({required this.userId});

  @override
  _UserDetailsScreenState createState() => _UserDetailsScreenState();
}

class _UserDetailsScreenState extends State<UserDetailsScreen> {
  UserModel? user;
  String? profileImage;
  RankingModel? ranking;
  List<QuizAttemptModel> attempts = [];
  Map<int, String> quizMap = {};
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchUserDetails();
  }

  void _fetchUserDetails() async {
    setState(() {
      _isLoading = true;
    });
    try {
      final response = await UserApi.getUserDetails(widget.userId);
      setState(() {
        user = UserModel.fromJson(response['data']['user']);
        profileImage = response['data']['profileImage'] as String?;
        ranking = response['data']['ranking'] != null
            ? RankingModel.fromJson(response['data']['ranking'])
            : null;
        attempts = (response['data']['attempts'] as List<dynamic>)
            .map((e) => QuizAttemptModel.fromJson(e))
            .toList();
        quizMap = (response['data']['quizMap'] as Map<String, dynamic>)
            .map((key, value) => MapEntry(int.parse(key), value.toString()));
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

  void _deleteUser() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirm Delete'),
        content: const Text('Are you sure you want to delete this user?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    if (confirm == true) {
      setState(() {
        _isLoading = true;
      });
      try {
        final response = await UserApi.deleteUser(widget.userId);
        HttpHelper.showSuccess(context, response['message']);
        Navigator.pop(context); // Quay lại màn hình trước (UserManagementScreen)
      } catch (e) {
        HttpHelper.handleError(context, e);
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('User Details'),
        backgroundColor: Colors.black87,
        actions: [
          IconButton(
            icon: const Icon(Icons.delete, color: Colors.red),
            onPressed: _deleteUser,
            tooltip: 'Delete User',
          ),
        ],
      ),
      drawer: CustomDrawer(
        onLogout: _logout,
        selectedIndex: 1,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'User Details',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Text(
              'Details for user: ${user?.username ?? "N/A"}',
              style: const TextStyle(fontSize: 16, color: Colors.grey),
            ),
            const SizedBox(height: 20),
            Card(
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('User Information',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 10),
                    if (user != null) ...[
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          profileImage != null
                              ? Image.network(
                            'http://192.168.1.12:8081/assets/img/$profileImage',
                            width: 80,
                            height: 80,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) =>
                            const Icon(Icons.image_not_supported,
                                size: 80),
                          )
                              : const Icon(Icons.person,
                              size: 80, color: Colors.grey),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('ID: ${user!.userId}'),
                                Text('Username: ${user!.username}'),
                                Text('Email: ${user!.email}'),
                                Chip(
                                  label: Text(user!.role
                                      .substring(5)
                                      .toLowerCase()),
                                  backgroundColor: user!.role == 'ROLE_USER'
                                      ? Colors.blue
                                      : Colors.purple,
                                  labelStyle:
                                  const TextStyle(color: Colors.white),
                                ),
                                Chip(
                                  label: Text(
                                      user!.isActive ? 'Active' : 'Inactive'),
                                  backgroundColor: user!.isActive
                                      ? Colors.green
                                      : Colors.grey,
                                  labelStyle:
                                  const TextStyle(color: Colors.white),
                                ),
                                Text(
                                  'Created At: ${user!.createdAt != null ? DateFormat('dd/MM/yyyy').format(user!.createdAt!) : 'N/A'}',
                                ),
                                Text(
                                  'Deleted At: ${user!.deletedAt != null ? DateFormat('dd/MM/yyyy').format(user!.deletedAt!) : 'N/A'}',
                                  style: TextStyle(
                                    color: user!.deletedAt == null
                                        ? Colors.blue
                                        : null,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ] else
                      const Text('No user data available'),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            Card(
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('User Rankings',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 10),
                    ranking == null
                        ? const Center(child: Text('No ranking data available'))
                        : SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: DataTable(
                        columns: const [
                          DataColumn(label: Text('Ranking Id')),
                          DataColumn(label: Text('User Id')),
                          DataColumn(label: Text('Username')),
                          DataColumn(label: Text('Total Score')),
                          DataColumn(label: Text('Quizzes Completed')),
                          DataColumn(label: Text('Correct Answers')),
                          DataColumn(label: Text('Rank Position')),
                          DataColumn(label: Text('Created At')),
                          DataColumn(label: Text('Updated At')),
                        ],
                        rows: [
                          DataRow(cells: [
                            DataCell(
                              Chip(
                                label: Text(ranking!.rankingId.toString()),
                                backgroundColor: Colors.black,
                                labelStyle:
                                const TextStyle(color: Colors.white),
                              ),
                            ),
                            DataCell(
                              Chip(
                                label: Text(ranking!.userId.toString()),
                                backgroundColor: Colors.black,
                                labelStyle:
                                const TextStyle(color: Colors.white),
                              ),
                            ),
                            DataCell(Text(ranking!.username)),
                            DataCell(Text(ranking!.totalScore.toString())),
                            DataCell(
                                Text(ranking!.quizzesCompleted.toString())),
                            DataCell(
                                Text(ranking!.correctAnswers.toString())),
                            DataCell(
                                Text(ranking!.rankPosition.toString())),
                            DataCell(
                              Text(ranking!.createdAt != null
                                  ? DateFormat('dd/MM/yyyy')
                                  .format(ranking!.createdAt!)
                                  : 'N/A'),
                            ),
                            DataCell(
                              Text(ranking!.updatedAt != null
                                  ? DateFormat('dd/MM/yyyy')
                                  .format(ranking!.updatedAt!)
                                  : 'N/A'),
                            ),
                          ]),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            Card(
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Quiz Attempts',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 10),
                    attempts.isEmpty
                        ? const Center(child: Text('No quiz attempts available'))
                        : SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: DataTable(
                        columns: const [
                          DataColumn(label: Text('Quiz Title')),
                          DataColumn(label: Text('Start Time')),
                          DataColumn(label: Text('End Time')),
                          DataColumn(label: Text('Score')),
                          DataColumn(label: Text('Status')),
                          DataColumn(label: Text('Actions')),
                        ],
                        rows: attempts.map((attempt) {
                          return DataRow(cells: [
                            DataCell(
                                Text(quizMap[attempt.quizzId] ?? 'N/A')),
                            DataCell(Text(
                                attempt.startTime?.toString() ?? 'N/A')),
                            DataCell(
                              Text(
                                attempt.endTime?.toString() ?? 'N/A',
                                style: TextStyle(
                                  color: attempt.endTime == null
                                      ? Colors.blue
                                      : null,
                                ),
                              ),
                            ),
                            DataCell(Text(attempt.score.toString())),
                            DataCell(
                              Chip(
                                label: Text(attempt.status),
                                backgroundColor:
                                attempt.status == 'COMPLETED'
                                    ? Colors.green
                                    : attempt.status == 'IN_PROGRESS'
                                    ? Colors.orange
                                    : Colors.red,
                                labelStyle:
                                const TextStyle(color: Colors.white),
                              ),
                            ),
                            DataCell(
                              ElevatedButton.icon(
                                onPressed: () => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        AttemptDetailsScreen(
                                          attemptId: attempt.attemptId!,
                                          userId: widget.userId,
                                        ),
                                  ),
                                ),
                                icon: const Icon(Icons.visibility, size: 16),
                                label: const Text('Details'),
                                style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.green),
                              ),
                            ),
                          ]);
                        }).toList(),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}