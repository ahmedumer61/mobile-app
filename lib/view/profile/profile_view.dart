import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../../common/colo_extension.dart';
import '../../common_widget/round_button.dart';
import '../../common_widget/setting_row.dart';
import '../../common_widget/title_subtitle_cell.dart';
import 'package:animated_toggle_switch/animated_toggle_switch.dart';
import '../login/login_view.dart';

class ProfileView extends StatefulWidget {
  @override
  _ProfileViewState createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  bool positive = false;
  String userName = "User";
  bool _isLoading = true;
  bool _isLoggingOut = false;

  @override
  void initState() {
    super.initState();
    _getUserData();
  }

  Future<void> _getUserData() async {
    final prefs = await SharedPreferences.getInstance();
    String? storedName = prefs.getString('user_name');

    setState(() {
      userName = storedName ?? "User";
      _isLoading = false;
    });
  }

  Future<void> _logout() async {
    setState(() {
      _isLoggingOut = true;
    });

    try {
      bool shouldLogout = await _showLogoutConfirmation();

      if (!shouldLogout) {
        setState(() {
          _isLoggingOut = false;
        });
        return;
      }

      await FirebaseAuth.instance.signOut();

      try {
        final GoogleSignIn googleSignIn = GoogleSignIn();
        if (await googleSignIn.isSignedIn()) {
          await googleSignIn.signOut();
        }
      } catch (googleSignOutError) {
        print('Google sign-out failed: $googleSignOutError');
      }

      final prefs = await SharedPreferences.getInstance();
      await prefs.clear();

      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => const LoginView()),
            (Route<dynamic> route) => false,
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Logout failed: ${e.toString()}'),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isLoggingOut = false;
        });
      }
    }
  }

  Future<bool> _showLogoutConfirmation() async {
    return await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirm Logout'),
          content: Text('Are you sure you want to logout?'),
          actions: <Widget>[
            TextButton(
              child: Text('Cancel'),
              onPressed: () => Navigator.of(context).pop(false),
            ),
            TextButton(
              child: Text('Logout'),
              style: TextButton.styleFrom(foregroundColor: Colors.red),
              onPressed: () => Navigator.of(context).pop(true),
            ),
          ],
        );
      },
    ) ?? false;
  }

  List accountArr = [
    {"image": "assets/img/p_personal.png", "name": "Personal Data", "tag": "1"},
    {"image": "assets/img/p_achi.png", "name": "Achievement", "tag": "2"},
    {"image": "assets/img/p_activity.png", "name": "Activity History", "tag": "3"},
    {"image": "assets/img/p_workout.png", "name": "Workout Progress", "tag": "4"},
  ];

  List otherArr = [
    {"image": "assets/img/p_contact.png", "name": "Contact Us", "tag": "5"},
    {"image": "assets/img/p_privacy.png", "name": "Privacy Policy", "tag": "6"},
    {"image": "assets/img/p_setting.png", "name": "Setting", "tag": "7"},
  ];

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;
    double scale = media.width / 390;

    return Transform.scale(
      scale: scale.clamp(0.85, 1.2),
      alignment: Alignment.topCenter,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: TColor.white,
          centerTitle: true,
          automaticallyImplyLeading: false,
          elevation: 0,
          leadingWidth: 0,
          title: Text(
            "Profile",
            style: TextStyle(
              color: TColor.black,
              fontSize: 16 * scale,
              fontWeight: FontWeight.w700,
            ),
          ),
          // ✅ Removed the actions (icon on top-right)
        ),
        backgroundColor: TColor.white,
        body: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(
              vertical: 15 * scale,
              horizontal: 25 * scale,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(30 * scale),
                      child: Image.asset(
                        "assets/img/u2.png",
                        width: 50 * scale,
                        height: 50 * scale,
                        fit: BoxFit.cover,
                      ),
                    ),
                    SizedBox(width: 15 * scale),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("$userName",
                              style: TextStyle(
                                  color: TColor.black,
                                  fontSize: 14 * scale,
                                  fontWeight: FontWeight.w500)),
                          Text("Lose a Fat Program",
                              style: TextStyle(
                                color: TColor.gray,
                                fontSize: 12 * scale,
                              ))
                        ],
                      ),
                    ),
                    SizedBox(
                      width: 70 * scale,
                      height: 25 * scale,
                      child: RoundButton(
                        title: _isLoggingOut ? "..." : "Logout",
                        type: RoundButtonType.bgGradient,
                        fontSize: 12 * scale,
                        fontWeight: FontWeight.w400,
                        onPressed: () {
                          if (!_isLoggingOut) {
                            _logout();
                          }
                        },
                      ),
                    )
                  ],
                ),
                SizedBox(height: 20 * scale),
                Container(
                  padding: EdgeInsets.all(16 * scale),
                  decoration: BoxDecoration(
                    color: TColor.secondaryG[0].withOpacity(0.1),
                    borderRadius: BorderRadius.circular(15 * scale),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.emoji_events,
                          color: TColor.secondaryG[0], size: 24 * scale),
                      SizedBox(width: 10 * scale),
                      Expanded(
                        child: Text(
                          "Welcome back, $userName!\nKeep pushing your limits today.",
                          style: TextStyle(
                            color: TColor.black,
                            fontSize: 14 * scale,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 25 * scale),
                buildSection("Account", accountArr, scale),
                SizedBox(height: 25 * scale),
                buildNotification(scale),
                SizedBox(height: 25 * scale),
                buildSection("Other", otherArr, scale),
                SizedBox(height: 25 * scale),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildSection(String title, List items, double scale) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 10 * scale, horizontal: 15 * scale),
      decoration: BoxDecoration(
        color: TColor.white,
        borderRadius: BorderRadius.circular(15 * scale),
        boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 2)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
              style: TextStyle(
                  color: TColor.black,
                  fontSize: 16 * scale,
                  fontWeight: FontWeight.w700)),
          SizedBox(height: 8 * scale),
          ListView.builder(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: items.length,
            itemBuilder: (context, index) {
              var iObj = items[index] as Map? ?? {};
              return SettingRow(
                icon: iObj["image"].toString(),
                title: iObj["name"].toString(),
                onPressed: () {},
              );
            },
          )
        ],
      ),
    );
  }

  Widget buildNotification(double scale) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 10 * scale, horizontal: 15 * scale),
      decoration: BoxDecoration(
        color: TColor.white,
        borderRadius: BorderRadius.circular(15 * scale),
        boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 2)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Notification",
              style: TextStyle(
                  color: TColor.black,
                  fontSize: 16 * scale,
                  fontWeight: FontWeight.w700)),
          SizedBox(height: 8 * scale),
          Row(
            children: [
              Image.asset("assets/img/p_notification.png",
                  height: 15 * scale, width: 15 * scale, fit: BoxFit.contain),
              SizedBox(width: 15 * scale),
              Expanded(
                child: Text("Pop-up Notification",
                    style: TextStyle(color: TColor.black, fontSize: 12 * scale)),
              ),
              CustomAnimatedToggleSwitch<bool>(
                current: positive,
                values: [false, true],
                dif: 0.0,
                indicatorSize: Size.square(30.0 * scale),
                animationDuration: const Duration(milliseconds: 200),
                animationCurve: Curves.linear,
                onChanged: (b) => setState(() => positive = b),
                iconBuilder: (context, local, global) => const SizedBox(),
                defaultCursor: SystemMouseCursors.click,
                onTap: () => setState(() => positive = !positive),
                iconsTappable: false,
                wrapperBuilder: (context, global, child) => Stack(
                  alignment: Alignment.center,
                  children: [
                    Positioned(
                      left: 10.0 * scale,
                      right: 10.0 * scale,
                      height: 30.0 * scale,
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(colors: TColor.secondaryG),
                          borderRadius: BorderRadius.circular(50.0 * scale),
                        ),
                      ),
                    ),
                    child,
                  ],
                ),
                foregroundIndicatorBuilder: (context, global) =>
                    SizedBox.fromSize(
                      size: Size(10 * scale, 10 * scale),
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          color: TColor.white,
                          borderRadius: BorderRadius.circular(50.0 * scale),
                          boxShadow: const [
                            BoxShadow(
                              color: Colors.black38,
                              spreadRadius: 0.05,
                              blurRadius: 1.1,
                              offset: Offset(0.0, 0.8),
                            )
                          ],
                        ),
                      ),
                    ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
