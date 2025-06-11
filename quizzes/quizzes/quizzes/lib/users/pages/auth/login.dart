import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../../../admin/helpers/auth_helper.dart';
import '../../../admin/screens/dashboard_screen.dart';
import '../../../huy/users_quizzes/welcome.dart';
import '../../models/login_request_dto.dart';
import '../../repositories/auth_repository.dart';
import '../../services/user_service.dart';
import '../home.dart';

class UserLoginPage extends StatefulWidget {
  const UserLoginPage({super.key});

  @override
  State<UserLoginPage> createState() => _LoginState();
}

class _LoginState extends State<UserLoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController(text: "");
  final _passwordController = TextEditingController(text: "");
  final authRepository = AuthRepository();
  final userService = UserService();
  bool isLoading = false;

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void loginButton() async {
    if (_formKey.currentState!.validate()) {
      setState(() => isLoading = true);

      try {
        final loginRequest = LoginRequestDto(
            username: _usernameController.text, password: _passwordController.text);
        final response = await authRepository.login(loginRequest);
        setState(() => isLoading = false);

        if (response != null && response.message == "Login successful") {
          final role = response.role?.toUpperCase();
          final username = response.username ?? "User";
          final userDto = response.userDto;
          final accessToken = response.accessToken;
          final refreshToken = response.refreshToken;

          // Lưu token
          if (accessToken != null && refreshToken != null) {
            await AuthHelper.saveToken1(accessToken, refreshToken);
          } else {
            Fluttertoast.showToast(
                msg: "Missing access or refresh token from server",
                toastLength: Toast.LENGTH_LONG);
            return;
          }

          // Lưu UserDto
          if (userDto != null) {
            await userService.saveUser(userDto);
            print(
                "UserDTO saved: ID=${userDto.userId}, Username=${userDto.username}, Email=${userDto.email}, Role=${userDto.role}");
          }

          if (role == "ROLE_ADMIN") {
            Fluttertoast.showToast(msg: "Login successful! Welcome Admin");
            Navigator.pushReplacement(
                context, MaterialPageRoute(builder: (context) => DashboardScreen()));
          } else if (role == "ROLE_USER") {
            Fluttertoast.showToast(msg: "Login successful! Welcome $username");
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => WelcomeScreen(userId: response.userDto!.userId ?? 0)),
            );
          } else {
            Fluttertoast.showToast(
                msg: "Invalid role: $role", toastLength: Toast.LENGTH_LONG);
          }
        } else {
          Fluttertoast.showToast(
              msg: "Login failed. Please check your credentials.",
              toastLength: Toast.LENGTH_LONG);
        }
      } catch (e) {
        setState(() => isLoading = false);
        Fluttertoast.showToast(msg: "Login error: $e", toastLength: Toast.LENGTH_LONG);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'User Login',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    controller: _usernameController,
                    decoration: const InputDecoration(
                      labelText: 'Username',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.person),
                    ),
                    keyboardType: TextInputType.text,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your username';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _passwordController,
                    decoration: const InputDecoration(
                      labelText: 'Password',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.lock),
                    ),
                    keyboardType: TextInputType.text,
                    obscureText: true,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your password';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                  isLoading
                      ? const CircularProgressIndicator()
                      : ElevatedButton(
                    onPressed: loginButton,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black87,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 40, vertical: 15),
                      textStyle: const TextStyle(fontSize: 16),
                    ),
                    child: const Text(
                      'Sign In',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  const SizedBox(height: 10),

                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}