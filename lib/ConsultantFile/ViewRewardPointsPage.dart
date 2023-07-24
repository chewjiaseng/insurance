import 'package:flutter/material.dart';

class ViewRewardPointsPage extends StatelessWidget {
  final Map<String, dynamic> customerData;

  ViewRewardPointsPage({required this.customerData});

  void _redeemPoints(BuildContext context) {
    // Add 10 points to the customer's reward points
    int currentPoints = int.tryParse(customerData['point'] ?? '') ?? 0;
    int newPoints = currentPoints + 10;

    // Show the "Redeemed Successfully" SnackBar
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Redeemed Successfully! You earned 10 points. Just waiting admin to approve!'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  void _deductPoints(BuildContext context) {
    // Deduct 10 points from the customer's reward points
    int currentPoints = int.tryParse(customerData['point'] ?? '') ?? 0;
    int newPoints = currentPoints - 10;

    // Show the "Points Deducted" SnackBar
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Points Deducted! You lost 10 points. Waiting admin to approve!'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Reward Points'),
        backgroundColor: Colors.teal,
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
        child: Padding(
          padding: EdgeInsets.all(20.0),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircleAvatar(
                  radius: 50,
                  backgroundColor: Colors.grey,
                  child: Icon(
                    Icons.person,
                    size: 60,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 20),
                Text(
                  customerData['name'],
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  'Reward Points: ${customerData['point']}',
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.black,
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  'Email: ${customerData['email']}',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.black,
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  'Phone: ${customerData['mobile']}',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.black,
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  'Role: ${customerData['rool']}',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.black,
                  ),
                ),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        _redeemPoints(context);
                      },
                      style: ElevatedButton.styleFrom(
                        primary: Colors.teal,
                        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                      ),
                      child: Text(
                        'Redeem Points',
                        style: TextStyle(fontSize: 18),
                      ),
                    ),
                    SizedBox(width: 20),
                    ElevatedButton(
                      onPressed: () {
                        _deductPoints(context);
                      },
                      style: ElevatedButton.styleFrom(
                        primary: Colors.red,
                        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                      ),
                      child: Text(
                        'Deduct Points',
                        style: TextStyle(fontSize: 18),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
