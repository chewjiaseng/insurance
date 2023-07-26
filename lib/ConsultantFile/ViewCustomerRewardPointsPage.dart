import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'ViewRewardPointsPage.dart'; // Import the ViewRewardPointsPage class

class ViewCustomerRewardPointsPage extends StatelessWidget {
  const ViewCustomerRewardPointsPage({Key? key, required String roleToRetrieve})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('View Reward Points'),
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
        child: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection('users')
              .where('rool', isEqualTo: 'customer') // Corrected field name
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Center(
                child: Text('Error: ${snapshot.error}'),
              );
            }

            if (!snapshot.hasData) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            final customers = snapshot.data!.docs;

            if (customers.isEmpty) {
              return const Center(
                child: Text('No customers found.'),
              );
            }

            return ListView.builder(
              itemCount: customers.length,
              itemBuilder: (context, index) {
                final customer =
                    customers[index].data() as Map<String, dynamic>;
                return Card(
                  color: Colors.white.withOpacity(0.9),
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: ListTile(
                    title: Text(
                      customer['name'],
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20, // Set the font size
                        color: Colors.teal, // Set the font color
                      ),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Email: ${customer['email']}',
                          style: TextStyle(
                            fontSize: 16, // Set the font size
                            color: Colors.black, // Set the font color
                          ),
                        ),
                        Text(
                          'Phone: ${customer['mobile']}',
                          style: TextStyle(
                            fontSize: 16, // Set the font size
                            color: Colors.black, // Set the font color
                          ),
                        ),
                        Text(
                          'Role: ${customer['rool']}',
                          style: TextStyle(
                            fontSize: 16, // Set the font size
                            color: Colors.black, // Set the font color
                          ),
                        ),
                        Text(
                          'Reward Points: ${customer['point']}',
                          style: TextStyle(
                            fontSize: 16, // Set the font size
                            color: Color.fromRGBO(247, 19, 19, 1), // Set the font color
                          ),
                        ),
                        // Add more details you want to display here.
                      ],
                    ),
                    onTap: () {
                      // Navigate to the ViewRewardPointsPage with the customer data
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              ViewRewardPointsPage(customerData: customer),
                        ),
                      );
                    },
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
