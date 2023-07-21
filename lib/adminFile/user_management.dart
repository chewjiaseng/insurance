import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; 

class UserManagementPage extends StatelessWidget {
  final Map<String, dynamic>? user;

  UserManagementPage({required this.user});

   Future<void> assignRole(String role, BuildContext context) async {
    String updatedRole = role ?? '';

    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(user?['userId'])
          .update({'rool': updatedRole});

      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Success'),
          content: Text('Role assigned successfully.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('OK'),
            ),
          ],
        ),
      );
    } catch (error) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Error'),
          content: Text('Failed to assign role. Please try again.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('OK'),
            ),
          ],
        ),
      );
    }
  }

  Future<void> toggleBlockUser(BuildContext context) async {
    String? userId = user?['userId'];

    if (userId == null) {
      print('User ID is null.');
      return;
    }

    print('Toggling block status for user with ID: $userId');

    try {
      // Set the "blocked" field to true
      await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .update({'blocked': true});

      print('User blocked successfully: $userId');

      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Success'),
          content: Text('User blocked successfully.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('OK'),
            ),
          ],
        ),
      );
    } catch (error) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Error'),
          content: Text('Failed to update blocked status. Please try again.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('OK'),
            ),
          ],
        ),
      );
      print('Error updating blocked status: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
     print('User object in UserManagementPage: $user'); // Add this line to check the user object
     
    if (user == null) {
      return Scaffold(
        appBar: AppBar(
          title: Text('Error'),
        ),
        body: Center(
          child: Text('User data not available.'),
        ),
      );
    }

    String? userId = user?['userId'];
    String? role = user?['rool'];
    String? profileImageUrl = user?['profileImageUrl'];
    String? name = user?['name'];

    bool isCustomer = role == 'customer';

    return Scaffold(
      appBar: AppBar(
        title: Text('User Management'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 50,
              backgroundImage: profileImageUrl != null
                  ? NetworkImage(profileImageUrl) as ImageProvider<Object>?
                  : null,
              child: profileImageUrl == null
                  ? Icon(
                      Icons.person,
                      size: 50,
                      color: Colors.white,
                    )
                  : null,
            ),
            SizedBox(height: 10),
            Text(
              '${name ?? 'Unknown User'}',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 160,
                  height: 160,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: Text('Assign Role'),
                          content: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              ElevatedButton(
                                onPressed: () {
                                  assignRole('admin', context);
                                  Navigator.pop(context);
                                },
                                child: Text('Admin'),
                              ),
                              ElevatedButton(
                                onPressed: () {
                                  assignRole('customer', context);
                                  Navigator.pop(context);
                                },
                                child: Text('Customer'),
                              ),
                              ElevatedButton(
                                onPressed: () {
                                  assignRole('consultant', context);
                                  Navigator.pop(context);
                                },
                                child: Text('Consultant'),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                    icon: Icon(Icons.person_add, color: Colors.black),
                    label: Text('Assign Role', style: TextStyle(color: Colors.black)),
                    style: ElevatedButton.styleFrom(
                      primary: Color(0xF5F6F0F0),
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        side: BorderSide(color: Colors.grey, width: 2),
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 20),
                Container(
                  width: 160,
                  height: 160,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      // Perform the action for "View Activity Logs" here
                    },
                    icon: Icon(Icons.history, color: Colors.black),
                    label: Text('View Activity Logs', style: TextStyle(color: Colors.black)),
                    style: ElevatedButton.styleFrom(
                      primary: Color(0xF5F6F0F0),
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        side: BorderSide(color: Colors.grey, width: 2),
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 160,
                  height: 160,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      toggleBlockUser(context); // Pass the context here
                    },
                    icon: Icon(Icons.block, color: Colors.black),
                    label: Text('Block User', style: TextStyle(color: Colors.black)),
                    style: ElevatedButton.styleFrom(
                      primary: Color(0xF5F6F0F0),
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        side: BorderSide(color: Colors.grey, width: 2),
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 20),
                Container(
                  width: 160,
                  height: 160,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      if (isCustomer) {
                        // Perform the action for "Upload Banner" here
                      } else {
                        // Perform the action for "Review Consultant Registration" here
                      }
                    },
                    icon: Icon(
                      isCustomer ? Icons.file_upload : Icons.rate_review,
                      color: Colors.black,
                    ),
                    label: Text(
                      isCustomer ? 'Upload Banner' : 'Review Consultant Registration',
                      style: TextStyle(color: Colors.black),
                    ),
                    style: ElevatedButton.styleFrom(
                      primary: Color(0xF5F6F0F0),
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        side: BorderSide(color: Colors.grey, width: 2),
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
