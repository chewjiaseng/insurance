import 'package:flutter/material.dart';
import 'ViewPolicyAvailableDetailsScreen.dart';

class ViewAvailableBoosterPackage extends StatelessWidget {
  final Map<String, String> policyImages = {
    'Allianz General Insurance': 'assets/allianz_policy_image.png',
    'Zurich General Insurance': 'assets/zurich_policy_image.png',
    'Great Eastern General Insurance': 'assets/great_eastern_policy_image.png',
    'RHB Insurance': 'assets/rhb_policy_image.png',
    'AIA Insurance': 'assets/aia_policy_image.png',
    // Add more policy types and image paths as needed
  };

  final List<String> availablePolicies = [
    'Allianz General Insurance',
    'Zurich General Insurance',
    'Great Eastern General Insurance',
    'RHB Insurance',
    'AIA Insurance',
    // Add more policy types as needed
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Booster Package'),
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
        child: ListView.builder(
          itemCount: availablePolicies.length,
          itemBuilder: (context, index) {
            final policyType = availablePolicies[index];
            return Card(
              elevation: 2,
              margin: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              child: ListTile(
                title: Text(policyType),
                onTap: () {
                  // Navigate to the PolicyTypeScreen with the selected policy type and image path map.
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ViewPolicyAvailableDetailsScreen(
                        policyType: policyType,
                        policyImages: policyImages,
                      ),
                    ),
                  );
                },
              ),
            );
          },
        ),
      ),
    );
  }
}
