import 'package:flutter/material.dart';
import 'package:readmore/readmore.dart';
import '../../common/colo_extension.dart';
import '../../common_widget/food_step_detail_row.dart';
import '../../common_widget/round_button.dart';
import 'meal_schedule_view.dart';

class FoodInfoDetailsView extends StatefulWidget {
  final Map mObj;
  final Map dObj;
  const FoodInfoDetailsView(
      {super.key, required this.dObj, required this.mObj});

  @override
  State<FoodInfoDetailsView> createState() => _FoodInfoDetailsViewState();
}

class _FoodInfoDetailsViewState extends State<FoodInfoDetailsView> {
  List nutritionArr = [
    {"image": "assets/img/burn.png", "title": "180kCal"},
    {"image": "assets/img/egg.png", "title": "30g fats"},
    {"image": "assets/img/proteins.png", "title": "20g proteins"},
    {"image": "assets/img/carbo.png", "title": "50g carbo"},
  ];

  List ingredientsArr = [
    {
      "image": "assets/img/flour.png",
      "title": "Wheat Flour",
      "value": "100grm"
    },
    {"image": "assets/img/sugar.png", "title": "Sugar", "value": "3 tbsp"},
    {
      "image": "assets/img/baking_soda.png",
      "title": "Baking Soda",
      "value": "2tsp"
    },
    {"image": "assets/img/eggs.png", "title": "Eggs", "value": "2 items"},
  ];

  List stepArr = [
    {"no": "1", "detail": "Prepare all of the ingredients that needed"},
    {"no": "2", "detail": "Mix flour, sugar, salt, and baking powder"},
    {
      "no": "3",
      "detail":
          "In a separate place, mix the eggs and liquid milk until blended"
    },
    {
      "no": "4",
      "detail":
          "Put the egg and milk mixture into the dry ingredients, stir until smooth"
    },
    {"no": "5", "detail": "Prepare all of the ingredients that needed"},
  ];

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;
    double scale = media.width / 375;

