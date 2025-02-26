import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:geolocator/geolocator.dart';

class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String? uid = FirebaseAuth.instance.currentUser?.uid;

  Future<void> addBloodRequest(String bloodType, Position location, double urgency) async {
    await _firestore.collection('requests').add({
      'blood_type': bloodType,
      'location': GeoPoint(location.latitude, location.longitude),
      'urgency': urgency,
      'user_id': uid,
      'timestamp': FieldValue.serverTimestamp(),
    });
  }

  Future<void> addBloodShortage(String bloodType, int quantity) async {
    if (uid == null) {
      throw Exception("User not logged in");
    }

    DocumentSnapshot userDoc = await _firestore.collection('users').doc(uid).get();
    String hospitalName = userDoc.exists ? userDoc['name'] ?? 'Unknown Hospital' : 'Unknown Hospital';

    await _firestore.collection('shortages').add({
      'blood_type': bloodType,
      'quantity': quantity,
      'hospital_id': uid,
      'hospital_name': hospitalName, // ✅ Store hospital name
      'timestamp': FieldValue.serverTimestamp(),
    });
  }

  Future<void> addDonationDrive(String bloodType, String locationName, GeoPoint location, DateTime date) async {
    await _firestore.collection('drives').add({
      'blood_type': bloodType,
      'location_name': locationName,
      'location': location,
      'date': Timestamp.fromDate(date),
      'volunteer_id': uid,
      'timestamp': FieldValue.serverTimestamp(),
    });
  }

  Future<void> updateInventory(String bloodType, int quantity) async {
    if (uid == null) {
      throw Exception("User not logged in");
    }

    CollectionReference inventory = _firestore.collection('inventory');

    QuerySnapshot snapshot = await inventory
        .where('bloodbank_id', isEqualTo: uid)
        .where('blood_type', isEqualTo: bloodType)
        .get();

    if (snapshot.docs.isNotEmpty) {
      DocumentReference docRef = snapshot.docs.first.reference;
      await docRef.update({'quantity': quantity});
    } else {
      await inventory.add({
        'bloodbank_id': uid,
        'blood_type': bloodType,
        'quantity': quantity,
        'timestamp': FieldValue.serverTimestamp(),
      });
    }
  }

  Future<List<Map<String, dynamic>>> getBloodShortages() async {
    QuerySnapshot snapshot = await _firestore.collection('shortages').get(); // ✅ Corrected
    return snapshot.docs.map((doc) => doc.data() as Map<String, dynamic>).toList();
  }


  // Fetch all blood requests
  Stream<QuerySnapshot> getBloodRequests() {
    return _firestore.collection('requests').orderBy('timestamp', descending: true).snapshots();
  }
}
