import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../utils/constants.dart';

class ViewShortagesScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Hospital Shortages'),
        centerTitle: true,
      ),
      body: Container(
        color: AppConstants.secondaryColor, // Cream background
        padding: EdgeInsets.all(16.0),
        child: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance.collection('shortages').snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Center(
                child: Text(
                  'Error: ${snapshot.error}',
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
              );
            }
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            }
            if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
              return Center(
                child: Text(
                  'No hospital shortages found.',
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
              );
            }

            return ListView.builder(
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (context, index) {
                var shortage = snapshot.data!.docs[index];
                String bloodType = shortage['blood_type'];
                int quantity = shortage['quantity'];
                String hospitalId = shortage['hospital_id'];
                Timestamp timestamp = shortage['timestamp'];

                return Card(
                  color: Colors.white, // White card on cream background
                  elevation: 2,
                  margin: EdgeInsets.symmetric(vertical: 8.0),
                  child: ListTile(
                    title: Text(
                      'Blood Type: $bloodType',
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Quantity Needed: $quantity units'),
                        Text('Hospital ID: $hospitalId'),
                        Text('Posted: ${timestamp.toDate().toString().substring(0, 16)}'),
                      ],
                    ),
                    trailing: Icon(
                      Icons.bloodtype,
                      color: AppConstants.primaryColor, // Red icon
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}