import 'dart:convert';
import 'package:flutter/foundation.dart';

enum IntensityLevel { low, moderate, high, extreme }

IntensityLevel intensityLevelFromString(String value) {
  switch (value.toLowerCase()) {
    case 'low':
      return IntensityLevel.low;
    case 'moderate':
      return IntensityLevel.moderate;
    case 'high':
      return IntensityLevel.high;
    case 'extreme':
      return IntensityLevel.extreme;
    default:
      throw Exception('Unknown intensity level: $value');
  }
}

String intensityLevelToString(IntensityLevel level) {
  return describeEnum(level).toUpperCase();
}

class WorkOutSchema {
  static const String WEIGHT_GAIN = "Weight Gain";
  static const String WEIGHT_LOSS = "Weight Lose";
  static const String MUSCLES_GAIN = "Muscles Gain";
  static const String STAMINA_INCREASE = "Stamina";
}

class HealthPlan {
  final String dietaryGuidelines;
  final String mealPlanSchedule;
  final String supplementList;
  final String optimalSleepDuration;
  final String sleepImprovementTips;
  final String dailyWorkoutSplit;
  final String weeklyWorkoutSchedule;
  final IntensityLevel workoutIntensityLevel;
  final String targetHeartRateZone;
  final String perceivedExertionScale;
  final int totalDailyEnergyExpenditure;
  final int calorieAdjustment;
  final String macroDistributionRatios;
  final String dailyMotivationalQuote;
  final String expectedProgressTimeline;

  HealthPlan({
    required this.dietaryGuidelines,
    required this.mealPlanSchedule,
    required this.supplementList,
    required this.optimalSleepDuration,
    required this.sleepImprovementTips,
    required this.dailyWorkoutSplit,
    required this.weeklyWorkoutSchedule,
    required this.workoutIntensityLevel,
    required this.targetHeartRateZone,
    required this.perceivedExertionScale,
    required this.totalDailyEnergyExpenditure,
    required this.calorieAdjustment,
    required this.macroDistributionRatios,
    required this.dailyMotivationalQuote,
    required this.expectedProgressTimeline,
  });

  factory HealthPlan.fromJson(Map<String, dynamic> json) {
    return HealthPlan(
      dietaryGuidelines: json['dietary_guidelines'] ?? '',
      mealPlanSchedule: json['meal_plan_schedule'] ?? '',
      supplementList: json['supplement_list'] ?? '',
      optimalSleepDuration: json['optimal_sleep_duration'] ?? '',
      sleepImprovementTips: json['sleep_improvement_tips'] ?? '',
      dailyWorkoutSplit: json['daily_workout_split'] ?? '',
      weeklyWorkoutSchedule: json['weekly_workout_schedule'] ?? '',
      workoutIntensityLevel: intensityLevelFromString(
          json['workout_intensity_level'] ?? 'moderate'),
      targetHeartRateZone: json['target_heart_rate_zone'] ?? '',
      perceivedExertionScale: json['perceived_exertion_scale'] ?? '',
      totalDailyEnergyExpenditure: json['total_daily_energy_expenditure'] ?? 0,
      calorieAdjustment: json['calorie_adjustment'] ?? 0,
      macroDistributionRatios: json['macro_distribution_ratios'] ?? '',
      dailyMotivationalQuote: json['daily_motivational_quote'] ?? '',
      expectedProgressTimeline: json['expected_progress_timeline'] ?? '',
    );
  }

  List<dynamic> get mealPlanScheduleList {
    try {
      if (mealPlanSchedule.isEmpty) return [];
      // Try to parse as JSON first
      return jsonDecode(mealPlanSchedule);
    } catch (e) {
      // If it's not JSON, treat as plain text and split by lines
      if (mealPlanSchedule.contains('\n')) {
        return mealPlanSchedule
            .split('\n')
            .map((line) => {'meal': line.trim(), 'time': 'Scheduled'})
            .toList();
      }
      return [
        {'meal': mealPlanSchedule, 'time': 'Scheduled'}
      ];
    }
  }

