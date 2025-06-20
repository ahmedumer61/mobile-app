import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../common/colo_extension.dart';
import '../../common_widget/round_button.dart';
import '../main_tab/main_tab_view.dart';

class WelcomeView extends StatefulWidget {
  const WelcomeView({super.key});

  @override
  State<WelcomeView> createState() => _WelcomeViewState();
}

class _WelcomeViewState extends State<WelcomeView> {
  String userName = "User";  // Default name if no name is found in SharedPreferences
  bool _isLoading = true;    // Flag to track loading state

  @override
  void initState() {
    super.initState();
    _getUserName();  // Retrieve the username when the screen is initialized
  }

  // Function to retrieve the stored user's name from SharedPreferences
  Future<void> _getUserName() async {
    final prefs = await SharedPreferences.getInstance();
    String? storedName = prefs.getString('user_name');  // Retrieve the saved username

    print('Fetched Username: $storedName');  // Debugging step

    setState(() {
      userName = storedName ?? "User";  // Default to 'User' if no name is found
      _isLoading = false;  // Stop loading once the data is retrieved
    });
  }

  // Function to save the username in SharedPreferences (called after login or signup)
  Future<void> saveUserName(String username) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('user_name', username);  // Save the username in SharedPreferences
    print('Username saved: $username');  // Debugging step
  }

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;

    // Show loading indicator while fetching the name
    if (_isLoading) {
      return Scaffold(
        backgroundColor: TColor.white,
        body: Center(
          child: CircularProgressIndicator(),  // Show loading spinner
        ),
      );
    }

    return Scaffold(
      backgroundColor: TColor.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            width: media.width,
            padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 25),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              children: [
                SizedBox(
                  height: media.width * 0.1,
                ),
                Image.asset(
                  "assets/img/welcome.png",
                  width: media.width * 0.75,
                  fit: BoxFit.fitWidth,
                ),
                SizedBox(
                  height: media.width * 0.1,
                ),
                // Display the dynamic name here
                Text(
                  "Welcome, $userName", // Dynamic name from SharedPreferences
                  style: TextStyle(
                      color: TColor.black,
                      fontSize: 20,
                      fontWeight: FontWeight.w700),
                ),
                Text(
                  "You are all set now, let’s reach your\ngoals together with us",
                  textAlign: TextAlign.center,
                  style: TextStyle(color: TColor.gray, fontSize: 12),
                ),
                const SizedBox(height: 20), // Replaced Spacer with fixed size

                RoundButton(
                    title: "Go To Home",
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const MainTabView()));
                    }),
                SizedBox(height: 20), // Added space at the bottom
              ],
            ),
          ),
        ),
      ),
    );
  }
}
