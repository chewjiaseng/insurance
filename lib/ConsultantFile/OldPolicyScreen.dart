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
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              imagePath,
              width: 200,
              height: 200,
              fit: BoxFit.contain,
            ),
            SizedBox(height: 20),
            Text(
              'Details for Old Policy $policyType',
              style: TextStyle(fontSize: 18),
            ),
            // Add more content or details related to the old policy if needed
          ],
        ),
      ),
    );
  }
}
