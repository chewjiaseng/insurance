import 'package:flutter/material.dart';
import 'DisplayOldPolicyPage.dart';
import 'DisplayNewPolicyPage.dart';
import 'DisplayPolicyStatusPage.dart';

class ViewPolicyPage extends StatelessWidget {
  final Map<String, dynamic> customerData;

  ViewPolicyPage({required this.customerData});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Booster Package'),
        backgroundColor: Colors.teal, // Set app bar color
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.teal,
              Colors.teal.shade200,
              Colors.white,
            ],
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => DisplayOldPolicyPage(
                        imageAssetPath: 'assets/images/OldPolicy.jpg',
                      ),
                    ),
                  );
                },
                child: Text('Old Policy'),
                style: ElevatedButton.styleFrom(
                  minimumSize: Size(240, 80),
                  primary: Colors.teal,
                  textStyle: TextStyle(fontSize: 18),
                ),
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => DisplayNewPolicyPage(
                        imageAssetPath: 'assets/images/NewPolicy.jpg',
                      ),
                    ),
                  );
                },
                child: Text('New Policy'),
                style: ElevatedButton.styleFrom(
                  minimumSize: Size(240, 80),
                  primary: Colors.teal,
                  textStyle: TextStyle(fontSize: 18),
                ),
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => DisplayPolicyStatusPage(
                        imageAssetPath: 'assets/images/PolicyStatus1.jpg',
                      ),
                    ),
                  );
                },
                child: Text('Policy Status'),
                style: ElevatedButton.styleFrom(
                  minimumSize: Size(240, 80),
                  primary: Colors.teal,
                  textStyle: TextStyle(fontSize: 18),
                ),
              ),
              SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}
