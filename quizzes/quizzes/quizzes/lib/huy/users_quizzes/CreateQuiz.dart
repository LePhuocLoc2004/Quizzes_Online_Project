import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:quizzes/huy/apis/quizzes_api.dart';
import 'package:quizzes/huy/users_quizzes/welcome.dart';

class CreateQuizPage extends StatefulWidget {
  final int userId;

  CreateQuizPage({required this.userId});

  @override
  _CreateQuizPageState createState() => _CreateQuizPageState();
}

class _CreateQuizPageState extends State<CreateQuizPage> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _timeLimitController = TextEditingController();
  String? _selectedCategoryId;
  PlatformFile? _photoFile;
  bool _isLoading = false;
  String? _successMessage;
  String? _errorMessage;

  List<Map<String, dynamic>> _categories = [];
  bool _isLoadingCategories = true;

  final QuizzesApi _quizzesApi = QuizzesApi();

  @override
  void initState() {
    super.initState();
    _loadCategories();
  }

  Future<void> _loadCategories() async {
    setState(() {
      _isLoadingCategories = true;
    });
    try {
      _categories = await _quizzesApi.getCategories();
    } catch (e) {
      setState(() {
        _errorMessage = 'Failed to load categories: $e';
      });
    } finally {
      setState(() {
        _isLoadingCategories = false;
      });
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _timeLimitController.dispose();
    super.dispose();
  }

  Future<void> _pickPhoto() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.image,
    );
    if (result != null) {
      setState(() {
        _photoFile = result.files.first;
      });
    }
  }

  Future<void> _createQuiz() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
        _successMessage = null;
        _errorMessage = null;
      });
      try {
        File? photoFile = _photoFile != null ? File(_photoFile!.path!) : null;

        final newQuiz = await _quizzesApi.createQuiz(
          userId: widget.userId,
          title: _titleController.text,
          description: _descriptionController.text,
          timeLimit: int.parse(_timeLimitController.text),
          categoryId: int.parse(_selectedCategoryId!),
          photoFile: photoFile,
        );

        setState(() {
          _successMessage =
              'Quiz created successfully with ID: ${newQuiz.quizzId}';
        });

        Future.delayed(Duration(seconds: 2), () {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) => WelcomeScreen(
                      userId: widget.userId,
                    )),
          );
        });
      } catch (e) {
        setState(() {
          _errorMessage = 'Failed to create quiz: $e';
        });
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
                        CircleAvatar(
                          radius: 40,
                          backgroundColor: Colors.blue.shade100,
                          child: Icon(
                            Icons.quiz,
                            size: 50,
                            color: Colors.blue.shade900,
                          ),
                        ),
                        SizedBox(height: 20),
                        Text(
                          'Create New Quiz',
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
                            : DropdownButtonFormField<String>(
                                value: _selectedCategoryId,
                                decoration: InputDecoration(
                                  labelText: 'Category',
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  filled: true,
                                  fillColor: Colors.grey.shade100,
                                ),
                                items: _categories.map((category) {
                                  return DropdownMenuItem<String>(
                                    value: category['categoryId'],
                                    child: Text(category['name']),
                                  );
                                }).toList(),
                                onChanged: (value) {
                                  setState(() {
                                    _selectedCategoryId = value;
                                  });
                                },
                                validator: (value) => value == null
                                    ? 'Please select a category'
                                    : null,
                              ),
                        SizedBox(height: 20),
                        TextFormField(
                          controller: _titleController,
                          decoration: InputDecoration(
                            labelText: 'Title',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            filled: true,
                            fillColor: Colors.grey.shade100,
                          ),
                          validator: (value) =>
                              value!.isEmpty ? 'Please enter a title' : null,
                        ),
                        SizedBox(height: 20),
                        TextFormField(
                          controller: _descriptionController,
                          decoration: InputDecoration(
                            labelText: 'Description',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            filled: true,
                            fillColor: Colors.grey.shade100,
                          ),
                          maxLines: 4,
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
                                  _photoFile != null
                                      ? _photoFile!.name
                                      : 'Upload Photo',
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
                            labelText: 'Time Limit (minutes)',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            filled: true,
                            fillColor: Colors.grey.shade100,
                          ),
                          keyboardType: TextInputType.number,
                          validator: (value) {
                            if (value!.isEmpty)
                              return 'Please enter time limit';
                            if (int.tryParse(value) == null ||
                                int.parse(value) < 1)
                              return 'Enter a valid number >= 1';
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
                                onPressed: _createQuiz,
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
                                  'Create Quiz',
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
