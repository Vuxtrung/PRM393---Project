import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'auth_service.dart';

class NotificationService {
  static const String baseUrl = 'http://10.0.2.2:5050/api/notifications';

  // Global stream to notify when a transaction occurred
  static final StreamController<void> _newTransactionController = StreamController<void>.broadcast();
  static Stream<void> get onNewTransaction => _newTransactionController.stream;

  static void notifyNewTransaction() {
    _newTransactionController.add(null);
  }

  static Future<List<dynamic>> getNotifications() async {
    final token = await AuthService.getToken();
    if (token == null) throw Exception('No token');

    final response = await http.get(
      Uri.parse(baseUrl),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to load notifications');
    }
  }

  static Future<void> markAsRead(String id) async {
    final token = await AuthService.getToken();
    if (token == null) return;

    await http.put(
      Uri.parse('$baseUrl/$id/read'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );
  }
}
