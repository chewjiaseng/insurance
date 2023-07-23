import 'package:flutter/material.dart';

class DisplayOldPolicyPage extends StatelessWidget {
  final String imageAssetPath; // Define the image asset path parameter

  DisplayOldPolicyPage({required this.imageAssetPath}); // Constructor

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Old Policy'),
      ),
      body: Center(
        child: Image.asset(
            'assets/images/OldPolicy.jpg'), // Display the image using the asset path
      ),
    );
  }
}
