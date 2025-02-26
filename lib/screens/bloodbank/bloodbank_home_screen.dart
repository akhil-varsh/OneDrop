import 'package:donordash/screens/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:donordash/screens/bloodbank/manage_inventory_screen.dart';
import 'package:donordash/screens/bloodbank/view_shortages_screen.dart';
import 'package:donordash/screens/citizen/map_screen.dart';
import 'package:donordash/services/auth_service.dart';
import '../../utils/basescreen.dart';
import '../citizen/view_hospital_requests.dart';

class BloodBankHomeScreen extends StatelessWidget {
  final AuthService _authService = AuthService();

  // Blood stock data
  final Map<String, double> bloodStock = {
    'A+': 80,
    'A-': 60,
    'B+': 50,
    'B-': 70,
    'O+': 40,
    'O-': 90,
    'AB+': 55,
    'AB-': 65,
  };

  @override
  Widget build(BuildContext context) {
    final List<DrawerItem> drawerItems = [
      DrawerItem(icon: Icons.home, title: 'Home', onTap: () => Navigator.pop(context)),
      DrawerItem(icon: Icons.inventory, title: 'Manage Inventory', onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => ManageInventoryScreen()))),
      DrawerItem(icon: Icons.bloodtype, title: 'View Requests', onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => ViewHospitalRequestsScreen()))),
      DrawerItem(icon: Icons.warning, title: 'Shortages', onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => ViewShortagesScreen()))),
      DrawerItem(icon: Icons.logout, title: 'Log out', onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => LoginScreen()))),
    ];

    return Scaffold(
      appBar: AppBar(title: Text('Blood Bank Dashboard')),
      drawer: Drawer(
        child: ListView(
          children: drawerItems.map((item) => ListTile(
            leading: Icon(item.icon),
            title: Text(item.title),
            onTap: item.onTap,
          )).toList(),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Blood Inventory Overview',
              style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF444444)
              ),
            ),
            SizedBox(height: 20),
            Expanded(
              child: _buildChart(),
            ),
            SizedBox(height: 20),
            _buildLegend(),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomNavigationBar(context),
    );
  }

  Widget _buildChart() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: BarChart(
        BarChartData(
          gridData: FlGridData(show: false),
          borderData: FlBorderData(
            show: true,
            border: Border(
              bottom: BorderSide(color: Colors.black12, width: 1),
              left: BorderSide(color: Colors.black12, width: 1),
            ),
          ),
          titlesData: FlTitlesData(
            show: true,
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (value, meta) {
                  List<String> titles = bloodStock.keys.toList();
                  if (value.toInt() < 0 || value.toInt() >= titles.length) return Text('');
                  return Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Text(
                      titles[value.toInt()],
                      style: TextStyle(
                        color: Color(0xFF444444),
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  );
                },
                reservedSize: 28,
              ),
            ),
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (value, meta) {
                  return Text(
                    value.toInt().toString(),
                    style: TextStyle(
                      color: Color(0xFF444444),
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  );
                },
                reservedSize: 28,
              ),
            ),
            topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
            rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          ),
          barGroups: bloodStock.entries.map((entry) {
            return BarChartGroupData(
              x: bloodStock.keys.toList().indexOf(entry.key),
              barRods: [
                BarChartRodData(
                  toY: entry.value,
                  color: Color(0xFFFF5F6D),
                  width: 16,
                  borderRadius: BorderRadius.circular(4),
                ),
              ],
            );
          }).toList(),
          maxY: 100,
          barTouchData: BarTouchData(
            enabled: true,
            touchTooltipData: BarTouchTooltipData(
              // tooltipBackgroundColor: Colors.blueGrey,
              getTooltipItem: (group, groupIndex, rod, rodIndex) {
                return BarTooltipItem(
                  '${bloodStock.keys.toList()[group.x]} : ${rod.toY.round()}',
                  TextStyle(color: Colors.white),
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLegend() {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 5,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 16,
            height: 16,
            decoration: BoxDecoration(
              color: Color(0xFFFF5F6D),
              borderRadius: BorderRadius.circular(4),
            ),
          ),
          SizedBox(width: 8),
          Text(
            'Blood Units Available',
            style: TextStyle(
              color: Color(0xFF444444),
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomNavigationBar(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 15,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: BottomNavigationBar(
          items: [
            BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
            BottomNavigationBarItem(icon: Icon(Icons.map), label: 'Map'),
          ],
          onTap: (index) {
            if (index == 1) {
              Navigator.push(context, MaterialPageRoute(builder: (_) => MapScreen()));
            }
          },
          backgroundColor: Colors.white,
          selectedItemColor: Color(0xFFFF5F6D),
          unselectedItemColor: Colors.grey.shade400,
          type: BottomNavigationBarType.fixed,
          showSelectedLabels: true,
          showUnselectedLabels: true,
          selectedLabelStyle: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}