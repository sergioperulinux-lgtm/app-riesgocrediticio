import 'package:flutter/material.dart';
import 'screens/home_screen.dart';

void main() {
  runApp(const CreditRiskApp());
}

class CreditRiskApp extends StatelessWidget {
  const CreditRiskApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Credit Risk App',
      theme: ThemeData(
        primaryColor: const Color(0xFF1E3A8A),
        scaffoldBackgroundColor: const Color(0xFFF5F7FB),
        fontFamily: 'Roboto',
      ),
      home: const HomeScreen(),
    );
  }
}