import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:donordash/services/auth_service.dart';

import '../../utils/basescreen.dart';

class CitizenProfileScreen extends StatefulWidget {
  @override
  _CitizenProfileScreenState createState() => _CitizenProfileScreenState();
}

class _CitizenProfileScreenState extends State<CitizenProfileScreen> {
  final AuthService _authService = AuthService();
  final _formKey = GlobalKey<FormState>();
  String? _name, _phoneNumber, _bloodType, _gender;
  List<String> bloodTypes = ['A+', 'A-', 'B+', 'B-', 'O+', 'O-', 'AB+', 'AB-'];
  List<String> genders = ['Male', 'Female', 'Other'];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadProfileData(); // Load existing data on init
  }

  void _loadProfileData() async {
    String citizenId = FirebaseAuth.instance.currentUser!.uid;
    DocumentSnapshot doc = await FirebaseFirestore.instance.collection('users').doc(citizenId).get();
    if (doc.exists) {
      setState(() {
        _name = doc.get('username'); // Previously stored as username
        _phoneNumber = doc.get('phone_number') ?? '';
        _bloodType = doc.get('blood_type');
        _gender = doc.get('gender');
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return BaseScreen(
      title: 'Citizen Profile',
      authService: _authService,
      showBackButton: true,
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SizedBox(height: 20),
                // Name Field
                TextFormField(
                  initialValue: _name,
                  decoration: InputDecoration(
                    labelText: 'Full Name',
                    prefixIcon: Icon(Icons.person, color: Color(0xFFFF5F6D)),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    filled: true,
                    fillColor: Colors.grey.shade100,
                  ),
                  onChanged: (val) => _name = val.trim(),
                  validator: (val) => val!.isEmpty ? 'Please enter your name' : null,
                ),
                SizedBox(height: 16),
                // Phone Number Field
                TextFormField(
                  initialValue: _phoneNumber,
                  decoration: InputDecoration(
                    labelText: 'Phone Number',
                    prefixIcon: Icon(Icons.phone, color: Color(0xFFFF5F6D)),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    filled: true,
                    fillColor: Colors.grey.shade100,
                  ),
                  keyboardType: TextInputType.phone,
                  onChanged: (val) => _phoneNumber = val.trim(),
                  validator: (val) => val!.isEmpty || val.length < 10 ? 'Enter a valid phone number' : null,
                ),
                SizedBox(height: 16),
                // Blood Type Dropdown
                DropdownButtonFormField<String>(
                  value: _bloodType,
                  items: bloodTypes.map((type) {
                    return DropdownMenuItem(value: type, child: Text(type));
                  }).toList(),
                  onChanged: (value) => setState(() => _bloodType = value),
                  decoration: InputDecoration(
                    labelText: 'Blood Type',
                    prefixIcon: Icon(Icons.bloodtype, color: Color(0xFFFF5F6D)),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    filled: true,
                    fillColor: Colors.grey.shade100,
                  ),
                  validator: (val) => val == null ? 'Please select a blood type' : null,
                ),
                SizedBox(height: 16),
                // Gender Dropdown
                DropdownButtonFormField<String>(
                  value: _gender,
                  items: genders.map((gender) {
                    return DropdownMenuItem(value: gender, child: Text(gender));
                  }).toList(),
                  onChanged: (value) => setState(() => _gender = value),
                  decoration: InputDecoration(
                    labelText: 'Gender',
                    prefixIcon: Icon(Icons.people, color: Color(0xFFFF5F6D)),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    filled: true,
                    fillColor: Colors.grey.shade100,
                  ),
                  validator: (val) => val == null ? 'Please select a gender' : null,
                ),
                SizedBox(height: 30),
                // Save Button
                _isLoading
                    ? Center(child: CircularProgressIndicator())
                    : ElevatedButton(
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      setState(() => _isLoading = true);
                      try {
                        String citizenId = FirebaseAuth.instance.currentUser!.uid;
                        await FirebaseFirestore.instance.collection('users').doc(citizenId).update({
                          'username': _name, // Updating existing field
                          'phone_number': _phoneNumber,
                          'blood_type': _bloodType,
                          'gender': _gender,
                        });
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Profile Updated Successfully!')),
                        );
                      } catch (e) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Error: $e')),
                        );
                      }
                      setState(() => _isLoading = false);
                    }
                  },
                  child: Text('Save Profile'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFFFF5F6D),
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