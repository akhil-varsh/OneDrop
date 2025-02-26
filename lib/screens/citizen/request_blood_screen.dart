import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import '../../services/firestore_service.dart';
import '../../utils/constants.dart';
import '../../utils/basescreen.dart';
import '../../services/auth_service.dart';

class RequestBloodScreen extends StatefulWidget {
  @override
  _RequestBloodScreenState createState() => _RequestBloodScreenState();
}

class _RequestBloodScreenState extends State<RequestBloodScreen> {
  final FirestoreService _firestoreService = FirestoreService();
  final AuthService _authService = AuthService();
  String? bloodType;
  double urgency = 0;
  Position? location;

  @override
  Widget build(BuildContext context) {
    return BaseScreen(
      title: 'Request Blood',
      authService: _authService,
      showBackButton: true, // Enable the back button
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            DropdownButtonFormField<String>(
              value: bloodType,
              items: AppConstants.bloodTypes
                  .map((type) => DropdownMenuItem(value: type, child: Text(type)))
                  .toList(),
              onChanged: (val) => setState(() => bloodType = val),
              decoration: InputDecoration(labelText: 'Blood Type'),
            ),
            SizedBox(height: 16),
            Slider(
              value: urgency,
              min: 0,
              max: 10,
              divisions: 10,
              label: 'Urgency: $urgency',
              onChanged: (val) => setState(() => urgency = val),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                location = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
                await _firestoreService.addBloodRequest(bloodType!, location!, urgency);
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Request Sent!')));
                Navigator.pop(context);
              },
              child: Text('Submit Request'),
            ),
          ],
        ),
      ),
    );
  }
}
