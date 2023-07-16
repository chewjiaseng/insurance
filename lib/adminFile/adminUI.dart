import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:insuranceapp/adminFile/edit_user.dart';

import '../login.dart';

class AdminPage extends StatefulWidget {
  const AdminPage();

  @override
  State<AdminPage> createState() => _AdminPageState();
}

class _AdminPageState extends State<AdminPage> {
  @override
  Widget build(BuildContext context) {
    final buttonSize = Size(120, 120); // Set the desired button size
    final wrapperSize = Size(300, 150); // Set the desired wrapper size
    final wrapperPadding = EdgeInsets.all(16.0); // Set the desired padding for the wrapper

    return Scaffold(
      appBar: AppBar(
        title: Text("Admin"),
        actions: [
          IconButton(
            onPressed: () {
              logout();
            },
            icon: Icon(
              Icons.logout,
            ),
          )
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0), // Add padding to create space between the wrapper and screen edges
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: wrapperSize.width,
                height: wrapperSize.height,
                padding: wrapperPadding,
                decoration: BoxDecoration(
                  color: Colors.transparent,
                  border: Border.all(color: Colors.brown, width: 2),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  children: [
                    Text(
                      'Hi, Admin',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    SizedBox(height: 8),
                    Opacity(
                      opacity: 0.7, // Set the desired opacity value
                      child: Text(
                        'Welcome to the admin panel',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: buttonSize.width,
                    height: buttonSize.height,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => EditUserPage(),
                          ),
                        );
                      },
                      icon: Icon(Icons.edit, color: Colors.black),
                      label: Text('Edit User', style: TextStyle(color: Colors.black)),
                      style: ElevatedButton.styleFrom(
                        minimumSize: buttonSize, // Set the minimum button size
                        primary: Colors.transparent, // Set the button color to transparent
                        elevation: 0, // Disable the button elevation/shadow
                        shape: RoundedRectangleBorder(
                          side: BorderSide(color: Colors.grey, width: 2),
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),

                  ),
                  SizedBox(width: 20),
                  Container(
                    width: buttonSize.width,
                    height: buttonSize.height,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        // Perform the action for "Upload Policy" here
                      },
                      icon: Icon(Icons.upload_file, color: Colors.black),
                      label: Text('Upload Policy', style: TextStyle(color: Colors.black)),
                      style: ElevatedButton.styleFrom(
                        minimumSize: buttonSize, // Set the minimum button size
                        primary: Colors.transparent, // Set the button color to transparent
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
              Container(
                width: buttonSize.width,
                height: buttonSize.height,
                child: ElevatedButton.icon(
                  onPressed: () {
                    // Perform the action for "Edit Package" here
                  },
                  icon: Icon(Icons.edit_attributes, color: Colors.black),
                  label: Text('Edit Package', style: TextStyle(color: Colors.black)),
                  style: ElevatedButton.styleFrom(
                    minimumSize: buttonSize, // Set the minimum button size
                    primary: Colors.transparent, // Set the button color to transparent
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
        ),
      ),
    );
  }

  Future<void> logout() async {
    await FirebaseAuth.instance.signOut();
    navigateToLoginPage();
  }

  void navigateToLoginPage() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => LoginPage(),
      ),
    );
  }
}
