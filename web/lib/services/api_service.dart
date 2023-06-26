import 'dart:convert';
import 'package:http/http.dart' as http;
import 'dart:core';
import 'package:web/config.dart';

class ApiService {
  Future<String> get_playlist_data(String playlistUrl) async {
    const callUrl = BASE_URL + PLAYLIST_ENDPOINT;
    final url = Uri.parse(callUrl);
    final data = {'playlist_url': playlistUrl};
    final response = await http.post(
      url,
      body: jsonEncode(data),
      headers: {
        'Content-Type': 'application/json',
      },
    );
    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body);
      return responseData['csv'];
    } else {
      return ""; //TODO: Implement error handling
    }
  }
}
