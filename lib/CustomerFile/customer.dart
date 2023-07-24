import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../login.dart'; // Replace this with the path to your login page if necessary

class Customer extends StatefulWidget {
  const Customer({Key? key});

  @override
  State<Customer> createState() => _CustomerState();
}

class _CustomerState extends State<Customer> {
  late String _userName;
  late String _profileImageUrl = 'assets/images/default_profile_image.png'; // Default image

  @override
  void initState() {
    super.initState();
    _fetchUserData();
  }

  Future<void> _fetchUserData() async {
    try {
      // Get the current user ID from FirebaseAuth
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        // Fetch the user document from Firestore using the user ID
        final userDoc =
            await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
        if (userDoc.exists) {
          // Get the user's real name and profile image URL from the document data
          setState(() {
            _userName = userDoc['name'];
            _profileImageUrl = userDoc['profileImageUrl'] ?? 'assets/images/default_profile_image.png';
          });
        }
      }
    } catch (error) {
      print('Error fetching user data: $error');
    }
  }

  // Load profile image based on the URL's prefix
  Widget _loadProfileImage() {
    if (_profileImageUrl.startsWith('http')) {
      return Image.network(
        _profileImageUrl,
        width: 500,
        height: 200,
        fit: BoxFit.cover,
      );
    } else {
      return Image.asset(
        _profileImageUrl,
        width: 150,
        height: 100,
        fit: BoxFit.cover,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Customer"),
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
            'assets/images/customerbg.png', // Background image path
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            fit: BoxFit.cover,
          ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Stack(
                  alignment: Alignment.center,
                  children: [
                    Container(
                      width: 500,
                      height: 200,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.transparent,
                        // Add a transparent color when no profile image is available
                      ),
                      child: _loadProfileImage(),
                    ),
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
                  ],
                ),
                SizedBox(height: 10),
                Text(
                  _userName ?? 'Unknown User',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
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
                            // TODO: Implement "Invite Friends" functionality
                          },
                          icon: Icon(Icons.person_add, color: Colors.black),
                          label: Text('Invite Friends', style: TextStyle(color: Colors.black)),
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
                            // TODO: Implement "Upload Policy" functionality
                          },
                          icon: Icon(Icons.upload_file, color: Colors.black),
                          label: Text('Upload Policy', style: TextStyle(color: Colors.black)),
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
                            // TODO: Implement "Booster Package" functionality
                          },
                          icon: Icon(Icons.shopping_bag, color: Colors.black),
                          label: Text('Booster Package', style: TextStyle(color: Colors.black)),
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
                            // TODO: Implement "Point & Reward" functionality
                          },
                          icon: Icon(Icons.star, color: Colors.black),
                          label: Text('Point & Reward', style: TextStyle(color: Colors.black)),
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
