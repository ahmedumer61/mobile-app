import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../../common/colo_extension.dart';
import '../../common_widget/find_eat_cell.dart';
import '../../common_widget/round_button.dart';
import '../../common_widget/today_meal_row.dart';
import '../../models/health_plan.dart';
import 'meal_food_details_view.dart';
import 'meal_schedule_view.dart';

class MealPlannerView extends StatefulWidget {
  final HealthPlan? healthPlan;

  const MealPlannerView({super.key, this.healthPlan});

  @override
  State<MealPlannerView> createState() => _MealPlannerViewState();
}

class _MealPlannerViewState extends State<MealPlannerView> {
  List todayMealArr = [
    {
      "name": "Salmon Nigiri",
      "image": "assets/img/m_1.png",
      "time": "28/05/2023 07:00 AM"
    },
    {
      "name": "Lowfat Milk",
      "image": "assets/img/m_2.png",
      "time": "28/05/2023 08:00 AM"
    },
  ];

  List findEatArr = [
    {
      "name": "Breakfast",
      "image": "assets/img/m_3.png",
      "number": "120+ Foods"
    },
    {"name": "Lunch", "image": "assets/img/m_4.png", "number": "130+ Foods"},
  ];

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;

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
            margin: const EdgeInsets.all(8),
            height: 40,
            width: 40,
            alignment: Alignment.center,
            decoration: BoxDecoration(
                color: TColor.lightGray,
                borderRadius: BorderRadius.circular(10)),
            child: Image.asset(
              "assets/img/black_btn.png",
              width: 15,
              height: 15,
              fit: BoxFit.contain,
            ),
          ),
        ),
        title: Text(
          "Meal Planner",
          style: TextStyle(
              color: TColor.black, fontSize: 16, fontWeight: FontWeight.w700),
        ),
        actions: [
          InkWell(
            onTap: () {},
            child: Container(
              margin: const EdgeInsets.all(8),
              height: 40,
              width: 40,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                  color: TColor.lightGray,
                  borderRadius: BorderRadius.circular(10)),
              child: Image.asset(
                "assets/img/more_btn.png",
                width: 15,
                height: 15,
                fit: BoxFit.contain,
              ),
            ),
          )
        ],
      ),
      backgroundColor: TColor.white,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Meal Nutritions",
                        style: TextStyle(
                            color: TColor.black,
                            fontSize: 16,
                            fontWeight: FontWeight.w700),
                      ),
                      Container(
                          height: 30,
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(colors: TColor.primaryG),
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton(
                              items: ["Weekly", "Monthly"]
                                  .map((name) => DropdownMenuItem(
                                value: name,
                                child: Text(
                                  name,
                                  style: TextStyle(
                                      color: TColor.gray, fontSize: 14),
                                ),
                              ))
                                  .toList(),
                              onChanged: (value) {},
                              icon:
                              Icon(Icons.expand_more, color: TColor.white),
                              hint: Text(
                                "Weekly",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: TColor.white, fontSize: 12),
                              ),
                            ),
                          )),
                    ],
                  ),
                  SizedBox(
                    height: media.width * 0.05,
                  ),
                  Container(
                      padding: const EdgeInsets.only(left: 15),
                      height: media.width * 0.5,
                      width: double.maxFinite,
                      child: LineChart(
                        LineChartData(
                          // showingTooltipIndicators:
                          //     showingTooltipOnSpots.map((index) {
                          //   return ShowingTooltipIndicators([
                          //     LineBarSpot(
                          //       tooltipsOnBar,
                          //       lineBarsData.indexOf(tooltipsOnBar),
                          //       tooltipsOnBar.spots[index],
                          //     ),
                          //   ]);
                          // }).toList(),
                          lineTouchData: LineTouchData(
                            enabled: true,
                            handleBuiltInTouches: false,
                            touchCallback: (FlTouchEvent event,
                                LineTouchResponse? response) {
                              // if (response == null || response.lineBarSpots == null) {
                              //   return;
                              // }
                              // if (event is FlTapUpEvent) {
                              //   final spotIndex =
                              //       response.lineBarSpots!.first.spotIndex;
                              //   showingTooltipOnSpots.clear();
                              //   setState(() {
                              //     showingTooltipOnSpots.add(spotIndex);
                              //   });
                              // }
                            },
                            mouseCursorResolver: (FlTouchEvent event,
                                LineTouchResponse? response) {
                              if (response == null ||
                                  response.lineBarSpots == null) {
                                return SystemMouseCursors.basic;
                              }
                              return SystemMouseCursors.click;
                            },
                            getTouchedSpotIndicator: (LineChartBarData barData,
                                List<int> spotIndexes) {
                              return spotIndexes.map((index) {
                                return TouchedSpotIndicatorData(
                                  FlLine(
                                    color: Colors.transparent,
                                  ),
                                  FlDotData(
                                    show: true,
                                    getDotPainter:
                                        (spot, percent, barData, index) =>
                                        FlDotCirclePainter(
                                          radius: 3,
                                          color: Colors.white,
                                          strokeWidth: 3,
                                          strokeColor: TColor.secondaryColor1,
                                        ),
                                  ),
                                );
                              }).toList();
                            },
                            touchTooltipData: LineTouchTooltipData(
                              getTooltipColor: (touchedSpot) =>
                              TColor.secondaryColor1,
                              tooltipRoundedRadius: 20,
                              getTooltipItems:
                                  (List<LineBarSpot> lineBarsSpot) {
                                return lineBarsSpot.map((lineBarSpot) {
                                  return LineTooltipItem(
                                    "${lineBarSpot.x.toInt()} mins ago",
                                    const TextStyle(
                                      color: Colors.white,
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  );
                                }).toList();
                              },
                            ),
                          ),
                          lineBarsData: lineBarsData1,
                          minY: -0.5,
                          maxY: 110,
                          titlesData: FlTitlesData(
                              show: true,
                              leftTitles: AxisTitles(),
                              topTitles: AxisTitles(),
                              bottomTitles: AxisTitles(
                                sideTitles: bottomTitles,
                              ),
                              rightTitles: AxisTitles(
                                sideTitles: rightTitles,
                              )),
                          gridData: FlGridData(
                            show: true,
                            drawHorizontalLine: true,
                            horizontalInterval: 25,
                            drawVerticalLine: false,
                            getDrawingHorizontalLine: (value) {
                              return FlLine(
                                color: TColor.gray.withOpacity(0.15),
                                strokeWidth: 2,
                              );
                            },
                          ),
                          borderData: FlBorderData(
                            show: true,
                            border: Border.all(
                              color: Colors.transparent,
                            ),
                          ),
                        ),
                      )),
                  SizedBox(
                    height: media.width * 0.05,
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        vertical: 15, horizontal: 15),
                    decoration: BoxDecoration(
                      color: TColor.primaryColor2.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Daily Meal Schedule",
                          style: TextStyle(
                              color: TColor.black,
                              fontSize: 14,
                              fontWeight: FontWeight.w700),
                        ),
                        SizedBox(
                          width: 70,
                          height: 25,
                          child: RoundButton(
                            title: "Check",
                            type: RoundButtonType.bgGradient,
                            fontSize: 12,
                            fontWeight: FontWeight.w400,
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                  const MealScheduleView(),
                                ),
                              );
                            },
                          ),
                        )
                      ],
                    ),
                  ),
                  SizedBox(
                    height: media.width * 0.05,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Today Meals",
                        style: TextStyle(
                            color: TColor.black,
                            fontSize: 16,
                            fontWeight: FontWeight.w700),
                      ),
                      Container(
                          height: 30,
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(colors: TColor.primaryG),
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton(
                              items: [
                                "Breakfast",
                                "Lunch",
                                "Dinner",
                                "Snack",
                                "Dessert"
                              ]
                                  .map((name) => DropdownMenuItem(
                                value: name,
                                child: Text(
                                  name,
                                  style: TextStyle(
                                      color: TColor.gray, fontSize: 14),
                                ),
                              ))
                                  .toList(),
                              onChanged: (value) {},
                              icon:
                              Icon(Icons.expand_more, color: TColor.white),
                              hint: Text(
                                "Breakfast",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: TColor.white, fontSize: 12),
                              ),
                            ),
                          )),
                    ],
                  ),
                  SizedBox(
                    height: media.width * 0.05,
                  ),
                  ListView.builder(
                      padding: EdgeInsets.zero,
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: todayMealArr.length,
                      itemBuilder: (context, index) {
                        var mObj = todayMealArr[index] as Map? ?? {};
                        return TodayMealRow(
                          mObj: mObj,
                        );
                      }),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Text(
                "Find Something to Eat",
                style: TextStyle(
                    color: TColor.black,
                    fontSize: 16,
                    fontWeight: FontWeight.w700),
              ),
            ),
            SizedBox(
              height: media.width * 0.55,
              child: ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 15.0),
                  scrollDirection: Axis.horizontal,
                  itemCount: findEatArr.length,
                  itemBuilder: (context, index) {
                    var fObj = findEatArr[index] as Map? ?? {};
                    return InkWell(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    MealFoodDetailsView(eObj: fObj)));
                      },
                      child: FindEatCell(
                        fObj: fObj,
                        index: index,
                      ),
                    );
                  }),
            ),
            SizedBox(
              height: media.width * 0.05,
            ),

            // API Meal Plan Section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: LinearGradient(colors: [
                    TColor.primaryColor2.withOpacity(0.1),
                    TColor.primaryColor1.withOpacity(0.1)
                  ]),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.restaurant, color: TColor.primaryColor1),
                        const SizedBox(width: 10),
                        Text(
                          "AI Personalized Meal Plan",
                          style: TextStyle(
                            color: TColor.black,
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 15),

                    // Dietary Guidelines
                    Container(
                      padding: const EdgeInsets.all(15),
                      decoration: BoxDecoration(
                        color: TColor.white,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(Icons.lightbulb,
                                  color: TColor.primaryColor1),
                              const SizedBox(width: 10),
                              Text(
                                "Dietary Guidelines",
                                style: TextStyle(
                                  color: TColor.black,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          Text(
                            widget.healthPlan?.dietaryGuidelines ?? '',
                            style: TextStyle(
                              color: TColor.gray,
                              fontSize: 14,
                              height: 1.4,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 15),

                    // Calorie Information
                    Row(
                      children: [
                        Expanded(
                          child: Container(
                            padding: const EdgeInsets.all(15),
                            decoration: BoxDecoration(
                              color: TColor.white,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Column(
                              children: [
                                Icon(Icons.local_fire_department,
                                    color: TColor.primaryColor1),
                                const SizedBox(height: 8),
                                Text(
                                  "TDEE",
                                  style: TextStyle(
                                    color: TColor.gray,
                                    fontSize: 12,
                                  ),
                                ),
                                Text(
                                  "${widget.healthPlan?.totalDailyEnergyExpenditure}",
                                  style: TextStyle(
                                    color: TColor.black,
                                    fontSize: 18,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                Text(
                                  "calories",
                                  style: TextStyle(
                                    color: TColor.gray,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Container(
                            padding: const EdgeInsets.all(15),
                            decoration: BoxDecoration(
                              color: TColor.white,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Column(
                              children: [
                                Icon(Icons.trending_up,
                                    color: TColor.primaryColor1),
                                const SizedBox(height: 8),
                                Text(
                                  "Adjustment",
                                  style: TextStyle(
                                    color: TColor.gray,
                                    fontSize: 12,
                                  ),
                                ),
                                Text(
                                  "${(widget.healthPlan?.calorieAdjustment ?? 0) > 0 ? '+' : ''}${widget.healthPlan?.calorieAdjustment ?? 0}",
                                  style: TextStyle(
                                    color: TColor.black,
                                    fontSize: 18,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                Text(
                                  "calories",
                                  style: TextStyle(
                                    color: TColor.gray,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 15),

                    // Dietary Guidelines
                    if (widget.healthPlan?.dietaryGuidelines.isNotEmpty ==
                        true) ...[
                      Text(
                        "Dietary Guidelines",
                        style: TextStyle(
                          color: TColor.black,
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Container(
                        width: double.maxFinite,
                        padding: const EdgeInsets.all(15),
                        decoration: BoxDecoration(
                          color: TColor.white,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          widget.healthPlan?.dietaryGuidelines ?? '',
                          style: TextStyle(
                            color: TColor.black,
                            fontSize: 14,
                            height: 1.4,
                          ),
                        ),
                      ),
                      const SizedBox(height: 15),
                    ],

                    // Macro Distribution
                    Text(
                      "Macro Distribution",
                      style: TextStyle(
                        color: TColor.black,
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 10),
                    ...(widget.healthPlan?.macroDistributionRatiosMap.entries
                        .map(
                          (entry) => Container(
                        margin: const EdgeInsets.only(bottom: 8),
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: TColor.white,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 60,
                              height: 60,
                              decoration: BoxDecoration(
                                gradient:
                                LinearGradient(colors: TColor.primaryG),
                                borderRadius: BorderRadius.circular(30),
                              ),
                              child: Center(
                                child: Text(
                                  entry.key.substring(0, 1).toUpperCase(),
                                  style: TextStyle(
                                    color: TColor.white,
                                    fontSize: 18,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 15),
                            Expanded(
                              child: Column(
                                crossAxisAlignment:
                                CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    entry.key,
                                    style: TextStyle(
                                      color: TColor.black,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  Text(
                                    "${((entry.value is double ? entry.value : (entry.value is int ? entry.value.toDouble() : double.tryParse(entry.value.toString()) ?? 0.0)) * 100).toStringAsFixed(1)}% of daily calories",
                                    style: TextStyle(
                                      color: TColor.gray,
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ) ??
                        []),

                    const SizedBox(height: 15),

                    // Meal Plan Schedule
                    Text(
                      "Meal Plan Schedule",
                      style: TextStyle(
                        color: TColor.black,
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 10),
                    ...(widget.healthPlan?.mealPlanScheduleList.map(
                          (meal) => Container(
                        margin: const EdgeInsets.only(bottom: 8),
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: TColor.white,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Row(
                          children: [
                            Icon(Icons.schedule,
                                color: TColor.primaryColor1),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Column(
                                crossAxisAlignment:
                                CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    meal['meal'] ?? 'Meal',
                                    style: TextStyle(
                                      color: TColor.black,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  Text(
                                    meal['time'] ?? 'Time not specified',
                                    style: TextStyle(
                                      color: TColor.gray,
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ) ??
                        []),

                    const SizedBox(height: 15),

                    // Supplements
                    Text(
                      "Recommended Supplements",
                      style: TextStyle(
                        color: TColor.black,
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 10),
                    if (widget.healthPlan?.supplementListData.isNotEmpty ==
                        true) ...[
                      ...(widget.healthPlan?.supplementListData.map(
                            (supplement) => Container(
                          margin: const EdgeInsets.only(bottom: 8),
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: TColor.white,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Row(
                            children: [
                              Icon(Icons.medication,
                                  color: TColor.primaryColor1),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Text(
                                  supplement.toString(),
                                  style: TextStyle(
                                    color: TColor.black,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ) ??
                          []),
                    ] else ...[
                      Container(
                        margin: const EdgeInsets.only(bottom: 8),
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: TColor.white,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Row(
                          children: [
                            Icon(Icons.medication, color: TColor.gray),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                "No supplements recommended",
                                style: TextStyle(
                                  color: TColor.gray,
                                  fontSize: 14,
                                  fontStyle: FontStyle.italic,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                    // Motivational Quote
                    if (widget.healthPlan?.dailyMotivationalQuote.isNotEmpty ==
                        true) ...[
                      const SizedBox(height: 15),
                      Container(
                        width: double.maxFinite,
                        padding: const EdgeInsets.all(15),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(colors: TColor.primaryG),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Icon(Icons.format_quote, color: TColor.white),
                                const SizedBox(width: 10),
                                Text(
                                  "Daily Motivation",
                                  style: TextStyle(
                                    color: TColor.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 10),
                            Text(
                              widget.healthPlan?.dailyMotivationalQuote ?? '',
                              style: TextStyle(
                                color: TColor.white,
                                fontSize: 14,
                                height: 1.4,
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                    // Expected Progress Timeline
                    if (widget
                        .healthPlan?.expectedProgressTimeline.isNotEmpty ==
                        true) ...[
                      const SizedBox(height: 15),
                      Container(
                        width: double.maxFinite,
                        padding: const EdgeInsets.all(15),
                        decoration: BoxDecoration(
                          color: TColor.white,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Icon(Icons.timeline,
                                    color: TColor.primaryColor1),
                                const SizedBox(width: 10),
                                Text(
                                  "Expected Progress Timeline",
                                  style: TextStyle(
                                    color: TColor.black,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 10),
                            Text(
                              widget.healthPlan?.expectedProgressTimeline ?? '',
                              style: TextStyle(
                                color: TColor.black,
                                fontSize: 14,
                                height: 1.4,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
            SizedBox(
              height: media.width * 0.1,
            ),
          ],
        ),
      ),
    );
  }

  List<LineChartBarData> get lineBarsData1 => [
    lineChartBarData1_1,
  ];

  LineChartBarData get lineChartBarData1_1 => LineChartBarData(
    isCurved: true,
    gradient: LinearGradient(colors: [
      TColor.primaryColor2,
      TColor.primaryColor1,
    ]),
    barWidth: 2,
    isStrokeCapRound: true,
    dotData: FlDotData(
      show: true,
      getDotPainter: (spot, percent, barData, index) => FlDotCirclePainter(
        radius: 3,
        color: Colors.white,
        strokeWidth: 1,
        strokeColor: TColor.primaryColor2,
      ),
    ),
    belowBarData: BarAreaData(show: false),
    spots: const [
      FlSpot(1, 35),
      FlSpot(2, 70),
      FlSpot(3, 40),
      FlSpot(4, 80),
      FlSpot(5, 25),
      FlSpot(6, 70),
      FlSpot(7, 35),
    ],
  );

  SideTitles get rightTitles => SideTitles(
    getTitlesWidget: rightTitleWidgets,
    showTitles: true,
    interval: 20,
    reservedSize: 40,
  );

  Widget rightTitleWidgets(double value, TitleMeta meta) {
    String text;
    switch (value.toInt()) {
      case 0:
        text = '0%';
        break;
      case 20:
        text = '20%';
        break;
      case 40:
        text = '40%';
        break;
      case 60:
        text = '60%';
        break;
      case 80:
        text = '80%';
        break;
      case 100:
        text = '100%';
        break;
      default:
        return Container();
    }

    return Text(text,
        style: TextStyle(
          color: TColor.gray,
          fontSize: 12,
        ),
        textAlign: TextAlign.center);
  }

  SideTitles get bottomTitles => SideTitles(
    showTitles: true,
    reservedSize: 32,
    interval: 1,
    getTitlesWidget: bottomTitleWidgets,
  );

  Widget bottomTitleWidgets(double value, TitleMeta meta) {
    var style = TextStyle(
      color: TColor.gray,
      fontSize: 12,
    );
    Widget text;
    switch (value.toInt()) {
      case 1:
        text = Text('Sun', style: style);
        break;
      case 2:
        text = Text('Mon', style: style);
        break;
      case 3:
        text = Text('Tue', style: style);
        break;
      case 4:
        text = Text('Wed', style: style);
        break;
      case 5:
        text = Text('Thu', style: style);
        break;
      case 6:
        text = Text('Fri', style: style);
        break;
      case 7:
        text = Text('Sat', style: style);
        break;
      default:
        text = const Text('');
        break;
    }

    return SideTitleWidget(
      axisSide: meta.axisSide,
      space: 10,
      child: text,
    );
  }
}