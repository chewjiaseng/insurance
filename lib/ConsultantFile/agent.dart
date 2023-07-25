import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:insuranceapp/ConsultantFile/ViewAvailableBoosterPackage.dart';
import 'package:insuranceapp/ConsultantFile/ViewPolicyPage.dart';

import '../login.dart';
import 'ShareAppsPage.dart'; // Import the ShareAppsPage class
import 'ViewCustomersPage.dart'; //Import the ViewCustomersPage class // Import the ViewPolicyPage class
import 'ViewCustomerRewardPointsPage.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'dart:io';

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
    _showTermsAndConditionsDialog(); // Show the Consultant Terms & Conditions immediately
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

void _showTermsAndConditionsDialog() async {
  print("Entering _showTermsAndConditionsDialog()");

  String role = 'agent';
  final snapshot = await FirebaseFirestore.instance.collection('termsAndConditions').doc(role).get();
  String downloadURL = snapshot['url'];

  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: Text('Hello, Please Read'),
      content: FutureBuilder<String>(
        future: _downloadAndSavePDF(downloadURL),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError || snapshot.data == null) {
            return Text('Error downloading PDF');
          } else {
            return Container(
              height: MediaQuery.of(context).size.height * 0.8, // Set the height as per your requirement
              width: MediaQuery.of(context).size.width * 0.8,   // Set the width as per your requirement
              child: PDFView(
                filePath: snapshot.data!,
              ),
            );
          }
        },
      ),
      actions: [
        ElevatedButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: Text('Agree and do not show again'),
        ),
      ],
    ),
  );
}
  
 Future<String> _downloadAndSavePDF(String downloadURL) async {
    try {
      Directory appDocDir = await getApplicationDocumentsDirectory();
      String appDocPath = appDocDir.path;
      String fileName = 'Consultant_Term_Condition.pdf'; // Adjust filename here
      File pdfFile = File('$appDocPath/$fileName');

      bool fileExists = await pdfFile.exists();
      if (!fileExists) {
        // Download the PDF if it doesn't exist in the app directory
        final pdfData =
            await firebase_storage.FirebaseStorage.instance.refFromURL(downloadURL).getData();
        if (pdfData != null) {
          await pdfFile.writeAsBytes(pdfData.buffer.asUint8List());
        } else {
          print('Failed to download PDF data');
          return '';
        }
      }

      return pdfFile.path;
    } catch (error) {
      print('Error downloading PDF: $error');
      return '';
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
                                builder: (context) => ViewAvailableBoosterPackage(),
                              ),
                            );
                          },
                          icon: Icon(Icons.policy, color: Colors.black),
                          label: Text('View Avaiable Booster Package',
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
                            // Navigate to the ViewCustomersPage with the role "customer"
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const ViewCustomerRewardPointsPage(
                                  roleToRetrieve: 'customer',
                                ),
                              ),
                            );
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
