import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:donordash/screens/login_screen.dart';
import 'package:donordash/screens/citizen/citizen_home_screen.dart';
import 'package:donordash/screens/hospital/hospital_home_screen.dart';
import 'package:donordash/screens/bloodbank/bloodbank_home_screen.dart';
import 'package:donordash/services/auth_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'OneDrop',
      theme: ThemeData(primarySwatch: Colors.red),
      home: AuthWrapper(),
    );
  }
}

class AuthWrapper extends StatelessWidget {
  final AuthService _authService = AuthService();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: _authService.authStateChanges,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasData) {
          return FutureBuilder(
            future: _authService.getUserRole(snapshot.data!.uid),
            builder: (context, AsyncSnapshot<String> roleSnapshot) {
              if (!roleSnapshot.hasData) return Center(child: CircularProgressIndicator());
              switch (roleSnapshot.data) {
                case 'Citizen':
                  return CitizenHomeScreen();
                case 'Hospital':
                  return HospitalHomeScreen();
                case 'BloodBank':
                  return BloodBankHomeScreen();
                default:
                  return LoginScreen();
              }
            },
          );
        }
        return LoginScreen();
      },
    );
  }
}