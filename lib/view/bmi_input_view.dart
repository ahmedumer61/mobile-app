import 'package:flutter/material.dart';
import '../common/colo_extension.dart';
import '../common_widget/round_button.dart';
import '../models/health_plan.dart';
import '../services/health_api_service.dart';
import 'main_tab/select_view.dart';

class BmiInputView extends StatefulWidget {
  const BmiInputView({super.key});

  @override
  State<BmiInputView> createState() => _BmiInputViewState();
}

class _BmiInputViewState extends State<BmiInputView> {
  final TextEditingController _bmiController = TextEditingController();
  String _selectedGoal = WorkOutSchema.WEIGHT_LOSS;
  bool _isLoading = false;

  final List<String> _workoutGoals = [
    WorkOutSchema.WEIGHT_LOSS,
    WorkOutSchema.WEIGHT_GAIN,
    WorkOutSchema.MUSCLES_GAIN,
    WorkOutSchema.STAMINA_INCREASE,
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: TColor.white,
      appBar: AppBar(
        backgroundColor: TColor.white,
        centerTitle: true,
        elevation: 0,
        title: Text(
          "Health Profile",
          style: TextStyle(
            color: TColor.black,
            fontSize: 16,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            Text(
              "Enter Your BMI",
              style: TextStyle(
                color: TColor.black,
                fontSize: 18,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              "Your BMI helps us create a personalized health plan",
              style: TextStyle(
                color: TColor.gray,
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _bmiController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                hintText: "Enter your BMI (e.g., 24.5)",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                filled: true,
                fillColor: TColor.lightGray,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              "Select Your Goal",
              style: TextStyle(
                color: TColor.black,
                fontSize: 18,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 15),
            ..._workoutGoals.map((goal) => RadioListTile<String>(
              title: Text(goal),
              value: goal,
              groupValue: _selectedGoal,
              onChanged: (value) {
                setState(() {
                  _selectedGoal = value!;
                });
              },
              activeColor: TColor.primaryColor1,
            )),
            const Spacer(),
            RoundButton(
              title: _isLoading ? "Loading..." : "Get Personalized Plan",
              onPressed: _isLoading ? () {} : () => _getHealthPlan(),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Future<void> _getHealthPlan() async {
    final bmiText = _bmiController.text.trim();
    if (bmiText.isEmpty) {
      _showSnackBar("Please enter your BMI");
      return;
    }

    final bmi = double.tryParse(bmiText);
    if (bmi == null || bmi <= 0) {
      _showSnackBar("Please enter a valid BMI");
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final healthPlan = await HealthApiService.getHealthPlan(
        bmi: bmi,
        workoutGoal: _selectedGoal,
      );

      setState(() {
        _isLoading = false;
      });

      if (healthPlan != null) {
        // Navigate to the select view with the health plan data
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => SelectView(healthPlan: healthPlan),
          ),
        );
      } else {
        _showSnackBar("Failed to get health plan. Please try again.");
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      _showSnackBar("Error: $e");
    }
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  void dispose() {
    _bmiController.dispose();
    super.dispose();
  }
}