from flask import Flask, request, jsonify
from flask_cors import CORS
from providers.scraper import *
from providers.recommender import *

app = Flask(__name__)
CORS(app)
scraper = Scraper()

@app.route("/hi")
def hello():
    return jsonify({"hi": "hello"})

@app.route("/playlist", methods=['POST'])
def get_playlist_as_csv():
    data = request.get_json()
    playlistUrl = data.get("playlist_url")
    message = "csv has been saved"
    try:
        scraper.get_playlist(playlistUrl)
        csvData = scraper.save_trackdata_csv()
    except:
        message = "Playlist not found"
        return jsonify({
            'message': message
        }), 404

    return jsonify({
        'message': message,
        'csv': csvData
    })

@app.route("/recommend", methods = ['POST'])
def recommend():
    recommender = RecommendationSystem()
    data = request.get_json()
    link = data.get('link')
    n_of_songs = data.get('n_of_songs')
    songUrl, songs = recommender.recommend(link, n_of_songs=int(n_of_songs))
    return jsonify({
        'song_url': songUrl,
        'similar_song_urls': [song.to_dict() for song in songs],
    })

if __name__ == "__main__":
    app.run(debug=True, port=5000, host="0.0.0.0")