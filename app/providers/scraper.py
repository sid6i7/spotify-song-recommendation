import spotipy
from spotipy.oauth2 import SpotifyClientCredentials
import pandas as pd
from config import *

class Scraper:
    """
    A class for scraping track data from a Spotify playlist.

    Attributes:
        spotifyCredentials (SpotifyClientCredentials): Spotify client credentials.
        spotify (spotipy.Spotify): Spotify API client.
        trackData (list): List to store the track data.

    Methods:
        get_tracks_from_playlist: Retrieves track data from a Spotify playlist.
        __trackdata_to_df: Converts the track data to a DataFrame.
        __get_track_features: Retrieves track features from the Spotify API.
        get_playlist: Retrieves tracks from a playlist given its link.
        save_trackdata_csv: Saves the track data as a CSV file.
    """

    def __init__(self) -> None:
        """
        Initializes the Scraper object.

        It sets up the Spotify client credentials and initializes the trackData list.
        """
        self.spotifyCredentials = SpotifyClientCredentials(client_id=SPOTIFY_CLIENT_ID, client_secret=SPOTIFY_CLIENT_SECRET)
        self.spotify = spotipy.Spotify(client_credentials_manager=self.spotifyCredentials)
        self.trackData = []

    def get_tracks_from_playlist(self, playlistUri):
        """
        Retrieves track data from a Spotify playlist.

        Args:
            playlistUri (str): The URI of the Spotify playlist.

        The function iterates through the tracks in the playlist and retrieves track information,
        including track name, artist name, artist popularity, artist genres, album, track popularity,
        and track features. It stores the track data in the trackData list.
        """
        for track in self.spotify.playlist_tracks(playlistUri)["items"]:
            trackUri = track["track"]["uri"]
            trackFeatures = self.get_track_features(trackUri)

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

    def __trackdata_to_df(self):
        """
        Converts the track data to a DataFrame.

        Returns:
            pandas.DataFrame: DataFrame containing the track data.

        It converts the trackData list into a pandas DataFrame.
        """
        return pd.DataFrame(self.trackData)
    
    def __parse_features(self, trackFeatures):
        parsedFeatures = {}
        for feature in SONG_FEATURES:
            parsedFeatures[feature] = trackFeatures[feature]
        return parsedFeatures

    def get_track_features(self, trackUri, parse=False):
        """
        Retrieves track features from the Spotify API.

        Args:
            trackUri (str): The URI of the Spotify track.

        Returns:
            dict: Track features in the form of a dictionary.

        It retrieves track features from the Spotify API for a given track URI.
        """
        if parse:
            features = self.__parse_features(self.spotify.audio_features(trackUri)[0])
        else:
            features = self.spotify.audio_features(trackUri)[0]
        return features

    def get_playlist(self, playlistLink):
        """
        Retrieves tracks from a playlist given its link.

        Args:
            playlistLink (str): The link to the Spotify playlist.

        It extracts the playlist URI from the given link and calls the get_tracks_from_playlist
        method to retrieve the tracks from the playlist.
        """
        playlistUri = playlistLink.split("/")[-1].split("?")[0]
        self.get_tracks_from_playlist(playlistUri)

    def save_trackdata_csv(self):
        """
        Saves the track data as a CSV file.

        Returns:
            str: The CSV data as a string.

        It converts the track data to a DataFrame, saves it as a CSV file, and returns
        the CSV data as a string.
        """
        songDf = self.__trackdata_to_df()
        csvData = songDf.to_csv(index=False)
        return csvData