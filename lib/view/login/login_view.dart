import 'package:firebase_auth/firebase_auth.dart';
import 'package:fitness_app/view/login/signup_view.dart';
import 'package:fitness_app/view/login/what_your_goal_view.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:fitness_app/common/colo_extension.dart';
import 'package:fitness_app/common_widget/round_button.dart';
import 'package:fitness_app/common_widget/round_textfield.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> loginUser() async {
    setState(() => isLoading = true);
    try {
      UserCredential userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      final email = userCredential.user?.email ?? "User";
      final username = email.split('@')[0];
      await saveUserName(username);

      Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => WhatYourGoalView()));
    } on FirebaseAuthException catch (e) {
      _showErrorSnackbar(e.message ?? "Authentication failed.");
    } finally {
      setState(() => isLoading = false);
    }
  }

  Future<void> saveUserName(String username) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('user_name', username);
  }

  Future<void> signInWithGoogle() async {
    setState(() => isLoading = true);

    try {
      if (kIsWeb) {
        GoogleAuthProvider googleProvider = GoogleAuthProvider();
        UserCredential userCredential = await FirebaseAuth.instance.signInWithPopup(googleProvider);

        final email = userCredential.user?.email ?? "User";
        final username = email.split('@')[0];
        await saveUserName(username);
      } else {
        final GoogleSignIn googleSignIn = GoogleSignIn(scopes: ['email']);
        final GoogleSignInAccount? googleUser = await googleSignIn.signIn();

        if (googleUser == null) {
          _showErrorSnackbar("Google sign-in canceled.");
          return;
        }

        final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

        if (googleAuth.idToken == null || googleAuth.accessToken == null) {
          _showErrorSnackbar("Google Auth Token missing.");
          return;
        }

        final credential = GoogleAuthProvider.credential(
          idToken: googleAuth.idToken,
          accessToken: googleAuth.accessToken,
        );

        final userCredential = await FirebaseAuth.instance.signInWithCredential(credential);

        final email = userCredential.user?.email ?? "User";
        final username = email.split('@')[0];
        await saveUserName(username);
      }

      Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => WhatYourGoalView()));
    } catch (e) {
      debugPrint("Google Sign-In Error: $e");
      _showErrorSnackbar("Google Sign-In failed: ${e.toString()}");
    } finally {
      setState(() => isLoading = false);
    }
  }

  void _showErrorSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _navigateToRegister() {
    Navigator.push(context, MaterialPageRoute(builder: (_) => SignUpView()));
  }

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: TColor.white,
      body: SingleChildScrollView(
        child: SafeArea(
          child: Container(
            height: media.height * 0.9,
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text("Hey there,", style: TextStyle(color: TColor.gray, fontSize: 16)),
                Text("Welcome Back", style: TextStyle(color: TColor.black, fontSize: 20, fontWeight: FontWeight.w700)),
                SizedBox(height: media.width * 0.05),
                RoundTextField(
                  controller: _emailController,
                  hitText: "Email",
                  icon: "assets/img/email.png",
                  keyboardType: TextInputType.emailAddress,
                ),
                SizedBox(height: media.width * 0.04),
                RoundTextField(
                  controller: _passwordController,
                  hitText: "Password",
                  icon: "assets/img/lock.png",
                  obscureText: true,
                ),
                const Spacer(),
                RoundButton(title: "Login", onPressed: loginUser),
                SizedBox(height: media.width * 0.04),
                Row(
                  children: [
                    Expanded(child: Divider(color: TColor.gray.withOpacity(0.5))),
                    Text("  Or  ", style: TextStyle(color: TColor.black, fontSize: 12)),
                    Expanded(child: Divider(color: TColor.gray.withOpacity(0.5))),
                  ],
                ),
                SizedBox(height: media.width * 0.04),
                GestureDetector(
                  onTap: signInWithGoogle,
                  child: Container(
                    width: 50,
                    height: 50,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: TColor.white,
                      border: Border.all(width: 1, color: TColor.gray.withOpacity(0.4)),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Image.asset("assets/img/google.png", width: 20, height: 20),
                  ),
                ),
                SizedBox(height: media.width * 0.04),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text("Don't have an account yet? ", style: TextStyle(color: TColor.black, fontSize: 14)),
                    GestureDetector(
                      onTap: _navigateToRegister,
                      child: Text("Register", style: TextStyle(
                        color: TColor.primaryColor1,
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        decoration: TextDecoration.underline,
                      )),
                    ),
                  ],
                ),
                SizedBox(height: media.width * 0.04),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
