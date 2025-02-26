import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:donordash/services/auth_service.dart';

import '../../utils/basescreen.dart';

class ViewHospitalRequestsScreen extends StatelessWidget {
  final AuthService _authService = AuthService();

  @override
  Widget build(BuildContext context) {
    return BaseScreen(
      title: 'Hospital Requests',
      authService: _authService,
      showBackButton: true,
      body: Padding(
        padding: EdgeInsets.all(20.0),
        child: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance.collection('hospital_requests').snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}', style: TextStyle(color: Color(0xFF444444))));
            }
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            }
            if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
              return Center(child: Text('No hospital requests found.', style: TextStyle(color: Color(0xFF444444))));
            }

            return ListView.builder(
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (context, index) {
                var request = snapshot.data!.docs[index];
                String requestId = request.id;
                String patientName = request['patient_name'];
                String bloodType = request['blood_type'];
                double urgency = request['urgency'];
                String description = request['description'];
                GeoPoint location = request['location'];
                Timestamp timestamp = request['timestamp'];

                return Card(
                  elevation: 2,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  margin: EdgeInsets.symmetric(vertical: 8.0),
                  child: Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Patient: $patientName', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF444444))),
                        SizedBox(height: 8),
                        Text('Blood Type: $bloodType'),
                        Text('Urgency: ${urgency.toInt()}/10'),
                        Text('Location: (${location.latitude.toStringAsFixed(2)}, ${location.longitude.toStringAsFixed(2)})'),
                        Text('Requested: ${timestamp.toDate().toString().substring(0, 16)}'),
                        SizedBox(height: 8),
                        Text('Description: $description', style: TextStyle(fontStyle: FontStyle.italic, color: Colors.grey.shade600)),
                        SizedBox(height: 12),
                        Align(
                          alignment: Alignment.centerRight,
                          child: ElevatedButton(
                            onPressed: () async {
                              String citizenId = FirebaseAuth.instance.currentUser!.uid;
                              DocumentSnapshot userDoc = await FirebaseFirestore.instance
                                  .collection('users')
                                  .doc(citizenId)
                                  .get();
                              String username = userDoc['username'];

                              await FirebaseFirestore.instance
                                  .collection('hospital_requests')
                                  .doc(requestId)
                                  .collection('donors')
                                  .doc(citizenId)
                                  .set({
                                'citizen_id': citizenId,
                                'username': username,
                                'timestamp': FieldValue.serverTimestamp(),
                              });

                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('Thank you for volunteering to donate!')),
                              );
                            },
                            child: Text('Donate'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Color(0xFFFF5F6D),
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            ),
                          ),
                        ),
                      ],
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