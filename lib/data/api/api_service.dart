import 'dart:convert';
import 'dart:typed_data';

import 'package:http/http.dart' as http;

import '../model/story.dart';
import '../model/user.dart';
import '../model/response/login_response.dart';
import '../model/response/mutation_response.dart';
import '../model/response/stories_response.dart';
import '../model/response/story_detail_response.dart';

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

    final body = MutationResponse.fromJson(
      jsonDecode(response.body) as Map<String, dynamic>,
    );
    if (body.error) {
      throw Exception(
        body.message.isNotEmpty ? body.message : 'Register failed',
      );
    }
    return body.message;
  }

  Future<User> login({required String email, required String password}) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'password': password}),
    );

    final body = LoginResponse.fromJson(
      jsonDecode(response.body) as Map<String, dynamic>,
    );
    if (body.error) {
      throw Exception(body.message.isNotEmpty ? body.message : 'Login failed');
    }
    final loginResult = body.loginResult;
    if (loginResult == null) {
      throw Exception('Login failed');
    }
    return loginResult;
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

    final body = StoriesResponse.fromJson(
      jsonDecode(response.body) as Map<String, dynamic>,
    );
    if (body.error) {
      throw Exception(
        body.message.isNotEmpty ? body.message : 'Failed to fetch stories',
      );
    }

    return body.listStory;
  }

  Future<Story> getStoryDetail({
    required String token,
    required String id,
  }) async {
    final response = await http.get(
      Uri.parse('$_baseUrl/stories/$id'),
      headers: {'Authorization': 'Bearer $token'},
    );

    final body = StoryDetailResponse.fromJson(
      jsonDecode(response.body) as Map<String, dynamic>,
    );
    if (body.error) {
      throw Exception(
        body.message.isNotEmpty ? body.message : 'Failed to fetch story detail',
      );
    }

    final story = body.story;
    if (story == null) {
      throw Exception('Failed to fetch story detail');
    }
    return story;
  }

  Future<String> addStory({
    required String token,
    required String description,
    required Uint8List photoBytes,
    required String fileName,
    double? lat,
    double? lon,
  }) async {
    final uri = Uri.parse('$_baseUrl/stories');
    final request = http.MultipartRequest('POST', uri)
      ..headers['Authorization'] = 'Bearer $token'
      ..fields['description'] = description
      ..files.add(
        http.MultipartFile.fromBytes('photo', photoBytes, filename: fileName),
      );

    if (lat != null && lon != null) {
      request.fields['lat'] = lat.toString();
      request.fields['lon'] = lon.toString();
    }

    final streamedResponse = await request.send();
    final response = await http.Response.fromStream(streamedResponse);
    final body = MutationResponse.fromJson(
      jsonDecode(response.body) as Map<String, dynamic>,
    );

    if (body.error) {
      throw Exception(
        body.message.isNotEmpty ? body.message : 'Failed to add story',
      );
    }
    return body.message;
  }
}
