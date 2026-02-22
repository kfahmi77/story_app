import 'dart:convert';
import 'dart:typed_data';

import 'package:http/http.dart' as http;

import '../model/story.dart';
import '../model/user.dart';

class ApiService {
  static const String _baseUrl = 'https://story-api.dicoding.dev/v1';

  Future<String> register({
    required String name,
    required String email,
    required String password,
  }) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/register'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'name': name, 'email': email, 'password': password}),
    );

    final body = jsonDecode(response.body) as Map<String, dynamic>;
    if (body['error'] == true) {
      throw Exception(body['message'] ?? 'Register failed');
    }
    return body['message'] as String;
  }

  Future<User> login({required String email, required String password}) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'password': password}),
    );

    final body = jsonDecode(response.body) as Map<String, dynamic>;
    if (body['error'] == true) {
      throw Exception(body['message'] ?? 'Login failed');
    }
    return User.fromJson(body['loginResult'] as Map<String, dynamic>);
  }

  Future<List<Story>> getAllStories({
    required String token,
    int? page,
    int? size,
  }) async {
    final queryParams = <String, String>{};
    if (page != null) queryParams['page'] = page.toString();
    if (size != null) queryParams['size'] = size.toString();

    final uri = Uri.parse(
      '$_baseUrl/stories',
    ).replace(queryParameters: queryParams.isNotEmpty ? queryParams : null);

    final response = await http.get(
      uri,
      headers: {'Authorization': 'Bearer $token'},
    );

    final body = jsonDecode(response.body) as Map<String, dynamic>;
    if (body['error'] == true) {
      throw Exception(body['message'] ?? 'Failed to fetch stories');
    }

    final list = body['listStory'] as List<dynamic>;
    return list.map((e) => Story.fromJson(e as Map<String, dynamic>)).toList();
  }

  Future<Story> getStoryDetail({
    required String token,
    required String id,
  }) async {
    final response = await http.get(
      Uri.parse('$_baseUrl/stories/$id'),
      headers: {'Authorization': 'Bearer $token'},
    );

    final body = jsonDecode(response.body) as Map<String, dynamic>;
    if (body['error'] == true) {
      throw Exception(body['message'] ?? 'Failed to fetch story detail');
    }

    return Story.fromJson(body['story'] as Map<String, dynamic>);
  }

  Future<String> addStory({
    required String token,
    required String description,
    required Uint8List photoBytes,
    required String fileName,
  }) async {
    final uri = Uri.parse('$_baseUrl/stories');
    final request = http.MultipartRequest('POST', uri)
      ..headers['Authorization'] = 'Bearer $token'
      ..fields['description'] = description
      ..files.add(
        http.MultipartFile.fromBytes('photo', photoBytes, filename: fileName),
      );

    final streamedResponse = await request.send();
    final response = await http.Response.fromStream(streamedResponse);
    final body = jsonDecode(response.body) as Map<String, dynamic>;

    if (body['error'] == true) {
      throw Exception(body['message'] ?? 'Failed to add story');
    }
    return body['message'] as String;
  }
}