  List<dynamic> get supplementListData {
    try {
      if (supplementList.isEmpty) return [];
      // Try to parse as JSON first
      return jsonDecode(supplementList);
    } catch (e) {
      // If it's not JSON, treat as plain text and split by lines or commas
      if (supplementList.contains('\n')) {
        return supplementList
            .split('\n')
            .map((line) => line.trim())
            .where((line) => line.isNotEmpty)
            .toList();
      } else if (supplementList.contains(',')) {
        return supplementList
            .split(',')
            .map((item) => item.trim())
            .where((item) => item.isNotEmpty)
            .toList();
      }
      return supplementList.isNotEmpty ? [supplementList] : [];
    }
  }

  List<dynamic> get sleepImprovementTipsList {
    try {
      if (sleepImprovementTips.isEmpty) return [];
      // Try to parse as JSON first
      return jsonDecode(sleepImprovementTips);
    } catch (e) {
      // If it's not JSON, treat as plain text and split by lines
      if (sleepImprovementTips.contains('\n')) {
        return sleepImprovementTips
            .split('\n')
            .map((line) => line.trim())
            .where((line) => line.isNotEmpty)
            .toList();
      }
      return sleepImprovementTips.isNotEmpty ? [sleepImprovementTips] : [];
    }
  }

  List<dynamic> get dailyWorkoutSplitData {
    try {
      if (dailyWorkoutSplit.isEmpty) return [];
      // Try to parse as JSON first
      return jsonDecode(dailyWorkoutSplit);
    } catch (e) {
      // If it's not JSON, treat as plain text and split by lines
      if (dailyWorkoutSplit.contains('\n')) {
        return dailyWorkoutSplit.split('\n').map((line) {
          final parts = line.split(':');
          if (parts.length >= 2) {
            return {
              'day': parts[0].trim(),
              'exercises': [
                {'exercise': parts[1].trim()}
              ]
            };
          }
          return {
            'day': 'Day',
            'exercises': [
              {'exercise': line.trim()}
            ]
          };
        }).toList();
      }
      return [
        {
          'day': 'Daily',
          'exercises': [
            {'exercise': dailyWorkoutSplit}
          ]
        }
      ];
    }
  }

  List<dynamic> get weeklyWorkoutScheduleData {
    try {
      if (weeklyWorkoutSchedule.isEmpty) return [];
      // Try to parse as JSON first
      return jsonDecode(weeklyWorkoutSchedule);
    } catch (e) {
      // If it's not JSON, treat as plain text and split by lines
      if (weeklyWorkoutSchedule.contains('\n')) {
        return weeklyWorkoutSchedule.split('\n').map((line) {
          final parts = line.split(':');
          if (parts.length >= 2) {
            return {'day': parts[0].trim(), 'activity': parts[1].trim()};
          }
          return {'day': 'Day', 'activity': line.trim()};
        }).toList();
      }
      return [
        {'day': 'Weekly', 'activity': weeklyWorkoutSchedule}
      ];
    }
  }

  Map<String, dynamic> get macroDistributionRatiosMap {
    try {
      if (macroDistributionRatios.isEmpty) return {};
      // Try to parse as JSON first
      return jsonDecode(macroDistributionRatios);
    } catch (e) {
      // If it's not JSON, try to parse common formats
      if (macroDistributionRatios.contains('protein') ||
          macroDistributionRatios.contains('carbs') ||
          macroDistributionRatios.contains('fats')) {
        // Try to extract percentages from text
        final proteinMatch = RegExp(r'protein[:\s]*(\d+(?:\.\d+)?)')
            .firstMatch(macroDistributionRatios);
        final carbsMatch = RegExp(r'carbs[:\s]*(\d+(?:\.\d+)?)')
            .firstMatch(macroDistributionRatios);
        final fatsMatch = RegExp(r'fats[:\s]*(\d+(?:\.\d+)?)')
            .firstMatch(macroDistributionRatios);

        return {
          'protein': proteinMatch != null
              ? double.tryParse(proteinMatch.group(1)!) ?? 0.3
              : 0.3,
          'carbs': carbsMatch != null
              ? double.tryParse(carbsMatch.group(1)!) ?? 0.4
              : 0.4,
          'fats': fatsMatch != null
              ? double.tryParse(fatsMatch.group(1)!) ?? 0.3
              : 0.3,
        };
      }
      return {};
    }
  }
}