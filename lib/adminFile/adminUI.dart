import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:insuranceapp/adminFile/edit_user.dart';
import 'package:insuranceapp/adminFile/terms_and_conditions.dart';
import 'package:insuranceapp/adminFile/reward_request.dart';
// Import other files for additional functionalities here

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
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/insurancebg.png"), // Replace with the actual image path
            fit: BoxFit.cover,
          ),
        ),
        child: Padding(
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
                    color: Color.fromRGBO(122, 135, 177, 0.961),
                    border: Border.all(color: Color.fromRGBO(41, 45, 86, 1), width: 2),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    children: [
                      Text(
                        'Hi, Admin',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(height: 8),
                      Opacity(
                        opacity: 0.7, // Set the desired opacity value
                        child: Text(
                          'Welcome to the admin panel',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.white,
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
                          primary: Color.fromRGBO(255, 250, 250, 0.925), // Set the button color to transparent
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
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => TermsAndConditionsPage(),
                            ),
                          );
                        },
                        icon: Icon(Icons.upload_file, color: Colors.black),
                        label: Text('Upload term & condition', style: TextStyle(color: Colors.black)),
                        style: ElevatedButton.styleFrom(
                          minimumSize: buttonSize, // Set the minimum button size
                          primary: Color.fromRGBO(243, 241, 241, 1), // Set the button color to transparent
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
                    // Navigate to the RewardRequestPage when "Reward Requests" button is clicked
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => RewardRequestPage(),
                      ),
                    );
                  },
                    icon: Icon(Icons.star_rate, color: Colors.black),
                    label: Text('Reward Requests', style: TextStyle(color: Colors.black)),
                    style: ElevatedButton.styleFrom(
                      minimumSize: buttonSize, // Set the minimum button size
                      primary: Color.fromRGBO(248, 241, 241, 1), // Set the button color to transparent
                      elevation: 0, // Disable the button elevation/shadow
                      shape: RoundedRectangleBorder(
                        side: BorderSide(color: Colors.grey, width: 2),
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 20),
                // Add more buttons for other functionalities here

              ],
            ),
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
