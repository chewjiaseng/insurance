import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'user_management.dart';

class EditUserPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit User'),
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: getUsers(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          final users = snapshot.data;

          if (users == null || users.isEmpty) {
            return Center(child: Text('No users found'));
          }

          return ListView.builder(
            itemCount: users.length,
            itemBuilder: (context, index) {
              final user = users[index];
              return ListTile(
                title: Text('Name: ${user['name'] ?? 'N/A'}'),
                subtitle: Text('Role: ${user['rool'] ?? 'N/A'}'),
                trailing: ElevatedButton(
                  onPressed: () {
                    print('User object: $user'); // Add this line to check the user object
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => UserManagementPage(user: user),
                      ),
                    );
                  },
                  child: Text('Manage'),
                ),
              );
            },
          );
        },
      ),
    );
  }

Future<List<Map<String, dynamic>>> getUsers() async {
  final snapshot = await FirebaseFirestore.instance.collection('users').get();
  return snapshot.docs.map((doc) {
    final data = doc.data() as Map<String, dynamic>;
    // Check if 'userId' key exists in the data, if not, set it to the document ID from Firebase
    if (!data.containsKey('userId')) {
      data['userId'] = doc.id;
    }
    return data;
  }).toList();
 }
}