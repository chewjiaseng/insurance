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

          return Container(
            // Set the background image using DecorationImage
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/edituser.png'), // Replace with the path to your edituser.png image
                fit: BoxFit.cover,
              ),
            ),
            child: ListView.builder(
              itemCount: users.length,
              itemBuilder: (context, index) {
                final user = users[index];
                return Card(
                  color: Color.fromRGBO(81, 128, 198, 1),
                  elevation: 4,
                  margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: ListTile(
                    title: Text('Name: ${user['name'] ?? 'N/A'}', style: TextStyle(color: Color.fromRGBO(245, 244, 244, 1))),
                    subtitle: Text('Role: ${user['rool'] ?? 'N/A'}', style: TextStyle(color: Color.fromRGBO(198, 222, 241, 1))),
                    trailing: ElevatedButton(
                      onPressed: () {
                        print('User object: $user');
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => UserManagementPage(user: user),
                          ),
                        );
                      },
                      child: Text('Manage'),
                      style: ElevatedButton.styleFrom(
                        primary: Color(0xFF0F1465),
                        onPrimary: Color(0xDBF0F6F7),
                      ),
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }

  Future<List<Map<String, dynamic>>> getUsers() async {
    final snapshot = await FirebaseFirestore.instance.collection('users').get();
    return snapshot.docs.map((doc) {
      final data = doc.data() as Map<String, dynamic>;
      if (!data.containsKey('userId')) {
        data['userId'] = doc.id;
      }
      return data;
    }).toList();
 }
}