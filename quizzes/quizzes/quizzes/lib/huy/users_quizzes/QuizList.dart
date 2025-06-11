import 'package:flutter/material.dart';
import 'package:quizzes/huy/apis/quizzes_api.dart';
import 'package:quizzes/minhthan/pages/take_quiz/take_quiz.dart';

import '../../base_url.dart';
import '../models_user/category_model.dart';
import '../models_user/quiz_model.dart';

class QuizListPage extends StatefulWidget {
  @override
  _QuizListPageState createState() => _QuizListPageState();
}

class _QuizListPageState extends State<QuizListPage> {
  late Future<Map<String, Object>> _quizListFuture;
  int _currentPage = 1;
  late String _keyword = '';
  String? _selectedCategoryId;
  String? _timeFilter;
  final QuizzesApi _quizzesApi = QuizzesApi();
  final List<CategoryModel> _categories = [];
  int? _totalPages;

  @override
  void initState() {
    super.initState();
    _loadQuizList();
  }

  void _loadQuizList() async {
    _quizListFuture = _quizzesApi.getQuizList(_currentPage, _keyword);
    final data = await _quizListFuture;
    setState(() {
      _totalPages = data['totalPages'] as int;
      _categories.clear();
      _categories.addAll(data['categories'] as List<CategoryModel>);
    });
  }

  void _searchQuizzes() {
    setState(() {
      _currentPage = 1;
      _loadQuizList();
    });
  }

  void _nextPage() {
    setState(() {
      _currentPage++;
      _loadQuizList();
    });
  }

