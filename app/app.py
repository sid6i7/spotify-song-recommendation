from flask import Flask, request, jsonify
from providers.scraper import *

app = Flask(__name__)
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

if __name__ == "__main__":
    app.run(debug=True)