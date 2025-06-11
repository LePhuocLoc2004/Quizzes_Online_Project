import 'package:flutter/material.dart';
import 'package:quizzes/huy/apis/quizzes_api.dart';


import '../models_user/answer_model.dart';
import '../models_user/question_model.dart';


class EditQuestionPage extends StatefulWidget {
  final QuestionModel? question; // Cho phép null để xử lý trường hợp không có dữ liệu ban đầu
  final int quizzId;
  final int userId;
  final int questionId; // Thêm questionId vào constructor

  EditQuestionPage({
    required this.question,
    required this.quizzId,
    required this.userId,
    required this.questionId, // Yêu cầu questionId
  });

  @override
  _EditQuestionPageState createState() => _EditQuestionPageState();
}

class _EditQuestionPageState extends State<EditQuestionPage> {
  final QuizzesApi _quizzesApi = QuizzesApi();
  late TextEditingController _questionTextController;
  late String _questionType;
  late TextEditingController _scoreController;
  late List<AnswerModel> _answers;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _initializeData();
  }

  void _initializeData() {
    // Khởi tạo mặc định trước khi gọi API
    _questionTextController = TextEditingController(text: widget.question?.questionText ?? '');
    _questionType = widget.question?.questionType ?? 'SINGLE_CHOICE';
    _scoreController = TextEditingController(text: (widget.question?.score ?? 0).toString());
    _answers = widget.question?.answers
        ?.map((answer) => AnswerModel(
      answerId: answer.answerId,
      questionId: answer.questionId,
      answerText: answer.answerText ?? '',
      isCorrect: answer.isCorrect ?? false,
      orderIndex: answer.orderIndex,
    ))
        ?.toList() ??
        [AnswerModel(answerText: '', isCorrect: false, questionId: widget.questionId)]; // Giá trị mặc định
    _loadQuestion();
  }

  Future<void> _loadQuestion() async {
    if (widget.questionId == null) {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Question ID is required'), backgroundColor: Colors.red),
      );
      return;
    }

    try {
      final loadedQuestion = await _quizzesApi.fetchQuestionForEdit(widget.quizzId, widget.userId, widget.questionId);
      setState(() {
        _questionTextController.text = loadedQuestion.questionText ?? widget.question?.questionText ?? '';
        _questionType = loadedQuestion.questionType ?? widget.question?.questionType ?? 'SINGLE_CHOICE';
        _scoreController.text = (loadedQuestion.score ?? widget.question?.score ?? 0).toString();
        _answers = List.from(loadedQuestion.answers.map((answer) => AnswerModel(
          answerId: answer.answerId,
          questionId: answer.questionId,
          answerText: answer.answerText ?? '',
          isCorrect: answer.isCorrect ?? false,
          orderIndex: answer.orderIndex,
        )).toList());
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _updateQuestion() async {
    if (_questionTextController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Vui lòng nhập nội dung câu hỏi'), backgroundColor: Colors.red),
      );
      return;
    }

    if (_scoreController.text.isEmpty || int.tryParse(_scoreController.text) == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Vui lòng nhập điểm số hợp lệ'), backgroundColor: Colors.red),
      );
      return;
    }

    if (_answers.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Vui lòng thêm ít nhất một đáp án'), backgroundColor: Colors.red),
      );
      return;
    }

    if (_answers.any((answer) => answer.answerText?.isEmpty ?? true)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Tất cả đáp án phải có nội dung'), backgroundColor: Colors.red),
      );
      return;
    }

    if (_questionType == 'TRUE_FALSE' && _answers.length != 2) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('TRUE_FALSE phải có đúng 2 đáp án'), backgroundColor: Colors.red),
      );
      return;
    } else if (_questionType == 'SINGLE_CHOICE' && (_answers.length < 2 || _answers.length > 4)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('SINGLE_CHOICE phải có từ 2 đến 4 đáp án'), backgroundColor: Colors.red),
      );
      return;
    } else if (_questionType == 'MULTIPLE_CHOICE' && (_answers.length < 2 || _answers.length > 4)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('MULTIPLE_CHOICE phải có từ 2 đến 4 đáp án'), backgroundColor: Colors.red),
      );
      return;
    }

    int correctCount = _answers.where((a) => a.isCorrect ?? false).length;
    if (_questionType == 'TRUE_FALSE' && correctCount != 1) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('TRUE_FALSE phải có đúng 1 đáp án đúng'), backgroundColor: Colors.red),
      );
      return;
    } else if (_questionType == 'SINGLE_CHOICE' && correctCount != 1) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('SINGLE_CHOICE phải có đúng 1 đáp án đúng'), backgroundColor: Colors.red),
      );
      return;
    } else if (_questionType == 'MULTIPLE_CHOICE' && correctCount < 1) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('MULTIPLE_CHOICE phải có ít nhất 1 đáp án đúng'), backgroundColor: Colors.red),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });
    try {
      await _quizzesApi.updateQuestion(
        quizzId: widget.quizzId,
        userId: widget.userId,
        questionId: widget.questionId, // Sử dụng questionId từ constructor
        questionText: _questionTextController.text,
        questionType: _questionType,
        score: int.parse(_scoreController.text), // Sẽ bị server bỏ qua
        orderIndex: _answers.first.orderIndex ?? 0, // Sẽ bị server bỏ qua
        answers: _answers,
      );
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Cập nhật câu hỏi thành công!'), backgroundColor: Colors.green),
      );
      Navigator.pop(context, true);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Lỗi khi cập nhật: $e'), backgroundColor: Colors.red),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _addAnswer() {
    if (_questionType == 'TRUE_FALSE' && _answers.length >= 2) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('TRUE_FALSE chỉ được có tối đa 2 đáp án'), backgroundColor: Colors.red),
      );
      return;
    } else if ((_questionType == 'SINGLE_CHOICE' || _questionType == 'MULTIPLE_CHOICE') && _answers.length >= 4) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('SINGLE_CHOICE và MULTIPLE_CHOICE chỉ được có tối đa 4 đáp án'), backgroundColor: Colors.red),
      );
      return;
    }

    setState(() {
      _answers.add(AnswerModel(
        answerText: '',
        isCorrect: false,
        orderIndex: null, // Server sẽ tự gán
        questionId: widget.questionId, // Sử dụng questionId từ constructor
      ));
    });
  }

  void _removeAnswer(int index) {
    setState(() {
      _answers.removeAt(index);
    });
  }

  void _updateAnswer(int index, String answerText, bool isCorrect) {
    setState(() {
      _answers[index] = AnswerModel(
        answerId: _answers[index].answerId,
        questionId: _answers[index].questionId,
        answerText: answerText,
        isCorrect: isCorrect,
        orderIndex: _answers[index].orderIndex,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chỉnh sửa Câu hỏi - Quiz ID: ${widget.quizzId}'),
        backgroundColor: Colors.blue.shade900,
        foregroundColor: Colors.white,
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator(color: Colors.blue))
          : SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Câu hỏi:',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _questionTextController,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Nhập nội dung câu hỏi',
              ),
              maxLines: 3,
            ),
            const SizedBox(height: 16),
            Text(
              'Loại câu hỏi:',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            DropdownButton<String>(
              value: _questionType,
              isExpanded: true,
              items: ['TRUE_FALSE', 'SINGLE_CHOICE', 'MULTIPLE_CHOICE']
                  .map((type) => DropdownMenuItem(
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
            const SizedBox(height: 16),
            Text(
              'Điểm (không thay đổi):',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _scoreController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Điểm số (không cập nhật)',
              ),
              enabled: false,
            ),
            const SizedBox(height: 16),
            Text(
              'Đáp án:',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            ..._answers.asMap().entries.map((entry) {
              int index = entry.key;
              AnswerModel answer = entry.value;
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Row(
                  children: [
                    Text(
                      '${index + 1}',
                      style: TextStyle(fontSize: 16),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: TextField(
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          hintText: 'Nhập đáp án ${index + 1}',
                        ),
                        controller: TextEditingController(text: answer.answerText),
                        onChanged: (value) {
                          _updateAnswer(index, value, answer.isCorrect ?? false);
                        },
                      ),
                    ),
                    Checkbox(
                      value: answer.isCorrect ?? false,
                      onChanged: (value) {
                        _updateAnswer(index, answer.answerText ?? '', value ?? false);
                      },
                    ),
                    IconButton(
                      icon: Icon(Icons.delete, color: Colors.red),
                      onPressed: () => _removeAnswer(index),
                    ),
                  ],
                ),
              );
            }).toList(),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _addAnswer,
              child: Text('Thêm đáp án'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue.shade700,
                foregroundColor: Colors.white,
              ),
            ),
            const SizedBox(height: 20),
            Center(
              child: ElevatedButton(
                onPressed: _isLoading ? null : _updateQuestion,
                child: Text('Cập nhật'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}