import 'package:flutter/material.dart';

class ConfigureScreen extends StatelessWidget {
  const ConfigureScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Configure'),
      ),
      body: const Center(
        child: Text(
          'Configure Screen',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}