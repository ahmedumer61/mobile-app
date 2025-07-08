import 'package:fitness_app/view/home/home_view.dart';
import 'package:fitness_app/view/on_boarding/started_view.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _checkLoginState();
  }

  Future<void> _checkLoginState() async {
    await Future.delayed(Duration(seconds: 7)); // simulate splash duration
    final prefs = await SharedPreferences.getInstance();
    final isLoggedIn = prefs.getString('user_uid') != null;

    if (isLoggedIn) {
      Navigator.push(
          context,
      MaterialPageRoute(builder: (context)=> HomeView()));
    } else {
      Navigator.push(context,
          MaterialPageRoute(builder: (context)=>StartedView()));
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.white, // Changed to white background
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Replace this with your actual logo image
            Container(
              width: screenWidth * 0.4, // Adjust size as needed
              height: screenWidth * 0.4, // Keep it square
              child: Image.asset(
                'assets/img/fitness_logo.png', // Add your logo image here
                fit: BoxFit.contain,
              ),
            ),
            SizedBox(height: screenHeight * 0.03),
            Text(
              'FITNESS COMPANION',
              style: TextStyle(
                fontSize: screenWidth * 0.06, // Adjusted for better fit
                color: Color(0xFF1E4B8B), // Blue color matching the logo
                fontWeight: FontWeight.bold,
                letterSpacing: 1.2,
              ),
            ),
          ],
        ),
      ),
    );
  }
}