    return Container(
      decoration:
          BoxDecoration(gradient: LinearGradient(colors: TColor.primaryG)),
      child: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) {
          return [
            SliverAppBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
              centerTitle: true,
              leading: InkWell(
                onTap: () => Navigator.pop(context),
                child: Container(
                  margin: EdgeInsets.all(8 * scale),
                  height: 40 * scale,
                  width: 40 * scale,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                      color: TColor.lightGray,
                      borderRadius: BorderRadius.circular(10 * scale)),
                  child: Image.asset("assets/img/black_btn.png",
                      width: 15 * scale, height: 15 * scale),
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
                        borderRadius: BorderRadius.circular(10 * scale)),
                    child: Image.asset("assets/img/more_btn.png",
                        width: 15 * scale, height: 15 * scale),
                  ),
                )
              ],
            ),
            SliverAppBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
              centerTitle: true,
              leadingWidth: 0,
              leading: Container(),
              expandedHeight: media.width * 0.5,
              flexibleSpace: ClipRect(
                child: Stack(
                  alignment: Alignment.bottomCenter,
                  children: [
                    Transform.scale(
                      scale: 1.25,
                      child: Container(
                        width: media.width * 0.55,
                        height: media.width * 0.55,
                        decoration: BoxDecoration(
                          color: Colors.white24,
                          borderRadius:
                              BorderRadius.circular(media.width * 0.275),
                        ),
                      ),
                    ),
                    Transform.scale(
                      scale: 1.25,
                      child: Image.asset(
                        widget.dObj["b_image"].toString(),
                        width: media.width * 0.50,
                        height: media.width * 0.50,
                        fit: BoxFit.contain,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ];
        },
        body: Container(
          decoration: BoxDecoration(
              color: TColor.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(25 * scale),
                topRight: Radius.circular(25 * scale),
              )),
          child: Scaffold(
            backgroundColor: Colors.transparent,
            body: Stack(
              children: [
                SingleChildScrollView(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 15 * scale),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 10 * scale),
                        Center(
                          child: Container(
                            width: 50 * scale,
                            height: 4 * scale,
                            decoration: BoxDecoration(
                              color: TColor.gray.withOpacity(0.3),
                              borderRadius: BorderRadius.circular(3 * scale),
                            ),
                          ),
                        ),
                        SizedBox(height: 20 * scale),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    widget.dObj["name"].toString(),
                                    style: TextStyle(
                                      color: TColor.black,
                                      fontSize: 16 * scale,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                  Text("Ahmed Umer",
                                      style: TextStyle(
                                        color: TColor.gray,
                                        fontSize: 12 * scale,
                                      )),
                                ],
                              ),
                            ),
                            TextButton(
                              onPressed: () {},
                              child: Image.asset(
                                "assets/img/fav.png",
                                width: 15 * scale,
                                height: 15 * scale,
                              ),
                            )
                          ],
                        ),
                        SizedBox(height: 20 * scale),
                        Text(
                          "Nutrition",
                          style: TextStyle(
                            color: TColor.black,
                            fontSize: 16 * scale,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        SizedBox(
                          height: 50 * scale,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: nutritionArr.length,
                            itemBuilder: (context, index) {
                              var nObj = nutritionArr[index];
                              return Container(
                                margin: EdgeInsets.symmetric(
                                    vertical: 8 * scale, horizontal: 4 * scale),
                                padding:
                                    EdgeInsets.symmetric(horizontal: 8 * scale),
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [
                                      TColor.primaryColor2.withOpacity(0.4),
                                      TColor.primaryColor1.withOpacity(0.4),
                                    ],
                                  ),
                                  borderRadius:
                                      BorderRadius.circular(10 * scale),
                                ),
                                child: Row(
                                  children: [
                                    Image.asset(
                                      nObj["image"],
                                      width: 15 * scale,
                                      height: 15 * scale,
                                    ),
                                    Padding(
                                      padding: EdgeInsets.all(8.0 * scale),
                                      child: Text(
                                        nObj["title"],
                                        style: TextStyle(
                                            color: TColor.black,
                                            fontSize: 12 * scale),
                                      ),
                                    )
                                  ],
                                ),
                              );
                            },
                          ),
                        ),
                        SizedBox(height: 20 * scale),
                        Text(
                          "Descriptions",
                          style: TextStyle(
                              color: TColor.black,
                              fontSize: 16 * scale,
                              fontWeight: FontWeight.w700),
                        ),
                        SizedBox(height: 4 * scale),
                        ReadMoreText(
                          'Pancakes are some people\'s favorite breakfast, who doesn\'t like pancakes?...',
                          trimLines: 4,
                          trimMode: TrimMode.Line,
                          trimCollapsedText: ' Read More ...',
                          trimExpandedText: ' Read Less',
                          colorClickableText: TColor.black,
                          style: TextStyle(
                              color: TColor.gray, fontSize: 12 * scale),
                          moreStyle: TextStyle(
                              fontSize: 12 * scale,
                              fontWeight: FontWeight.w700),
                        ),
                        SizedBox(height: 15 * scale),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("Ingredients That You\nWill Need",
                                style: TextStyle(
                                    color: TColor.black,
                                    fontSize: 16 * scale,
                                    fontWeight: FontWeight.w700)),
                            TextButton(
                              onPressed: () {},
                              child: Text("${stepArr.length} Items",
                                  style: TextStyle(
                                      color: TColor.gray,
                                      fontSize: 12 * scale)),
                            )
                          ],
                        ),
                        SizedBox(
                          height: (media.width * 0.25) + 40 * scale,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: ingredientsArr.length,
                            itemBuilder: (context, index) {
                              var iObj = ingredientsArr[index];
                              return Container(
                                width: media.width * 0.23,
                                margin:
                                    EdgeInsets.symmetric(horizontal: 4 * scale),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      height: media.width * 0.23,
                                      decoration: BoxDecoration(
                                        color: TColor.lightGray,
                                        borderRadius:
                                            BorderRadius.circular(10 * scale),
                                      ),
                                      alignment: Alignment.center,
                                      child: Image.asset(
                                        iObj["image"],
                                        width: 45 * scale,
                                        height: 45 * scale,
                                      ),
                                    ),
                                    SizedBox(height: 4 * scale),
                                    Text(iObj["title"],
                                        style: TextStyle(
                                            fontSize: 12 * scale,
                                            color: TColor.black)),
                                    Text(iObj["value"],
                                        style: TextStyle(
                                            fontSize: 10 * scale,
                                            color: TColor.gray)),
                                  ],
                                ),
                              );
                            },
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("Step by Step",
                                style: TextStyle(
                                    fontSize: 16 * scale,
                                    fontWeight: FontWeight.w700,
                                    color: TColor.black)),
                            TextButton(
                              onPressed: () {},
                              child: Text("${stepArr.length} Steps",
                                  style: TextStyle(
                                      color: TColor.gray,
                                      fontSize: 12 * scale)),
                            ),
                          ],
                        ),
                        ListView.builder(
                          itemCount: stepArr.length,
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemBuilder: (context, index) {
                            var sObj = stepArr[index];
                            return FoodStepDetailRow(
                                sObj: sObj,
                                isLast: index == stepArr.length - 1);
                          },
                        ),
                        SizedBox(height: media.width * 0.25),
                      ],
                    ),
                  ),
                ),
                SafeArea(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 15 * scale),
                        child: RoundButton(
                          title: "Add to ${widget.mObj["name"]} Meal",
                          onPressed: () {},
                        ),
                      ),
                      SizedBox(height: 15 * scale),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
