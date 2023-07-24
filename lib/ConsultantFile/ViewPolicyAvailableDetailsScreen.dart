import 'package:flutter/material.dart';
import 'OldPolicyScreen.dart';
import 'NewPolicyScreen.dart';

class ViewPolicyAvailableDetailsScreen extends StatelessWidget {
  final String policyType;
  final Map<String, String> policyImages;

  ViewPolicyAvailableDetailsScreen({required this.policyType, required this.policyImages});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Choose Policy Type'),
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
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () {
                  // Navigate to the OldPolicyScreen with the selected policy type and image path.
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => OldPolicyScreen(
                        policyType: policyType,
                        imagePath: policyImages['old_${policyType.toLowerCase()}'] ?? '',
                      ),
                    ),
                  );
                },
                child: Text(
                  'Old Policy',
                  style: TextStyle(fontSize: 18),
                ),
                style: ElevatedButton.styleFrom(
                  primary: Colors.teal, // Set button background color
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                ),
              ),
              SizedBox(height: 20), // Add spacing between the buttons
              ElevatedButton(
                onPressed: () {
                  // Navigate to the NewPolicyScreen with the selected policy type and image path.
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => NewPolicyScreen(
                        policyType: policyType,
                        imagePath: policyImages['new_${policyType.toLowerCase()}'] ?? '',
                      ),
                    ),
                  );
                },
                child: Text(
                  'New Policy',
                  style: TextStyle(fontSize: 18),
                ),
                style: ElevatedButton.styleFrom(
                  primary: Colors.teal, // Set button background color
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
