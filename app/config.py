import dotenv
import os
dotenv.load_dotenv()
SPOTIFY_CLIENT_ID = os.getenv('SPOTIFY_CLIENT_ID')
SPOTIFY_CLIENT_SECRET = os.getenv('SPOTIFY_CLIENT_SECRET')
OUTPUT_DIR = "./output"
DATA_DIR = "./data"
SCALER_DIR = "scalers"