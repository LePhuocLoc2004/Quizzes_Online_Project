import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:quizzes/admin/screens/quizzes_by_category_screen.dart'; // Thêm import này
import '../../users/services/user_service.dart';
import '../apis/quiz_api.dart';
import '../helpers/auth_helper.dart';
import '../helpers/http_helper.dart';
import '../models/category_model.dart';
import '../widgets/custom_drawer.dart';
import 'add_edit_category_screen.dart';
import 'login_screen.dart';

class CategoryManagementScreen extends StatefulWidget {
  @override
  _CategoryManagementScreenState createState() => _CategoryManagementScreenState();
}

class _CategoryManagementScreenState extends State<CategoryManagementScreen> {
  List<CategoryModel> categories = [];
  Map<int, String> userMap = {};
  int currentPage = 1;
  int totalPages = 1;
  int totalCategories = 0;
  int pageSize = 6;
  bool _isLoading = true;
  final UserService _userService = UserService();
  int? _currentUserId;

  @override
  void initState() {
    super.initState();
    _fetchCurrentUserId();
    _fetchCategories();
  }

  Future<void> _fetchCurrentUserId() async {
    final user = await _userService.getUser();
    setState(() {
      _currentUserId = user?.userId;
    });
  }

  void _fetchCategories() async {
    setState(() {
      _isLoading = true;
    });
    try {
      final response = await QuizApi.getAllCategories(currentPage);
      setState(() {
        categories = (response['data']['categories'] as List<dynamic>)
            .map((e) => CategoryModel.fromJson(e))
            .toList();
        userMap = (response['data']['userMap'] as Map<String, dynamic>? ?? {})
            .map((key, value) => MapEntry(int.parse(key), value.toString()));
        currentPage = response['data']['currentPage'] ?? 1;
        totalPages = response['data']['totalPages'] ?? 1;
        totalCategories = response['data']['totalCategories'] ?? 0;
        pageSize = response['data']['pageSize'] ?? 6;
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
    await _userService.logout();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => LoginScreen()),
    );
  }

  void _goToPage(int page) {
    if (page >= 1 && page <= totalPages) {
      setState(() {
        currentPage = page;
      });
      _fetchCategories();
    }
  }

  void _deleteCategory(int categoryId) async {
    try {
      final response = await QuizApi.deleteCategory(categoryId);
      HttpHelper.showSuccess(context, response['message']);
      _fetchCategories();
    } catch (e) {
      HttpHelper.handleError(context, e);
    }
  }

  void _restoreCategory(int categoryId) async {
    try {
      final response = await QuizApi.restoreCategory(categoryId);
      HttpHelper.showSuccess(context, response['message']);
      _fetchCategories();
    } catch (e) {
      HttpHelper.handleError(context, e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Category Management',
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
        selectedIndex: 1,
      ),
      body: Container(
        color: Colors.white,
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : Stack(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'All Categories',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      ElevatedButton.icon(
                        onPressed: () => Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => AddEditCategoryScreen()),
                        ).then((_) => _fetchCategories()),
                        icon: const Icon(Icons.add, color: Colors.white),
                        label: const Text(
                          'Add New Category',
                          style: TextStyle(color: Colors.white, fontSize: 16),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.black87,
                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Expanded(
                    child: categories.isEmpty
                        ? const Center(child: Text('No categories available'))
                        : ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: categories.length,
                      itemBuilder: (context, index) {
                        final category = categories[index];
                        return Card(
                          elevation: 2,
                          margin: const EdgeInsets.symmetric(vertical: 8),
                          child: ExpansionTile(
                            leading: const CircleAvatar(
                              child: Icon(Icons.category),
                              radius: 30,
                            ),
                            title: Text(
                              category.name,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                              ),
                            ),
                            subtitle: Text(
                              category.description ?? 'N/A',
                              style: const TextStyle(fontSize: 16),
                            ),
                            trailing: PopupMenuButton<String>(
                              icon: const Icon(Icons.more_vert),
                              onSelected: (value) {
                                if (value == 'edit') {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          AddEditCategoryScreen(category: category),
                                    ),
                                  ).then((_) => _fetchCategories());
                                } else if (value == 'delete') {
                                  _deleteCategory(category.categoryId!);
                                } else if (value == 'restore') {
                                  _restoreCategory(category.categoryId!);
                                } else if (value == 'details') {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => QuizzesByCategoryScreen(
                                          categoryId: category.categoryId!),
                                    ),
                                  );
                                }
                              },
                              itemBuilder: (context) => [
                                if (category.deletedAt == null) ...[
                                  const PopupMenuItem(
                                    value: 'edit',
                                    child: Row(
                                      children: [
                                        Icon(Icons.edit, color: Colors.blue),
                                        SizedBox(width: 8),
                                        Text('Edit'),
                                      ],
                                    ),
                                  ),
                                  const PopupMenuItem(
                                    value: 'delete',
                                    child: Row(
                                      children: [
                                        Icon(Icons.delete, color: Colors.red),
                                        SizedBox(width: 8),
                                        Text('Delete'),
                                      ],
                                    ),
                                  ),
                                  const PopupMenuItem(
                                    value: 'details',
                                    child: Row(
                                      children: [
                                        Icon(Icons.visibility, color: Colors.green),
                                        SizedBox(width: 8),
                                        Text('View Quizzes'),
                                      ],
                                    ),
                                  ),
                                ] else ...[
                                  const PopupMenuItem(
                                    value: 'restore',
                                    child: Row(
                                      children: [
                                        Icon(Icons.restore, color: Colors.green),
                                        SizedBox(width: 8),
                                        Text('Restore'),
                                      ],
                                    ),
                                  ),
                                ],
                              ],
                            ),
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Category ID: ${category.categoryId}',
                                      style: const TextStyle(
                                          fontSize: 18, fontWeight: FontWeight.bold),
                                    ),
                                    const SizedBox(height: 10),
                                    Text(
                                      'Created At: ${category.createdAt != null ? DateFormat('dd/MM/yyyy').format(category.createdAt!) : 'N/A'}',
                                      style: const TextStyle(
                                          fontSize: 18, fontWeight: FontWeight.bold),
                                    ),
                                    const SizedBox(height: 10),
                                    Text(
                                      'Updated At: ${category.updatedAt != null ? DateFormat('dd/MM/yyyy').format(category.updatedAt!) : 'N/A'}',
                                      style: const TextStyle(
                                          fontSize: 18, fontWeight: FontWeight.bold),
                                    ),
                                    const SizedBox(height: 10),
                                    Text(
                                      'Deleted At: ${category.deletedAt != null ? DateFormat('dd/MM/yyyy').format(category.deletedAt!) : ''}',
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: category.deletedAt == null
                                            ? Colors.blue
                                            : null,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: Container(
                color: Colors.white,
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      onPressed: currentPage > 1 ? () => _goToPage(currentPage - 1) : null,
                      icon: const Icon(Icons.arrow_back, size: 24),
                      disabledColor: Colors.grey,
                    ),
                    Text(
                      'Page $currentPage of $totalPages',
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    IconButton(
                      onPressed:
                      currentPage < totalPages ? () => _goToPage(currentPage + 1) : null,
                      icon: const Icon(Icons.arrow_forward, size: 24),
                      disabledColor: Colors.grey,
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