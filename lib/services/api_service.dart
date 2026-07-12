import 'dart:convert';
import 'package:http/http.dart' as http;
import 'auth_service.dart';
import '../models/goal_model.dart';

class ApiService {
  static const String baseUrl = 'http://10.0.2.2:5050/api/goals';

  static Future<Map<String, String>> _getHeaders() async {
    final token = await AuthService.getToken();
    return {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };
  }

  // Lấy danh sách mục tiêu
  static Future<List<GoalModel>> getGoals() async {
    final headers = await _getHeaders();
    final response = await http.get(Uri.parse(baseUrl), headers: headers);

    if (response.statusCode == 200) {
      final List data = jsonDecode(response.body);
      return data.map((e) => GoalModel.fromJson(e)).toList();
    } else {
      throw Exception('Không thể tải dữ liệu');
    }
  }

  // Lấy chi tiết mục tiêu
  static Future<Map<String, dynamic>> getGoalById(String id) async {
    final headers = await _getHeaders();
    final response = await http.get(Uri.parse('$baseUrl/$id'), headers: headers);

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Không thể tải chi tiết mục tiêu');
    }
  }

  // Tạo mục tiêu mới
  static Future<bool> createGoal(String name, double targetAmount, String deadline, String icon) async {
    final headers = await _getHeaders();
    final response = await http.post(
      Uri.parse(baseUrl),
      headers: headers,
      body: jsonEncode({
        'name': name,
        'targetAmount': targetAmount,
        'deadline': deadline,
        'icon': icon,
        'color': '#005454'
      }),
    );

    return response.statusCode == 201;
  }

  // Nạp tiền
  static Future<bool> addMoney(String goalId, double amount, String note) async {
    final headers = await _getHeaders();
    final response = await http.post(
      Uri.parse('$baseUrl/$goalId/add-money'),
      headers: headers,
      body: jsonEncode({
        'amount': amount,
        'note': note,
      }),
    );

    return response.statusCode == 200;
  }

  // Rút tiền
  static Future<bool> withdrawMoney(String goalId, double amount, String note) async {
    final headers = await _getHeaders();
    final response = await http.post(
      Uri.parse('$baseUrl/$goalId/withdraw'),
      headers: headers,
      body: jsonEncode({
        'amount': amount,
        'note': note,
      }),
    );

    return response.statusCode == 200;
  }

  // Chỉnh sửa mục tiêu
  static Future<bool> editGoal(String goalId, String name, double targetAmount, String deadline, String icon) async {
    final headers = await _getHeaders();
    final response = await http.put(
      Uri.parse('$baseUrl/$goalId'),
      headers: headers,
      body: jsonEncode({
        'name': name,
        'targetAmount': targetAmount,
        'deadline': deadline,
        'icon': icon,
      }),
    );

    return response.statusCode == 200;
  }
}
