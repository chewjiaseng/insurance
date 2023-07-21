import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

class UserManagementPage extends StatelessWidget {
  final Map<String, dynamic> user;

  UserManagementPage({required this.user});

  // Function to assign a role to the user
  void assignRole(String role, BuildContext context) {
    // Handle null 'rool' value
    String updatedRole = role != null ? role : ''; // Provide a default empty string if 'role' is null

    // Update the 'rool' field in the database for the user
    FirebaseDatabase.instance
        .reference()
        .child('users')
        .child(user['userId'])
        .update({'rool': updatedRole}).then((_) {
      // Show a success message to the admin
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
    }).catchError((error) {
      // Show an error message to the admin
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
    });
  }

void toggleBlockUser(bool blocked, BuildContext context) {
  try {
    // Update the 'blocked' field in the database for the user
    FirebaseDatabase.instance
        .reference()
        .child('users')
        .child(user['userId'])
        .update({'blocked': blocked}).then((_) {
      // Show a success message to the admin
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Success'),
          content: Text(
            blocked ? 'User blocked successfully.' : 'User unblocked successfully.',
          ),
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
    }).catchError((error) {
      // Show an error message to the admin
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
    });
  } catch (e) {
    // Print or handle the error
    print('Error updating blocked status: $e');
  }
}



  @override
  Widget build(BuildContext context) {
    bool isCustomer = user['rool'] == 'customer'; // Use 'rool' instead of 'role' based on your database structure

    return Scaffold(
      appBar: AppBar(
        title: Text('User Management'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // User's Profile with Placeholder (Using FadeInImage)
            CircleAvatar(
              radius: 50,
              backgroundImage: user['profileImageUrl'] != null
                  ? NetworkImage(user['profileImageUrl']!) as ImageProvider<Object>?
                  : null, // Use null to show the system default icon
              child: user['profileImageUrl'] == null
                  ? Icon(
                      Icons.person,
                      size: 50,
                      color: Colors.white,
                    )
                  : null, // Hide the child widget when the profileImageUrl is not null
            ),
            SizedBox(height: 10),
            // User's Name
            Text(
              '${user['name'] ?? 'Unknown User'}',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Assign Role Button
                Container(
                  width: 160,
                  height: 160,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      // Show a dialog to select the role to assign
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
                                  Navigator.pop(context); // Close the dialog after role assignment
                                },
                                child: Text('Admin'),
                              ),
                              ElevatedButton(
                                onPressed: () {
                                  assignRole('customer', context);
                                  Navigator.pop(context); // Close the dialog after role assignment
                                },
                                child: Text('Customer'),
                              ),
                              ElevatedButton(
                                onPressed: () {
                                  assignRole('consultant', context);
                                  Navigator.pop(context); // Close the dialog after role assignment
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
                      primary: Color(0xF5F6F0F0), // Set the button color to transparent
                      elevation: 0, // Disable the button elevation/shadow
                      shape: RoundedRectangleBorder(
                        side: BorderSide(color: Colors.grey, width: 2),
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 20),
                // View Activity Logs Button
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
                      primary: Color(0xF5F6F0F0), // Set the button color to transparent
                      elevation: 0, // Disable the button elevation/shadow
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
                // Block User Button
                Container(
                  width: 160,
                  height: 160,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      // Perform the action for "Block User" here
                      bool currentlyBlocked = user['blocked'] ?? false; // Get the current blocked status from the database
                      toggleBlockUser(!currentlyBlocked, context); // Toggle the blocked status (block/unblock user)
                    },
                    icon: Icon(Icons.block, color: Colors.black),
                    label: Text('Block User', style: TextStyle(color: Colors.black)),
                    style: ElevatedButton.styleFrom(
                      primary: Color(0xF5F6F0F0), // Set the button color to transparent
                      elevation: 0, // Disable the button elevation/shadow
                      shape: RoundedRectangleBorder(
                        side: BorderSide(color: Colors.grey, width: 2),
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 20),
                // Review Consultant Registration / Upload Banner Button
                Container(
                  width: 160,
                  height: 160,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      // Perform the action based on the user's role
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
                      primary: Color(0xF5F6F0F0), // Set the button color to transparent
                      elevation: 0, // Disable the button elevation/shadow
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
