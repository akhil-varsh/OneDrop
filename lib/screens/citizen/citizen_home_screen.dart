import 'package:donordash/screens/citizen/donate_blood_screen.dart';
import 'package:flutter/material.dart';

import 'package:donordash/screens/citizen/donor_leaderboard_screen.dart';
import 'package:donordash/screens/citizen/map_screen.dart';
import 'package:donordash/screens/citizen/request_blood_screen.dart';

import 'package:donordash/services/auth_service.dart';

import '../../utils/basescreen.dart';
import '../hospital/viewrequestsscreen.dart';
import 'citizen_profile.dart';
import 'donorguide.dart';

class CitizenHomeScreen extends StatefulWidget {
  @override
  _CitizenHomeScreenState createState() => _CitizenHomeScreenState();
}

class _CitizenHomeScreenState extends State<CitizenHomeScreen> {
  final AuthService _authService = AuthService();
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    final List<BottomNavItem> bottomNavItems = [
      BottomNavItem(
        navItem: BottomNavigationBarItem(
          icon: Icon(Icons.home_outlined),
          activeIcon: Icon(Icons.home),
          label: 'Home',
        ),
        onTap: () => setState(() => _selectedIndex = 0),
      ),
      BottomNavItem(
        navItem: BottomNavigationBarItem(
          icon: Icon(Icons.bloodtype_outlined),
          activeIcon: Icon(Icons.bloodtype),
          label: 'Donate Now',
        ),
        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => ViewHospitalRequestsScreen())),
      ),
      BottomNavItem(
        navItem: BottomNavigationBarItem(
          icon: Icon(Icons.map_outlined),
          activeIcon: Icon(Icons.map),
          label: 'Map',
        ),
        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => MapScreen())),
      ),
      BottomNavItem(
        navItem: BottomNavigationBarItem(
          icon: Icon(Icons.account_circle_outlined),
          activeIcon: Icon(Icons.account_circle),
          label: 'Profile',
        ),
        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => CitizenProfileScreen())),
      ),
    ];

    return BaseScreen(
      title: 'Citizen Dashboard 🩺',
      authService: _authService,
      bottomNavItems: bottomNavItems,
      selectedIndex: _selectedIndex,
      onNavItemTap: (index) {
        if (index == 1) {
          Navigator.push(context, MaterialPageRoute(builder: (_) => ViewHospitalRequestsScreen()));
        } else if (index == 2) {
          Navigator.push(context, MaterialPageRoute(builder: (_) => MapScreen()));
        } else if (index == 3) {
          Navigator.push(context, MaterialPageRoute(builder: (_) => CitizenProfileScreen()));
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
              'Help save lives by donating or requesting blood',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[600],
              ),
            ),
            SizedBox(height: 30),
            // Quick Actions Grid
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
                  title: 'Request\nBlood',
                  color: Color(0xFFFF5F6D), // Red
                  onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => RequestBloodScreen())),
                ),
                _buildActionCard(
                  context,
                  icon: Icons.bloodtype,
                  title: 'Donate\nBlood',
                  color: Color(0xFFFFC371), // Orange
                  onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => DonateBloodScreen())),
                ),
                _buildActionCard(
                  context,
                  icon: Icons.leaderboard,
                  title: 'Donor\nLeaderboard',
                  color: Color(0xFF6C63FF), // Blue
                  onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => DonorLeaderboardScreen())),
                ),
                _buildActionCard(
                  context,
                  icon: Icons.book_outlined,
                  title: 'Donor\nGuide',
                  color: Color(0xFF4CAF50), // Green
                  onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => DonorGuide())),
                ),
                _buildActionCard(
                  context,
                  icon: Icons.map,
                  title: 'View\nMap',
                  color: Color(0xFFFF9800), // Amber
                  onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => MapScreen())),
                ),
                _buildActionCard(
                  context,
                  icon: Icons.account_circle,
                  title: 'My\nProfile',
                  color: Color(0xFF2196F3), // Light Blue
                  onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => CitizenProfileScreen())),
                ),
              ],
            ),
          ],
        ),
      ),
      // floatingActionButton: FloatingActionButton.extended(
      //   onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => RequestBloodScreen())),
      //   icon: Icon(Icons.add),
      //   label: Text('Request Blood'),
      //   backgroundColor: Color(0xFFFF5F6D),
      // ),
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