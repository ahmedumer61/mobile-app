import 'package:firebase_auth/firebase_auth.dart';
import 'package:fitness_app/view/home/home_view.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:fitness_app/common/colo_extension.dart';
import 'package:fitness_app/common_widget/round_button.dart';
import 'package:fitness_app/common_widget/round_textfield.dart';
import 'package:fitness_app/view/login/complete_profile_view.dart';
import 'package:fitness_app/view/login/signup_view.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/foundation.dart'; // For checking if it's web platform

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
    setState(() {
      isLoading = true;
    });

    try {
      UserCredential userCredential =
          await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      // Extract username (before '@') from email
      String email = userCredential.user?.email ?? "User";
      String username = email.split('@')[0]; // Get part before '@'

      // Save the username to SharedPreferences
      await saveUserName(username);

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const CompleteProfileView()),
      );
    } on FirebaseAuthException catch (e) {
      _showErrorDialog(e.message ?? "Authentication failed.");
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  // Save username to SharedPreferences
  Future<void> saveUserName(String username) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('user_name', username); // Save only the username part
    print('Username saved: $username');
  }

  Future<void> signInWithGoogle() async {
    setState(() {
      isLoading = true;
    });

    try {
      final GoogleSignIn googleSignIn = GoogleSignIn(
        clientId:
            "1052699764012-mab61it75e9d7mnttv6dte9ifd6h6iqk.apps.googleusercontent.com", // Replace with your actual Web client ID
        scopes: ['email'],
      );

      final GoogleSignInAccount? googleUser = await googleSignIn.signIn();

      if (googleUser == null) {
        _showErrorDialog("Google sign-in canceled by user.");
        return;
      }

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      if (googleAuth.accessToken == null || googleAuth.idToken == null) {
        _showErrorDialog("Google sign-in failed. Missing tokens.");
        return;
      }

      final OAuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      await FirebaseAuth.instance.signInWithCredential(credential);

      // Extract username (before '@') from email or use displayName
      String email = googleUser.email;
      String username = email.split('@')[0]; // Get part before '@'

      // Save the username to SharedPreferences
      await saveUserName(username);

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const CompleteProfileView()),
      );
    } catch (e) {
      print("Error during Google sign-in: $e");
      _showErrorDialog("Failed to sign in with Google. Try again.");
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Error"),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("OK"),
          ),
        ],
      ),
    );
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
            child: Stack(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text("Hey there,",
                        style: TextStyle(color: TColor.gray, fontSize: 16)),
                    Text("Welcome Back",
                        style: TextStyle(
                            color: TColor.black,
                            fontSize: 20,
                            fontWeight: FontWeight.w700)),
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
                    RoundButton(
                        title: "Login",
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const HomeView()));
                        }),
                    SizedBox(height: media.width * 0.04),
                    Row(
                      children: [
                        Expanded(
                            child:
                                Divider(color: TColor.gray.withOpacity(0.5))),
                        Text("  Or  ",
                            style:
                                TextStyle(color: TColor.black, fontSize: 12)),
                        Expanded(
                            child:
                                Divider(color: TColor.gray.withOpacity(0.5))),
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
                          border: Border.all(
                              width: 1, color: TColor.gray.withOpacity(0.4)),
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Image.asset("assets/img/google.png",
                            width: 20, height: 20),
                      ),
                    ),
                    SizedBox(height: media.width * 0.04),
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const SignUpView()));
                      },
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text("Don’t have an account yet? ",
                              style:
                                  TextStyle(color: TColor.black, fontSize: 14)),
                          Text("Register",
                              style: TextStyle(
                                  color: TColor.black,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w700)),
                        ],
                      ),
                    ),
                    SizedBox(height: media.width * 0.04),
                  ],
                ),
                if (isLoading)
                  Center(
                    child: Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        color: Colors.black54,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const CircularProgressIndicator(),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
