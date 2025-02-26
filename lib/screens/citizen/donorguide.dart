import 'package:flutter/material.dart';

class DonorGuide extends StatefulWidget {
  @override
  _DonorGuideState createState() => _DonorGuideState();
}

class _DonorGuideState extends State<DonorGuide> {
  bool showBenefits = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Donor Guide'),
        backgroundColor: Colors.redAccent,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(vertical: 16),
                      textStyle: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      backgroundColor: Colors.redAccent,
                    ),
                    onPressed: () {
                      setState(() {
                        showBenefits = true;
                      });
                    },
                    child: Text('Benefits'),
                  ),
                ),
                SizedBox(width: 10),
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(vertical: 16),
                      textStyle: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      backgroundColor: Colors.white,
                    ),
                    onPressed: () {
                      setState(() {
                        showBenefits = false;
                      });
                    },
                    child: Text('Know More'),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(16.0),
              child: showBenefits ? _buildBenefitsSection() : _buildBloodDetailsSection(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBenefitsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Benefits of Blood Donation',
          style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.redAccent),
        ),
        SizedBox(height: 8),
        _buildBenefit(
          title: 'Saves Lives',
          description: 'Each donation can save up to three lives.',
          icon: Icons.favorite,
          color: Colors.red,
        ),
        _buildBenefit(
          title: 'Improves Heart Health',
          description: 'Regular donation helps reduce harmful iron stores and lowers heart disease risk.',
          icon: Icons.favorite_border,
          color: Colors.pink,
        ),
        _buildBenefit(
          title: 'Boosts Red Blood Cell Production',
          description: 'The body replenishes lost blood, boosting overall health.',
          icon: Icons.water_drop,
          color: Colors.blue,
        ),
        _buildBenefit(
          title: 'Provides a Free Health Checkup',
          description: 'Donors undergo a mini health screening before donation.',
          icon: Icons.medical_services,
          color: Colors.green,
        ),
      ],
    );
  }

  Widget _buildBloodDetailsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Blood Analytics Guide',
          style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.redAccent),
        ),
        SizedBox(height: 8),
        Text(
          'Understanding Blood Components and Donor Matching',
          style: TextStyle(fontSize: 18, color: Colors.grey[700]),
        ),
        SizedBox(height: 16),
        _buildBenefit(
          title: 'Red Blood Cells (Erythrocytes)',
          description: 'Carry oxygen from your lungs to the rest of your body.',
          icon: Icons.bloodtype,
          color: Colors.red,
        ),
        _buildBenefit(
          title: 'White Blood Cells (Leukocytes)',
          description: 'Fight infections and protect the body from foreign invaders.',
          icon: Icons.coronavirus,
          color: Colors.white,
        ),
        _buildBenefit(
          title: 'Platelets (Thrombocytes)',
          description: 'Help in blood clotting to prevent excessive bleeding.',
          icon: Icons.healing,
          color: Colors.yellow,
        ),
        _buildBenefit(
          title: 'Plasma',
          description: 'The liquid part of blood that carries cells and nutrients throughout the body.',
          icon: Icons.water_drop,
          color: Colors.blue,
        ),
      ],
    );
  }

  Widget _buildBenefit({required String title, required String description, required IconData icon, required Color color}) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 10),
      child: ListTile(
        leading: Icon(icon, color: color, size: 36),
        title: Text(
          title,
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
        ),
        subtitle: Text(description, style: TextStyle(fontSize: 16)),
      ),
    );
  }
}
