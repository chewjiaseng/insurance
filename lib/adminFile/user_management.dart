import 'package:flutter/material.dart';

class UserManagementPage extends StatelessWidget {
  final Map<String, dynamic> user;

  UserManagementPage({required this.user});

  @override
  Widget build(BuildContext context) {
    // Implement the user management UI for the specific user here
    // You can access user details using this.user
    return Scaffold(
      appBar: AppBar(
        title: Text('User Management'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('User Management for ${user['name']}'),
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
                      // Perform the action for "Assign Role" here
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
                // Review Consultant Registration Button
                Container(
                  width: 160,
                  height: 160,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      // Perform the action for "Review Consultant Registration" here
                    },
                    icon: Icon(Icons.rate_review, color: Colors.black),
                    label: Text('Review Consultant Registration', style: TextStyle(color: Colors.black)),
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
