import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/clothing.dart';

class ApiService {
  static const String baseUrl = 'https://tpm-api-tugas-872136705893.us-central1.run.app/api/clothes';

  static Future<List<Clothing>> fetchClothes() async {
    final res = await http.get(Uri.parse(baseUrl));
    if (res.statusCode == 200) {
      final List data = json.decode(res.body)['data'];
      return data.map((e) => Clothing.fromJson(e)).toList();
    } else {
      throw Exception('Failed to load clothes');
    }
  }

  static Future<Clothing> fetchClothing(int id) async {
    final res = await http.get(Uri.parse('$baseUrl/$id'));
    if (res.statusCode == 200) {
      final data = json.decode(res.body)['data'];
      return Clothing.fromJson(data);
    } else {
      throw Exception('Clothing not found');
    }
  }

  static Future<void> deleteClothing(int id) async {
    final res = await http.delete(Uri.parse('$baseUrl/$id'));
    if (res.statusCode != 200) throw Exception('Delete failed');
  }

  static Future<void> createClothing(Clothing cloth) async {
    final body = json.encode(cloth.toJson());
    print('Request Body: $body');

    final res = await http.post(
      Uri.parse(baseUrl),
      headers: {'Content-Type': 'application/json'},
      body: body,
    );

    print('Response status: ${res.statusCode}');
    print('Response body: ${res.body}');

    if (res.statusCode != 201) throw Exception('Create failed: ${res.body}');
  }

  static Future<bool> updateClothing(int? id, Map<String, dynamic> data) async {
  if (id == null) return false;
  final url = Uri.parse('$baseUrl/$id');

  final body = json.encode(data);
  print('Update request body: $body');

  final response = await http.put(
    url,
    headers: {'Content-Type': 'application/json'},
    body: body,
  );

  print('Update response status: ${response.statusCode}');
  print('Update response body: ${response.body}');

  return response.statusCode == 200;
}
}
