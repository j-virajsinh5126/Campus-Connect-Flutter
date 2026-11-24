import 'dart:convert';

import 'package:http/http.dart' as http;

class PublicEvent {
  final int id;
  final String title;
  final String description;

  const PublicEvent({
    required this.id,
    required this.title,
    required this.description,
  });

  factory PublicEvent.fromJson(Map<String, dynamic> json) {
    return PublicEvent(
      id: json['id'] as int,
      title: json['title'] as String? ?? 'Untitled Event',
      description: json['body'] as String? ?? '',
    );
  }
}

class PublicEventApiService {
  static const String _url =
      'https://jsonplaceholder.typicode.com/posts?_limit=10';

  Future<List<PublicEvent>> fetchEvents() async {
    final response = await http
        .get(Uri.parse(_url))
        .timeout(const Duration(seconds: 15));

    if (response.statusCode == 200) {
      final List<dynamic> jsonList = jsonDecode(response.body);

      return jsonList
          .map((item) => PublicEvent.fromJson(item as Map<String, dynamic>))
          .toList();
    }

    throw Exception(
      'Failed to load events. Status code: ${response.statusCode}',
    );
  }
}
