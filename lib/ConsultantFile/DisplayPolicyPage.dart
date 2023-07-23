import 'package:flutter/material.dart';

class DisplayPolicyPage extends StatelessWidget {
  final String imageAssetPath; // Define the image asset path parameter

  DisplayPolicyPage({required this.imageAssetPath}); // Constructor

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Old Policy'),
      ),
      body: Center(
        child: Image.asset(
            'OldPolicy.jpg'), // Display the image using the asset path
      ),
    );
  }
}
