import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:donordash/services/auth_service.dart';

import '../../utils/basescreen.dart';

class MapScreen extends StatefulWidget {
  final LatLng? initialLocation; // Optional initial location from hospital

  const MapScreen({this.initialLocation});

  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  final AuthService _authService = AuthService();
  GoogleMapController? mapController;
  TextEditingController searchController = TextEditingController();

  CameraPosition initialPosition = CameraPosition(
    target: LatLng(0, 0), // Default, updated later
    zoom: 15,
  );

  Set<Marker> markers = {};
  Position? currentPosition;

  @override
  void initState() {
    super.initState();
    if (widget.initialLocation != null) {
      // Use hospital location if provided
      initialPosition = CameraPosition(
        target: widget.initialLocation!,
        zoom: 15,
      );
      markers.add(
        Marker(
          markerId: MarkerId('hospitalLocation'),
          position: widget.initialLocation!,
          infoWindow: InfoWindow(title: 'Hospital Location'),
        ),
      );
    } else {
      _getCurrentLocation(); // Otherwise, get user’s location
    }
  }

  Future<void> _getCurrentLocation() async {
    try {
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          throw 'Location permissions denied';
        }
      }

      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      setState(() {
        currentPosition = position;
        initialPosition = CameraPosition(
          target: LatLng(position.latitude, position.longitude),
          zoom: 15,
        );

        markers.add(
          Marker(
            markerId: MarkerId('currentLocation'),
            position: LatLng(position.latitude, position.longitude),
            infoWindow: InfoWindow(title: 'Current Location'),
          ),
        );
      });

