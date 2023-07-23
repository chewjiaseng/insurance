import 'package:flutter/material.dart';

class ViewRewardPointsPage extends StatelessWidget {
  final Map<String, dynamic> customerData;

  ViewRewardPointsPage({required this.customerData});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Reward Points'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              // Display customer's profile picture here if available
              // Replace this with the actual profile picture
              radius: 50,
              backgroundColor: Colors.grey,
              child: Icon(
                Icons.person,
                size: 60,
                color: Colors.white,
              ),
            ),
            SizedBox(height: 10),
            Text(
              customerData['name'], // Display the customer's name here
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            SizedBox(height: 20),
            Text(
              'Reward Points: ${customerData['point']}', // Display the customer's reward points here
              style: TextStyle(
                fontSize: 18,
                color: Colors.black,
              ),
            ),
            Text(
              'Email: ${customerData['email']}', // Display the customer's email here
              style: TextStyle(
                fontSize: 18,
                color: Colors.black,
              ),
            ),
            Text(
              'Phone: ${customerData['mobile']}', // Display the customer's phone here
              style: TextStyle(
                fontSize: 18,
                color: Colors.black,
              ),
            ),
            // Add more details or widgets you want to display here.
            Text(
              'Role: ${customerData['rool']}', // Display the customer's phone here
              style: TextStyle(
                fontSize: 18,
                color: Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
