import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../apis/quiz_api.dart';
import '../helpers/auth_helper.dart';
import '../helpers/http_helper.dart';
import '../models/answer_model.dart';
import '../models/question_model.dart';
import '../models/quiz_model.dart';
import '../widgets/custom_drawer.dart';
import 'add_edit_answer_screen.dart';
import 'add_edit_question_screen.dart';
import 'login_screen.dart';

class QuestionDetailsScreen extends StatefulWidget {
  final int quizzId;

  QuestionDetailsScreen({required this.quizzId});

  @override
  _QuestionDetailsScreenState createState() => _QuestionDetailsScreenState();
}

class _QuestionDetailsScreenState extends State<QuestionDetailsScreen> {
  QuizModel? quiz;
  List<QuestionModel> questions = [];
  List<AnswerModel> answers = [];
  Map<int, int> answerCountMap = {};
  Map<int, bool> insufficientAnswersMap = {};
  QuestionModel? selectedQuestion;
  AnswerModel? selectedAnswer;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchQuestionDetails();
  }

  void _fetchQuestionDetails() async {
    setState(() {
      _isLoading = true;
    });
    try {
      final response = await QuizApi.getQuestionDetails(widget.quizzId);
      setState(() {
        quiz = QuizModel.fromJson(response['data']['quiz']);
        questions = (response['data']['questions'] as List<dynamic>)
            .map((e) => QuestionModel.fromJson(e))
            .toList();
        answers = (response['data']['answers'] as List<dynamic>)
            .map((e) => AnswerModel.fromJson(e))
            .toList();
        answerCountMap = (response['data']['answerCountMap'] as Map<String, dynamic>)
            .map((key, value) => MapEntry(int.parse(key), value as int));
        insufficientAnswersMap = (response['data']['insufficientAnswersMap'] as Map<String, dynamic>)
            .map((key, value) => MapEntry(int.parse(key), value as bool));
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

  void _deleteAnswer(int answerId) async {
    try {
      final response = await QuizApi.deleteAnswer(answerId, widget.quizzId);
      HttpHelper.showSuccess(context, response['message']);
      _fetchQuestionDetails();
    } catch (e) {
      HttpHelper.handleError(context, e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Question Details',
          style: TextStyle(
            fontSize: 26,
            fontWeight: FontWeight.w800,
            color: Colors.black,
            fontFamily: 'Times New Roman',
          ),
        ),
        backgroundColor: Colors.blue[100],
        elevation: 0,
        centerTitle: true,
      ),
      drawer: CustomDrawer(
        onLogout: _logout,
        selectedIndex: 2,
      ),
      body: Container(
        color: Colors.white,
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [

                  Row(
                    children: [
                      ElevatedButton.icon(
                        onPressed: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => AddEditQuestionScreen(quizzId: widget.quizzId),
                          ),
                        ).then((_) => _fetchQuestionDetails()),
                        icon: const Icon(Icons.add, color: Colors.white),
                        label: const Text(
                          'Add Question',
                          style: TextStyle(color: Colors.white, fontSize: 16),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.black87,
                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                        ),
                      ),
                      const SizedBox(width: 10),
                      ElevatedButton.icon(
                        onPressed: selectedQuestion != null
                            ? () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                AddEditQuestionScreen(question: selectedQuestion),
                          ),
                        ).then((_) => _fetchQuestionDetails())
                            : null,
                        icon: const Icon(Icons.edit, color: Colors.white),
                        label: const Text(
                          'Edit Question',
                          style: TextStyle(color: Colors.white, fontSize: 16),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                          selectedQuestion != null ? Colors.black87 : Colors.grey,
                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Card(
                elevation: 2,
                margin: const EdgeInsets.symmetric(vertical: 8),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Quiz Information',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 10),
                      Text('Title: ${quiz?.title ?? "N/A"}'),
                      Text('Description: ${quiz?.description ?? "N/A"}'),
                      Text('Time Limit: ${quiz?.timeLimit ?? 0} minutes'),
                      Text('Total Score: ${quiz?.totalScore ?? 0}'),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          Chip(
                            label: Text(quiz?.status ?? 'N/A'),
                            backgroundColor: quiz?.status == 'PUBLISHED'
                                ? Colors.green
                                : quiz?.status == 'DRAFT'
                                ? Colors.grey
                                : Colors.red,
                            labelStyle: const TextStyle(color: Colors.white),
                          ),
                          const SizedBox(width: 10),
                          Chip(
                            label: Text(quiz?.visibility ?? 'N/A'),
                            backgroundColor:
                            quiz?.visibility == 'PUBLIC' ? Colors.green : Colors.grey,
                            labelStyle: const TextStyle(color: Colors.white),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 10),
              questions.isEmpty
                  ? const Center(child: Text('No questions available for this quiz'))
                  : ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: questions.length,
                itemBuilder: (context, index) {
                  final question = questions[index];
                  final questionAnswers = answers
                      .where((answer) => answer.questionId == question.questionId)
                      .toList();
                  final answerCount = answerCountMap[question.questionId] ?? 0;
                  final isAnswerLimitReached = (question.questionType == 'TRUE_FALSE' &&
                      answerCount >= 2) ||
                      ((question.questionType == 'SINGLE_CHOICE' ||
                          question.questionType == 'MULTIPLE_CHOICE') &&
                          answerCount >= 4);

                  return Card(
                    elevation: 2,
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    child: ExpansionTile(
                      leading: const CircleAvatar(
                        child: Icon(Icons.question_answer),
                        radius: 30,
                      ),
                      title: Text(
                        question.questionText,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      ),
                      trailing: PopupMenuButton<String>(
                        icon: const Icon(Icons.more_vert),
                        onSelected: (value) {
                          if (value == 'edit_answer' && selectedAnswer != null) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => AddEditAnswerScreen(
                                  answer: selectedAnswer,
                                  questionId: question.questionId!,
                                  quizzId: widget.quizzId,
                                ),
                              ),
                            ).then((_) => _fetchQuestionDetails());
                          } else if (value == 'add_answer') {
                            if (!isAnswerLimitReached) {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => AddEditAnswerScreen(
                                    questionId: question.questionId!,
                                    quizzId: widget.quizzId,
                                  ),
                                ),
                              ).then((_) => _fetchQuestionDetails());
                            }
                          } else if (value == 'delete_answer' && selectedAnswer != null) {
                            _deleteAnswer(selectedAnswer!.answerId!);
                          }
                        },
                        itemBuilder: (context) => [
                          PopupMenuItem(
                            value: 'edit_answer',
                            enabled: selectedAnswer != null,
                            child: Row(
                              children: [
                                Icon(Icons.edit,
                                    color: selectedAnswer != null ? Colors.blue : Colors.grey),
                                const SizedBox(width: 8),
                                const Text('Edit Answer'),
                              ],
                            ),
                          ),
                          PopupMenuItem(
                            value: 'add_answer',
                            enabled: !isAnswerLimitReached,
                            child: Row(
                              children: [
                                Icon(Icons.add,
                                    color: isAnswerLimitReached ? Colors.grey : Colors.green),
                                const SizedBox(width: 8),
                                const Text('Add Answer'),
                              ],
                            ),
                          ),
                          PopupMenuItem(
                            value: 'delete_answer',
                            enabled: selectedAnswer != null,
                            child: Row(
                              children: [
                                Icon(Icons.delete,
                                    color: selectedAnswer != null ? Colors.red : Colors.grey),
                                const SizedBox(width: 8),
                                const Text('Delete Answer'),
                              ],
                            ),
                          ),
                        ],
                      ),
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  const Text(
                                    'Type: ',
                                    style: TextStyle(
                                        fontSize: 18, fontWeight: FontWeight.bold),
                                  ),
                                  Chip(
                                    label: Text(question.questionType),
                                    backgroundColor: question.questionType == 'SINGLE_CHOICE'
                                        ? Colors.blue
                                        : question.questionType == 'MULTIPLE_CHOICE'
                                        ? Colors.purple
                                        : Colors.green,
                                    labelStyle:
                                    const TextStyle(color: Colors.white, fontSize: 14),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 10),
                              Text(
                                'Score: ${question.score}',
                                style: const TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(height: 10),
                              const Text(
                                'Answers:',
                                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(height: 10),
                              questionAnswers.isEmpty
                                  ? const Text('No answers available')
                                  : Column(
                                children: questionAnswers.map((answer) {
                                  return Padding(
                                    padding: const EdgeInsets.symmetric(vertical: 4.0),
                                    child: GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          selectedAnswer = answer;
                                        });
                                      },
                                      child: Container(
                                        padding: const EdgeInsets.all(8.0),
                                        decoration: BoxDecoration(
                                          color: answer.isCorrect
                                              ? Colors.green
                                              : Colors.grey,
                                          border: selectedAnswer == answer
                                              ? Border.all(color: Colors.red, width: 2)
                                              : null,
                                          borderRadius: BorderRadius.circular(8),
                                        ),
                                        child: Row(
                                          children: [
                                            Expanded(
                                              child: Text(
                                                answer.answerText,
                                                style: const TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 14,
                                                ),
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  );
                                }).toList(),
                              ),
                            ],
                          ),
                        ),
                      ],
                      onExpansionChanged: (expanded) {
                        if (!expanded) {
                          setState(() {
                            selectedAnswer = null; // Reset selected answer khi đóng
                          });
                        } else {
                          setState(() {
                            selectedQuestion = question; // Chọn câu hỏi khi mở rộng
                          });
                        }
                      },
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}