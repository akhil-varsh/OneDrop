import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:donordash/services/auth_service.dart';

import '../../utils/basescreen.dart';

class ViewHospitalRequestsScreen extends StatelessWidget {
  final AuthService _authService = AuthService();

  @override
  Widget build(BuildContext context) {
    final String hospitalId = FirebaseAuth.instance.currentUser!.uid;

    return BaseScreen(
      title: 'Patient Blood Requests',
      authService: _authService,
      showBackButton: true,
      body: Padding(
        padding: EdgeInsets.all(20.0),
        child: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection('hospital_requests')
              .where('hospital_id', isEqualTo: hospitalId)
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}', style: TextStyle(color: Color(0xFF444444))));
            }
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            }
            if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
              return Center(child: Text('No requests found.', style: TextStyle(color: Color(0xFF444444))));
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
                        Text('Description: $description', style: TextStyle(fontStyle: FontStyle.italic, color: Colors.grey.shade600)),
                        Text('Requested: ${timestamp.toDate().toString().substring(0, 16)}'),
                        SizedBox(height: 12),
                        // Donors List
                        StreamBuilder<QuerySnapshot>(
                          stream: FirebaseFirestore.instance
                              .collection('hospital_requests')
                              .doc(requestId)
                              .collection('donors')
                              .snapshots(),
                          builder: (context, donorSnapshot) {
                            if (donorSnapshot.hasError) {
                              return Text('Error loading donors', style: TextStyle(color: Colors.red));
                            }
                            if (donorSnapshot.connectionState == ConnectionState.waiting) {
                              return Text('Loading donors...', style: TextStyle(color: Color(0xFF444444)));
                            }
                            if (!donorSnapshot.hasData || donorSnapshot.data!.docs.isEmpty) {
                              return Text('No donors yet.', style: TextStyle(color: Colors.grey.shade600));
                            }

                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Willing Donors:', style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF444444))),
                                SizedBox(height: 8),
                                ...donorSnapshot.data!.docs.map((donor) {
                                  String username = donor['username'];
                                  return Text('- $username', style: TextStyle(color: Color(0xFF444444)));
                                }).toList(),
                              ],
                            );
                          },
                        ),
                        SizedBox(height: 12),
                        Align(
                          alignment: Alignment.centerRight,
                          child: ElevatedButton(
                            onPressed: () => _confirmDelete(context, requestId),
                            child: Text('Delete Request'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.redAccent,
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

  void _confirmDelete(BuildContext context, String requestId) {
    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: Text('Delete Request'),
          content: Text('Are you sure you want to delete this request?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                await FirebaseFirestore.instance.collection('hospital_requests').doc(requestId).delete();
                Navigator.pop(dialogContext);
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Request deleted.')));
              },
              child: Text('Delete', style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }
}