import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../users/services/user_service.dart';
import '../apis/quiz_api.dart';
import '../helpers/http_helper.dart';
import '../models/category_model.dart';
import '../models/quiz_model.dart';

class AddEditQuizScreen extends StatefulWidget {
  final QuizModel? quiz;
  final int? categoryId;

  AddEditQuizScreen({this.quiz, this.categoryId});

  @override
  _AddEditQuizScreenState createState() => _AddEditQuizScreenState();
}

class _AddEditQuizScreenState extends State<AddEditQuizScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _timeLimitController = TextEditingController();
  final _totalScoreController = TextEditingController();
  String _status = 'DRAFT';
  String _visibility = 'PRIVATE';
  int? _categoryId;
  List<CategoryModel> _categories = [];
  File? _photoFile;
  bool _isLoading = false;
  String? _error;
  final UserService _userService = UserService();

  @override
  void initState() {
    super.initState();
    _fetchCategories();
    if (widget.quiz != null) {
      _titleController.text = widget.quiz!.title;
      _descriptionController.text = widget.quiz!.description ?? '';
      _timeLimitController.text = widget.quiz!.timeLimit?.toString() ?? '0';
      _totalScoreController.text = widget.quiz!.totalScore?.toString() ?? '0';
      _status = widget.quiz!.status;
      _visibility = widget.quiz!.visibility;
      _categoryId = widget.quiz!.categoryId;
    } else if (widget.categoryId != null) {
      _categoryId = widget.categoryId;
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

  void _fetchCategories() async {
    try {
      final response = await QuizApi.getAllCategories(1);
      setState(() {
        _categories = (response['data']['categories'] as List<dynamic>)
            .map((e) => CategoryModel.fromJson(e))
            .toList();
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
      });
    }
  }

  Future<void> _pickImage() async {
    final ImagePicker _picker = ImagePicker();
    final XFile? pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _photoFile = File(pickedFile.path);
      });
    }
  }

  Future<int?> _getCurrentUserId() async {
    final user = await _userService.getUser();
    if (user != null && user.userId != null) {
      return user.userId;
    }
    throw Exception('User not logged in or userId not found');
  }

  void _saveQuiz() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
        _error = null;
      });
      try {
        int? currentUserId;
        if (widget.quiz == null) {
          currentUserId = await _getCurrentUserId();
        }

        final quiz = QuizModel(
          quizzId: widget.quiz?.quizzId,
          title: _titleController.text,
          description: _descriptionController.text.isEmpty ? null : _descriptionController.text,
          categoryId: _categoryId,
          createdBy: widget.quiz != null ? widget.quiz!.createdBy : currentUserId,
          timeLimit: int.parse(_timeLimitController.text),
          totalScore: int.parse(_totalScoreController.text),
          photo: _photoFile == null ? widget.quiz?.photo : null,
          status: _status,
          visibility: _visibility,
          createdAt: widget.quiz?.createdAt,
          updatedAt: widget.quiz?.updatedAt,
          deletedAt: widget.quiz?.deletedAt,
        );
        print('Quiz data: ${quiz.toJson(isEdit: widget.quiz != null)}');
        if (widget.quiz == null) {
          final response = await QuizApi.addQuiz(quiz, _photoFile?.path);
          HttpHelper.showSuccess(context, response['message']);
        } else {
          final response = await QuizApi.editQuiz(quiz, _photoFile?.path);
          HttpHelper.showSuccess(context, response['message']);
        }
        Navigator.pop(context);
      } catch (e) {
        setState(() {
          _error = 'Failed to save quiz: $e';
        });
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
        title: Text(
          widget.quiz == null ? 'Add New Quiz' : 'Edit Quiz',
          style: const TextStyle(
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
      body: Container(
        color: Colors.white,
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (_error != null) ...[
                  Text(_error!, style: const TextStyle(color: Colors.red)),
                  const SizedBox(height: 10),
                ],
                TextFormField(
                  controller: _titleController,
                  decoration: const InputDecoration(
                    labelText: 'Title',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) => value == null || value.isEmpty ? 'Please enter quiz title' : null,
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<int>(
                  value: _categoryId,
                  decoration: const InputDecoration(
                    labelText: 'Category',
                    border: OutlineInputBorder(),
                  ),
                  items: _categories.map((category) {
                    return DropdownMenuItem<int>(
                      value: category.categoryId,
                      child: Text(category.name),
                    );
                  }).toList(),
                  onChanged: (value) => setState(() => _categoryId = value),
                  validator: (value) => value == null ? 'Please select a category' : null,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _descriptionController,
                  decoration: const InputDecoration(
                    labelText: 'Description (Optional)',
                    border: OutlineInputBorder(),
                  ),
                  maxLines: 3,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _timeLimitController,
                  decoration: const InputDecoration(
                    labelText: 'Time Limit (minutes)',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) return 'Please enter time limit';
                    if (int.tryParse(value) == null || int.parse(value) < 1)
                      return 'Please enter a valid number (>= 1)';
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _totalScoreController,
                  decoration: const InputDecoration(
                    labelText: 'Total Score',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) return 'Please enter total score';
                    if (int.tryParse(value) == null || int.parse(value) < 0)
                      return 'Please enter a valid number (>= 0)';
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  value: _status,
                  decoration: const InputDecoration(
                    labelText: 'Status',
                    border: OutlineInputBorder(),
                  ),
                  items: ['DRAFT', 'PUBLISHED', 'ARCHIVED']
                      .map((status) => DropdownMenuItem<String>(value: status, child: Text(status)))
                      .toList(),
                  onChanged: (value) => setState(() => _status = value!),
                  validator: (value) => value == null ? 'Please select a status' : null,
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  value: _visibility,
                  decoration: const InputDecoration(
                    labelText: 'Visibility',
                    border: OutlineInputBorder(),
                  ),
                  items: ['PUBLIC', 'PRIVATE']
                      .map((visibility) => DropdownMenuItem<String>(value: visibility, child: Text(visibility)))
                      .toList(),
                  onChanged: (value) => setState(() => _visibility = value!),
                  validator: (value) => value == null ? 'Please select visibility' : null,
                ),
                const SizedBox(height: 16),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Current Photo:', style: TextStyle(fontWeight: FontWeight.w600)),
                          const SizedBox(height: 10),
                          widget.quiz?.photo != null
                              ? Image.network(
                            'http://192.168.1.12:8081/assets/img/${widget.quiz!.photo}',
                            width: 100,
                            height: 100,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) =>
                            const Icon(Icons.image_not_supported),
                          )
                              : const Text('No photo uploaded'),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Upload New Photo (Optional):',
                              style: TextStyle(fontWeight: FontWeight.w600)),
                          const SizedBox(height: 10),
                          ElevatedButton.icon(
                            onPressed: _pickImage,
                            icon: const Icon(Icons.upload, color: Colors.white),
                            label: const Text('Choose Photo', style: TextStyle(color: Colors.white)),
                            style: ElevatedButton.styleFrom(backgroundColor: Colors.black87),
                          ),
                          if (_photoFile != null) ...[
                            const SizedBox(height: 10),
                            Image.file(_photoFile!, width: 100, height: 100, fit: BoxFit.cover),
                          ],
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    if (_isLoading)
                      const CircularProgressIndicator()
                    else ...[
                      ElevatedButton.icon(
                        onPressed: _saveQuiz,
                        icon: const Icon(Icons.save, color: Colors.white),
                        label: const Text('Save', style: TextStyle(color: Colors.white)),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.black87,
                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                        ),
                      ),
                      const SizedBox(width: 10),
                      OutlinedButton.icon(
                        onPressed: () => Navigator.pop(context),
                        icon: const Icon(Icons.cancel),
                        label: const Text('Cancel'),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.black87,
                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                        ),
                      ),
                    ],
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