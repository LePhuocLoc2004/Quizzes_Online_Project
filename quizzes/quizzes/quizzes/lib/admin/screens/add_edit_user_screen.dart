import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../../users/pages/auth/login.dart'; // Import UserLoginPage
import '../apis/user_api.dart';
import '../helpers/auth_helper.dart';
import '../helpers/http_helper.dart';
import '../models/user_model.dart';

class AddEditUserScreen extends StatefulWidget {
  final UserModel? user;

  AddEditUserScreen({this.user});

  @override
  _AddEditUserScreenState createState() => _AddEditUserScreenState();
}

class _AddEditUserScreenState extends State<AddEditUserScreen> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  String _role = 'ROLE_USER';
  File? _profileImage;
  bool _isLoading = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    if (widget.user != null) {
      _usernameController.text = widget.user!.username;
      _emailController.text = widget.user!.email;
      _role = widget.user!.role;
      // Không hiển thị mật khẩu cũ vì API không trả về mật khẩu
    }
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    PermissionStatus status = await Permission.photos.request();
    if (status.isDenied || status.isPermanentlyDenied) {
      status = await Permission.storage.request();
    }

    if (status.isGranted) {
      final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
      if (pickedFile != null) {
        setState(() {
          _profileImage = File(pickedFile.path);
        });
        Fluttertoast.showToast(msg: "Image selected", backgroundColor: Colors.green);
      }
    } else if (status.isPermanentlyDenied) {
      Fluttertoast.showToast(msg: "Please allow photo access in settings");
      await openAppSettings();
    } else {
      Fluttertoast.showToast(msg: "Permission denied");
    }
  }

  void _saveUser() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
        _error = null;
      });
      try {
        final user = UserModel(
          userId: widget.user?.userId,
          username: _usernameController.text,
          email: _emailController.text,
          password: _passwordController.text.isEmpty ? null : _passwordController.text, // Chỉ gửi khi có giá trị mới
          role: _role,
          isActive: widget.user?.isActive ?? true,
          profileImage: widget.user?.profileImage,
        );
        Map<String, dynamic> response;
        if (widget.user == null) {
          response = await UserApi.addUser(user, _profileImage?.path);
        } else {
          response = await UserApi.editUser(user, _profileImage?.path);
        }
        HttpHelper.showSuccess(context, response['message']);
        Navigator.pop(context);
      } catch (e) {
        setState(() {
          _error = HttpHelper.handleErrorMessage(e);
        });
        if (_error!.contains('Session expired') || _error!.contains('Authentication failed')) {
          await AuthHelper.clearTokens();
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => UserLoginPage()));
        }
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
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          widget.user == null ? 'Add New User' : 'Edit User',
          style: const TextStyle(color: Colors.black87, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.blue[100],
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                _buildProfileImageSection(),
                const SizedBox(height: 20),
                _buildTextField(
                  controller: _usernameController,
                  label: 'Username',
                  validator: (value) => value!.isEmpty ? 'Enter username' : null,
                ),
                const SizedBox(height: 16),
                _buildTextField(
                  controller: _emailController,
                  label: 'Email',
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value!.isEmpty) return 'Enter email';
                    if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) return 'Invalid email';
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                _buildDropdownField(),
                const SizedBox(height: 16),
                _buildTextField(
                  controller: _passwordController,
                  label: 'Password',
                  obscureText: true,
                  validator: (value) {
                    if (widget.user == null && (value == null || value.isEmpty)) {
                      return 'Enter password';
                    }
                    if (value != null && value.isNotEmpty && value.length < 6) {
                      return 'Password must be at least 6 characters';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                if (_error != null)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: Text(_error!, style: const TextStyle(color: Colors.red)),
                  ),
                const SizedBox(height: 20),
                _buildButtons(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildProfileImageSection() {
    return Column(
      children: [
        const Text(
          'Profile Image',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black),
        ),
        const SizedBox(height: 10),
        CircleAvatar(
          radius: 60,
          backgroundColor: Colors.black,
          child: _profileImage != null
              ? ClipOval(child: Image.file(_profileImage!, width: 120, height: 120, fit: BoxFit.cover))
              : widget.user?.profileImage != null
              ? ClipOval(
            child: Image.network(
              'http://192.168.1.12:8081/assets/img/${widget.user!.profileImage}',
              width: 120,
              height: 120,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => const Icon(Icons.person, size: 60, color: Colors.white),
            ),
          )
              : const Icon(Icons.person, size: 60, color: Colors.white),
        ),
        const SizedBox(height: 10),
        ElevatedButton.icon(
          onPressed: _pickImage,
          icon: const Icon(Icons.image, color: Colors.black),
          label: const Text('Choose Image', style: TextStyle(color: Colors.black)),
          style: ElevatedButton.styleFrom(backgroundColor: Colors.blue[100]),
        ),
      ],
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    bool obscureText = false,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Colors.black),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Colors.black),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Colors.black),
        ),
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      ),
      style: const TextStyle(color: Colors.black),
      obscureText: obscureText,
      keyboardType: keyboardType,
      validator: validator,
    );
  }

  Widget _buildDropdownField() {
    return DropdownButtonFormField<String>(
      value: _role,
      decoration: InputDecoration(
        labelText: 'Role',
        labelStyle: const TextStyle(color: Colors.black),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Colors.black),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Colors.black),
        ),
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      ),
      style: const TextStyle(color: Colors.black),
      items: ['ROLE_USER', 'ROLE_ADMIN']
          .map((role) => DropdownMenuItem(value: role, child: Text(role)))
          .toList(),
      onChanged: (value) => setState(() => _role = value!),
      validator: (value) => value == null ? 'Select a role' : null,
    );
  }

  Widget _buildButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        ElevatedButton(
          onPressed: _isLoading ? null : _saveUser,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blue[100],
            padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 12),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          ),
          child: _isLoading
              ? const CircularProgressIndicator(color: Colors.black)
              : const Text('Save', style: TextStyle(fontSize: 16, color: Colors.black)),
        ),
        OutlinedButton(
          onPressed: () => Navigator.pop(context),
          style: OutlinedButton.styleFrom(
            side: const BorderSide(color: Colors.black),
            padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 12),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          ),
          child: const Text('Cancel', style: TextStyle(fontSize: 16, color: Colors.black)),
        ),
      ],
    );
  }
}