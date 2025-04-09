import 'dart:convert';
import 'package:http/http.dart' as http;

class PaymentService {
  static const String _baseUrl = 'http://your-php-backend/api';

  Future<void> sendMoney(String recipientPhone, double amount) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/payment/send'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'recipient_phone': recipientPhone,
        'amount': amount,
      }),
    );

    if (response.statusCode != 200) {
      throw Exception('Payment failed: ${response.body}');
    }
  }

  Future<List<Map<String, dynamic>>> getTransactions() async {
    final response = await http.get(
      Uri.parse('$_baseUrl/payment/history'),
    );

    if (response.statusCode == 200) {
      return List<Map<String, dynamic>>.from(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load transactions');
    }
  }
}
