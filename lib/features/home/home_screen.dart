import 'package:flutter/material.dart';
import '../../constants/colors.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primary,
      appBar: AppBar(title: const Text("Home")),
      body: const Center(
        child: Text(
          "Welcome to Home Screen!",
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }
}
