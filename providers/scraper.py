import spotipy
from spotipy.oauth2 import SpotifyClientCredentials
import pandas as pd
from config import *

class Scraper:
    def __init__(self) -> None:
        self.spotifyCredentials = SpotifyClientCredentials(client_id=SPOTIFY_CLIENT_ID, client_secret=SPOTIFY_CLIENT_SECRET)
        self.spotify = spotipy.Spotify(client_credentials_manager=self.spotifyCredentials)
        self.trackData = []
    
    def get_tracks_from_playlist(self, playlistUri):
        for track in self.spotify.playlist_tracks(playlistUri)["items"]:
            trackUri = track["track"]["uri"]
            trackFeatures = self.zget_track_features(trackUri)
            
            trackName = track["track"]["name"]
            
            artistUri = track["track"]["artists"][0]["uri"]
            artistInfo = self.spotify.artist(artistUri)
            
            artistName = track["track"]["artists"][0]["name"]
            artistPop = artistInfo["popularity"]
            artistGenres = artistInfo["genres"]
            
            album = track["track"]["album"]["name"]
            
            trackPop = track["track"]["popularity"]
            
            track_data = {
                'Track Name': trackName,
                'Artist Name': artistName,
                'Artist Popularity': artistPop,
                'Artist Genres': artistGenres,
                'Album': album,
                'Track Popularity': trackPop
            }
            
            # Add each key-value pair from trackFeatures as a separate column
            for key, value in trackFeatures.items():
                track_data[key] = value
            
            self.trackData.append(track_data)
            break
    
    def trackdata_to_df(self):
        return pd.DataFrame(self.trackData)
    
    def get_track_features(self, trackUri):
        return self.spotify.audio_features(trackUri)[0]
    
    def get_playlist(self, playlistLink):
        playlistUri = playlistLink.split("/")[-1].split("?")[0]
        self.get_tracks_from_playlist(playlistUri)
    
    def save_trackdata_csv(self):
        path = os.path.join(OUTPUT_DIR, 'playlist.csv')
        song_df = self.trackdata_to_df()
        song_df.to_csv(path)

        

