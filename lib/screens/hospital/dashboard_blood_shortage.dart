import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:donordash/services/auth_service.dart';

import '../../utils/basescreen.dart';

class HospitalBloodShortageDashboardScreen extends StatelessWidget {
  final AuthService _authService = AuthService();

  @override
  Widget build(BuildContext context) {
    return BaseScreen(
      title: 'Blood Shortage Dashboard ',
      authService: _authService,
      showBackButton: true,
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Current Blood Shortages',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Color(0xFF444444),
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Monitor blood type shortages in your hospital',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[600],
              ),
            ),
            SizedBox(height: 20),
            Expanded(
              child: RadarChart(
                RadarChartData(
                  radarTouchData: RadarTouchData(enabled: true),
                  dataSets: _getRadarChartData(),
                  radarBackgroundColor: Colors.white,
                  borderData: FlBorderData(show: false),
                  titlePositionPercentageOffset: 0.2,
                  titleTextStyle: TextStyle(fontSize: 12, color: Colors.black),
                  getTitle: (index, angle) {
                    List<String> bloodTypes = ['A+', 'A-', 'B+', 'B-', 'O+', 'O-', 'AB+', 'AB-'];
                    return RadarChartTitle(text: bloodTypes[index], angle: angle);
                  },
                  radarShape: RadarShape.polygon,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<RadarDataSet> _getRadarChartData() {
    Map<String, int> shortageStock = {
      'A+': 20, 'A-': 15, 'B+': 30, 'B-': 10,
      'O+': 40, 'O-': 25, 'AB+': 5, 'AB-': 15,
    };
    List<String> bloodTypes = ['A+', 'A-', 'B+', 'B-', 'O+', 'O-', 'AB+', 'AB-'];

    return [
      RadarDataSet(
        dataEntries: bloodTypes.map((type) => RadarEntry(value: shortageStock[type]!.toDouble())).toList(),
        borderColor: Colors.red,
        fillColor: Colors.red.withOpacity(0.3),
        entryRadius: 3,
        borderWidth: 2,
      )
    ];
  }
}
