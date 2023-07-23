import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../login.dart';
import 'ShareAppsPage.dart'; // Import the ShareAppsPage class
import 'ViewCustomersPage.dart'; //Import the ViewCustomersPage class
import 'ViewPolicyAvailable.dart'; // Import the ViewPolicyPage class

class Agent extends StatefulWidget {
  const Agent({Key? key});

  @override
  State<Agent> createState() => _AgentState();
}

class _AgentState extends State<Agent> {
  String _consultantName = ''; // Store the consultant's name

  @override
  void initState() {
    super.initState();
    _getConsultantName(); // Get the consultant's name when the widget initializes
  }

  Future<void> _getConsultantName() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      // If user is logged in, retrieve the consultant's name from Firestore
      var snapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();
      setState(() {
        _consultantName = snapshot.get('consultantName');
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Consultant"),
        actions: [
          IconButton(
            onPressed: () {
              logout(context);
            },
            icon: Icon(
              Icons.logout,
            ),
          )
        ],
      ),
      body: Stack(
        children: [
          Image.asset(
            'assets/images/consultantbg.png', // Background image path
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            fit: BoxFit.cover,
          ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircleAvatar(
                  // Display profile picture here if available
                  // Replace this with the actual profile picture
                  radius: 50,
                  backgroundColor: Colors.grey,
                  child: Icon(
                    Icons.person,
                    size: 60,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  _consultantName, // Display the consultant's name here
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 20),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: GridView.count(
                      crossAxisCount: 2,
                      mainAxisSpacing: 20,
                      crossAxisSpacing: 20,
                      children: [
                        ElevatedButton.icon(
                          onPressed: () {
                            // Navigate to the ViewCustomersPage with the role "customer"
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const ViewCustomersPage(
                                  roleToRetrieve: 'customer',
                                ),
                              ),
                            );
                          },
                          icon: Icon(Icons.person, color: Colors.black),
                          label: Text('View Customers',
                              style: TextStyle(color: Colors.black)),
                          style: ElevatedButton.styleFrom(
                            minimumSize: Size(160, 60),
                            primary: Color(0xF5F6F0F0),
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              side: BorderSide(color: Colors.grey, width: 2),
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                        ElevatedButton.icon(
                          onPressed: () {
                            // Navigate to the ViewPolicyAvailable page
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ViewPolicyAvailable(),
                              ),
                            );
                          },
                          icon: Icon(Icons.policy, color: Colors.black),
                          label: Text('View Policies Company',
                              style: TextStyle(color: Colors.black)),
                          style: ElevatedButton.styleFrom(
                            minimumSize: Size(160, 60),
                            primary: Color(0xF5F6F0F0),
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              side: BorderSide(color: Colors.grey, width: 2),
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                        ElevatedButton.icon(
                          onPressed: () {
                            // TODO: Implement "View Booster Packages" functionality
                          },
                          icon: Icon(Icons.shopping_bag, color: Colors.black),
                          label: Text('View Reward Point',
                              style: TextStyle(color: Colors.black)),
                          style: ElevatedButton.styleFrom(
                            minimumSize: Size(160, 60),
                            primary: Color(0xF5F6F0F0),
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              side: BorderSide(color: Colors.grey, width: 2),
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                        ElevatedButton.icon(
                          onPressed: () {
                            // Navigate to the ShareAppsPage
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ShareAppsPage(),
                              ),
                            );
                          },
                          icon: Icon(Icons.email, color: Colors.black),
                          label: Text('Share Apps',
                              style: TextStyle(color: Colors.black)),
                          style: ElevatedButton.styleFrom(
                            minimumSize: Size(160, 60),
                            primary: Color(0xF5F6F0F0),
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              side: BorderSide(color: Colors.grey, width: 2),
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> logout(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => LoginPage(),
      ),
    );
  }
}
