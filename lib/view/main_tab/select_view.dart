import 'package:fitness_app/common_widget/round_button.dart';
import 'package:fitness_app/models/health_plan.dart';
import 'package:fitness_app/view/meal_planner/meal_planner_view.dart';
import 'package:fitness_app/view/workout_tracker/workout_tracker_view.dart';
import 'package:flutter/material.dart';
import '../bmi_input_view.dart';
import '../sleep_tracker/sleep_tracker_view.dart';

class SelectView extends StatelessWidget {
  final HealthPlan? healthPlan;

  const SelectView({super.key, this.healthPlan});

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => BmiInputView(),
              ),
            );
          },
        ),
        title: const Text('Select Activity'),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.black,
      ),
      body: SingleChildScrollView(
        child: ConstrainedBox(
          constraints: BoxConstraints(
            minHeight: media.height,
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                RoundButton(
                    title: "Workout Tracker",
                    onPressed: () {
                      if (healthPlan != null) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                WorkoutTrackerView(healthPlan: healthPlan!),
                          ),
                        );
                      } else {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                WorkoutTrackerView(healthPlan: null),
                          ),
                        );
                      }
                    }),
                const SizedBox(
                  height: 15,
                ),
                RoundButton(
                    title: "Meal Planner",
                    onPressed: () {
                      if (healthPlan != null) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                MealPlannerView(healthPlan: healthPlan!),
                          ),
                        );
                      } else {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => MealPlannerView(healthPlan: null),
                          ),
                        );
                      }
                    }),
                const SizedBox(
                  height: 15,
                ),
                RoundButton(
                    title: "Sleep Tracker",
                    onPressed: () {
                      if (healthPlan != null) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                SleepTrackerView(healthPlan: healthPlan!),
                          ),
                        );
                      } else {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                SleepTrackerView(healthPlan: null),
                          ),
                        );
                      }
                    })
              ],
            ),
          ),
        ),
      ),
    );
  }
}
