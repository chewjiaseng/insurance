import 'package:flutter/material.dart';

class DisplayNewPolicyPage extends StatelessWidget {
  final String imageAssetPath; // Define the image asset path parameter

  DisplayNewPolicyPage({required this.imageAssetPath}); // Constructor

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('New Policy'),
      ),
      body: Center(
        child: Image.asset(
            'assets/images/NewPolicy.png'), // Display the image using the asset path
      ),
    );
  }
}
