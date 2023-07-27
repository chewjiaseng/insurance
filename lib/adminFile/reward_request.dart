import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class RewardRequestPage extends StatefulWidget {
  @override
  _RewardRequestPageState createState() => _RewardRequestPageState();
}

class _RewardRequestPageState extends State<RewardRequestPage> {
  List<Map<String, dynamic>> _rewardRequests = [];

  @override
  void initState() {
    super.initState();
    _fetchRewardRequests();
  }

  void _fetchRewardRequests() async {
    final querySnapshot = await FirebaseFirestore.instance.collection('users').where('rool', isEqualTo: 'customer').get();
    setState(() {
      _rewardRequests = querySnapshot.docs.map((doc) => doc.data()).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Reward Requests'),
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/edituser.png"), // Replace with the actual image path
            fit: BoxFit.cover,
          ),
        ),
        child: _rewardRequests.isNotEmpty
            ? ListView.builder(
                itemCount: _rewardRequests.length,
                itemBuilder: (context, index) {
                  final request = _rewardRequests[index];
                  final name = request['name'];
                  final role = request['rool'];
                  final pendingPoints = request['pendingPoint'];

                  return Dismissible(
                    key: UniqueKey(),
                    onDismissed: (direction) {
                      setState(() {
                        _rewardRequests.removeAt(index);
                      });
                    },
                    child: Card(
                      color: Colors.blue.shade100, // Set the background color of the container
                      margin: EdgeInsets.all(16.0),
                      elevation: 4,
                      child: Container(
                        padding: EdgeInsets.all(16.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Name: $name', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Color.fromRGBO(65, 16, 165, 1))), // Update text style
                                  SizedBox(height: 8),
                                  Text('Role: $role', style: TextStyle(color: Color.fromRGBO(42, 51, 132, 1))), // Update text style
                                  SizedBox(height: 8),
                                  Text('Pending Points: $pendingPoints', style: TextStyle(fontWeight: FontWeight.bold,color: Color(0xFF020C53))), // Update text style
                                ],
                              ),
                            ),
                            Row(
                              children: [
                                ElevatedButton(
                                  onPressed: () {
                                    setState(() {
                                      _rewardRequests.removeAt(index);
                                    });
                                  },
                                  child: Text('Approve'),
                                  style: ElevatedButton.styleFrom(
                                    primary: Colors.green,
                                    onPrimary: Colors.black,
                                  ),
                                ),
                                SizedBox(width: 8),
                                ElevatedButton(
                                  onPressed: () {
                                    setState(() {
                                      _rewardRequests.removeAt(index);
                                    });
                                  },
                                  child: Text('Deny'),
                                  style: ElevatedButton.styleFrom(
                                    primary: Colors.red,
                                    onPrimary: Colors.black,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              )
            : Center(child: Text('No reward requests available.')),
      ),
    );
  }
}
