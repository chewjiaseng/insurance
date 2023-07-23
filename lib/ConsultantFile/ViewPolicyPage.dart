import 'package:flutter/material.dart';

import 'DisplayOldPolicyPage.dart'; // Import the DisplayImagePage class
import 'DisplayNewPolicyPage.dart'; // Import the DisplayImagePage class
import 'DisplayPolicyStatusPage.dart';
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
                    builder: (context) => DisplayOldPolicyPage(
                        imageAssetPath: 'assets/images/OldPolicy.jpg'),
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
              onPressed: () {
                // Navigate to the DisplayPolicyPage with the image asset path for the new policy
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => DisplayNewPolicyPage(
                      imageAssetPath: 'assets/images/NewPolicy.jpg',
                    ),
                  ),
                );
              },// Implement other buttons as needed
              child: Text('New Policy'),
              style: ElevatedButton.styleFrom(
                minimumSize: Size(240, 80),
              ),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                // Navigate to the DisplayPolicyStatusPage with the image asset path for policy status
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => DisplayPolicyStatusPage(
                      imageAssetPath: 'assets/images/PolicyStatus1.jpg',
                    ),
                  ),
                );
              }, // Implement other buttons as needed
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
