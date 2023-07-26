import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'agent.dart';
import '../login.dart';
 // Import the login page

class RegisterAgentPage extends StatefulWidget {
  const RegisterAgentPage({Key? key}) : super(key: key);

  @override
  _RegisterAgentPageState createState() => _RegisterAgentPageState();
}

class _RegisterAgentPageState extends State<RegisterAgentPage> {
  final TextEditingController idController = TextEditingController();
  final TextEditingController codeController = TextEditingController();
  final TextEditingController agencyController = TextEditingController();

  void _registerAgent() {
    final String id = idController.text.trim();
    final String code = codeController.text.trim();
    final String agency = agencyController.text.trim();

    // Check if all fields are filled
    if (id.isEmpty || code.isEmpty || agency.isEmpty) {
      _showSnackBar('Please fill all fields.');
      return;
    }

    // Store the data in Firestore database
    FirebaseFirestore.instance.collection('agents').add({
      'id': id,
      'code': code,
      'agency': agency,
    }).then((_) {
      // Clear the text fields after successful registration
      idController.clear();
      codeController.clear();
      agencyController.clear();
      _showSnackBar('Agent registered successfully!');

      // Navigate to the agent page after successful registration
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => Agent(),
        ),
      );
    }).catchError((error) {
      _showSnackBar('Failed to register agent: $error');
    });
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: Duration(seconds: 2),
      ),
    );
  }

  void _logout() {
    // Navigate back to the login page
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => LoginPage(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Registration'),
        backgroundColor: Colors.teal,
        actions: [
          IconButton(
            onPressed: _logout,
            icon: Icon(Icons.logout),
          ),
        ],
      ),
      body: Container(
        color: Colors.teal,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(height: 20),
              Text(
                'Consultant Registration',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 30),
              TextFormField(
                controller: idController,
                style: TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  labelText: 'National ID',
                  labelStyle: TextStyle(color: Colors.white),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              SizedBox(height: 10),
              TextFormField(
                controller: codeController,
                style: TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  labelText: 'Consultant Code',
                  labelStyle: TextStyle(color: Colors.white),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              SizedBox(height: 10),
              TextFormField(
                controller: agencyController,
                style: TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  labelText: 'Agency',
                  labelStyle: TextStyle(color: Colors.white),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _registerAgent,
                style: ElevatedButton.styleFrom(
                  primary: Colors.white,
                  padding: EdgeInsets.symmetric(vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: Text('Register', style: TextStyle(color: Colors.teal)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: RegisterAgentPage(),
  ));
}
