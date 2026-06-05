import 'package:flutter/material.dart';

import 'screens/login_screen.dart';
import 'screens/register_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const HabittApp());
}

class HabittApp extends StatelessWidget {
  const HabittApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Habitt',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),

      // First screen when app starts
      home: const LoginScreen(),

      // Named routes
      routes: {
        '/login': (context) => const LoginScreen(),
        '/register': (context) => const RegisterScreen(),
      },
    );
  }
}