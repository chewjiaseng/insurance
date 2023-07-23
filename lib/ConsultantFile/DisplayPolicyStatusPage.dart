import 'package:flutter/material.dart';

class DisplayPolicyStatusPage extends StatelessWidget {
  final String imageAssetPath; // Define the image asset path parameter

  DisplayPolicyStatusPage({required this.imageAssetPath}); // Constructor

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Policy Status'),
      ),
      body: Center(
        child: Image.asset(
            'assets/images/PolicyStatus1.png'), // Display the image using the asset path
      ),
    );
  }
}
