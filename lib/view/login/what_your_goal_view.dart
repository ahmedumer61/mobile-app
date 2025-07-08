import 'package:carousel_slider/carousel_slider.dart';
import 'package:fitness_app/view/login/complete_profile_view.dart';
import 'package:flutter/material.dart';
import '../../common/colo_extension.dart';
import '../../common_widget/round_button.dart';

class WhatYourGoalView extends StatefulWidget {
  const WhatYourGoalView({super.key});

  @override
  State<WhatYourGoalView> createState() => _WhatYourGoalViewState();
}

class _WhatYourGoalViewState extends State<WhatYourGoalView> {
  List goalArr = [
    {
      "image": "assets/img/goal_1.png",
      "title": "Improve Shape",
      "subtitle":
          "I have a low amount of body fat\nand need / want to build more\nmuscle"
    },
    {
      "image": "assets/img/goal_2.png",
      "title": "Lean & Tone",
      "subtitle":
          "I’m “skinny fat”. look thin but have\nno shape. I want to add learn\nmuscle in the right way"
    },
    {
      "image": "assets/img/goal_3.png",
      "title": "Lose a Fat",
      "subtitle":
          "I have over 20 lbs to lose. I want to\ndrop all this fat and gain muscle\nmass"
    },
  ];

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: TColor.white,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            double width = constraints.maxWidth;
            double blockSize = width / 100;

            return Stack(
              children: [
                Center(
                  child: CarouselSlider(
                    items: goalArr
                        .map(
                          (gObj) => Container(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: TColor.primaryG,
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                              borderRadius: BorderRadius.circular(25),
                            ),
                            padding: EdgeInsets.symmetric(
                              vertical: blockSize * 10,
                              horizontal: blockSize * 5,
                            ),
                            alignment: Alignment.center,
                            child: FittedBox(
                              child: Column(
                                children: [
                                  Image.asset(
                                    gObj["image"].toString(),
                                    width: blockSize * 50,
                                    fit: BoxFit.fitWidth,
                                  ),
                                  SizedBox(height: blockSize * 10),
                                  Text(
                                    gObj["title"].toString(),
                                    style: TextStyle(
                                      color: TColor.white,
                                      fontSize: blockSize * 4.2,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                  Container(
                                    width: blockSize * 10,
                                    height: 1,
                                    color: TColor.white,
                                  ),
                                  SizedBox(height: blockSize * 2),
                                  Text(
                                    gObj["subtitle"].toString(),
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: TColor.white,
                                      fontSize: blockSize * 3,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        )
                        .toList(),
                    options: CarouselOptions(
                      autoPlay: false,
                      enlargeCenterPage: true,
                      viewportFraction: 0.7,
                      aspectRatio: 0.74,
                      initialPage: 0,
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: blockSize * 5),
                  width: width,
                  child: Column(
                    children: [
                      SizedBox(height: blockSize * 5),
                      Text(
                        "What is your goal ?",
                        style: TextStyle(
                          color: TColor.black,
                          fontSize: blockSize * 5,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      Text(
                        "It will help us to choose a best\nprogram for you",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: TColor.gray,
                          fontSize: blockSize * 3.2,
                        ),
                      ),
                      const Spacer(),
                      SizedBox(height: blockSize * 5),
                      RoundButton(
                        title: "Confirm",
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>  CompleteProfileView(),
                            ),
                          );
                        },
                      ),
                      SizedBox(height: blockSize * 5),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
