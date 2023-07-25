import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'BoosterPackage.dart';

class BoosterPackagesPage extends StatefulWidget {
  @override
  _BoosterPackagesPageState createState() => _BoosterPackagesPageState();
}

class _BoosterPackagesPageState extends State<BoosterPackagesPage> {
  List<BoosterPackage> currentlySigningPackages = [];
  List<BoosterPackage> availableBoosterPackages = [];

  @override
  void initState() {
    super.initState();
    _fetchPackages();
  }

  Future<void> _fetchPackages() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        final userDoc = await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .collection('booster_packages')
            .doc('KMskalFmJV9YyJiIvItV')
            .get();

        // Clear the lists before updating them
        currentlySigningPackages.clear();
        availableBoosterPackages.clear();

        // Update the lists based on the retrieved data
        Map<String, dynamic> data = userDoc.data() as Map<String, dynamic>;
        data.forEach((key, value) {
          if (value is List && value.length == 2) {
            String packageName = value[0];
            bool isAvailable = value[1];

            BoosterPackage package = BoosterPackage(packageName, isAvailable);

            if (isAvailable) {
              currentlySigningPackages.add(package);
            } else {
              availableBoosterPackages.add(package);
            }
          }
        });

        // Debug print statements to check the data
        print('currentlySigningPackages: $currentlySigningPackages');
        print('availableBoosterPackages: $availableBoosterPackages');

        // Call setState to rebuild the UI with the updated lists
        setState(() {});
      }
    } catch (error) {
      print('Error fetching packages: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Booster Package"),
        backgroundColor: Colors.teal,
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
        child: ListView.builder(
          itemCount:
              2, // Number of sections (currentlySigningPackages and availableBoosterPackages)
          itemBuilder: (context, index) {
            if (index == 0) {
              return _buildPackageList(
                "Currently Signing Packages",
                currentlySigningPackages,
              );
            } else {
              return _buildPackageList(
                "Available Booster Packages",
                availableBoosterPackages,
              );
            }
          },
        ),
      ),
    );
  }

  Widget _buildPackageList(String title, List<BoosterPackage> packages) {
    return Card(
      margin: EdgeInsets.all(8.0),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              title,
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
          Divider(),
          ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: packages.length,
            itemBuilder: (context, index) {
              final package = packages[index];
              return ListTile(
                leading: Icon(
                  package.isSubscribed ? Icons.check_circle : Icons.add,
                  color: package.isSubscribed ? Colors.green : Colors.orange,
                ),
                title: Text(package.name),
                onTap: () {
                  if (package.isSubscribed) {
                    _showSubscriptionMessage();
                  } else {
                    _showConfirmationDialog(
                        context, package); // Pass context and package
                  }
                },
              );
            },
          ),
        ],
      ),
    );
  }

  void _showConfirmationDialog(BuildContext context, BoosterPackage package) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Confirm Subscription'),
          content: Text('Do you want to subscribe to ${package.name}?'),
          actions: <Widget>[
            TextButton(
              child: Text('No'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Yes'),
              onPressed: () async {
                try {
                  // Move the package from available to current
                  setState(() {
                    package.isSubscribed = true;
                    availableBoosterPackages.remove(package);
                    currentlySigningPackages.add(package);
                  });

                  // Update the package in Firestore
                  final user = FirebaseAuth.instance.currentUser;
                  if (user != null) {
                    final packageDocRef = FirebaseFirestore.instance
                        .collection('users')
                        .doc(user.uid)
                        .collection('booster_packages')
                        .doc('KMskalFmJV9YyJiIvItV');

                    // Update the 'isAvailable' value to true in the package array
                    await packageDocRef.update({
                      package.name: [package.name, true],
                    });
                  }

                  Navigator.of(context).pop();
                } catch (error) {
                  print('Error updating package: $error');
                  _showErrorDialog();
                }
              },
            ),
          ],
        );
      },
    );
  }

  void _showErrorDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Error'),
          content: Text('An error occurred. Please try again later.'),
          actions: <Widget>[
            TextButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _showSubscriptionMessage() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Already Subscribed'),
          content: Text('You are already subscribed to this package.'),
          actions: <Widget>[
            TextButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
