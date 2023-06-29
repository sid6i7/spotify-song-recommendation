import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:web/config.dart';
import 'package:web/models/song.dart';
import 'package:web/services/api_service.dart';
import 'package:web/services/csv_service.dart';
import 'package:web/widgets/song_list.dart';

class RecommenderPageForm extends StatefulWidget {
  const RecommenderPageForm({super.key});

  @override
  _RecommenderPageFormState createState() => _RecommenderPageFormState();
}

class _RecommenderPageFormState extends State<RecommenderPageForm> {
  final TextEditingController trackUrlController = TextEditingController();
  String errorMessage = '';
  bool isFetching = false;
  bool gotSongs = false;
  ApiService api = ApiService();
  CsvService csv = CsvService();
  double selectedNumber = 1;
  List<Song>? songs;

  @override
  void initState() {
    super.initState();
    errorMessage = '';
  }

  @override
  void dispose() {
    trackUrlController.dispose();
    super.dispose();
  }

  void validateForm() {
    String playlistUrl = trackUrlController.text.trim();

    if (playlistUrl.isEmpty) {
      setState(() {
        errorMessage = 'Please enter a playlist URL.';
      });
    } else {
      setState(() {
        errorMessage = '';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(
                height: 32,
              ),
              SizedBox(
                width: 500,
                child: TextField(
                  controller: trackUrlController,
                  decoration: InputDecoration(
                    hintText: 'URL',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                    errorText: errorMessage.isNotEmpty ? errorMessage : null,
                  ),
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              Text(
                "Number of Songs : $selectedNumber",
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(
                width: 600,
                child: Slider(
                  activeColor: const Color(SPOTIFY_COLOR),
                  secondaryActiveColor: const Color(SPOTIFY_COLOR),
                  inactiveColor: Colors.black,
                  value: selectedNumber,
                  label: selectedNumber.toStringAsPrecision(1),
                  min: 1,
                  max: 5,
                  divisions: 4,
                  onChanged: (double newValue) {
                    setState(() {
                      selectedNumber = newValue;
                    });
                  },
                ),
              ),
              const SizedBox(height: 32.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(SPOTIFY_COLOR),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                    ),
                    onPressed: () async {
                      setState(() {
                        isFetching = true;
                      });
                      final data = await api.recommend_songs(
                        trackUrlController.text,
                        selectedNumber.toInt(),
                      );

                      if (data.isNotEmpty) {
                        setState(() {
                          songs = data;
                          gotSongs = true;
                          isFetching = false;
                        });
                      }
                    },
                    child: Container(
                      width: 100.0,
                      height: 40.0,
                      alignment: Alignment.center,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                      ),
                      child: const Text(
                        'Recommend',
                        style: TextStyle(
                          fontSize: 16.0,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 30,
                  ),
                ],
              ),
              const SizedBox(
                height: 30,
              ),
              gotSongs ? SongList(songs: songs!) : const SizedBox.shrink(),
              const SizedBox(
                height: 30,
              ),
              SizedBox(
                width: 700,
                child: Container(
                  color: Colors.grey[200], // Background color of the section
                  padding: const EdgeInsets.all(16.0),
                  width: double.infinity,
                  child: const Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        'About the Recommender',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 8.0),
                      Text(
                        RECOMMENDER_DESCRIPTION,
                        textAlign: TextAlign.left,
                        style: TextStyle(
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 32),
              SizedBox(
                width: 400,
                child: InkWell(
                  onTap: () {
                    const url = GITHUB_REPO;
                    launchUrl(Uri.parse(url));
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        'images/github.png',
                        width: 80,
                        height: 80,
                      ),
                      const SizedBox(width: 16),
                      const Text(
                        'Find the source code here',
                        style: TextStyle(
                          fontSize: 16,
                          decoration: TextDecoration.underline,
                          color: Colors.blue,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        if (isFetching)
          Container(
            color: Color(SPOTIFY_COLOR),
            child: const Center(
              child: CircularProgressIndicator(),
            ),
          ),
      ],
    );
  }
}
