import dotenv
import os
dotenv.load_dotenv()
SPOTIFY_CLIENT_ID = os.getenv('SPOTIFY_CLIENT_ID')
SPOTIFY_CLIENT_SECRET = os.getenv('SPOTIFY_CLIENT_SECRET')
OUTPUT_DIR = "./output"
DATA_DIR = "./data"
SCALER_DIR = "scalers"
SONG_FEATURES = ["danceability", "energy", "key", "loudness", "mode", "speechiness", "acousticness", "instrumentalness", "liveness", "valence", "tempo", "uri", "duration_ms", "time_signature"]
SONGS_DF_NAME = 'genres_v2.csv'
SCALER_NAME = 'continuous_scaler.pkl'
ALL_TRACKS = 'allTracks.pkl'
BASE_URL = 'https://open.spotify.com/'
TRACK_ENDPOINT = 'track/'