      mapController?.animateCamera(
        CameraUpdate.newCameraPosition(initialPosition),
      );
    } catch (e) {
      print('Error getting location: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error getting location: $e')),
        );
      }
    }
  }

  Future<void> searchLocation(String query) async {
    if (query.isEmpty) return;

    try {
      List<Location> locations = await locationFromAddress(query);
      if (locations.isNotEmpty) {
        Location location = locations.first;

        Marker searchMarker = Marker(
          markerId: MarkerId('searchResult'),
          position: LatLng(location.latitude, location.longitude),
          infoWindow: InfoWindow(title: query),
        );

        setState(() {
          markers.removeWhere((marker) => marker.markerId.value == 'searchResult');
          markers.add(searchMarker);
        });

        mapController?.animateCamera(
          CameraUpdate.newCameraPosition(
            CameraPosition(
              target: LatLng(location.latitude, location.longitude),
              zoom: 15,
            ),
          ),
        );
      }
    } catch (e) {
      print('Error searching location: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Location not found')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return BaseScreen(
      title: 'Map 🗺️',
      authService: _authService,
      showBackButton: true,
      body: Stack(
        children: [
          GoogleMap(
            initialCameraPosition: initialPosition,
            markers: markers,
            myLocationEnabled: true,
            myLocationButtonEnabled: true,
            zoomControlsEnabled: true,
            onMapCreated: (GoogleMapController controller) {
              mapController = controller;
              if (widget.initialLocation != null) {
                controller.animateCamera(
                  CameraUpdate.newCameraPosition(
                    CameraPosition(
                      target: widget.initialLocation!,
                      zoom: 15,
                    ),
                  ),
                );
              } else if (currentPosition != null) {
                controller.animateCamera(
                  CameraUpdate.newCameraPosition(
                    CameraPosition(
                      target: LatLng(currentPosition!.latitude, currentPosition!.longitude),
                      zoom: 15,
                    ),
                  ),
                );
              }
            },
          ),
          Positioned(
            top: 20,
            left: 20,
            right: 20,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 5,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: TextField(
                controller: searchController,
                decoration: InputDecoration(
                  hintText: 'Search location',
                  prefixIcon: Icon(Icons.search, color: Color(0xFFFF5F6D)),
                  suffixIcon: IconButton(
                    icon: Icon(Icons.clear, color: Color(0xFFFF5F6D)),
                    onPressed: () => searchController.clear(),
                  ),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(horizontal: 15, vertical: 12),
                ),
                onSubmitted: (value) => searchLocation(value),
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _getCurrentLocation,
        child: Icon(Icons.my_location),
        backgroundColor: Color(0xFFFF5F6D),
      ),
    );
  }

  @override
  void dispose() {
    mapController?.dispose();
    searchController.dispose();
    super.dispose();
  }
}
// import 'package:flutter/material.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:geolocator/geolocator.dart';
// import 'package:geocoding/geocoding.dart';
// import 'package:donordash/services/auth_service.dart';
//
// import '../../utils/basescreen.dart';
//
// class MapScreen extends StatefulWidget {
//   @override
//   _MapScreenState createState() => _MapScreenState();
// }
//
// class _MapScreenState extends State<MapScreen> {
//   final AuthService _authService = AuthService();
//   GoogleMapController? mapController;
//   TextEditingController searchController = TextEditingController();
//
//   // Default position (updated later with current location)
//   CameraPosition initialPosition = CameraPosition(
//     target: LatLng(0, 0),
//     zoom: 15,
//   );
//
//   Set<Marker> markers = {};
//   Position? currentPosition;
//
//   @override
//   void initState() {
//     super.initState();
//     _getCurrentLocation();
//   }
//
//   Future<void> _getCurrentLocation() async {
//     try {
//       LocationPermission permission = await Geolocator.checkPermission();
//       if (permission == LocationPermission.denied) {
//         permission = await Geolocator.requestPermission();
//         if (permission == LocationPermission.denied) {
//           throw 'Location permissions denied';
//         }
//       }
//
//       Position position = await Geolocator.getCurrentPosition(
//         desiredAccuracy: LocationAccuracy.high,
//       );
//
//       setState(() {
//         currentPosition = position;
//         initialPosition = CameraPosition(
//           target: LatLng(position.latitude, position.longitude),
//           zoom: 15,
//         );
//
//         markers.add(
//           Marker(
//             markerId: MarkerId('currentLocation'),
//             position: LatLng(position.latitude, position.longitude),
//             infoWindow: InfoWindow(title: 'Current Location'),
//           ),
//         );
//       });
//
//       mapController?.animateCamera(
//         CameraUpdate.newCameraPosition(initialPosition),
//       );
//     } catch (e) {
//       print('Error getting location: $e');
//       if (mounted) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text('Error getting location: $e')),
//         );
//       }
//     }
//   }
//
//   Future<void> searchLocation(String query) async {
//     if (query.isEmpty) return;
//
//     try {
//       List<Location> locations = await locationFromAddress(query);
//       if (locations.isNotEmpty) {
//         Location location = locations.first;
//
//         Marker searchMarker = Marker(
//           markerId: MarkerId('searchResult'),
//           position: LatLng(location.latitude, location.longitude),
//           infoWindow: InfoWindow(title: query),
//         );
//
//         setState(() {
//           markers.removeWhere((marker) => marker.markerId.value == 'searchResult');
//           markers.add(searchMarker);
//         });
//
//         mapController?.animateCamera(
//           CameraUpdate.newCameraPosition(
//             CameraPosition(
//               target: LatLng(location.latitude, location.longitude),
//               zoom: 15,
//             ),
//           ),
//         );
//       }
//     } catch (e) {
//       print('Error searching location: $e');
//       if (mounted) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text('Location not found')),
//         );
//       }
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return BaseScreen(
//       title: 'Map 🗺️',
//       authService: _authService,
//       showBackButton: true, // Enables back button to return to previous screen
//       body: Stack(
//         children: [
//           GoogleMap(
//             initialCameraPosition: initialPosition,
//             markers: markers,
//             myLocationEnabled: true,
//             myLocationButtonEnabled: true,
//             zoomControlsEnabled: true,
//             onMapCreated: (GoogleMapController controller) {
//               mapController = controller;
//               if (currentPosition != null) {
//                 controller.animateCamera(
//                   CameraUpdate.newCameraPosition(
//                     CameraPosition(
//                       target: LatLng(currentPosition!.latitude, currentPosition!.longitude),
//                       zoom: 15,
//                     ),
//                   ),
//                 );
//               }
//             },
//           ),
//           Positioned(
//             top: 20,
//             left: 20,
//             right: 20,
//             child: Container(
//               decoration: BoxDecoration(
//                 color: Colors.white,
//                 borderRadius: BorderRadius.circular(8),
//                 boxShadow: [
//                   BoxShadow(
//                     color: Colors.black26,
//                     blurRadius: 5,
//                     offset: Offset(0, 2),
//                   ),
//                 ],
//               ),
//               child: TextField(
//                 controller: searchController,
//                 decoration: InputDecoration(
//                   hintText: 'Search location',
//                   prefixIcon: Icon(Icons.search, color: Color(0xFFFF5F6D)),
//                   suffixIcon: IconButton(
//                     icon: Icon(Icons.clear, color: Color(0xFFFF5F6D)),
//                     onPressed: () => searchController.clear(),
//                   ),
//                   border: InputBorder.none,
//                   contentPadding: EdgeInsets.symmetric(horizontal: 15, vertical: 12),
//                 ),
//                 onSubmitted: (value) => searchLocation(value),
//               ),
//             ),
//           ),
//         ],
//       ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: _getCurrentLocation,
//         child: Icon(Icons.my_location),
//         backgroundColor: Color(0xFFFF5F6D),
//       ),
//     );
//   }
//
//   @override
//   void dispose() {
//     mapController?.dispose();
//     searchController.dispose();
//     super.dispose();
//   }
// }