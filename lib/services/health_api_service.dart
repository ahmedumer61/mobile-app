import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/health_plan.dart';

class HealthApiService {
  static const String baseUrl = 'http://3.110.168.6:8000';
  static const String endpoint = '/chatbot';

  static Future<HealthPlan?> getHealthPlan({
    required double bmi,
    required String workoutGoal,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl$endpoint'),
        body: {
          'bmi': bmi.toString(),
          'workout': workoutGoal,
        },
      );
      if (response.statusCode == 200) {
        try {
          final Map<String, dynamic> data = jsonDecode(response.body);
          final healthPlan = HealthPlan.fromJson(data);
          return healthPlan;
        } catch (e) {
          return null;
        }
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }
}