import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:geolocator/geolocator.dart';
import 'package:donordash/services/auth_service.dart';

import '../../utils/basescreen.dart';

class PostHospitalRequestScreen extends StatefulWidget {
  @override
  _PostHospitalRequestScreenState createState() => _PostHospitalRequestScreenState();
}

class _PostHospitalRequestScreenState extends State<PostHospitalRequestScreen> {
  final _formKey = GlobalKey<FormState>();
  final AuthService _authService = AuthService();
  String? patientName, bloodType, description;
  double urgency = 0;
  Position? location;
  bool _isLoading = false;

  final List<String> bloodTypes = ['A+', 'A-', 'B+', 'B-', 'O+', 'O-', 'AB+', 'AB-'];

  @override
  Widget build(BuildContext context) {
    return BaseScreen(
      title: 'Request Blood',
      authService: _authService,
      showBackButton: true,
      body: Padding(
        padding: EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SizedBox(height: 20),
                // Patient Name
                TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Patient Name',
                    prefixIcon: Icon(Icons.person, color: Color(0xFFFF5F6D)),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    filled: true,
                    fillColor: Colors.grey.shade100,
                  ),
                  onChanged: (val) => patientName = val.trim(),
                  validator: (val) => val!.isEmpty ? 'Enter patient name' : null,
                ),
                SizedBox(height: 16),
                // Blood Type
                DropdownButtonFormField<String>(
                  value: bloodType,
                  items: bloodTypes
                      .map((type) => DropdownMenuItem(value: type, child: Text(type)))
                      .toList(),
                  onChanged: (val) => setState(() => bloodType = val),
                  decoration: InputDecoration(
                    labelText: 'Blood Type',
                    prefixIcon: Icon(Icons.bloodtype, color: Color(0xFFFF5F6D)),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    filled: true,
                    fillColor: Colors.grey.shade100,
                  ),
                  validator: (val) => val == null ? 'Select a blood type' : null,
                ),
                SizedBox(height: 16),
                // Urgency Slider
                Text(
                  'Urgency: ${urgency.toInt()}/10',
                  style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF444444)),
                ),
                Slider(
                  value: urgency,
                  min: 0,
                  max: 10,
                  divisions: 10,
                  activeColor: Color(0xFFFF5F6D), // Red from gradient
                  onChanged: (val) => setState(() => urgency = val),
                ),
                SizedBox(height: 16),
                // Description
                TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Description (e.g., condition)',
                    prefixIcon: Icon(Icons.description, color: Color(0xFFFF5F6D)),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    filled: true,
                    fillColor: Colors.grey.shade100,
                  ),
                  maxLines: 3,
                  onChanged: (val) => description = val.trim(),
                  validator: (val) => val!.isEmpty ? 'Enter a description' : null,
                ),
                SizedBox(height: 30),
                // Submit Button
                _isLoading
                    ? Center(child: CircularProgressIndicator())
                    : ElevatedButton(
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      setState(() => _isLoading = true);
                      try {
                        location = await Geolocator.getCurrentPosition(
                            desiredAccuracy: LocationAccuracy.high);
                        await FirebaseFirestore.instance.collection('hospital_requests').add({
                          'patient_name': patientName,
                          'blood_type': bloodType,
                          'location': GeoPoint(location!.latitude, location!.longitude),
                          'urgency': urgency,
                          'description': description,
                          'hospital_id': FirebaseAuth.instance.currentUser!.uid,
                          'timestamp': FieldValue.serverTimestamp(),
                        });
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Request Submitted!')),
                        );
                        Navigator.pop(context);
                      } catch (e) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text(e.toString())),
                        );
                      }
                      setState(() => _isLoading = false);
                    }
                  },
                  child: Text('Submit Request'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFFFF5F6D), // Red from gradient
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}