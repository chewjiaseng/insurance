import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

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
                subtitle: Text('Email: ${user['email'] ?? 'N/A'}'),
                trailing: Text('Role: ${user['rool'] ?? 'N/A'}'),
              );
            },
          );
        },
      ),
    );
  }

  Future<List<Map<String, dynamic>>> getUsers() async {
    final snapshot = await FirebaseFirestore.instance.collection('users').get();
    return snapshot.docs.map((doc) => doc.data() as Map<String, dynamic>).toList();
  }
}
