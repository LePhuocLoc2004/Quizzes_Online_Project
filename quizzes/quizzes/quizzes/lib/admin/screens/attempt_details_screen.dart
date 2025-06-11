import 'package:flutter/material.dart';

import '../apis/user_api.dart';
import '../helpers/auth_helper.dart';
import '../helpers/http_helper.dart';
import '../models/quiz_attempt_model.dart';
import '../models/user_answer_model.dart';
import '../models/user_model.dart';
import '../widgets/custom_drawer.dart';
import 'login_screen.dart';


class AttemptDetailsScreen extends StatefulWidget {
  final int attemptId;
  final int userId;

  AttemptDetailsScreen({required this.attemptId, required this.userId});

  @override
  _AttemptDetailsScreenState createState() => _AttemptDetailsScreenState();
}

class _AttemptDetailsScreenState extends State<AttemptDetailsScreen> {
  UserModel? user;
  QuizAttemptModel? attempt;
  List<UserAnswerModel> userAnswers = [];
  Map<int, String> quizMap = {};
  Map<int, String> questionMap = {};
  Map<int, String> answerMap = {};
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchAttemptDetails();
  }

  void _fetchAttemptDetails() async {
    setState(() {
      _isLoading = true;
    });
    try {
      final response = await UserApi.getAttemptDetails(widget.attemptId, widget.userId);
      setState(() {
        user = UserModel.fromJson(response['data']['user']);
        attempt = QuizAttemptModel.fromJson(response['data']['attempt']);
        userAnswers = (response['data']['userAnswers'] as List<dynamic>)
            .map((e) => UserAnswerModel.fromJson(e))
            .toList();
        quizMap = (response['data']['quizMap'] as Map<String, dynamic>)
            .map((key, value) => MapEntry(int.parse(key), value.toString()));
        questionMap = (response['data']['questionMap'] as Map<String, dynamic>)
            .map((key, value) => MapEntry(int.parse(key), value.toString()));
        answerMap = (response['data']['answerMap'] as Map<String, dynamic>)
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Attempt Details'),
        backgroundColor: Colors.black87,
      ),
      drawer: CustomDrawer(
        onLogout: _logout,
        selectedIndex: 1,
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Attempt Details',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(
              'Details for quiz attempt by ${user?.username ?? "N/A"} on quiz: ${quizMap[attempt?.quizzId] ?? "N/A"}',
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
            SizedBox(height: 20),
            Card(
              elevation: 4,
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Attempt Information', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    SizedBox(height: 10),
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Quiz Title: ${quizMap[attempt?.quizzId] ?? "N/A"}'),
                              Chip(
                                label: Text(attempt?.startTime?.toString() ?? 'N/A'),
                                backgroundColor: Colors.green,
                                labelStyle: TextStyle(color: Colors.white),
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Chip(
                                label: Text(attempt?.endTime?.toString() ?? 'N/A'),
                                backgroundColor: Colors.red,
                                labelStyle: TextStyle(color: Colors.white),
                              ),
                              Text('Score: ${attempt?.score ?? 0}'),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 20),
            Card(
              elevation: 4,
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('User Answers', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    SizedBox(height: 10),
                    userAnswers.isEmpty
                        ? Center(child: Text('No user answers available for this attempt'))
                        : SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: DataTable(
                        columns: [
                          DataColumn(label: Text('Question')),
                          DataColumn(label: Text('Answer')),
                          DataColumn(label: Text('Correct')),
                        ],
                        rows: userAnswers.map((userAnswer) {
                          return DataRow(cells: [
                            DataCell(Text(questionMap[userAnswer.questionId] ?? 'N/A')),
                            DataCell(
                              Chip(
                                label: Text(
                                  answerMap[userAnswer.answerId] ?? 'N/A',
                                  overflow: TextOverflow.ellipsis,
                                ),
                                backgroundColor: userAnswer.isCorrect ? Colors.green : Colors.red,
                                labelStyle: TextStyle(color: Colors.white),
                              ),
                            ),
                            DataCell(
                              Chip(
                                label: Text(userAnswer.isCorrect ? 'Yes' : 'No'),
                                backgroundColor: userAnswer.isCorrect ? Colors.green : Colors.red,
                                labelStyle: TextStyle(color: Colors.white),
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