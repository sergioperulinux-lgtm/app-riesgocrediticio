import 'package:flutter/material.dart';

class LoadingWidget extends StatelessWidget {
  const LoadingWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: const [
        SizedBox(height: 20),
        CircularProgressIndicator(),
        SizedBox(height: 10),
        Text(
          "Analizando perfil crediticio...",
          style: TextStyle(fontSize: 16),
        ),
      ],
    );
  }
}