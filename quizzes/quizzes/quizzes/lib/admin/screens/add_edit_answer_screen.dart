import 'package:flutter/material.dart';


import '../apis/quiz_api.dart';
import '../helpers/http_helper.dart';
import '../models/answer_model.dart';

class AddEditAnswerScreen extends StatefulWidget {
  final AnswerModel? answer;
  final int questionId;
  final int quizzId;

  AddEditAnswerScreen({this.answer, required this.questionId, required this.quizzId});

  @override
  _AddEditAnswerScreenState createState() => _AddEditAnswerScreenState();
}

class _AddEditAnswerScreenState extends State<AddEditAnswerScreen> {
  final _formKey = GlobalKey<FormState>();
  final _answerTextController = TextEditingController();
  bool _isCorrect = false;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    if (widget.answer != null) {
      _answerTextController.text = widget.answer!.answerText;
      _isCorrect = widget.answer!.isCorrect;
    }
  }

  @override
  void dispose() {
    _answerTextController.dispose();
    super.dispose();
  }

  void _saveAnswer() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });
      try {
        final answer = AnswerModel(
          answerId: widget.answer?.answerId,
          questionId: widget.questionId,
          answerText: _answerTextController.text,
          isCorrect: _isCorrect,
          orderIndex: widget.answer?.orderIndex,
        );
        if (widget.answer == null) {
          // Add new answer
          final response = await QuizApi.addAnswer(answer);
          HttpHelper.showSuccess(context, response['message']);
        } else {
          // Update existing answer
          final response = await QuizApi.editAnswer(answer);
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
        title: Text(widget.answer == null ? 'Add New Answer' : 'Edit Answer'),
        backgroundColor: Colors.black87,
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.answer == null ? 'Add New Answer' : 'Edit Answer',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 20),
                TextFormField(
                  controller: _answerTextController,
                  decoration: InputDecoration(
                    labelText: 'Answer Text',
                    border: OutlineInputBorder(),
                  ),
                  maxLines: 3,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter answer text';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16),
                DropdownButtonFormField<bool>(
                  value: _isCorrect,
                  decoration: InputDecoration(
                    labelText: 'Is Correct',
                    border: OutlineInputBorder(),
                  ),
                  items: [
                    DropdownMenuItem(value: true, child: Text('True')),
                    DropdownMenuItem(value: false, child: Text('False')),
                  ],
                  onChanged: (value) {
                    setState(() {
                      _isCorrect = value!;
                    });
                  },
                  validator: (value) {
                    if (value == null) {
                      return 'Please select if the answer is correct';
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
                      onPressed: _saveAnswer,
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
                        foregroundColor: Colors.black87, padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
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