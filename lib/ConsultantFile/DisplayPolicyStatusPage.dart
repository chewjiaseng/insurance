import 'package:flutter/material.dart';

class DisplayPolicyStatusPage extends StatelessWidget {
  final String imageAssetPath; // Define the image asset path parameter

  DisplayPolicyStatusPage({required this.imageAssetPath}); // Constructor

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Policy Status',
          style: TextStyle(
            // Customize the app bar text style
            fontWeight: FontWeight.bold,
            fontSize: 24,
          ),
        ),
        backgroundColor: Colors.teal, // Customize the app bar color
      ),
      backgroundColor: Colors.white, // Customize the page background color
      body: Center(
        child: Image.asset(
          'assets/images/PolicyStatus1.png', // Display the image using the asset path
          fit: BoxFit.cover, // Adjust the image to cover the entire container
        ),
      ),
    );
  }
}
