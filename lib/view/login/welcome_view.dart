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
  String userName = "User";
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _getUserName();
  }

  Future<void> _getUserName() async {
    final prefs = await SharedPreferences.getInstance();
    String? storedName = prefs.getString('user_name');
    setState(() {
      userName = storedName ?? "User";
      _isLoading = false;
    });
  }

  Future<void> saveUserName(String username) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('user_name', username);
  }

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;

    if (_isLoading) {
      return Scaffold(
        backgroundColor: TColor.white,
        body: const Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return Scaffold(
      backgroundColor: TColor.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: LayoutBuilder(
            builder: (context, constraints) {
              double width = constraints.maxWidth;
              double blockSize = width / 100;

              return Container(
                width: width,
                padding: EdgeInsets.symmetric(
                    vertical: blockSize * 3, horizontal: blockSize * 5),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    SizedBox(height: blockSize * 10),
                    Image.asset(
                      "assets/img/welcome.png",
                      width: blockSize * 75,
                      fit: BoxFit.fitWidth,
                    ),
                    SizedBox(height: blockSize * 10),
                    Text(
                      "Welcome, $userName",
                      style: TextStyle(
                          color: TColor.black,
                          fontSize: blockSize * 5,
                          fontWeight: FontWeight.w700),
                    ),
                    Text(
                      "You are all set now, let’s reach your\ngoals together with us",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: TColor.gray, fontSize: blockSize * 3),
                    ),
                    SizedBox(height: blockSize * 5),
                    RoundButton(
                      title: "Go To Home",
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const MainTabView()),
                        );
                      },
                    ),
                    SizedBox(height: blockSize * 5),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
