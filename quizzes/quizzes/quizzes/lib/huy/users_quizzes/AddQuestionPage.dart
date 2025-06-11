import 'package:flutter/material.dart';
import 'package:quizzes/huy/apis/quizzes_api.dart';


import '../models_user/answer_model.dart';


class AddQuestionPage extends StatefulWidget {
  final int? quizzId;
  final int? userId;
  final int? orderIndex;

  AddQuestionPage({this.quizzId, this.userId, this.orderIndex = 1});

  @override
  _AddQuestionPageState createState() => _AddQuestionPageState();
}

class _AddQuestionPageState extends State<AddQuestionPage> {
  final _formKey = GlobalKey<FormState>();
  final _questionTextController = TextEditingController();
  String _questionType = 'TRUE_FALSE';
  final List<Map<String, dynamic>> _answers = [
    {'answerText': '', 'isCorrect': false},
    {'answerText': '', 'isCorrect': false},
  ];
  final QuizzesApi _quizzesApi = QuizzesApi();
  bool _isLoading = false;
  String? _errorMessage;
  String? _successMessage;

  @override
  void initState() {
    super.initState();
    print('Init - quizzId: ${widget.quizzId}, userId: ${widget.userId}, orderIndex: ${widget.orderIndex}');
  }

  void _addAnswerField() {
    final maxAnswers = _questionType == 'TRUE_FALSE' ? 2 : 4;
    if (_answers.length >= maxAnswers) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Tối đa $maxAnswers đáp án cho loại câu hỏi này!')),
      );
      return;
    }

    setState(() {
      _answers.add({'answerText': '', 'isCorrect': false});
    });
  }

  void _updateCheckboxBehavior(int changedIndex, bool? value) {
    setState(() {
      if (_questionType == 'TRUE_FALSE' || _questionType == 'SINGLE_CHOICE') {
        for (int i = 0; i < _answers.length; i++) {
          _answers[i]['isCorrect'] = (i == changedIndex) ? value : false;
        }
      } else {
        _answers[changedIndex]['isCorrect'] = value ?? false;
      }
    });
  }

  bool _validateAnswers() {
    // Kiểm tra nội dung đáp án
    if (_answers.any((answer) {
      final answerText = answer['answerText'] as String?;
      return answerText == null || answerText.trim().isEmpty;
    })) {
      setState(() {
        _errorMessage = 'Tất cả đáp án phải có nội dung.';
      });
      return false;
    }

    // Kiểm tra số lượng đáp án và đáp án đúng
    final correctCount = _answers.where((a) => a['isCorrect'] == true).length;
    if (_questionType == 'TRUE_FALSE') {
      if (_answers.length != 2) {
        setState(() {
          _errorMessage = 'TRUE_FALSE phải có đúng 2 đáp án.';
        });
        return false;
      }
      if (correctCount != 1) {
        setState(() {
          _errorMessage = 'TRUE_FALSE phải có đúng 1 đáp án đúng.';
        });
        return false;
      }
    } else if (_questionType == 'SINGLE_CHOICE') {
      if (_answers.length < 2 || _answers.length > 4) {
        setState(() {
          _errorMessage = 'SINGLE_CHOICE phải có từ 2 đến 4 đáp án.';
        });
        return false;
      }
      if (correctCount != 1) {
        setState(() {
          _errorMessage = 'SINGLE_CHOICE phải có đúng 1 đáp án đúng.';
        });
        return false;
      }
    } else if (_questionType == 'MULTIPLE_CHOICE') {
      if (_answers.length < 2 || _answers.length > 4) {
        setState(() {
          _errorMessage = 'MULTIPLE_CHOICE phải có từ 2 đến 4 đáp án.';
        });
        return false;
      }
      if (correctCount < 1) {
        setState(() {
          _errorMessage = 'MULTIPLE_CHOICE phải có ít nhất 1 đáp án đúng.';
        });
        return false;
      }
    }
    return true;
  }

  Future<void> _submitQuestion() async {
    if (_formKey.currentState!.validate() && _validateAnswers()) {
      setState(() {
        _isLoading = true;
        _errorMessage = null;
        _successMessage = null;
      });

      final int? safeQuizzId = widget.quizzId ?? 0;
      final int? safeUserId = widget.userId ?? 0;
      final int? safeOrderIndex = widget.orderIndex ?? 1;

      print('Submitting - quizzId: $safeQuizzId, userId: $safeUserId, orderIndex: $safeOrderIndex, questionText: ${_questionTextController.text}, questionType: $_questionType');
      print('Raw _answers: $_answers');

      if (safeQuizzId == 0 || safeUserId == 0) {
        setState(() {
          _errorMessage = 'quizzId hoặc userId không hợp lệ!';
          _isLoading = false;
        });
        return;
      }

      try {
        final answers = _answers.asMap().entries.map((entry) {
          final index = entry.key;
          final value = entry.value;
          print('Answer $index - Raw value: $value');
          return AnswerModel(
            answerText: value['answerText'] as String? ?? '',
            isCorrect: value['isCorrect'] as bool? ?? false,
            orderIndex: index + 1,
          );
        }).toList();

        print('Mapped answers: $answers');

        await _quizzesApi.addQuestionWithAnswers(
          quizzId: safeQuizzId!,
          userId: safeUserId!,
          questionText: _questionTextController.text,
          questionType: _questionType,
          score: 10,
          orderIndex: safeOrderIndex!,
          answers: answers,
        );

        setState(() {
          _successMessage = 'Thêm câu hỏi thành công!';
        });

        Navigator.pop(context, true);
      } catch (e) {
        setState(() {
          _errorMessage = 'Lỗi khi thêm câu hỏi: $e';
          _isLoading = false;
        });
        print('Error Details: $e');
      }
    }
  }

  @override
  void dispose() {
    _questionTextController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Thêm Câu hỏi'),
        backgroundColor: Colors.blue.shade900,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (_successMessage != null)
                  Container(
                    padding: EdgeInsets.all(10),
                    margin: EdgeInsets.only(bottom: 15),
                    decoration: BoxDecoration(
                      color: Colors.green.shade100,
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Text(
                      _successMessage!,
                      style: TextStyle(color: Colors.green.shade800),
                    ),
                  ),
                if (_errorMessage != null)
                  Container(
                    padding: EdgeInsets.all(10),
                    margin: EdgeInsets.only(bottom: 15),
                    decoration: BoxDecoration(
                      color: Colors.red.shade100,
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Text(
                      _errorMessage!,
                      style: TextStyle(color: Colors.red.shade800),
                    ),
                  ),
                Text(
                  'Câu hỏi (Thứ tự: ${widget.orderIndex ?? 1})',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: _questionTextController,
                  decoration: InputDecoration(
                    labelText: 'Nội dung câu hỏi',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  maxLines: 3,
                  validator: (value) =>
                  value!.isEmpty ? 'Vui lòng nhập nội dung câu hỏi' : null,
                ),
                const SizedBox(height: 20),
                DropdownButtonFormField<String>(
                  value: _questionType,
                  decoration: InputDecoration(
                    labelText: 'Loại câu hỏi',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  items: [
                    DropdownMenuItem(value: 'TRUE_FALSE', child: Text('Trắc nghiệm Đúng/Sai (TRUE_FALSE)')),
                    DropdownMenuItem(value: 'SINGLE_CHOICE', child: Text('Trắc nghiệm đơn (Single Choice)')),
                    DropdownMenuItem(value: 'MULTIPLE_CHOICE', child: Text('Trắc nghiệm nhiều (Multiple Choice)')),
                  ],
                  onChanged: (value) {
                    setState(() {
                      _questionType = value!;
                      _answers.clear();
                      _answers.addAll(List.generate(
                        _questionType == 'TRUE_FALSE' ? 2 : 4,
                            (index) => {'answerText': '', 'isCorrect': false},
                      ));
                    });
                  },
                  validator: (value) =>
                  value == null ? 'Vui lòng chọn loại câu hỏi' : null,
                ),
                const SizedBox(height: 20),
                Text(
                  'Điểm: 10 (Cố định)',
                  style: TextStyle(fontSize: 16, color: Colors.grey.shade400),
                ),
                const SizedBox(height: 20),
                Text(
                  'Đáp án:',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: _answers.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Row(
                        children: [
                          Container(
                            width: 30,
                            alignment: Alignment.center,
                            child: Text(
                              '${index + 1}',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                          Expanded(
                            child: TextFormField(
                              initialValue: _answers[index]['answerText'],
                              decoration: InputDecoration(
                                labelText: 'Đáp án ${index + 1}',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              onChanged: (value) {
                                setState(() {
                                  _answers[index]['answerText'] = value ?? '';
                                });
                              },
                              validator: (value) {
                                if (_questionType != 'TRUE_FALSE' && (value == null || value.isEmpty)) {
                                  return 'Vui lòng nhập nội dung cho tất cả đáp án';
                                }
                                return null;
                              },
                            ),
                          ),
                          const SizedBox(width: 10),
                          Checkbox(
                            value: _answers[index]['isCorrect'] as bool? ?? false,
                            onChanged: (value) {
                              _updateCheckboxBehavior(index, value);
                            },
                          ),
                          Text('Đúng'),
                        ],
                      ),
                    );
                  },
                ),
                const SizedBox(height: 10),
                if (_answers.length < (_questionType == 'TRUE_FALSE' ? 2 : 4))
                  TextButton(
                    onPressed: _addAnswerField,
                    child: Text(
                      '+ Thêm đáp án',
                      style: TextStyle(color: Colors.blue),
                    ),
                  ),
                const SizedBox(height: 20),
                _isLoading
                    ? Center(child: CircularProgressIndicator())
                    : ElevatedButton(
                  onPressed: _submitQuestion,
                  child: Text(
                    'Thêm',
                    style: TextStyle(color: Colors.white),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue.shade900,
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
