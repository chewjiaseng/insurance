import 'package:flutter/material.dart';

class OldPolicyScreen extends StatelessWidget {
  final String policyType;
  final String imagePath;

  OldPolicyScreen({required this.policyType, required this.imagePath});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Old Policy'),
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
