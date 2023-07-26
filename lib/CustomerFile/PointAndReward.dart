import 'package:flutter/material.dart';

class PointAndRewardPage extends StatefulWidget {
  @override
  _PointAndRewardPageState createState() => _PointAndRewardPageState();
}

class _PointAndRewardPageState extends State<PointAndRewardPage> {
  int _availablePoints = 1000; // Sample available points for the customer
  int _pendingPoints = 1000; // Sample pending points for the customer

  List<RedeemableItem> _redeemableItems = [
    RedeemableItem('RM10 Cash', 500),
    RedeemableItem('RM20 Cash', 900),
    RedeemableItem('RM50 Cash', 2000),
  ];

  void _deductPoints(int pointsToDeduct) {
    if (_availablePoints >= pointsToDeduct) {
      setState(() {
        _availablePoints -= pointsToDeduct;
      });
      _showRedeemSuccessDialog();
    } else {
      _showNotEnoughPointsDialog();
    }
  }

  void _showRedeemSuccessDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Redeem Success'),
          content: Text('You have successfully redeemed the item.'),
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

  void _showNotEnoughPointsDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Not Enough Points'),
          content: Text('You do not have enough points to redeem this item.'),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Point and Reward'),
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
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Available Points: $_availablePoints',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              Text(
                'Pending Points: $_pendingPoints',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 16),
              Text(
                'Redeemable Items:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: _redeemableItems.length,
                  itemBuilder: (context, index) {
                    final item = _redeemableItems[index];
                    return RedeemableItemCard(
                      itemName: item.name,
                      pointsRequired: item.pointsRequired,
                      onRedeemPressed: () {
                        _deductPoints(item.pointsRequired);
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class RedeemableItem {
  final String name;
  final int pointsRequired;

  RedeemableItem(this.name, this.pointsRequired);
}

class RedeemableItemCard extends StatelessWidget {
  final String itemName;
  final int pointsRequired;
  final VoidCallback onRedeemPressed;

  RedeemableItemCard({
    required this.itemName,
    required this.pointsRequired,
    required this.onRedeemPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 8.0),
      child: ListTile(
        title: Text(itemName),
        subtitle: Text('Points required: $pointsRequired'),
        trailing: ElevatedButton(
          onPressed: onRedeemPressed,
          child: Text('Redeem'),
        ),
      ),
    );
  }
}
