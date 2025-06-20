import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../common_widget/round_button.dart';
import '../../common_widget/round_textfield.dart';
import '../../common/colo_extension.dart';
import '../login/what_your_goal_view.dart';

class CompleteProfileView extends StatefulWidget {
  const CompleteProfileView({super.key});

  @override
  State<CompleteProfileView> createState() => _CompleteProfileViewState();
}

class _CompleteProfileViewState extends State<CompleteProfileView> {
  // Controllers for profile data
  TextEditingController txtDateOfBirth = TextEditingController();
  TextEditingController txtWeight = TextEditingController();
  TextEditingController txtHeight = TextEditingController();
  String gender = 'Male';  // Default gender

  // Save profile info using SharedPreferences
  Future<void> saveProfileInfo(String gender, String dob, String weight, String height) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('gender', gender);
    await prefs.setString('dob', dob);
    await prefs.setString('weight', weight);
    await prefs.setString('height', height);
    print('Profile information saved');
  }

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: TColor.white,
      body: SingleChildScrollView(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Column(
              children: [
                Image.asset(
                  "assets/img/complete_profile.png",
                  width: media.width,
                  fit: BoxFit.fitWidth,
                ),
                SizedBox(
                  height: media.width * 0.05,
                ),
                Text(
                  "Let’s complete your profile",
                  style: TextStyle(
                      color: TColor.black,
                      fontSize: 20,
                      fontWeight: FontWeight.w700),
                ),
                Text(
                  "It will help us to know more about you!",
                  style: TextStyle(color: TColor.gray, fontSize: 12),
                ),
                SizedBox(
                  height: media.width * 0.05,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15.0),
                  child: Column(
                    children: [
                      // Gender selection
                      DropdownButtonHideUnderline(
                        child: DropdownButton(
                          items: ["Male", "Female"]
                              .map((name) => DropdownMenuItem(
                            value: name,
                            child: Text(
                              name,
                              style: TextStyle(
                                  color: TColor.gray,
                                  fontSize: 14),
                            ),
                          ))
                              .toList(),
                          onChanged: (value) {
                            setState(() {
                              gender = value!;
                            });
                          },
                          isExpanded: true,
                          hint: Text(
                            "Choose Gender",
                            style: TextStyle(
                                color: TColor.gray, fontSize: 12),
                          ),
                        ),
                      ),
                      // Date of Birth
                      RoundTextField(
                        controller: txtDateOfBirth,
                        hitText: "Date of Birth",
                        icon: "assets/img/date.png",
                      ),
                      SizedBox(
                        height: media.width * 0.04,
                      ),
                      // Weight
                      Row(
                        children: [
                          Expanded(
                            child: RoundTextField(
                              controller: txtWeight,
                              hitText: "Your Weight",
                              icon: "assets/img/weight.png",
                            ),
                          ),
                          const SizedBox(
                            width: 8,
                          ),
                          Container(
                            width: 50,
                            height: 50,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: TColor.secondaryG,
                              ),
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: Text(
                              "KG",
                              style:
                              TextStyle(color: TColor.white, fontSize: 12),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: media.width * 0.04,
                      ),
                      // Height
                      Row(
                        children: [
                          Expanded(
                            child: RoundTextField(
                              controller: txtHeight,
                              hitText: "Your Height",
                              icon: "assets/img/hight.png",
                            ),
                          ),
                          const SizedBox(
                            width: 8,
                          ),
                          Container(
                            width: 50,
                            height: 50,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: TColor.secondaryG,
                              ),
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: Text(
                              "CM",
                              style:
                              TextStyle(color: TColor.white, fontSize: 12),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: media.width * 0.07,
                      ),
                      // Next button
                      RoundButton(
                          title: "Next >",
                          onPressed: () {
                            saveProfileInfo(
                              gender,
                              txtDateOfBirth.text,
                              txtWeight.text,
                              txtHeight.text,
                            );
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                    const WhatYourGoalView()));
                          }),
                    ],
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
