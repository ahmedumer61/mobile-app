import 'dart:math';
import 'package:dotted_dashed_line/dotted_dashed_line.dart';
import 'package:fitness_app/common_widget/round_button.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:simple_animation_progress_bar/simple_animation_progress_bar.dart';
import 'package:simple_circular_progress_bar/simple_circular_progress_bar.dart';
import '../../common/colo_extension.dart';


class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  // State variables
  String userName = "User";
  double bmi = 0;
  String bmiCategory = "Calculating...";
  double waterIntake = 0;
  bool _isLoading = true;
  List waterArr = [];

  // Dynamic calories data based on BMI
  double dailyCalorieGoal = 2000;
  double consumedCalories = 0;
  double remainingCalories = 0;
  double calorieProgress = 0;

  @override
  void initState() {
    super.initState();
    _getUserData();
  }

  // Data Management Methods
  Future<void> _getUserData() async {
    final prefs = await SharedPreferences.getInstance();

    // Get user data from SharedPreferences
    String? storedName = prefs.getString('user_name');
    double? height = double.tryParse(prefs.getString('user_height') ?? '0');
    double? weight = double.tryParse(prefs.getString('user_weight') ?? '0');
    double? storedWater = double.tryParse(prefs.getString('user_water_intake') ?? '0');

    // Debug prints to check data retrieval
    print("Retrieved - Name: $storedName, Height: $height, Weight: $weight, Water: $storedWater");

    // Calculate BMI and category
    double calculatedBMI = 0;
    String category = "Enter your details";
    if (height != null && height > 0 && weight != null && weight > 0) {
      double heightInMeters = height / 100;
      calculatedBMI = weight / pow(heightInMeters, 2);
      category = _getBMICategory(calculatedBMI);
    }

    // Calculate dynamic calories based on BMI and weight
    _calculateDynamicCalories(calculatedBMI, weight ?? 0);

    // Prepare water intake data
    _prepareWaterIntakeData(storedWater ?? 0);

    // Update state
    setState(() {
      userName = storedName ?? "User";
      bmi = calculatedBMI;
      bmiCategory = category;
      waterIntake = storedWater ?? 0;
      _isLoading = false;
    });
  }

  String _getBMICategory(double bmi) {
    if (bmi < 18.5) {
      return "Underweight";
    } else if (bmi < 24.9) {
      return "Normal weight";
    } else if (bmi < 29.9) {
      return "Overweight";
    } else {
      return "Obesity";
    }
  }

  void _calculateDynamicCalories(double bmi, double weight) {
    // Base metabolic rate calculation (simplified)
    double basalMetabolicRate = weight * 24; // Rough estimate: weight * 24 calories per day

    // Adjust calorie goal based on BMI category
    if (bmi == 0) {
      dailyCalorieGoal = 2000; // Default value
      consumedCalories = 0;
    } else if (bmi < 18.5) {
      // Underweight: Need more calories to gain weight
      dailyCalorieGoal = basalMetabolicRate * 1.5;
      consumedCalories = dailyCalorieGoal * 0.4; // 40% consumed
    } else if (bmi < 24.9) {
      // Normal weight: Maintain current weight
      dailyCalorieGoal = basalMetabolicRate * 1.2;
      consumedCalories = dailyCalorieGoal * 0.6; // 60% consumed
    } else if (bmi < 29.9) {
      // Overweight: Slight calorie deficit
      dailyCalorieGoal = basalMetabolicRate * 1.0;
      consumedCalories = dailyCalorieGoal * 0.7; // 70% consumed
    } else {
      // Obesity: More significant calorie deficit
      dailyCalorieGoal = basalMetabolicRate * 0.8;
      consumedCalories = dailyCalorieGoal * 0.8; // 80% consumed
    }

    // Calculate remaining calories and progress
    remainingCalories = (dailyCalorieGoal - consumedCalories).clamp(0, dailyCalorieGoal);
    calorieProgress = ((consumedCalories / dailyCalorieGoal) * 100).clamp(0, 100);
  }

  void _prepareWaterIntakeData(double waterIntake) {
    double perInterval = (waterIntake / 5).clamp(0.0, double.infinity);
    List<String> intervals = [
      "6am - 8am",
      "9am - 11am",
      "11am - 2pm",
      "2pm - 4pm",
      "4pm - now"
    ];

    waterArr = intervals.map((title) => {
      "title": title,
      "subtitle": "${perInterval.toStringAsFixed(1)} L"
    }).toList();
  }



  // Show BMI details dialog
  void _showBMIDetails() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("BMI Details"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Your BMI: ${bmi > 0 ? bmi.toStringAsFixed(1) : 'Not calculated'}"),
              Text("Category: $bmiCategory"),
              SizedBox(height: 10),
              Text("BMI Categories:", style: TextStyle(fontWeight: FontWeight.bold)),
              Text("• Underweight: Below 18.5"),
              Text("• Normal weight: 18.5-24.9"),
              Text("• Overweight: 25.0-29.9"),
              Text("• Obesity: 30.0 and above"),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text("Close"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: TColor.white,
      body: SingleChildScrollView(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: media.width * 0.08),
                _buildHeader(),
                SizedBox(height: media.width * 0.05),
                _buildBMICard(media),
                SizedBox(height: media.width * 0.05),
                _buildTodayTargetCard(),
                SizedBox(height: media.width * 0.05),
                _buildStatsSection(media),
                SizedBox(height: media.width * 0.05),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Header Section (removed notification icon)
  Widget _buildHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Welcome Back,",
          style: TextStyle(
            color: TColor.gray,
            fontSize: 12,
          ),
        ),
        Text(
          userName,
          style: TextStyle(
            color: TColor.black,
            fontSize: 20,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }

  // BMI Card Section
  Widget _buildBMICard(Size media) {
    double bmiPercent = bmi > 0 ? (bmi / 40).clamp(0.0, 1.0) * 100 : 0;

    return Container(
      height: media.width * 0.4,
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: TColor.primaryG),
        borderRadius: BorderRadius.circular(media.width * 0.075),
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Image.asset(
            "assets/img/bg_dots.png",
            height: media.width * 0.4,
            width: double.maxFinite,
            fit: BoxFit.fitHeight,
          ),
          if (_isLoading)
            CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(TColor.white),
            )
          else
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 25, horizontal: 25),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildBMIInfo(media),
                  _buildBMIChart(bmiPercent),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildBMIInfo(Size media) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "BMI (Body Mass Index)",
          style: TextStyle(
            color: TColor.white,
            fontSize: 14,
            fontWeight: FontWeight.w700,
          ),
        ),
        Text(
          bmi > 0 ? "${bmi.toStringAsFixed(1)} - $bmiCategory" : bmiCategory,
          style: TextStyle(
            color: TColor.white.withOpacity(0.7),
            fontSize: 12,
          ),
        ),
        SizedBox(height: media.width * 0.05),
        SizedBox(
          width: 120,
          height: 35,
          child: RoundButton(
            title: "View More",
            type: RoundButtonType.bgSGradient,
            fontSize: 12,
            fontWeight: FontWeight.w400,
            onPressed: _showBMIDetails,
          ),
        ),
      ],
    );
  }

  Widget _buildBMIChart(double bmiPercent) {
    return SizedBox(
      width: 100,
      height: 100,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // BMI Value Display in Center
          Container(
            width: 60,
            height: 60,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.9),
              borderRadius: BorderRadius.circular(30),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  bmi > 0 ? bmi.toStringAsFixed(1) : "--",
                  style: TextStyle(
                    color: TColor.black,
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Text(
                  "BMI",
                  style: TextStyle(
                    color: TColor.gray,
                    fontSize: 10,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          // Pie Chart
          AspectRatio(
            aspectRatio: 1,
            child: PieChart(
              PieChartData(
                startDegreeOffset: 250,
                borderData: FlBorderData(show: false),
                sectionsSpace: 2,
                centerSpaceRadius: 35,
                sections: _buildPieChartSections(bmiPercent),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Create pie chart sections with BMI category colors
  List<PieChartSectionData> _buildPieChartSections(double bmiPercent) {
    double validPercent = bmiPercent.clamp(0.0, 100.0);

    // Choose color based on BMI category
    Color bmiColor;
    if (bmi == 0) {
      bmiColor = Colors.grey;
    } else if (bmi < 18.5) {
      bmiColor = Colors.blue; // Underweight
    } else if (bmi < 24.9) {
      bmiColor = Colors.green; // Normal
    } else if (bmi < 29.9) {
      bmiColor = Colors.orange; // Overweight
    } else {
      bmiColor = Colors.red; // Obesity
    }

    return [
      PieChartSectionData(
        color: bmiColor,
        value: validPercent > 0 ? validPercent : 25, // Show something even if BMI is 0
        title: '',
        radius: 15,
        borderSide: BorderSide.none,
      ),
      PieChartSectionData(
        color: Colors.white.withOpacity(0.3),
        value: validPercent > 0 ? (100 - validPercent) : 75,
        title: '',
        radius: 15,
        borderSide: BorderSide.none,
      ),
    ];
  }

  // Today Target Card
  Widget _buildTodayTargetCard() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
      decoration: BoxDecoration(
        color: TColor.primaryColor2.withOpacity(0.3),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            "Today Target",
            style: TextStyle(
              color: TColor.black,
              fontSize: 14,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }

  // Stats Section (Water and Sleep/Calories only - no heart rate)
  Widget _buildStatsSection(Size media) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: _buildWaterSection(media),
        ),
        SizedBox(width: media.width * 0.05),
        Expanded(
          child: Column(
            children: [
              _buildSleepSection(media),
              SizedBox(height: media.width * 0.05),
              _buildCaloriesSection(media),
            ],
          ),
        ),
      ],
    );
  }

  // Water Intake Section
  Widget _buildWaterSection(Size media) {
    return Container(
      height: media.width * 0.95,
      padding: const EdgeInsets.symmetric(vertical: 25, horizontal: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(25),
        boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 2),
        ],
      ),
      child: Row(
        children: [
          _buildWaterProgressBar(media),
          const SizedBox(width: 10),
          Expanded(child: _buildWaterDetails(media)),
        ],
      ),
    );
  }

  Widget _buildWaterProgressBar(Size media) {
    return SimpleAnimationProgressBar(
      height: media.width * 0.85,
      width: media.width * 0.07,
      backgroundColor: Colors.grey.shade100,
      foregroundColor: Colors.purple,
      ratio: (waterIntake / 4).clamp(0.0, 1.0),
      direction: Axis.vertical,
      curve: Curves.fastLinearToSlowEaseIn,
      duration: const Duration(seconds: 3),
      borderRadius: BorderRadius.circular(15),
      gradientColor: LinearGradient(
        colors: TColor.primaryG,
        begin: Alignment.bottomCenter,
        end: Alignment.topCenter,
      ),
    );
  }

  Widget _buildWaterDetails(Size media) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Water Intake",
          style: TextStyle(
            color: TColor.black,
            fontSize: 12,
            fontWeight: FontWeight.w700,
          ),
        ),
        ShaderMask(
          blendMode: BlendMode.srcIn,
          shaderCallback: (bounds) => LinearGradient(
            colors: TColor.primaryG,
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ).createShader(Rect.fromLTRB(0, 0, bounds.width, bounds.height)),
          child: Text(
            "${waterIntake.toStringAsFixed(1)} Liters",
            style: const TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: 14,
            ),
          ),
        ),
        const SizedBox(height: 10),
        Text(
          "Real time updates",
          style: TextStyle(color: TColor.gray, fontSize: 12),
        ),
        ...waterArr.map((wObj) => _buildWaterTimelineItem(wObj, media)),
      ],
    );
  }

  Widget _buildWaterTimelineItem(Map wObj, Size media) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            children: [
              Container(
                width: 10,
                height: 10,
                decoration: BoxDecoration(
                  color: TColor.secondaryColor1.withOpacity(0.5),
                  borderRadius: BorderRadius.circular(5),
                ),
              ),
              if (wObj != waterArr.last)
                DottedDashedLine(
                  height: media.width * 0.078,
                  width: 0,
                  dashColor: TColor.secondaryColor1.withOpacity(0.5),
                  axis: Axis.vertical,
                ),
            ],
          ),
          const SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                wObj["title"],
                style: TextStyle(color: TColor.gray, fontSize: 10),
              ),
              ShaderMask(
                blendMode: BlendMode.srcIn,
                shaderCallback: (bounds) => LinearGradient(
                  colors: TColor.secondaryG,
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                ).createShader(Rect.fromLTRB(0, 0, bounds.width, bounds.height)),
                child: Text(
                  wObj["subtitle"],
                  style: const TextStyle(fontSize: 12),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // Sleep Section
  Widget _buildSleepSection(Size media) {
    return Container(
      width: double.maxFinite,
      height: media.width * 0.45,
      padding: const EdgeInsets.symmetric(vertical: 25, horizontal: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(25),
        boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 2),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Sleep",
            style: TextStyle(
              color: TColor.black,
              fontSize: 12,
              fontWeight: FontWeight.w700,
            ),
          ),
          ShaderMask(
            blendMode: BlendMode.srcIn,
            shaderCallback: (bounds) => LinearGradient(
              colors: TColor.primaryG,
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
            ).createShader(Rect.fromLTRB(0, 0, bounds.width, bounds.height)),
            child: const Text(
              "8h 20m",
              style: TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 14,
              ),
            ),
          ),
          const Spacer(),
          Image.asset(
            "assets/img/sleep_grap.png",
            width: double.maxFinite,
            fit: BoxFit.fitWidth,
          ),
        ],
      ),
    );
  }

  // Dynamic Calories Section based on BMI
  Widget _buildCaloriesSection(Size media) {
    return Container(
      width: double.maxFinite,
      height: media.width * 0.45,
      padding: const EdgeInsets.symmetric(vertical: 25, horizontal: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(25),
        boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 2),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Calories",
            style: TextStyle(
              color: TColor.black,
              fontSize: 12,
              fontWeight: FontWeight.w700,
            ),
          ),
          ShaderMask(
            blendMode: BlendMode.srcIn,
            shaderCallback: (bounds) => LinearGradient(
              colors: TColor.primaryG,
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
            ).createShader(Rect.fromLTRB(0, 0, bounds.width, bounds.height)),
            child: Text(
              "${consumedCalories.toInt()} kCal",
              style: const TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 14,
              ),
            ),
          ),
          const Spacer(),
          _buildCaloriesChart(media),
        ],
      ),
    );
  }

  Widget _buildCaloriesChart(Size media) {
    // Get BMI-based colors (same as BMI chart)
    List<Color> calorieColors = _getBMIBasedColors();

    return Container(
      alignment: Alignment.center,
      child: SizedBox(
        width: media.width * 0.2,
        height: media.width * 0.2,
        child: Stack(
          alignment: Alignment.center,
          children: [
            Container(
              width: media.width * 0.15,
              height: media.width * 0.15,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                gradient: LinearGradient(colors: calorieColors),
                borderRadius: BorderRadius.circular(media.width * 0.075),
              ),
              child: FittedBox(
                child: Text(
                  "${remainingCalories.toInt()}kCal\nleft",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: TColor.white,
                    fontSize: 11,
                  ),
                ),
              ),
            ),
            SimpleCircularProgressBar(
              progressStrokeWidth: 10,
              backStrokeWidth: 10,
              progressColors: calorieColors,
              backColor: Colors.grey.shade100,
              valueNotifier: ValueNotifier(calorieProgress),
              startAngle: -180,
            ),
          ],
        ),
      ),
    );
  }

  // Get BMI-based colors for calories chart
  List<Color> _getBMIBasedColors() {
    if (bmi == 0) {
      return [Colors.grey.shade400, Colors.grey.shade600]; // Default grey gradient
    } else if (bmi < 18.5) {
      return [Colors.blue.shade300, Colors.blue.shade600]; // Underweight - Blue gradient
    } else if (bmi < 24.9) {
      return [Colors.green.shade300, Colors.green.shade600]; // Normal - Green gradient
    } else if (bmi < 29.9) {
      return [Colors.orange.shade300, Colors.orange.shade600]; // Overweight - Orange gradient
    } else {
      return [Colors.red.shade300, Colors.red.shade600]; // Obesity - Red gradient
    }
  }
}