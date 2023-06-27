import 'package:flutter/material.dart';

class SongList extends StatefulWidget {
  final List<dynamic> songs;
  SongList({super.key, required this.songs});

  @override
  State<SongList> createState() => _SongListState();
}

class _SongListState extends State<SongList> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 400,
      child: ListView.builder(
        itemCount: widget.songs.length,
        itemBuilder: (context, index) {
          if (index < widget.songs.length) {
            return Container(
              child: Text(widget.songs[index]),
            );
          } else {
            return Center(
              child: Text("No songs found"),
            );
          }
        },
      ),
    );
  }
}
