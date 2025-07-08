import 'package:fitness_app/common_widget/icon_title_next_row.dart';
import 'package:fitness_app/common_widget/round_button.dart';
import 'package:flutter/material.dart';

import '../../common/colo_extension.dart';

class ComparisonView extends StatefulWidget {
  const ComparisonView({super.key});

  @override
  State<ComparisonView> createState() => _ComparisonViewState();
}

class _ComparisonViewState extends State<ComparisonView> {
  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;
    double scale = media.width / 375; // Base width for scaling

    return Scaffold(
      appBar: AppBar(
        backgroundColor: TColor.white,
        centerTitle: true,
        elevation: 0,
        leading: InkWell(
          onTap: () {
            Navigator.pop(context);
          },
          child: Container(
            margin: EdgeInsets.all(8 * scale),
            height: 40 * scale,
            width: 40 * scale,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: TColor.lightGray,
              borderRadius: BorderRadius.circular(10 * scale),
            ),
            child: Image.asset(
              "assets/img/black_btn.png",
              width: 15 * scale,
              height: 15 * scale,
              fit: BoxFit.contain,
            ),
          ),
        ),
        title: Text(
          "Comparison",
          style: TextStyle(
            color: TColor.black,
            fontSize: 16 * scale,
            fontWeight: FontWeight.w700,
          ),
        ),
        actions: [
          InkWell(
            onTap: () {},
            child: Container(
              margin: EdgeInsets.all(8 * scale),
              height: 40 * scale,
              width: 40 * scale,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: TColor.lightGray,
                borderRadius: BorderRadius.circular(10 * scale),
              ),
              child: Image.asset(
                "assets/img/more_btn.png",
                width: 15 * scale,
                height: 15 * scale,
                fit: BoxFit.contain,
              ),
            ),
          )
        ],
      ),
      backgroundColor: TColor.white,
      body: Padding(
        padding: EdgeInsets.symmetric(
          vertical: 20 * scale,
          horizontal: 20 * scale,
        ),
        child: Column(
          children: [
            IconTitleNextRow(
              icon: "assets/img/date.png",
              title: "Select Month 1",
              time: "May",
              onPressed: () {},
              color: TColor.lightGray,
            ),
            SizedBox(height: 15 * scale),
            IconTitleNextRow(
              icon: "assets/img/date.png",
              title: "Select Month 2",
              time: "select Month",
              onPressed: () {},
              color: TColor.lightGray,
            ),
            const Spacer(),
            RoundButton(
              title: "Compare",
              onPressed: () {
                // Navigator logic here
              },
            ),
            SizedBox(height: 15 * scale),
          ],
        ),
      ),
    );
  }
}