  void _previousPage() {
    if (_currentPage > 1) {
      setState(() {
        _currentPage--;
        _loadQuizList();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade900,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Center(
                child: Column(
                  children: [
                    Text(
                      'Danh sách bài thi',
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue.shade900,
                      ),
                    ),
                    Text(
                      'Khám phá và thử thách bản thân với các bài thi đa dạng',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey.shade400,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 3,
                    child: TextField(
                      decoration: InputDecoration(
                        labelText: 'Tìm kiếm bài thi...',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        prefixIcon:
                            Icon(Icons.search, color: Colors.blue.shade900),
                        filled: true,
                        fillColor: Colors.grey.shade800,
                      ),
                      onChanged: (value) => setState(() => _keyword = value),
                    ),
                  ),
                  SizedBox(width: 10),
                  ElevatedButton(
                    onPressed: _searchQuizzes,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.search, color: Colors.white),
                        SizedBox(width: 5),
                        Text('Tìm kiếm', style: TextStyle(color: Colors.white)),
                      ],
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue.shade900,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20),
              Expanded(
                child: FutureBuilder<Map<String, Object>>(
                  future: _quizListFuture,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(
                          child: CircularProgressIndicator(
                              color: Colors.cyanAccent));
                    } else if (snapshot.hasError) {
                      return Center(
                          child: Text('Error: ${snapshot.error}',
                              style: TextStyle(color: Colors.white)));
                    } else if (!snapshot.hasData) {
                      return Center(
                          child: Text('No data available',
                              style: TextStyle(color: Colors.white)));
                    }

                    final data = snapshot.data!;
                    final List<QuizModel> quizzes =
                        data['quizzes'] as List<QuizModel>;
                    final int totalPages = data['totalPages'] as int;
                    _categories.clear();
                    _categories
                        .addAll(data['categories'] as List<CategoryModel>);

                    return GridView.builder(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        mainAxisSpacing: 10,
                        crossAxisSpacing: 10,
                        childAspectRatio: 0.7,
                      ),
                      itemCount: quizzes.length,
                      itemBuilder: (context, index) {
                        final quiz = quizzes[index];
                        return Card(
                          color: Colors.grey.shade800,
                          elevation: 4,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: ClipRRect(
                                  borderRadius: BorderRadius.vertical(
                                      top: Radius.circular(12)),
                                  child: quiz.photo != null
                                      ? Image.network(
                                          '${BaseUrl.staticUrl}${quiz.photo!.startsWith('/') ? quiz.photo!.substring(1) : quiz.photo}',
                                          fit: BoxFit.cover,
                                          width: double.infinity,
                                          errorBuilder:
                                              (context, error, stackTrace) {
                                            print(
                                                'Error loading image in QuizListPage: $error, URL: ${BaseUrl.staticUrl}${quiz.photo}');
                                            return Image.asset(
                                              'assets/img/default-quiz.jpg',
                                              fit: BoxFit.cover,
                                              width: double.infinity,
                                            );
                                          },
                                        )
                                      : Image.asset(
                                          'assets/img/default-quiz.jpg',
                                          fit: BoxFit.cover,
                                          width: double.infinity,
                                        ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Icon(Icons.book,
                                            color: Colors.blue.shade900,
                                            size: 16),
                                        SizedBox(width: 5),
                                        Expanded(
                                          child: Text(
                                            quiz.title,
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16,
                                            ),
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 5),
                                    Row(
                                      children: [
                                        Icon(Icons.lock_clock,
                                            color: Colors.grey.shade400,
                                            size: 16),
                                        SizedBox(width: 5),
                                        Text(
                                          quiz.timeLimit != null
                                              ? '${quiz.timeLimit} phút'
                                              : 'N/A',
                                          style: TextStyle(
                                              color: Colors.grey.shade400,
                                              fontSize: 14),
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 5),
                                    Text(
                                      quiz.status != null
                                          ? _getStatusText(quiz.status!)
                                          : 'N/A',
                                      style: TextStyle(
                                        color:
                                            _getStatusColor(quiz.status ?? ''),
                                        fontSize: 12,
                                      ),
                                    ),
                                    SizedBox(height: 10),
                                    Wrap(
                                      spacing: 5,
                                      runSpacing: 5,
                                      alignment: WrapAlignment.end,
                                      children: [
                                        if (quiz.status == 'DRAFT' ||
                                            quiz.status == 'PUBLISHED')
                                          ElevatedButton(
                                            onPressed: () {

                                             Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => TakeQuizPage(quizId: quiz.quizzId!),
      ),
    );
                                            },
                                            child: Text(
                                              'Bắt đầu thi',
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 12),
                                            ),
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor:
                                                  Colors.blue.shade900,
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 10, vertical: 5),
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                              ),
                                            ),
                                          ),
                                        if (quiz.status == 'PUBLISHED')
                                          ElevatedButton(
                                            onPressed: () {
                                                                                     Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => TakeQuizPage(quizId: quiz.quizzId!),
      ),
    );
                                            },
                                            child: Text(
                                              'Tiếp tục',
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 12),
                                            ),
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor:
                                                  Colors.blue.shade900,
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 10, vertical: 5),
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                              ),
                                            ),
                                          ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
              if (_totalPages != null && _totalPages! > 1)
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                        onPressed: _previousPage,
                        child: Row(
                          children: [
                            Icon(Icons.chevron_left,
                                color: Colors.white, size: 16),
                            SizedBox(width: 5),
                            Text('Trước',
                                style: TextStyle(color: Colors.white)),
                          ],
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue.shade900,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),
                      SizedBox(width: 10),
                      Text(
                        'Trang $_currentPage của $_totalPages',
                        style: TextStyle(color: Colors.white),
                      ),
                      SizedBox(width: 10),
                      ElevatedButton(
                        onPressed:
                            _currentPage < _totalPages! ? _nextPage : null,
                        child: Row(
                          children: [
                            Text('Sau', style: TextStyle(color: Colors.white)),
                            SizedBox(width: 5),
                            Icon(Icons.chevron_right,
                                color: Colors.white, size: 16),
                          ],
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue.shade900,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  String _getStatusText(String status) {
    switch (status) {
      case 'Active':
        return 'Đã hoàn thành';
      case 'DRAFT':
        return 'Chưa làm';
      case 'PUBLISHED':
        return 'Đang làm';
      default:
        return 'N/A';
    }
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'Active':
        return Colors.green;
      case 'DRAFT':
        return Colors.grey;
      case 'PUBLISHED':
        return Colors.orange;
      default:
        return Colors.white;
    }
  }
}
