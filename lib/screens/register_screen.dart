import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'login_screen.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController _nameController =
  TextEditingController();
  final TextEditingController _usernameController =
  TextEditingController();
  final TextEditingController _emailController =
  TextEditingController();
  final TextEditingController _passwordController =
  TextEditingController();

  double _age = 25;
  String _country = 'India';

  final List<String> _countries = [
    'Australia',
    'Brazil',
    'Canada',
    'China',
    'France',
    'Germany',
    'India',
    'Japan',
    'South Africa',
    'United Kingdom',
    'United States',
  ];

  final List<String> availableHabits = [
    'Wake Up Early',
    'Workout',
    'Drink Water',
    'Meditate',
    'Read a Book',
    'Practice Gratitude',
    'Sleep 8 Hours',
    'Eat Healthy',
    'Journal',
    'Walk 10,000 Steps',
  ];

  List<String> selectedHabits = [];

  bool validateForm() {
    if (_nameController.text.trim().isEmpty ||
        _usernameController.text.trim().isEmpty ||
        _emailController.text.trim().isEmpty ||
        _passwordController.text.trim().isEmpty) {
      return false;
    }

    final emailRegex = RegExp(
      r'^[\w\-\.]+@([\w\-]+\.)+[\w\-]{2,4}$',
    );

    return emailRegex.hasMatch(
      _emailController.text.trim(),
    );
  }

  Future<void> saveUserData() async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setString(
      'name',
      _nameController.text.trim(),
    );

    await prefs.setString(
      'username',
      _usernameController.text.trim(),
    );

    await prefs.setString(
      'email',
      _emailController.text.trim(),
    );

    await prefs.setString(
      'password',
      _passwordController.text.trim(),
    );

    await prefs.setDouble('age', _age);

    await prefs.setString(
      'country',
      _country,
    );

    await prefs.setStringList(
      'habits',
      selectedHabits,
    );
  }

  Future<void> _register() async {
    if (!validateForm()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Please fill all fields correctly',
          ),
        ),
      );
      return;
    }

    await saveUserData();

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          'Registration Successful',
        ),
      ),
    );

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => const LoginScreen(),
      ),
    );
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
        borderRadius: BorderRadius.circular(30),
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
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 15,
          ),
        ),
      ),
    );
  }

  Widget _buildCountryDropdown() {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 20,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
      ),
      child: DropdownButton<String>(
        value: _country,
        isExpanded: true,
        underline: const SizedBox(),
        items: _countries.map((country) {
          return DropdownMenuItem<String>(
            value: country,
            child: Text(country),
          );
        }).toList(),
        onChanged: (value) {
          setState(() {
            _country = value!;
          });
        },
      ),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _usernameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue.shade700,
        title: const Text(
          'Register',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => const LoginScreen(),
              ),
            );
          },
        ),
      ),
      body: Container(
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
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment:
            CrossAxisAlignment.start,
            children: [
              _buildInputField(
                _nameController,
                'Name',
                Icons.person,
              ),
              const SizedBox(height: 12),

              _buildInputField(
                _usernameController,
                'Username',
                Icons.alternate_email,
              ),
              const SizedBox(height: 12),

              _buildInputField(
                _emailController,
                'Email',
                Icons.email,
              ),
              const SizedBox(height: 12),

              _buildInputField(
                _passwordController,
                'Password',
                Icons.lock,
                obscureText: true,
              ),
              const SizedBox(height: 20),

              Text(
                'Age: ${_age.round()}',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                ),
              ),

              Slider(
                value: _age,
                min: 21,
                max: 100,
                divisions: 79,
                activeColor: Colors.white,
                onChanged: (value) {
                  setState(() {
                    _age = value;
                  });
                },
              ),

              const SizedBox(height: 10),

              _buildCountryDropdown(),

              const SizedBox(height: 20),

              const Text(
                'Select Your Habits',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                ),
              ),

              const SizedBox(height: 10),

              Wrap(
                spacing: 10,
                runSpacing: 10,
                children: availableHabits.map((habit) {
                  final isSelected =
                  selectedHabits.contains(habit);

                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        if (isSelected) {
                          selectedHabits.remove(habit);
                        } else {
                          selectedHabits.add(habit);
                        }
                      });
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 10,
                      ),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? Colors.blue
                            : Colors.white,
                        borderRadius:
                        BorderRadius.circular(20),
                      ),
                      child: Text(
                        habit,
                        style: TextStyle(
                          color: isSelected
                              ? Colors.white
                              : Colors.blue,
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),

              const SizedBox(height: 30),

              Center(
                child: ElevatedButton(
                  onPressed: _register,
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                    Colors.blue.shade600,
                    padding:
                    const EdgeInsets.symmetric(
                      horizontal: 80,
                      vertical: 15,
                    ),
                    shape:
                    RoundedRectangleBorder(
                      borderRadius:
                      BorderRadius.circular(30),
                    ),
                  ),
                  child: const Text(
                    'Register',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 15),

              Center(
                child: TextButton(
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                        const LoginScreen(),
                      ),
                    );
                  },
                  child: const Text(
                    'Already have an account? Login',
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}