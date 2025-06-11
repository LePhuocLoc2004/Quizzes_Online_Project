import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:quizzes/admin/screens/user_details_screen.dart';

import '../apis/user_api.dart';
import '../helpers/auth_helper.dart';
import '../helpers/http_helper.dart';
import '../models/ranking_model.dart';
import '../models/user_model.dart';
import '../widgets/custom_drawer.dart';
import 'add_edit_user_screen.dart';
import 'login_screen.dart';

class UserManagementScreen extends StatefulWidget {
  @override
  _UserManagementScreenState createState() => _UserManagementScreenState();
}

class _UserManagementScreenState extends State<UserManagementScreen> {
  List<UserModel> users = [];
  List<RankingModel> rankings = [];
  int currentPage = 1;
  int totalPages = 1;
  int totalUsers = 0;
  int pageSize = 7;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchUsers();
  }

  void _fetchUsers() async {
    setState(() {
      _isLoading = true;
    });
    try {
      final response = await UserApi.getAllUsers(currentPage);
      setState(() {
        users = (response['data']['users'] as List<dynamic>)
            .map((e) => UserModel.fromJson(e))
            .toList(); // Xóa phần sort vì API đã sắp xếp
        rankings = (response['data']['rankings'] as List<dynamic>)
            .map((e) => RankingModel.fromJson(e))
            .toList();
        currentPage = response['data']['currentPage'] ?? 1;
        totalPages = response['data']['totalPages'] ?? 1;
        totalUsers = response['data']['totalUsers'] ?? 0;
        pageSize = response['data']['pageSize'] ?? 7;
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

  void _goToPage(int page) {
    if (page >= 1 && page <= totalPages) {
      setState(() {
        currentPage = page;
      });
      _fetchUsers();
    }
  }

  void _deleteUser(int userId) async {
    try {
      final response = await UserApi.deleteUser(userId);
      HttpHelper.showSuccess(context, response['message']);
      _fetchUsers();
    } catch (e) {
      HttpHelper.handleError(context, e);
    }
  }

  void _toggleUserStatus(int userId, bool isActive) async {
    try {
      final response = isActive
          ? await UserApi.deactivateUser(userId)
          : await UserApi.activateUser(userId);
      HttpHelper.showSuccess(context, response['message']);
      _fetchUsers();
    } catch (e) {
      HttpHelper.handleError(context, e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
            'User Management',
          style: TextStyle(
            fontSize: 26, // Tăng kích thước font
            fontWeight: FontWeight.w800, // Font dày nhất
            color: Colors.black,
            fontFamily: 'Times New Roman',// Giữ màu đen
          ),
        ),
        backgroundColor: Colors.blue[100],
        elevation: 0,
        centerTitle: true, // Căn giữa tiêu đề
      ),
      drawer: CustomDrawer(
        onLogout: _logout,
        selectedIndex: 1,
      ),
      body: Container(
        color: Colors.white, // Nền xanh nhạt
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
                        'All Users',
                        style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                      ),
                      ElevatedButton.icon(
                        onPressed: () => Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => AddEditUserScreen()),
                        ).then((_) => _fetchUsers()),
                        icon: const Icon(Icons.add,color: Colors.white,),
                        label: const Text('Add New User',style: TextStyle(
                          color: Colors.white,
                          fontSize: 16
                        )),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.black87,
                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Expanded(
                    child: users.isEmpty
                        ? const Center(child: Text('No users available'))
                        : ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: users.length,
                      itemBuilder: (context, index) {
                        final user = users[index];
                        return Card(
                          elevation: 2,
                          margin: const EdgeInsets.symmetric(vertical: 8),
                          child: ExpansionTile(
                            leading: user.profileImage != null
                                ? CircleAvatar(
                              backgroundImage: NetworkImage(
                                'http://192.168.1.12:8081/assets/img/${user.profileImage}',
                              ),
                              radius: 30,
                              onBackgroundImageError: (exception, stackTrace) =>
                              const Icon(Icons.image_not_supported),
                            )
                                : const CircleAvatar(
                              child: Icon(Icons.person),
                              radius: 30,
                            ),
                            title: Text(
                              user.username,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                              ),
                            ),
                            subtitle: Text(
                              user.email,
                              style: const TextStyle(fontSize: 16),
                            ),
                            trailing: PopupMenuButton<String>(
                              icon: const Icon(Icons.more_vert),
                              onSelected: (value) {
                                if (value == 'edit') {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => AddEditUserScreen(user: user),
                                    ),
                                  ).then((_) => _fetchUsers());
                                } else if (value == 'delete') {
                                  _deleteUser(user.userId!);
                                } else if (value == 'toggle') {
                                  _toggleUserStatus(user.userId!, user.isActive);
                                } else if (value == 'details') {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          UserDetailsScreen(userId: user.userId!),
                                    ),
                                  );
                                }
                              },
                              itemBuilder: (context) => [
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
                                PopupMenuItem(
                                  value: 'toggle',
                                  child: Row(
                                    children: [
                                      Icon(
                                        user.isActive ? Icons.lock : Icons.lock_open,
                                        color: user.isActive ? Colors.orange : Colors.green,
                                      ),
                                      const SizedBox(width: 8),
                                      Text(user.isActive ? 'DEACTIVATE' : 'ACTIVATE'),
                                    ],
                                  ),
                                ),
                                const PopupMenuItem(
                                  value: 'details',
                                  child: Row(
                                    children: [
                                      Icon(Icons.visibility, color: Colors.green),
                                      SizedBox(width: 8),
                                      Text('Details'),
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
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: [
                                        Chip(
                                          label: Text(
                                            user.role,
                                            style: const TextStyle(
                                                color: Colors.white, fontSize: 14),
                                          ),
                                          backgroundColor: user.role == 'ROLE_USER'
                                              ? Colors.blue
                                              : Colors.purple,
                                        ),
                                        const SizedBox(width: 10),
                                        Chip(
                                          label: Text(
                                            user.isActive ? 'ACTIVATE' : 'INACTIVATE',
                                            style: const TextStyle(
                                                color: Colors.white, fontSize: 14),
                                          ),
                                          backgroundColor:
                                          user.isActive ? Colors.green : Colors.grey,
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 10),
                                    Text(
                                      'Created At: ${user.createdAt != null ? DateFormat('dd/MM/yyyy').format(user.createdAt!) : ''}',
                                      style: const TextStyle(
                                          fontSize: 18, fontWeight: FontWeight.bold),
                                    ),
                                    const SizedBox(height: 10),
                                    Text(
                                      'Deleted At: ${user.deletedAt != null ? DateFormat('dd/MM/yyyy').format(user.deletedAt!) : ''}',
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: user.deletedAt == null ? Colors.blue : null,
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
                color: Colors.white, // Đảm bảo nền đồng nhất
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
                      onPressed: currentPage < totalPages ? () => _goToPage(currentPage + 1) : null,
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