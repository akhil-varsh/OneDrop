import 'package:flutter/material.dart';
import '../models/user_model.dart';
import '../services/auth_service.dart';
import '../utils/constants.dart';
import 'login_screen.dart';

class SignupScreen extends StatefulWidget {
  @override
  _SignupScreenState createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final AuthService _authService = AuthService();
  final _formKey = GlobalKey<FormState>();
  String? email, password, username, bloodType, role = 'Citizen';
  bool _obscureText = true;
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox.expand( // Ensures full-screen background
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Color(0xFFFF5F6D),  // Soft red
                Color(0xFFFFC371),  // Warm orange
              ],
            ),
          ),
          child: SafeArea(
            child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 24.0, vertical: 20.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      // Logo and Title
                      Icon(
                        Icons.volunteer_activism,
                        size: 80,
                        color: Colors.white,
                      ),
                      SizedBox(height: 20),
                      Text(
                        'OneDrop ❤️',
                        style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        'Save Lives, Donate Blood 🩸',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.white70,
                        ),
                      ),
                      SizedBox(height: 40),

                      // Signup Form Card
                      Container(
                        padding: EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black12,
                              blurRadius: 15,
                              offset: Offset(0, 5),
                            ),
                          ],
                        ),
                        child: Column(
                          children: [
                            // Username Field
                            TextFormField(
                              decoration: InputDecoration(
                                labelText: 'Username',
                                hintText: 'Choose a username',
                                prefixIcon: Icon(Icons.person_outline),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              onChanged: (val) => username = val.trim(),
                              validator: (val) => val!.isEmpty ? 'Enter a username' : null,
                            ),
                            SizedBox(height: 16),

                            // Email Field
                            TextFormField(
                              decoration: InputDecoration(
                                labelText: 'Email',
                                hintText: 'Enter your email',
                                prefixIcon: Icon(Icons.email_outlined),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              keyboardType: TextInputType.emailAddress,
                              onChanged: (val) => email = val.trim(),
                              validator: (val) => val!.isEmpty ? 'Enter an email' : null,
                            ),
                            SizedBox(height: 16),

                            // Password Field
                            TextFormField(
                              decoration: InputDecoration(
                                labelText: 'Password',
                                hintText: 'Create a password',
                                prefixIcon: Icon(Icons.lock_outline),
                                suffixIcon: IconButton(
                                  icon: Icon(_obscureText ? Icons.visibility : Icons.visibility_off),
                                  onPressed: () => setState(() => _obscureText = !_obscureText),
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              obscureText: _obscureText,
                              onChanged: (val) => password = val,
                              validator: (val) => val!.length < 6 ? 'Password must be 6+ characters' : null,
                            ),
                            SizedBox(height: 16),

                            // Role Selection
                            Text(
                              'I am a:',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 10),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                _buildRoleCard('Citizen', Icons.person, '🧑'),
                                _buildRoleCard('Hospital', Icons.local_hospital, '🏥'),
                                _buildRoleCard('Blood Bank', Icons.water_drop, '🏦'),
                              ],
                            ),
                            SizedBox(height: 16),

                            // Blood Type Selector (only for Citizens)
                            if (role == 'Citizen')
                              DropdownButtonFormField<String>(
                                value: bloodType,
                                items: AppConstants.bloodTypes
                                    .map((type) => DropdownMenuItem(
                                  value: type,
                                  child: Text('$type 🩸'),
                                ))
                                    .toList(),
                                onChanged: (val) => setState(() => bloodType = val),
                                decoration: InputDecoration(
                                  labelText: 'Blood Type',
                                  prefixIcon: Icon(Icons.bloodtype),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                                validator: (val) => val == null ? 'Select blood type' : null,
                              ),
                            SizedBox(height: 24),

                            // Signup Button
                            _isLoading
                                ? CircularProgressIndicator()
                                : ElevatedButton(
                              onPressed: () async {
                                if (_formKey.currentState!.validate()) {
                                  setState(() => _isLoading = true);
                                  try {
                                    UserModel user = UserModel(
                                      email: email!,
                                      username: username!,
                                      role: role!,
                                      bloodType: role == 'Citizen' ? bloodType : null,
                                    );
                                    await _authService.signUp(email!, password!, user);
                                    Navigator.pushReplacementNamed(context, '/home');
                                  } catch (e) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(content: Text(e.toString())),
                                    );
                                  }
                                  setState(() => _isLoading = false);
                                }
                              },
                              child: Padding(
                                padding: EdgeInsets.symmetric(vertical: 12, horizontal: 24),
                                child: Text(
                                  'Join OneDrop',
                                  style: TextStyle(fontSize: 18,color: Colors.white),
                                ),
                              ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Color(0xFFFF5F6D),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 20),

                      // Login Link
                      TextButton(
                        onPressed: () => Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => LoginScreen()),
                        ),
                        child: Text(
                          'Already have an account? Login',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildRoleCard(String roleValue, IconData icon, String emoji) {
    bool isSelected = role == roleValue;
    return GestureDetector(
      onTap: () => setState(() {
        role = roleValue;
        if (roleValue != 'Citizen') bloodType = null;
      }),
      child: Container(
        padding: EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isSelected ? Color(0xFFFF5F6D) : Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: isSelected ? Color(0xFFFF5F6D) : Colors.grey.shade300,
            width: 2,
          ),
        ),
        child: Column(
          children: [
            Text(emoji, style: TextStyle(fontSize: 24)),
            SizedBox(height: 4),
            Text(
              roleValue,
              style: TextStyle(
                color: isSelected ? Colors.white : Colors.black87,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
