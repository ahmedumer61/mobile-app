import 'package:flutter/material.dart';

import '../../common/colo_extension.dart';
import '../../common_widget/round_button.dart';
import 'comparison_view.dart';

class PhotoProgressView extends StatefulWidget {
  const PhotoProgressView({super.key});

  @override
  State<PhotoProgressView> createState() => _PhotoProgressViewState();
}

class _PhotoProgressViewState extends State<PhotoProgressView> {
  List photoArr = [
    {
      "time": "2 June",
      "photo": [
        "assets/img/pp_1.png",
        "assets/img/pp_2.png",
        "assets/img/pp_3.png",
        "assets/img/pp_4.png",
      ]
    },
    {
      "time": "5 May",
      "photo": [
        "assets/img/pp_5.png",
        "assets/img/pp_6.png",
        "assets/img/pp_7.png",
        "assets/img/pp_8.png",
      ]
    }
  ];

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;
    double scale = media.width / 375;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: TColor.white,
        centerTitle: true,
        automaticallyImplyLeading: false,
        elevation: 0,
        leadingWidth: 0,
        leading: const SizedBox(),
        title: Text(
          "Progress Photo",
          style: TextStyle(
              color: TColor.black,
              fontSize: 16 * scale,
              fontWeight: FontWeight.w700),
        ),
      ),
      backgroundColor: TColor.white,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(
                  vertical: 10 * scale, horizontal: 20 * scale),
              child: Container(
                width: double.maxFinite,
                padding: EdgeInsets.all(15 * scale),
                decoration: BoxDecoration(
                    color: const Color(0xffFFE5E5),
                    borderRadius: BorderRadius.circular(20 * scale)),
                child: Row(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                          color: TColor.white,
                          borderRadius: BorderRadius.circular(30 * scale)),
                      width: 50 * scale,
                      height: 50 * scale,
                      alignment: Alignment.center,
                      child: Image.asset(
                        "assets/img/date_notifi.png",
                        width: 30 * scale,
                        height: 30 * scale,
                      ),
                    ),
                    SizedBox(width: 8 * scale),
                    Expanded(
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Reminder!",
                              style: TextStyle(
                                  color: Colors.red,
                                  fontSize: 12 * scale,
                                  fontWeight: FontWeight.w500),
                            ),
                            Text(
                              "Next Photos Fall On July 08",
                              style: TextStyle(
                                  color: TColor.black,
                                  fontSize: 14 * scale,
                                  fontWeight: FontWeight.w700),
                            ),
                          ]),
                    ),
                    Container(
                        height: 60 * scale,
                        alignment: Alignment.topRight,
                        child: IconButton(
                            onPressed: () {},
                            icon: Icon(
                              Icons.close,
                              color: TColor.gray,
                              size: 15 * scale,
                            )))
                  ],
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(
                  vertical: 10 * scale, horizontal: 20 * scale),
              child: Container(
                width: double.maxFinite,
                padding: EdgeInsets.all(20 * scale),
                height: media.width * 0.4,
                decoration: BoxDecoration(
                    gradient: LinearGradient(colors: [
                      TColor.primaryColor2.withOpacity(0.4),
                      TColor.primaryColor1.withOpacity(0.4)
                    ]),
                    borderRadius: BorderRadius.circular(20 * scale)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: 15 * scale),
                          Text(
                            "Track Your Progress Each\nMonth With Photo",
                            style: TextStyle(
                              color: TColor.black,
                              fontSize: 12 * scale,
                            ),
                          ),
                          const Spacer(),
                          SizedBox(
                            width: 110 * scale,
                            height: 35 * scale,
                            child: RoundButton(
                                title: "Learn More",
                                fontSize: 12 * scale,
                                onPressed: () {}),
                          )
                        ]),
                    Image.asset(
                      "assets/img/progress_each_photo.png",
                      width: media.width * 0.35,
                    )
                  ],
                ),
              ),
            ),
            SizedBox(height: media.width * 0.05),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 20 * scale),
              padding: EdgeInsets.symmetric(
                  vertical: 15 * scale, horizontal: 15 * scale),
              decoration: BoxDecoration(
                color: TColor.primaryColor2.withOpacity(0.3),
                borderRadius: BorderRadius.circular(15 * scale),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Compare my Photo",
                    style: TextStyle(
                        color: TColor.black,
                        fontSize: 14 * scale,
                        fontWeight: FontWeight.w500),
                  ),
                  SizedBox(
                    width: 100 * scale,
                    height: 25 * scale,
                    child: RoundButton(
                      title: "Compare",
                      type: RoundButtonType.bgGradient,
                      fontSize: 12 * scale,
                      fontWeight: FontWeight.w400,
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const ComparisonView(),
                          ),
                        );
                      },
                    ),
                  )
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(
                  vertical: 10 * scale, horizontal: 20 * scale),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Gallery",
                    style: TextStyle(
                        color: TColor.black,
                        fontSize: 16 * scale,
                        fontWeight: FontWeight.w700),
                  ),
                  TextButton(
                      onPressed: () {},
                      child: Text(
                        "See more",
                        style:
                            TextStyle(color: TColor.gray, fontSize: 12 * scale),
                      ))
                ],
              ),
            ),
            ListView.builder(
                padding: EdgeInsets.symmetric(horizontal: 16 * scale),
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: photoArr.length,
                itemBuilder: ((context, index) {
                  var pObj = photoArr[index] as Map? ?? {};
                  var imaArr = pObj["photo"] as List? ?? [];

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.all(8 * scale),
                        child: Text(
                          pObj["time"].toString(),
                          style: TextStyle(
                              color: TColor.gray, fontSize: 12 * scale),
                        ),
                      ),
                      SizedBox(
                        height: 100 * scale,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          padding: EdgeInsets.zero,
                          itemCount: imaArr.length,
                          itemBuilder: ((context, indexRow) {
                            return Container(
                              margin:
                                  EdgeInsets.symmetric(horizontal: 4 * scale),
                              width: 100 * scale,
                              decoration: BoxDecoration(
                                color: TColor.lightGray,
                                borderRadius: BorderRadius.circular(10 * scale),
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(10 * scale),
                                child: Image.asset(
                                  imaArr[indexRow] as String? ?? "",
                                  width: 100 * scale,
                                  height: 100 * scale,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            );
                          }),
                        ),
                      ),
                    ],
                  );
                })),
            SizedBox(height: media.width * 0.05),
          ],
        ),
      ),
      floatingActionButton: InkWell(
        onTap: () {
          // Add photo logic here
        },
        child: Container(
          width: 55 * scale,
          height: 55 * scale,
          decoration: BoxDecoration(
              gradient: LinearGradient(colors: TColor.secondaryG),
              borderRadius: BorderRadius.circular(27.5 * scale),
              boxShadow: const [
                BoxShadow(
                    color: Colors.black12, blurRadius: 5, offset: Offset(0, 2))
              ]),
          alignment: Alignment.center,
          child: Icon(
            Icons.photo_camera,
            size: 20 * scale,
            color: TColor.white,
          ),
        ),
      ),
    );
  }
}
