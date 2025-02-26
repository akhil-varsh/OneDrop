import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String email;
  final String username;
  final String role;
  final String? bloodType; // Optional, only for Citizens

  UserModel({
    required this.email,
    required this.username,
    required this.role,
    this.bloodType,
  });

  Map<String, dynamic> toMap() {
    return {
      'email': email,
      'username': username,
      'role': role,
      if (bloodType != null) 'blood_type': bloodType, // Only include if provided
      'created_at': FieldValue.serverTimestamp(),
    };
  }
}