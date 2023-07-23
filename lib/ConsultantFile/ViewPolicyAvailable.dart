import 'package:flutter/material.dart';

class ViewPolicyAvailable extends StatelessWidget {
  // List of available policy types (you can replace this with actual data)
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
        title: Text('Available Policies Company'),
      ),
      body: ListView.builder(
        itemCount: availablePolicies.length,
        itemBuilder: (context, index) {
          final policyType = availablePolicies[index];
          return ListTile(
            title: Text(policyType),
            onTap: () {
              // TODO: Implement the logic for when a policy type is selected
              // You can navigate to a new page or show a dialog with more details
              // about the selected policy type.
            },
          );
        },
      ),
    );
  }
}
