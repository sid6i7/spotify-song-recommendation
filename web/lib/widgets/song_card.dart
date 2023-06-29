import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:web/config.dart';
import 'package:web/models/song.dart';

class SongCard extends StatelessWidget {
  final Song song;
  const SongCard({super.key, required this.song});

  _redirect() {
    launchUrl(Uri.parse(song.url));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 300,
      padding: const EdgeInsets.all(5),
      child: Card(
        elevation: 4,
        child: ListTile(
          leading: const Icon(
            Icons.music_note,
            color: Color(SPOTIFY_COLOR),
          ),
          title: Text(
            song.name,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          subtitle: Text(song.genre),
          trailing: Text(
            song.similarity,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 15,
              color: Color(SPOTIFY_COLOR),
            ),
          ),
          onTap: _redirect,
        ),
      ),
    );
  }
}
