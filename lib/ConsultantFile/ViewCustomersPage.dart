import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'ViewPolicyPage.dart'; // Import the ViewPolicyPage class

class ViewCustomersPage extends StatelessWidget {
  const ViewCustomersPage({Key? key, required String roleToRetrieve})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('View Customers'),
      ),
      body: StreamBuilder<QuerySnapshot>(
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
              final customer = customers[index].data() as Map<String, dynamic>;
              return ListTile(
                title: Text(customer['name']),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Email: ${customer['email']}'),
                    Text('Name: ${customer['name']}'),
                    Text('Phone: ${customer['mobile']}'),
                    Text('Role: ${customer['rool']}'),
                    // Add more details you want to display here.
                  ],
                ),
                onTap: () {
                  // Navigate to the ViewPolicyPage with the customer data
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          ViewPolicyPage(customerData: customer),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}