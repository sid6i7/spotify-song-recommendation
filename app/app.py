from flask import Flask, request, jsonify
from providers.scraper import *

app = Flask(__name__)
scraper = Scraper()

@app.route("/playlist", methods=['POST'])
def get_playlist_as_csv():
    playlistUrl = request.form.get('playlist_url')
    message = "csv has been saved"
    try:
        scraper.get_playlist(playlistUrl)
    except:
        message = "some error occured"

    csvData = scraper.save_trackdata_csv()

    return jsonify({
        'message': csvData
    })