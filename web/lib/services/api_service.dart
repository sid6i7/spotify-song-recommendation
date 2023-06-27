import 'dart:convert';
import 'package:http/http.dart' as http;
import 'dart:core';
import 'package:web/config.dart';
import 'package:web/endpoints.dart';
import 'package:web/models/song.dart';

class ApiService {
  final String baseUrl = "$HOSTNAME:$PORT/";
  Future<List<dynamic>> recommend_songs(String uri, int nOfSongs) async {
    List<dynamic> songs = [];
    final callUrl = baseUrl + RECOMMEND_ENDPOINT;
    print(callUrl);
    final data = {'link': uri, 'n_of_songs': nOfSongs};
    final response = await http.post(
      Uri.parse(callUrl),
      body: jsonEncode(data),
      headers: {
        'Content-Type': 'application/json',
      },
    );
    if (response.statusCode == 200) {
      final responseBody = jsonDecode(response.body);
      songs = responseBody['similar_song_urls'];
    }
    print(songs);
    return songs;
  }

  Future<String> get_playlist_data(String playlistUrl) async {
    final callUrl = baseUrl + PLAYLIST_ENDPOINT;
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
