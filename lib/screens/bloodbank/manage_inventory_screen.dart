import 'package:flutter/material.dart';
import 'package:donordash/services/auth_service.dart';
import 'package:donordash/services/firestore_service.dart';

import '../../utils/basescreen.dart';

class ManageInventoryScreen extends StatefulWidget {
  @override
  _ManageInventoryScreenState createState() => _ManageInventoryScreenState();
}

class _ManageInventoryScreenState extends State<ManageInventoryScreen> {
  final FirestoreService _firestoreService = FirestoreService();
  final AuthService _authService = AuthService();
  final _formKey = GlobalKey<FormState>();
  String? bloodType;
  int quantity = 0;
  bool _isLoading = false;

  final List<String> bloodTypes = ['A+', 'A-', 'B+', 'B-', 'O+', 'O-', 'AB+', 'AB-'];

  final Map<String, int> staticInventory = {
    'A+': 80, 'A-': 60, 'B+': 50, 'B-': 70,
    'O+': 40, 'O-': 90, 'AB+': 55, 'AB-': 65,
  };

  @override
  Widget build(BuildContext context) {
    return BaseScreen(
      title: 'Manage Inventory 🩺',
      authService: _authService,
      showBackButton: true,
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Update Blood Inventory',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Color(0xFF444444),
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Manage your blood stock levels',
              style: TextStyle(fontSize: 16, color: Colors.grey[600]),
            ),
            SizedBox(height: 20),
            Form(
              key: _formKey,
              child: Column(
                children: [
                  DropdownButtonFormField<String>(
                    value: bloodType,
                    items: bloodTypes.map((type) => DropdownMenuItem(value: type, child: Text(type))).toList(),
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
                  TextFormField(
                    decoration: InputDecoration(
                      labelText: 'Quantity (Units)',
                      prefixIcon: Icon(Icons.inventory, color: Color(0xFFFF5F6D)),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                      filled: true,
                      fillColor: Colors.grey.shade100,
                    ),
                    keyboardType: TextInputType.number,
                    onChanged: (val) => setState(() => quantity = int.tryParse(val) ?? 0),
                    validator: (val) => val == null || val.isEmpty ? 'Enter a quantity' : null,
                  ),
                  SizedBox(height: 20),
                  _isLoading
                      ? Center(child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFFF5F6D))))
                      : ElevatedButton(
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        setState(() => _isLoading = true);
                        try {
                          await _firestoreService.updateInventory(bloodType!, quantity);
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Inventory Updated!')));
                          Navigator.pop(context);
                        } catch (e) {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
                        }
                        setState(() => _isLoading = false);
                      }
                    },
                    child: Text('Update Inventory'),
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
            SizedBox(height: 20),
            Text(
              'Current Inventory',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF444444)),
            ),
            SizedBox(height: 10),
            SizedBox(
              height: 400, // Adjust this height as needed
              child: ListView.builder(
                itemCount: bloodTypes.length,
                itemBuilder: (context, index) {
                  String type = bloodTypes[index];
                  int units = staticInventory[type] ?? 0;
                  return Card(
                    elevation: 2,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    child: ListTile(
                      leading: Icon(Icons.bloodtype, color: Color(0xFFFF5F6D)),
                      title: Text(type, style: TextStyle(color: Color(0xFF444444))),
                      trailing: Text('$units units', style: TextStyle(color: Color(0xFF444444))),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
