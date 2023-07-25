import 'package:flutter/material.dart';
import 'OldPolicyScreen.dart';
import 'NewPolicyScreen.dart';

class ViewAvailableBoosterPackage extends StatelessWidget {
  final Map<String, String> policyImages = {
    'Allianz General Insurance': 'assets/images/allianz_policy_image.jpg',
    'Zurich General Insurance': 'assets/images/zurich_policy_image.png',
    'Great Eastern General Insurance': 'assets/images/great_eastern_policy_image.jpeg',
    'RHB Insurance': 'assets/images/rhb_policy_image.jpg',
    'AIA Insurance': 'assets/images/aia_policy_image.jpg',
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
                leading: Image.asset(
                  policyImages[policyType]!,
                  width: 48,
                  height: 48,
                ),
                title: Text(policyType),
                onTap: () {
                  _showPolicyOptions(context, policyType);
                },
              ),
            );
          },
        ),
      ),
    );
  }

  void _showPolicyOptions(BuildContext context, String policyType) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Select Policy Type'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context); // Close the dialog
                  _navigateToPolicyScreen(context, policyType, isNewPolicy: false);
                },
                child: Text('Old Policy'),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context); // Close the dialog
                  _navigateToPolicyScreen(context, policyType, isNewPolicy: true);
                },
                child: Text('New Policy'),
              ),
            ],
          ),
        );
      },
    );
  }

  void _navigateToPolicyScreen(BuildContext context, String policyType, {required bool isNewPolicy}) {
    if (isNewPolicy) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => NewPolicyScreen(
            policyType: policyType,
            imagePath: _getImagePathForPolicy(policyType, isNewPolicy: true),
          ),
        ),
      );
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => OldPolicyScreen(
            policyType: policyType,
            imagePath: _getImagePathForPolicy(policyType, isNewPolicy: false),
          ),
        ),
      );
    }
  }

  String _getImagePathForPolicy(String policyType, {required bool isNewPolicy}) {
    if (isNewPolicy) {
      // Add the image path for new policies here
      switch (policyType) {
        case 'Allianz General Insurance':
          return 'assets/images/new_policy_1.jpg';
        case 'Zurich General Insurance':
          return 'assets/images/new_policy_2.jpg';
        case 'Great Eastern General Insurance':
          return 'assets/images/new_policy_3.jpg';
        case 'RHB Insurance':
          return 'assets/images/new_policy_4.png';
        case 'AIA Insurance':
          return 'assets/images/new_policy_5.jpg';
        default:
          return 'assets/images/default_policy_image.png';
      }
    } else {
      // Add the image path for old policies here
      switch (policyType) {
        case 'Allianz General Insurance':
          return 'assets/images/old_policy_1.jpg';
        case 'Zurich General Insurance':
          return 'assets/images/old_policy_2.jpeg';
        case 'Great Eastern General Insurance':
          return 'assets/images/old_policy_3.jpeg';
        case 'RHB Insurance':
          return 'assets/images/old_policy_4.jpg';
        case 'AIA Insurance':
          return 'assets/images/old_policy_5.png';
        default:
          return 'assets/images/default_policy_image.png';
      }
    }
  }
}
