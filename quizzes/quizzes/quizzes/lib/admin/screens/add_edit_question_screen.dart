import 'package:flutter/material.dart';
import '../apis/quiz_api.dart';
import '../helpers/http_helper.dart';
import '../models/question_model.dart';
import '../models/quiz_model.dart';

class AddEditQuestionScreen extends StatefulWidget {
  final QuestionModel? question;
  final int? quizzId;

  AddEditQuestionScreen({this.question, this.quizzId});

  @override
  _AddEditQuestionScreenState createState() => _AddEditQuestionScreenState();
}

class _AddEditQuestionScreenState extends State<AddEditQuestionScreen> {
  final _formKey = GlobalKey<FormState>();
  final _questionTextController = TextEditingController();
  final _scoreController = TextEditingController();
  String _questionType = 'SINGLE_CHOICE';
  int? _quizId;
  List<QuizModel> _quizzes = [];
  bool _isLoading = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    _fetchAllQuizzes();
    if (widget.question != null) {
      _questionTextController.text = widget.question!.questionText;
      _scoreController.text = widget.question!.score?.toString() ?? '';
      _questionType = widget.question!.questionType;
      _quizId = widget.question!.quizzId;
    } else if (widget.quizzId != null) {
      _quizId = widget.quizzId;
    }
  }

  @override
  void dispose() {
    _questionTextController.dispose();
    _scoreController.dispose();
    super.dispose();
  }

  void _fetchAllQuizzes() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });
    try {
      final response = await QuizApi.getAllQuizzesWithoutPagination();
      setState(() {
        _quizzes = (response['data']['quizzes'] as List<dynamic>)
            .map((e) => QuizModel.fromJson(e))
            .toList();
        _isLoading = false;
      });
      print('Total quizzes fetched: ${_quizzes.length}'); // Debug số lượng quiz
    } catch (e) {
      setState(() {
        _error = 'Failed to load quizzes: $e';
        _isLoading = false;
      });
    }
  }

  void _saveQuestion() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
        _error = null;
      });
      try {
        final question = QuestionModel(
          questionId: widget.question?.questionId,
          quizzId: _quizId!,
          questionText: _questionTextController.text,
          questionType: _questionType,
          score: int.parse(_scoreController.text),
          orderIndex: widget.question?.orderIndex,
        );
        if (widget.question == null) {
          final response = await QuizApi.addQuestion(question);
          HttpHelper.showSuccess(context, response['message']);
        } else {
          final response = await QuizApi.editQuestion(question);
          HttpHelper.showSuccess(context, response['message']);
        }
        Navigator.pop(context);
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
        title: Text(widget.question == null ? 'Add New Question' : 'Edit Question'),
        backgroundColor: Colors.black87,
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.question == null ? 'Add New Question' : 'Edit Question',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                if (_error != null) ...[
                  SizedBox(height: 20),
                  Text(_error!, style: TextStyle(color: Colors.red)),
                ],
                SizedBox(height: 20),
                DropdownButtonFormField<int>(
                  value: _quizId,
                  decoration: InputDecoration(
                    labelText: 'Quiz',
                    border: OutlineInputBorder(),
                  ),
                  items: _quizzes.map((quiz) {
                    return DropdownMenuItem<int>(
                      value: quiz.quizzId,
                      child: Text(
                        quiz.title,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                    );
                  }).toList(),
                  onChanged: widget.question == null
                      ? (value) {
                    setState(() {
                      _quizId = value;
                    });
                  }
                      : null,
                  validator: (value) {
                    if (value == null) {
                      return 'Please select a quiz';
                    }
                    return null;
                  },
                  disabledHint: widget.question != null && _quizzes.isNotEmpty
                      ? Text(_quizzes
                      .firstWhere((quiz) => quiz.quizzId == _quizId)
                      .title)
                      : null,
                ),
                SizedBox(height: 16),
                TextFormField(
                  controller: _questionTextController,
                  decoration: InputDecoration(
                    labelText: 'Question Text',
                    border: OutlineInputBorder(),
                  ),
                  maxLines: 3,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter question text';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  value: _questionType,
                  decoration: InputDecoration(
                    labelText: 'Question Type',
                    border: OutlineInputBorder(),
                  ),
                  items: ['SINGLE_CHOICE', 'MULTIPLE_CHOICE', 'TRUE_FALSE']
                      .map((type) => DropdownMenuItem<String>(
                    value: type,
                    child: Text(type),
                  ))
                      .toList(),
                  onChanged: (value) {
                    setState(() {
                      _questionType = value!;
                    });
                  },
                ),
                SizedBox(height: 16),
                TextFormField(
                  controller: _scoreController,
                  decoration: InputDecoration(
                    labelText: 'Score',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter score';
                    }
                    if (int.tryParse(value) == null) {
                      return 'Please enter a valid number';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    _isLoading
                        ? CircularProgressIndicator()
                        : ElevatedButton(
                      onPressed: _saveQuestion,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black87,
                        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                      ),
                      child: Text('Save', style: TextStyle(color: Colors.white)),
                    ),
                    SizedBox(width: 10),
                    OutlinedButton(
                      onPressed: () => Navigator.pop(context),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.black87,
                        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                      ),
                      child: Text('Cancel'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}