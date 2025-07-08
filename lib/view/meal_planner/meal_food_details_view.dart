import 'package:flutter/material.dart';
import '../../common/colo_extension.dart';
import '../../common_widget/meal_category_cell.dart';
import '../../common_widget/meal_recommed_cell.dart';
import '../../common_widget/popular_meal_row.dart';
import 'food_info_details_view.dart';

class MealFoodDetailsView extends StatefulWidget {
  final Map eObj;
  const MealFoodDetailsView({super.key, required this.eObj});

  @override
  State<MealFoodDetailsView> createState() => _MealFoodDetailsViewState();
}

class _MealFoodDetailsViewState extends State<MealFoodDetailsView> {
  TextEditingController txtSearch = TextEditingController();

  List categoryArr = [
    {"name": "Salad", "image": "assets/img/c_1.png"},
    {"name": "Cake", "image": "assets/img/c_2.png"},
    {"name": "Pie", "image": "assets/img/c_3.png"},
    {"name": "Smoothies", "image": "assets/img/c_4.png"},
    {"name": "Salad", "image": "assets/img/c_1.png"},
    {"name": "Cake", "image": "assets/img/c_2.png"},
    {"name": "Pie", "image": "assets/img/c_3.png"},
    {"name": "Smoothies", "image": "assets/img/c_4.png"},
  ];

  List popularArr = [
    {
      "name": "Blueberry Pancake",
      "image": "assets/img/f_1.png",
      "b_image": "assets/img/pancake_1.png",
      "size": "Medium",
      "time": "30mins",
      "kcal": "230kCal"
    },
    {
      "name": "Salmon Nigiri",
      "image": "assets/img/f_2.png",
      "b_image": "assets/img/nigiri.png",
      "size": "Medium",
      "time": "20mins",
      "kcal": "120kCal"
    },
  ];

  List recommendArr = [
    {
      "name": "Honey Pancake",
      "image": "assets/img/rd_1.png",
      "size": "Easy",
      "time": "30mins",
      "kcal": "180kCal"
    },
    {
      "name": "Canai Bread",
      "image": "assets/img/m_4.png",
      "size": "Easy",
      "time": "20mins",
      "kcal": "230kCal"
    },
  ];

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;
    double scale = media.width / 375;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: TColor.white,
        centerTitle: true,
        elevation: 0,
        leading: InkWell(
          onTap: () => Navigator.pop(context),
          child: Container(
            margin: EdgeInsets.all(8 * scale),
            height: 40 * scale,
            width: 40 * scale,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: TColor.lightGray,
              borderRadius: BorderRadius.circular(10 * scale),
            ),
            child: Image.asset("assets/img/black_btn.png",
                width: 15 * scale, height: 15 * scale, fit: BoxFit.contain),
          ),
        ),
        title: Text(
          widget.eObj["name"].toString(),
          style: TextStyle(
              color: TColor.black,
              fontSize: 16 * scale,
              fontWeight: FontWeight.w700),
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
              child: Image.asset("assets/img/more_btn.png",
                  width: 15 * scale, height: 15 * scale, fit: BoxFit.contain),
            ),
          )
        ],
      ),
      backgroundColor: TColor.white,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              margin: EdgeInsets.symmetric(horizontal: 20 * scale),
              padding: EdgeInsets.symmetric(horizontal: 8 * scale),
              decoration: BoxDecoration(
                color: TColor.white,
                borderRadius: BorderRadius.circular(15 * scale),
                boxShadow: const [
                  BoxShadow(
                      color: Colors.black12,
                      blurRadius: 2,
                      offset: Offset(0, 1))
                ],
              ),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: txtSearch,
                      decoration: InputDecoration(
                        isDense: true,
                        focusedBorder: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        prefixIcon: Image.asset("assets/img/search.png",
                            width: 20 * scale, height: 20 * scale),
                        hintText: "Search Pancake",
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 8 * scale),
                    width: 1,
                    height: 25 * scale,
                    color: TColor.gray.withOpacity(0.3),
                  ),
                  InkWell(
                    onTap: () {},
                    child: Image.asset(
                      "assets/img/Filter.png",
                      width: 25 * scale,
                      height: 25 * scale,
                    ),
                  )
                ],
              ),
            ),
            SizedBox(height: media.width * 0.05),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20 * scale),
              child: Text(
                "Category",
                style: TextStyle(
                    color: TColor.black,
                    fontSize: 16 * scale,
                    fontWeight: FontWeight.w700),
              ),
            ),
            SizedBox(
              height: 120 * scale,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: EdgeInsets.symmetric(horizontal: 15 * scale),
                itemCount: categoryArr.length,
                itemBuilder: (context, index) {
                  var cObj = categoryArr[index];
                  return MealCategoryCell(
                    cObj: cObj,
                    index: index,
                  );
                },
              ),
            ),
            SizedBox(height: media.width * 0.05),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20 * scale),
              child: Text(
                "Recommendation\nfor Diet",
                style: TextStyle(
                    color: TColor.black,
                    fontSize: 16 * scale,
                    fontWeight: FontWeight.w700),
              ),
            ),
            SizedBox(
              height: media.width * 0.6,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: EdgeInsets.symmetric(horizontal: 15 * scale),
                itemCount: recommendArr.length,
                itemBuilder: (context, index) {
                  var fObj = recommendArr[index];
                  return MealRecommendCell(fObj: fObj, index: index);
                },
              ),
            ),
            SizedBox(height: media.width * 0.05),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20 * scale),
              child: Text(
                "Popular",
                style: TextStyle(
                    color: TColor.black,
                    fontSize: 16 * scale,
                    fontWeight: FontWeight.w700),
              ),
            ),
            ListView.builder(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              padding: EdgeInsets.symmetric(horizontal: 15 * scale),
              itemCount: popularArr.length,
              itemBuilder: (context, index) {
                var fObj = popularArr[index];
                return InkWell(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => FoodInfoDetailsView(
                              dObj: fObj, mObj: widget.eObj),
                        ));
                  },
                  child: PopularMealRow(mObj: fObj),
                );
              },
            ),
            SizedBox(height: media.width * 0.05),
          ],
        ),
      ),
    );
  }
}
