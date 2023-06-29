class Song {
  String url;
  String name;
  String genre;
  String similarity;

  Song(
      {required this.url,
      required this.name,
      required this.genre,
      required this.similarity});

  factory Song.from_json(Map<String, dynamic> songData) {
    return Song(
        url: songData['url'],
        name: songData['name'],
        genre: songData['genre'],
        similarity: songData['similarity']);
  }
}
