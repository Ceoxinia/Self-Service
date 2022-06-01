import 'dart:convert';

import 'package:http/http.dart' as http;

Future sendEmail(String name, String email, String reciever) async {
  final url = Uri.parse('https://api.emailjs.com/api/v1.0/email/send');
  const serviceId = 'service_1kw8og8';
  const templateId = 'template_j36fgpi';
  const userId = '0_qWj9YC47tZfU5VD';
  final response = await http.post(url,
      headers: {
        'Content-Type': 'application/json'
      }, //This line makes sure it works for all platforms.
      body: json.encode({
        'service_id': serviceId,
        'template_id': templateId,
        'user_id': userId,
        'template_params': {
          'from_name': name,
          'to_email': email,
          'to_name': reciever,
        }
      }));
  return response.statusCode;
}
