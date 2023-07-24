import 'package:flutter/material.dart';

class DisplayOldPolicyPage extends StatelessWidget {
  final String imageAssetPath; // Define the image asset path parameter

  DisplayOldPolicyPage({required this.imageAssetPath}); // Constructor

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Old Policy'),
        backgroundColor: Colors.teal, // Set app bar color
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.teal,
              Colors.teal.shade200,
              Colors.white,
            ],
          ),
        ),
        child: Center(
          child: Image.asset(imageAssetPath), // Display the image using the asset path
        ),
      ),
    );
  }
}
