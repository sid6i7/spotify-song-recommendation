import 'package:flutter/material.dart';
import 'package:web/models/song.dart';
import 'package:web/widgets/song_card.dart';

class SongList extends StatefulWidget {
  final List<Song> songs;
  SongList({super.key, required this.songs});

  @override
  State<SongList> createState() => _SongListState();
}

class _SongListState extends State<SongList> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const Text(
          "We recommend the following songs",
          style: TextStyle(
            fontSize: 25,
          ),
        ),
        const SizedBox(
          height: 20,
        ),
        SingleChildScrollView(
          child: Column(
            children: [
              for (final song in widget.songs)
                SongCard(
                  song: song,
                ),
              if (widget.songs.isEmpty)
                const Center(
                  child: Text("No songs found"),
                ),
            ],
          ),
        ),
      ],
    );
  }
}
