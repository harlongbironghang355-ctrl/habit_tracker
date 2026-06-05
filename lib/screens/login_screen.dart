import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'register_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() =>
      _LoginScreenState();
}

class _LoginScreenState
    extends State<LoginScreen> {
  final TextEditingController
  _usernameController =
  TextEditingController();

  final TextEditingController
  _passwordController =
  TextEditingController();

  bool validateForm() {
    return _usernameController.text
        .trim()
        .isNotEmpty &&
        _passwordController.text
            .trim()
            .isNotEmpty;
  }

  Future<void> authenticateUser() async {
    final messenger =
    ScaffoldMessenger.of(context);

    final prefs =
    await SharedPreferences.getInstance();

    if (!mounted) return;

    final String? savedUsername =
    prefs.getString('username');

    final String? savedPassword =
    prefs.getString('password');

    if (_usernameController.text.trim() ==
        savedUsername &&
        _passwordController.text ==
            savedPassword) {
      messenger.showSnackBar(
        const SnackBar(
          content: Text(
            'Login Successful',
          ),
        ),
      );

      // Navigator.pushReplacement(
      //   context,
      //   MaterialPageRoute(
      //     builder: (context) =>
      //         const HomeScreen(),
      //   ),
      // );
    } else {
      messenger.showSnackBar(
        const SnackBar(
          content: Text(
            'Invalid Username or Password',
          ),
        ),
      );
    }
  }

  Future<void> handleLogin() async {
    final messenger =
    ScaffoldMessenger.of(context);

    if (!validateForm()) {
      messenger.showSnackBar(
        const SnackBar(
          content: Text(
            'Please enter username and password',
          ),
        ),
      );
      return;
    }

    await authenticateUser();
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Widget _buildInputField(
      TextEditingController controller,
      String hint,
      IconData icon, {
        bool obscureText = false,
      }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius:
        BorderRadius.circular(30),
      ),
      child: TextField(
        controller: controller,
        obscureText: obscureText,
        decoration: InputDecoration(
          prefixIcon: Icon(
            icon,
            color: Colors.blue.shade700,
          ),
          hintText: hint,
          border: InputBorder.none,
          contentPadding:
          const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 15,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.blue.shade700,
              Colors.blue.shade900,
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            padding:
            const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment:
              MainAxisAlignment.center,
              children: [
                const Text(
                  'Habitt',
                  style: TextStyle(
                    fontSize: 36,
                    fontWeight:
                    FontWeight.bold,
                    color: Colors.white,
                  ),
                ),

                const SizedBox(height: 40),

                _buildInputField(
                  _usernameController,
                  'Enter Username',
                  Icons.alternate_email,
                ),

                const SizedBox(height: 20),

                _buildInputField(
                  _passwordController,
                  'Enter Password',
                  Icons.lock,
                  obscureText: true,
                ),

                const SizedBox(height: 30),

                ElevatedButton(
                  onPressed: handleLogin,
                  child: const Text(
                    'Log In',
                  ),
                ),

                const SizedBox(height: 20),

                OutlinedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                        const RegisterScreen(),
                      ),
                    );
                  },
                  child: const Text(
                    'Sign Up',
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}