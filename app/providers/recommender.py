from config import *
import pickle
import numpy as np
import pandas as pd
from sklearn.metrics.pairwise import cosine_similarity
from providers.scraper import *

class RecommendationSystem:

    def __load_data(self):
       
       processedTracksPath = os.path.join(DATA_DIR, ALL_TRACKS)
       with open(processedTracksPath, 'rb') as f:
           self.allTracks = pickle.load(f)
       scalerDir = os.path.join(DATA_DIR, SCALER_DIR)
       scalerPath = os.path.join(scalerDir, SCALER_NAME) 
       with open(scalerPath, 'rb') as f:
           self.scaler = pickle.load(f)
       dfPath = os.path.join(DATA_DIR, SONGS_DF_NAME)
       self.songsDf = pd.read_csv(dfPath)
        
    def __init__(self) -> None:
        self.__load_data()
        self.featuresToDrop = ['type', 'id', 'uri', 'track_href', 'analysis_url']
        self.scraper = Scraper()
        self.baseTrackUrl = BASE_URL + TRACK_ENDPOINT
    
    def parse_uri(self, songUris):
        urls = []
        for uri in songUris:
            trackId = uri.split(":")[-1].strip()
            urls.append(self.baseTrackUrl + trackId)
        return urls
    
    def get_similar_songs_cosine(self, trackFeatures, n_of_songs):
        similarityScores = cosine_similarity(trackFeatures, self.allTracks)
        sorted_indices = np.argsort(-similarityScores)
        similarIndices = sorted_indices[0][:n_of_songs]
        songsUris = self.songsDf.iloc[similarIndices].uri.values
        return songsUris
    
    def recommend(self, link, use_method = 'cosine', n_of_songs=5):
        trackFeatures = self.scraper.get_track_features(link)
        trackUri = trackFeatures['uri']
        songUris = []
        for feature in self.featuresToDrop:
            del trackFeatures[feature]
        trackFeatures = np.array(list(trackFeatures.values())).reshape(1, -1)
        trackFeatures = self.scaler.transform(trackFeatures)
        if use_method == 'cosine':
            songUris = self.get_similar_songs_cosine(trackFeatures, n_of_songs)
        trackUrl = self.parse_uri([trackUri])
        songUrls = self.parse_uri(songUris)
        return trackUrl, songUrls