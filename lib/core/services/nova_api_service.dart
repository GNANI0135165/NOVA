import 'dart:convert';

import 'package:http/http.dart' as http;

class NovaApiService {
  static const String baseUrl = 'http://localhost:3000';

  static Future<String> sendMessage(String message) async {
    final uri = Uri.parse('$baseUrl/api/chat');

    final response = await http.post(
      uri,
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'message': message,
      }),
    );

    if (response.statusCode != 200) {
      try {
        final errorData = jsonDecode(response.body);

        throw Exception(
          errorData['error'] ?? 'NOVA backend error',
        );
      } catch (_) {
        throw Exception(
          'NOVA backend returned status ${response.statusCode}',
        );
      }
    }

    final data = jsonDecode(response.body);

    if (data['success'] != true) {
      throw Exception(
        data['error'] ?? 'NOVA returned an unknown error',
      );
    }

    return data['response']?.toString() ?? 'NOVA returned no response.';
  }
}