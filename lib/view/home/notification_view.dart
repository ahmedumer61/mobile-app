import 'package:flutter/material.dart';
import '../../common/colo_extension.dart';
import '../../common_widget/notification_row.dart';

class NotificationView extends StatefulWidget {
  const NotificationView({super.key});

  @override
  State<NotificationView> createState() => _NotificationViewState();
}

class _NotificationViewState extends State<NotificationView> {
  List notificationArr = [
    {
      "image": "assets/img/Workout1.png",
      "title": "Hey, it’s time for lunch",
      "time": "About 1 minutes ago"
    },
    {
      "image": "assets/img/Workout2.png",
      "title": "Don’t miss your lowerbody workout",
      "time": "About 3 hours ago"
    },
    {
      "image": "assets/img/Workout3.png",
      "title": "Hey, let’s add some meals for your b",
      "time": "About 3 hours ago"
    },
    {
      "image": "assets/img/Workout1.png",
      "title": "Congratulations, You have finished A..",
      "time": "29 May"
    },
    {
      "image": "assets/img/Workout2.png",
      "title": "Hey, it’s time for lunch",
      "time": "8 April"
    },
    {
      "image": "assets/img/Workout3.png",
      "title": "Ups, You have missed your Lowerbo...",
      "time": "8 April"
    },
  ];

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context).size;
    final width = media.width;
    final height = media.height;
    final scale = width / 375.0; // Base screen width used for scaling

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
          "Notification",
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
                width: 12 * scale,
                height: 12 * scale,
                fit: BoxFit.contain,
              ),
            ),
          )
        ],
      ),
      backgroundColor: TColor.white,
      body: Padding(
        padding: EdgeInsets.symmetric(
          vertical: 15 * scale,
          horizontal: 25 * scale,
        ),
        child: ListView.separated(
          itemCount: notificationArr.length,
          itemBuilder: (context, index) {
            var nObj = notificationArr[index] as Map? ?? {};
            return NotificationRow(
                nObj: nObj); // Ensure NotificationRow handles responsiveness
          },
          separatorBuilder: (context, index) {
            return Divider(
              color: TColor.gray.withOpacity(0.5),
              height: 1 * scale,
            );
          },
        ),
      ),
    );
  }
}
