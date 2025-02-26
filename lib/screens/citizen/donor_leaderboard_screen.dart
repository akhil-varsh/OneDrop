import 'package:flutter/material.dart';

class DonorLeaderboardScreen extends StatelessWidget {
  final List<Map<String, dynamic>> donors = [
    {"name": "Alice Johnson", "donations": 15, "emoji": "🥇", "isActive": true},
    {"name": "Bob Smith", "donations": 12, "emoji": "🥈", "isActive": false},
    {"name": "Charlie Brown", "donations": 10, "emoji": "🥉", "isActive": true},
    {"name": "David Lee", "donations": 9, "emoji": "", "isActive": false},
    {"name": "Emma Wilson", "donations": 8, "emoji": "", "isActive": true},
    {"name": "Frank Harris", "donations": 7, "emoji": "", "isActive": false},
    {"name": "Grace Kelly", "donations": 6, "emoji": "", "isActive": true},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('🏆 Donor Leaderboard')),
      body: ListView.builder(
        itemCount: donors.length,
        itemBuilder: (context, index) {
          var donor = donors[index];
          return Card(
            margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: ListTile(
              leading: CircleAvatar(
                child: Text('${index + 1}', style: TextStyle(fontWeight: FontWeight.bold)),
                backgroundColor: Colors.redAccent,
              ),
              title: Text(
                '${donor['emoji']} ${donor['name']}',
                style: TextStyle(fontSize: 18),
                overflow: TextOverflow.ellipsis,
              ),
              subtitle: Text('Donations: ${donor['donations']}'),
              trailing: Icon(Icons.favorite, color: Colors.red),
              onTap: () {
                _showDonorDetailsDialog(context, donor);
              },
            ),
          );
        },
      ),
    );
  }

  void _showDonorDetailsDialog(BuildContext context, Map<String, dynamic> donor) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Donor Details'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Name: ${donor['name']}'),
              Text('Donations: ${donor['donations']}'),
              Text('Status: ${donor['isActive'] ? 'Active' : 'Inactive'}'),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Close'),
            ),
          ],
        );
      },
    );
  }
}
