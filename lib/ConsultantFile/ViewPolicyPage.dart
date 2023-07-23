import 'package:flutter/material.dart';

import 'DisplayPolicyPage.dart'; // Import the DisplayImagePage class

// ... Other code ...

class ViewPolicyPage extends StatelessWidget {
  final Map<String, dynamic> customerData; // Define the customer data parameter

  // Add the named parameter 'customerData' to the constructor
  ViewPolicyPage({required this.customerData});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Booster Package'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                // Navigate to the DisplayImagePage with the image asset path
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => DisplayPolicyPage(
                        imageAssetPath: 'assets/OldPolicy.jpg'),
                  ),
                );
              },
              child: Text('Old Policy'),
              style: ElevatedButton.styleFrom(
                minimumSize: Size(240, 80),
              ),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: null, // Implement other buttons as needed
              child: Text('New Policy'),
              style: ElevatedButton.styleFrom(
                minimumSize: Size(240, 80),
              ),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: null, // Implement other buttons as needed
              child: Text('Policy Status'),
              style: ElevatedButton.styleFrom(
                minimumSize: Size(240, 80),
              ),
            ),
            SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
