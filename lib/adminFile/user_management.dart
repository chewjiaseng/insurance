import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'activity_logs_page.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';

class UserManagementPage extends StatefulWidget {
  final Map<String, dynamic>? user;

  UserManagementPage({required this.user});

  @override
  _UserManagementPageState createState() => _UserManagementPageState();
}

class _UserManagementPageState extends State<UserManagementPage> {
  
  Future<void> addActivityLog(String userId, String activity) async {
    try {
      // Generate a random ID for the log document
      String logId = FirebaseFirestore.instance.collection('logs').doc().id;

      // Create a map with the log data
      Map<String, dynamic> logData = {
        'userId': userId,
        'activity': activity,
        'timestamp': Timestamp.now(), // Use Firestore's timestamp for the current time
      };

      // Add the log document to the "logs" collection with the generated logId
      await FirebaseFirestore.instance.collection('logs').doc(logId).set(logData);
    } catch (error) {
      print('Error adding activity log: $error');
    }
  }

  Future<void> assignRole(String role) async {
    String updatedRole = role ?? '';

    print('Assigning role: $updatedRole');

    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(widget.user?['userId'])
          .update({'rool': updatedRole});

      // Call the addActivityLog method when the role is assigned/updated
      await addActivityLog(widget.user?['userId'], 'Role Assigned: $updatedRole');

      print('Role assigned successfully');

      // Get the current context of the UserManagementPage
      BuildContext context = this.context;

      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Success'),
          content: Text('Role assigned successfully.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Close the dialog using the correct context
              },
              child: Text('OK'),
            ),
          ],
        ),
      );
    } catch (error) {
      print('Error assigning role: $error');

      // Get the current context of the UserManagementPage
      BuildContext context = this.context;

      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Error'),
          content: Text('Failed to assign role. Please try again.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Close the dialog using the correct context
              },
              child: Text('OK'),
            ),
          ],
        ),
      );
    }
  }

  Future<void> toggleBlockUser(BuildContext context) async {
    String? userId = widget.user?['userId'];

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

      // Call the addActivityLog method when the user is blocked
      await addActivityLog(userId, 'User Blocked');

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

  Future<void> viewActivityLogs(BuildContext context) async {
    String? userId = widget.user?['userId'];

    if (userId == null) {
      print('User ID is null.');
      return;
    }

    print('Fetching activity logs for user with ID: $userId');

    try {
      // Fetch activity logs for the specific user from Firestore
      QuerySnapshot logsSnapshot = await FirebaseFirestore.instance
          .collection('logs')
          .where('userId', isEqualTo: userId)
          .orderBy('timestamp', descending: true)
          .get();

      // Process the logs and navigate to the ActivityLogsPage passing the logs
      List<String> activityLogs = [];
      for (var doc in logsSnapshot.docs) {
        String activity = doc['activity'];
        Timestamp timestamp = doc['timestamp'];
        DateTime dateTime = timestamp.toDate();
        String logMessage = '$activity - ${dateTime.toString()}';
        activityLogs.add(logMessage);
      }

      // Navigate to the ActivityLogsPage and pass the logs as arguments
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ActivityLogsPage(
            userName: widget.user?['name'] ?? 'Unknown User',
            activityLogs: activityLogs,
          ),
        ),
      );
    } catch (error) {
      print('Error fetching activity logs: $error');
      // Display an error message to the user (you can customize this as needed)
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Error'),
          content: Text('Failed to fetch activity logs. Please try again.'),
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

Future<void> uploadBanner(BuildContext context) async {
  final picker = ImagePicker();
  XFile? pickedFile;

  // Allow the user to pick an image from their gallery
  try {
    pickedFile = await picker.pickImage(source: ImageSource.gallery);
  } catch (e) {
    print('Error picking image: $e');
  }

  // If an image is picked, upload it to Firebase Storage
  if (pickedFile != null) {
    File imageFile = File(pickedFile.path);
    String userId = widget.user?['userId'];

    try {
      // Upload the image to Firebase Storage with a unique filename
      String fileName = 'banner_$userId.png';
      Reference storageRef = FirebaseStorage.instance.ref().child(fileName);
      await storageRef.putFile(imageFile);

      // Get the download URL of the uploaded image
      String downloadURL = await storageRef.getDownloadURL();

      // Update the user's profileImageUrl field in Firestore with the download URL
      await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .update({'profileImageUrl': downloadURL});

      // Show a success dialog to the user
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Success'),
          content: Text('Banner uploaded successfully.'),
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
      // Show an error dialog if the upload fails
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Error'),
          content: Text('Failed to upload banner. Please try again.'),
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
      print('Error uploading banner: $error');
    }
  }
}

Future<Map<String, dynamic>> fetchConsultantRegistration(String userId) async {
  try {
    DocumentSnapshot snapshot = await FirebaseFirestore.instance
        .collection('agents') 
        .doc(userId)
        .get();

    if (snapshot.exists) {
      return snapshot.data() as Map<String, dynamic>;
    } else {
      return {};
    }
  } catch (error) {
    print('Error fetching consultant registration: $error');
    return {};
  }
}

void _reviewConsultantRegistration() async {
  try {
    // Fetch the first document in the "agents" collection
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('agents')
        .limit(1)
        .get();

    if (querySnapshot.docs.isNotEmpty) {
      // Get the first document from the query snapshot
      DocumentSnapshot documentSnapshot = querySnapshot.docs.first;

      // Show a dialog with the consultant registration details
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text(
            'Consultant Registration Details',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('National ID:', style: TextStyle(fontWeight: FontWeight.bold, color:Color.fromRGBO(24, 113, 36, 1))),
              Text(documentSnapshot['id'], style: TextStyle(color: Colors.teal)),
              SizedBox(height: 10),
              Text('Agent Code:', style: TextStyle(fontWeight: FontWeight.bold, color:Color.fromRGBO(24, 113, 36, 1))),
              Text(documentSnapshot['code'], style: TextStyle(color: Colors.teal)),
              SizedBox(height: 10),
              Text('Agency:', style: TextStyle(fontWeight: FontWeight.bold, color:Color.fromRGBO(24, 113, 36, 1))),
              Text(documentSnapshot['agency'], style: TextStyle(color: Colors.teal)),
            ],
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(primary: Colors.red),
              child: Text('Disagree'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(primary: Colors.green),
              child: Text('Approve'),
            ),
          ],
        ),
      );
    } else {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Error'),
          content: Text('Consultant registration data not found.'),
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
  } catch (error) {
    print('Error fetching consultant registration: $error');
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Error'),
        content: Text('Failed to fetch consultant registration data. Please try again.'),
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


 @override
  Widget build(BuildContext context) {
    print('User object in UserManagementPage: ${widget.user}'); // Add this line to check the user object

    if (widget.user == null) {
      return Scaffold(
        appBar: AppBar(
          title: Text('Error'),
        ),
        body: Center(
          child: Text('User data not available.'),
        ),
      );
    }

    String? userId = widget.user?['userId'];
    String? role = widget.user?['rool'];
    String? profileImageUrl = widget.user?['profileImageUrl'];
    String? name = widget.user?['name'];

    bool isCustomer = role == 'customer';

    return Scaffold(
      appBar: AppBar(
        title: Text('User Management'),
      ),
      body: Stack(
        // Use Stack to place the background image behind the content
        children: [
          Image.asset(
            'assets/images/User Management.png', // Background image path
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            fit: BoxFit.cover,
          ),
          Column(
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
                                    assignRole('admin');
                                    Navigator.pop(context);
                                  },
                                  child: Text('Admin'),
                                ),
                                ElevatedButton(
                                  onPressed: () {
                                    assignRole('customer');
                                    Navigator.pop(context);
                                  },
                                  child: Text('Customer'),
                                ),
                                ElevatedButton(
                                  onPressed: () {
                                    assignRole('agent');
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
                        viewActivityLogs(context); // Call the method to view activity logs
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
                          uploadBanner(context); // Call the uploadBanner function
                        } else {
                           _reviewConsultantRegistration(); // Call the _reviewConsultantRegistration method
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
        ],
      ),
    );
  }
}