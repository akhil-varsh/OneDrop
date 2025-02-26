import 'package:flutter/material.dart';

import 'package:donordash/screens/hospital/post_hospital_request_screen.dart';

import 'package:donordash/screens/citizen/map_screen.dart';
import 'package:donordash/services/auth_service.dart';

import '../../utils/basescreen.dart';
import '../citizen/view_hospital_requests.dart';
import 'dashboard_blood_shortage.dart';

class HospitalHomeScreen extends StatefulWidget {
  @override
  _HospitalHomeScreenState createState() => _HospitalHomeScreenState();
}

class _HospitalHomeScreenState extends State<HospitalHomeScreen> {
  final AuthService _authService = AuthService();
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    final List<BottomNavItem> bottomNavItems = [
      BottomNavItem(
        navItem: BottomNavigationBarItem(
          icon: Icon(Icons.dashboard_outlined),
          activeIcon: Icon(Icons.dashboard),
          label: 'Home',
        ),
        onTap: () => setState(() => _selectedIndex = 0),
      ),
      BottomNavItem(
        navItem: BottomNavigationBarItem(
          icon: Icon(Icons.map_outlined),
          activeIcon: Icon(Icons.map),
          label: 'Map',
        ),
        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => MapScreen())),
      ),
    ];

    // final List<DrawerItem> drawerItems = [
    //   DrawerItem(
    //     icon: Icons.home,
    //     title: 'Home',
    //     onTap: () => Navigator.pop(context),
    //   ),
    //   DrawerItem(
    //     icon: Icons.local_hospital,
    //     title: 'Request Blood for Patient',
    //     onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => PostHospitalRequestScreen())),
    //   ),
    //   DrawerItem(
    //     icon: Icons.bloodtype,
    //     title: 'View Citizen Requests',
    //     onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => ViewHospitalRequestsScreen())),
    //   ),
    //   DrawerItem(
    //     icon: Icons.bar_chart,
    //     title: 'Blood Shortage Dashboard',
    //     onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => HospitalBloodShortageDashboardScreen())),
    //   ),
    // ];

    return BaseScreen(
      title: 'Hospital Dashboard 🏥',
      authService: _authService,
      bottomNavItems: bottomNavItems,
      selectedIndex: _selectedIndex,
      onNavItemTap: (index) {
        if (index == 1) {
          Navigator.push(context, MaterialPageRoute(builder: (_) => MapScreen()));
        } else {
          setState(() => _selectedIndex = index);
        }
      },
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Welcome back! 👋',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Color(0xFF444444),
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Manage blood requests and shortages',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[600],
              ),
            ),
            SizedBox(height: 30),
            GridView.count(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              mainAxisSpacing: 16,
              crossAxisSpacing: 16,
              children: [
                _buildActionCard(
                  context,
                  icon: Icons.add_circle_outline,
                  title: 'Post\nShortage',
                  color: Color(0xFFFF5F6D),
                  onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => PostHospitalRequestScreen())),
                ),
                _buildActionCard(
                  context,
                  icon: Icons.list_alt,
                  title: 'View\nRequests',
                  color: Color(0xFFFFC371),
                  onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => ViewHospitalRequestsScreen())),
                ),
                _buildActionCard(
                  context,
                  icon: Icons.bar_chart,
                  title: 'Shortage\nDashboard',
                  color: Color(0xFF6C63FF),
                  onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => HospitalBloodShortageDashboardScreen())),
                ),
                _buildActionCard(
                  context,
                  icon: Icons.book_outlined,
                  title: 'Request Blood\nFor Patient',
                  color: Color(0xFF4CAF50),
                  onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => PostHospitalRequestScreen())),
                ),
              ],
            ),
          ],
        ),
      ),
         );
  }

  Widget _buildActionCard(
      BuildContext context, {
        required IconData icon,
        required String title,
        required Color color,
        required VoidCallback onTap,
      }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: color.withOpacity(0.3)),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 40, color: color),
            SizedBox(height: 12),
            Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: color.withOpacity(0.8),
              ),
            ),
          ],
        ),
      ),
    );
  }
}