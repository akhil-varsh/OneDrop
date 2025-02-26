import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:donordash/screens/citizen/map_screen.dart';
import 'package:donordash/services/auth_service.dart';

import '../../utils/basescreen.dart';

class DonateBloodScreen extends StatelessWidget {
  final AuthService _authService = AuthService();

  // 5 static blood requests with real coordinates near Hyderabad, India
  final List<Map<String, dynamic>> bloodRequests = [
    {
      'hospital': 'Prasads Hospital',
      'bloodType': 'A+',
      'location': LatLng(17.505648869835802, 78.39557320804211), // Your provided coordinates
    },
    {
      'hospital': 'Yashoda Hospitals',
      'bloodType': 'O-',
      'location': LatLng(17.463211869544814, 78.3845339501794), // Nearby plausible location
    },
    {
      'hospital': 'TATA AIG',
      'bloodType': 'B+',
      'location': LatLng(17.444495102808247, 78.36705364737374), // Nearby plausible location
    },
    {
      'hospital': 'MAMS Hospital',
      'bloodType': 'AB-',
      'location': LatLng(17.538729735292378, 78.35806265868706), // Nearby plausible location
    },
    {
      'hospital': 'Malla Reddy Hospitals',
      'bloodType': 'O+',
      'location': LatLng(17.54737055572562, 78.43329681933616), // Nearby plausible location
    },
  ];

  @override
  Widget build(BuildContext context) {
    return BaseScreen(
      title: 'Donate Blood 🩺',
      authService: _authService,
      showBackButton: true,
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Register to Donate Blood',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Color(0xFF444444),
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Help fulfill hospital blood requests',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[600],
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Donation Registered!')),
                );
              },
              child: Text('Confirm Donation'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFFFF5F6D),
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
            SizedBox(height: 20),
            Text(
              'Blood Requests from Hospitals',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color(0xFF444444),
              ),
            ),
            SizedBox(height: 10),
            Expanded(
              child: ListView.builder(
                itemCount: bloodRequests.length,
                itemBuilder: (context, index) {
                  final request = bloodRequests[index];
                  return Card(
                    elevation: 2,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    margin: EdgeInsets.symmetric(vertical: 8.0),
                    child: ListTile(
                      title: Text(
                        '${request['hospital']}',
                        style: TextStyle(color: Color(0xFF444444), fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text(
                        'Blood Type: ${request['bloodType']}\nLocation: (${request['location'].latitude}, ${request['location'].longitude})',
                        style: TextStyle(color: Colors.grey[600]),
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: Icon(Icons.map, color: Color(0xFFFF5F6D)),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => MapScreen(
                                    initialLocation: request['location'], // Pass hospital location
                                  ),
                                ),
                              );
                            },
                          ),
                          ElevatedButton(
                            onPressed: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('Confirmed donation for ${request['hospital']}')),
                              );
                            },
                            child: Text('Confirm'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Color(0xFFFF5F6D),
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            ),
                          ),
                        ],
                      ),
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
// import 'package:flutter/material.dart';
// import 'package:donordash/screens/citizen/map_screen.dart';
// import 'package:donordash/services/auth_service.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
//
// import '../../utils/basescreen.dart';
//
// class DonateBloodScreen extends StatelessWidget {
//   final AuthService _authService = AuthService();
//
//   // 5 static blood requests with placeholder locations
//   final List<Map<String, String>> bloodRequests = [
//     {'hospital': 'Prasads Hospital', 'bloodType': 'A+', 'location': '17.505648869835802, 78.39557320804211'},
//     {'hospital': 'Yashoda Hospital', 'bloodType': 'O-', 'location': '17.463211869544814, 78.3845339501794'},
//     {'hospital': 'TATA AIG Hospital', 'bloodType': 'B+', 'location': '17.444495102808247, 78.36705364737374'},
//     {'hospital': 'LifeCare Hospital', 'bloodType': 'AB-', 'location': '[Your Location 4]'},
//     {'hospital': 'Starlight Medical', 'bloodType': 'O+', 'location': '[Your Location 5]'},
//   ];
//
//   @override
//   Widget build(BuildContext context) {
//     return BaseScreen(
//       title: 'Donate Blood 🩺',
//       authService: _authService,
//       showBackButton: true,
//       body: Padding(
//         padding: const EdgeInsets.all(20.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.stretch,
//           children: [
//             Text(
//               'Register to Donate Blood',
//               style: TextStyle(
//                 fontSize: 24,
//                 fontWeight: FontWeight.bold,
//                 color: Color(0xFF444444),
//               ),
//             ),
//             SizedBox(height: 8),
//             Text(
//               'Help fulfill hospital blood requests',
//               style: TextStyle(
//                 fontSize: 16,
//                 color: Colors.grey[600],
//               ),
//             ),
//             SizedBox(height: 20),
//             ElevatedButton(
//               onPressed: () {
//                 ScaffoldMessenger.of(context).showSnackBar(
//                   SnackBar(content: Text('Donation Registered!')),
//                 );
//               },
//               child: Text('Confirm Donation'),
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: Color(0xFFFF5F6D),
//                 foregroundColor: Colors.white,
//                 padding: EdgeInsets.symmetric(vertical: 16),
//                 shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//               ),
//             ),
//             SizedBox(height: 20),
//             Text(
//               'Blood Requests from Hospitals',
//               style: TextStyle(
//                 fontSize: 20,
//                 fontWeight: FontWeight.bold,
//                 color: Color(0xFF444444),
//               ),
//             ),
//             SizedBox(height: 10),
//             Expanded(
//               child: ListView.builder(
//                 itemCount: bloodRequests.length,
//                 itemBuilder: (context, index) {
//                   final request = bloodRequests[index];
//                   return Card(
//                     elevation: 2,
//                     shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//                     margin: EdgeInsets.symmetric(vertical: 8.0),
//                     child: ListTile(
//                       title: Text(
//                         '${request['hospital']}',
//                         style: TextStyle(color: Color(0xFF444444), fontWeight: FontWeight.bold),
//                       ),
//                       subtitle: Text(
//                         'Blood Type: ${request['bloodType']}\nLocation: ${request['location']}',
//                         style: TextStyle(color: Colors.grey[600]),
//                       ),
//                       trailing: Row(
//                         mainAxisSize: MainAxisSize.min,
//                         children: [
//                           IconButton(
//                             icon: Icon(Icons.map, color: Color(0xFFFF5F6D)),
//                             onPressed: () {
//                               // Navigate to MapScreen with hospital location
//                               Navigator.push(
//                                 context,
//                                 MaterialPageRoute(builder: (_) => MapScreen()),
//                               );
//                               // You can pass location data here once defined
//                             },
//                           ),
//                           ElevatedButton(
//                             onPressed: () {
//                               ScaffoldMessenger.of(context).showSnackBar(
//                                 SnackBar(content: Text('Confirmed donation for ${request['hospital']}')),
//                               );
//                             },
//                             child: Text('Confirm'),
//                             style: ElevatedButton.styleFrom(
//                               backgroundColor: Color(0xFFFF5F6D),
//                               foregroundColor: Colors.white,
//                               shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   );
//                 },
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }