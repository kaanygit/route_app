import 'package:flutter/material.dart';
import 'dart:io';

class SimpleErrorScreen extends StatelessWidget {
  final String errorMessage;

  const SimpleErrorScreen({
    Key? key,
    required this.errorMessage,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              errorMessage,
              style: const TextStyle(fontSize: 16, color: Colors.black),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                exit(0); // Uygulamayı kapatır
              },
              child: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }
}
