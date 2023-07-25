import 'package:flutter/material.dart';

class NewPolicyScreen extends StatelessWidget {
  final String policyType;
  final String imagePath;

  NewPolicyScreen({required this.policyType, required this.imagePath});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('New Policy'),
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        child: Stack(
          children: [
            Image.asset(
              imagePath,
              fit: BoxFit.cover,
            ),
          ],
        ),
      ),
    );
  }
}
