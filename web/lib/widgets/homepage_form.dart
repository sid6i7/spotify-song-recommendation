import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:web/config.dart';
import 'package:web/services/api_service.dart';
import 'package:web/services/csv_service.dart';
import 'package:web/widgets/dialog.dart';

class HomePageForm extends StatefulWidget {
  const HomePageForm({super.key});

  @override
  _HomePageFormState createState() => _HomePageFormState();
}

class _HomePageFormState extends State<HomePageForm> {
  final TextEditingController playlistUrlController = TextEditingController();
  String errorMessage = '';
  String csvData = '';
  bool isFetching = false;
  ApiService api = ApiService();
  CsvService csv = CsvService();

  @override
  void initState() {
    super.initState();
    csvData = '';
    errorMessage = '';
  }

  @override
  void dispose() {
    playlistUrlController.dispose();
    super.dispose();
  }

  void validateForm() {
    String playlistUrl = playlistUrlController.text.trim();

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
                  controller: playlistUrlController,
                  decoration: InputDecoration(
                    hintText: 'Playlist URL',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                    errorText: errorMessage.isNotEmpty ? errorMessage : null,
                  ),
                ),
              ),
              const SizedBox(height: 32.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          const Color(SPOTIFY_COLOR), // Use Spotify green color
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                            20.0), // Make the button rounded
                      ),
                    ),
                    onPressed: () async {
                      setState(() {
                        isFetching = true;
                      });
                      final data = await api
                          .get_playlist_data(playlistUrlController.text);
                      setState(() {
                        isFetching = false;
                      });
                      if (data.isEmpty) {
                        if (context.mounted) {
                          showAlertDialog(
                            context,
                            "Error",
                            "Playlist not found",
                          );
                        }
                      } else {
                        setState(() {
                          csvData = data;
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
                        'Scrape',
                        style: TextStyle(
                          fontSize: 16.0,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 30,
                  ),
                  Visibility(
                    visible: csvData.isNotEmpty,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(
                            SPOTIFY_COLOR), // Use Spotify green color
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                              20.0), // Make the button rounded
                        ),
                      ),
                      onPressed: () {
                        csv.initiateFileDownload(csvData);
                        csvData = '';
                        if (context.mounted) {
                          showAlertDialog(
                            context,
                            "Success",
                            "playlist.csv file has been download to your downloads folder",
                          );
                        }
                        setState(() {
                          playlistUrlController.clear();
                        });
                      },
                      child: Container(
                        width: 100.0,
                        height: 40.0,
                        alignment: Alignment.center,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                        ),
                        child: const Text(
                          'Download',
                          style: TextStyle(
                            fontSize: 16.0,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
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
                        'About the App',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 8.0),
                      Text(
                        APP_DESCRIPTION,
                        textAlign: TextAlign.center,
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
                        'images/github.png', // Replace with the path to your GitHub logo image
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
            color: Colors.black54,
            child: const Center(
              child: CircularProgressIndicator(),
            ),
          ),
      ],
    );
  }
}
