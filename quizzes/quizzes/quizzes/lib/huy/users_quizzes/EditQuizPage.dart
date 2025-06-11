import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:quizzes/huy/apis/quizzes_api.dart';

import '../../base_url.dart';
import '../models_user/quiz_model.dart';

class EditQuizPage extends StatefulWidget {
  final QuizModel quiz;
  final int userId;

  EditQuizPage({required this.quiz, required this.userId});

  @override
  _EditQuizPageState createState() => _EditQuizPageState();
}

class _EditQuizPageState extends State<EditQuizPage> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _timeLimitController = TextEditingController();
  final _totalScoreController = TextEditingController();
  String? _selectedCategoryId;
  PlatformFile? _newPhotoFile;
  bool _isLoading = false;
  String? _successMessage;
  String? _errorMessage;

  List<Map<String, dynamic>> _categories = [];
  bool _isLoadingCategories = true;

  final QuizzesApi _quizzesApi = QuizzesApi();

  @override
  void initState() {
    super.initState();
    _titleController.text = widget.quiz.title ?? '';
    _descriptionController.text = widget.quiz.description ?? '';
    _timeLimitController.text = widget.quiz.timeLimit?.toString() ?? '';
    _totalScoreController.text = widget.quiz.totalScore?.toString() ?? '100';
    _selectedCategoryId = widget.quiz.categoryId?.toString();
    print('Quiz photo: ${widget.quiz.photo}');
    print('Quiz categoryId: ${widget.quiz.categoryId}');
    _loadCategories();
  }

  Future<void> _loadCategories() async {
    setState(() {
      _isLoadingCategories = true;
    });
    try {
      _categories = await _quizzesApi.getCategories();
      print('Loaded categories: $_categories');
      if (_categories.isNotEmpty && _selectedCategoryId != null) {
        bool categoryExists = _categories.any((category) =>
            category['categoryId'].toString() == _selectedCategoryId);
        if (!categoryExists) {
          _selectedCategoryId = _categories.first['categoryId'].toString();
        }
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Failed to load categories: $e';
      });
      print('Error loading categories: $e');
    } finally {
      setState(() {
        _isLoadingCategories = false;
      });
    }
  }

  Future<void> _pickPhoto() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.image,
    );
    if (result != null) {
      setState(() {
        _newPhotoFile = result.files.first;
      });
    }
  }

  Future<void> _updateQuiz() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
        _successMessage = null;
        _errorMessage = null;
      });
      try {
        File? photoFile =
            _newPhotoFile != null ? File(_newPhotoFile!.path!) : null;

        final updatedQuiz = await _quizzesApi.updateQuiz(
          quizId: widget.quiz.quizzId!,
          userId: widget.userId,
          title: _titleController.text,
          description: _descriptionController.text,
          timeLimit: int.parse(_timeLimitController.text),
          totalScore: int.parse(_totalScoreController.text),
          categoryId: int.parse(_selectedCategoryId!),
          photoFile: photoFile,
        );

        setState(() {
          _successMessage = 'Quiz updated successfully!';
        });

        Future.delayed(Duration(seconds: 2), () {
          Navigator.pop(context, updatedQuiz);
        });
      } catch (e) {
        setState(() {
          _errorMessage = 'Failed to update quiz: $e';
        });
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _timeLimitController.dispose();
    _totalScoreController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chỉnh sửa Quiz'),
        backgroundColor: Colors.blue.shade900,
        foregroundColor: Colors.white,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Colors.blue.shade900, Colors.purple.shade600],
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Card(
                elevation: 10,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'Chỉnh sửa Quiz',
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: Colors.blue.shade900,
                          ),
                        ),
                        SizedBox(height: 10),
                        if (_successMessage != null)
                          Padding(
                            padding: const EdgeInsets.only(bottom: 10),
                            child: Text(
                              _successMessage!,
                              style:
                                  TextStyle(color: Colors.green, fontSize: 16),
                            ),
                          ),
                        if (_errorMessage != null)
                          Padding(
                            padding: const EdgeInsets.only(bottom: 10),
                            child: Text(
                              _errorMessage!,
                              style: TextStyle(color: Colors.red, fontSize: 16),
                            ),
                          ),
                        SizedBox(height: 20),
                        _isLoadingCategories
                            ? CircularProgressIndicator()
                            : _categories.isEmpty
                                ? Text(
                                    'Không tải được danh mục. Kiểm tra kết nối hoặc API.',
                                    style: TextStyle(color: Colors.red),
                                  )
                                : DropdownButtonFormField<String>(
                                    value: _selectedCategoryId,
                                    decoration: InputDecoration(
                                      labelText: 'Danh mục',
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      filled: true,
                                      fillColor: Colors.grey.shade100,
                                    ),
                                    items: _categories.map((category) {
                                      return DropdownMenuItem<String>(
                                        value:
                                            category['categoryId'].toString(),
                                        child: Text(category['name']),
                                      );
                                    }).toList(),
                                    onChanged: (value) {
                                      setState(() {
                                        _selectedCategoryId = value;
                                      });
                                    },
                                    validator: (value) => value == null
                                        ? 'Vui lòng chọn danh mục'
                                        : null,
                                  ),
                        SizedBox(height: 20),
                        TextFormField(
                          controller: _titleController,
                          decoration: InputDecoration(
                            labelText: 'Tiêu đề',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            filled: true,
                            fillColor: Colors.grey.shade100,
                          ),
                          validator: (value) =>
                              value!.isEmpty ? 'Vui lòng nhập tiêu đề' : null,
                        ),
                        SizedBox(height: 20),
                        TextFormField(
                          controller: _descriptionController,
                          decoration: InputDecoration(
                            labelText: 'Mô tả',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            filled: true,
                            fillColor: Colors.grey.shade100,
                          ),
                          maxLines: 4,
                        ),
                        SizedBox(height: 20),
                        if (widget.quiz.photo != null &&
                            widget.quiz.photo!.isNotEmpty)
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Ảnh hiện tại:',
                                style: TextStyle(color: Colors.grey.shade700),
                              ),
                              SizedBox(height: 10),
                              ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: Image.network(
                                  '${BaseUrl.url}${widget.quiz.photo!.startsWith('/') ? '' : '/'}${widget.quiz.photo}',
                                  width: 150,
                                  height: 150,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) {
                                    print(
                                        'Error loading image: $error, URL: ${BaseUrl.url}${widget.quiz.photo}');
                                    return Icon(
                                      Icons.broken_image,
                                      size: 150,
                                      color: Colors.grey,
                                    );
                                  },
                                ),
                              ),
                            ],
                          ),
                        SizedBox(height: 20),
                        GestureDetector(
                          onTap: _pickPhoto,
                          child: Container(
                            padding: EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Row(
                              children: [
                                Icon(Icons.image, color: Colors.blue.shade900),
                                SizedBox(width: 10),
                                Text(
                                  _newPhotoFile != null
                                      ? _newPhotoFile!.name
                                      : 'Chọn ảnh mới (nếu muốn thay đổi)',
                                  style: TextStyle(color: Colors.grey.shade700),
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(height: 20),
                        TextFormField(
                          controller: _timeLimitController,
                          decoration: InputDecoration(
                            labelText: 'Thời gian giới hạn (phút)',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            filled: true,
                            fillColor: Colors.grey.shade100,
                          ),
                          keyboardType: TextInputType.number,
                          validator: (value) {
                            if (value!.isEmpty)
                              return 'Vui lòng nhập thời gian';
                            if (int.tryParse(value) == null ||
                                int.parse(value) < 1) return 'Nhập số >= 1';
                            return null;
                          },
                        ),
                        SizedBox(height: 30),
                        _isLoading
                            ? CircularProgressIndicator(
                                valueColor: AlwaysStoppedAnimation<Color>(
                                    Colors.blue.shade900),
                              )
                            : ElevatedButton(
                                onPressed: _updateQuiz,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.blue.shade900,
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 50, vertical: 15),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  elevation: 5,
                                ),
                                child: Text(
                                  'Cập nhật Quiz',
                                  style: TextStyle(
                                    fontSize: 18,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
