import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/prediction_model.dart';

class ApiService {
  static const String baseUrl = "https://proyecto-riesgo-crediticio-bfis.onrender.com";

  static Future<PredictionModel?> predict(Map<String, dynamic> data) async {
    try {
      final response = await http.post(
        Uri.parse("$baseUrl/api/predict"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(data),
      );

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);
        return PredictionModel.fromJson(jsonData);
      } else {
        print("Error: ${response.body}");
        return null;
      }
    } catch (e) {
      print("Exception: $e");
      return null;
    }
  }
}