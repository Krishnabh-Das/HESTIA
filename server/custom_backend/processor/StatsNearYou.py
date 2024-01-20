import traceback
from pprint import pformat
from typing import Dict, Optional, Union, List, Tuple

from geopy.distance import geodesic

import numpy as np
from collections import Counter
from sklearn.cluster import DBSCAN

from main import logger
from configs.db import firestoreDB
from custoimErrors.Markers import MarkerNotFoundError

dbscan = DBSCAN(eps=1.0, min_samples=2)


class statsNearYou:
    def __init__(
        self,
        firebase_clent,
        max_distance_km: float,
    ) -> None:
        """
        Initialize the StatsNearYou instance.

        Parameters:
        - firebase_client : Firebase client instance.
        - max_distance_km (float): Maximum distance in kilometers to consider for finding the nearest marker.
        """
        self.firebaseClient = firebase_clent
        self.getAllMarkers()
        self.max_distance_km = max_distance_km
        self.cluster_markers_fn()
        logger.info("Creadted statsNearYou object.")

    def get_cluster_label(self, target_marker_id: str) -> int:
        """
        Get the cluster label for a given marker ID.

        Parameters:
        - target_marker_id (str): Marker ID.

        Returns:
        - int: Cluster label.
        """
        for marker in self.markers:
            if marker["marker-id"] == target_marker_id:
                logger.info("Successful got cluster label for given marker.")
                return marker["cluster_label"]
        raise MarkerNotFoundError(
            f"Marker ID {target_marker_id} not found in the list."
        )

    def getAllMarkers(
        self,
    ) -> None:
        """
        Retrieve all markers from Firebase and store them in the instance.
        """
        markers = []
        try:
            markers_get = self.firebaseClient.collection("Markers").get()
            logger.info("Successfully retrived all Markers")

        except Exception as e:
            traceback_str = traceback.format_exc()
            logger.error("An error occurred: %s", str(e))
            logger.debug(f"Traceback: {traceback_str}")

        for m in markers_get:  # type: ignore
            marker = {
                "marker-id": m.to_dict()["id"],
                "marker_cord": (m.to_dict()["lat"], m.to_dict()["long"]),
            }
            markers.append(marker)
        logger.info("Successfully got all Markers into python dict")
        self.markers = markers

    def cluster_markers_fn(self) -> None:
        """
        Cluster markers by coordinates using DBSCAN.
        """
        coordinates = np.array([marker["marker_cord"] for marker in self.markers])
        # Perform DBSCAN clustering
        labels = dbscan.fit_predict(coordinates)
        logger.info("Clustered makeres successfully.")

        # Add cluster labels to the markers
        for i, marker in enumerate(self.markers):
            marker["cluster_label"] = labels[i]
        logger.info("Updated Clusters with cluster ids.")

    def getClusteredMarkers(self) -> list[dict]:
        return self.markers

    def upadteClusterIDfirestore(self) -> None:
        """
        Update cluster IDs in Firestore for all markers.
        """
        marker_ids = [marker["marker-id"] for marker in self.markers]
        try:
            for key in marker_ids:
                ref = self.firebaseClient.collection("Markers").document(key)
                ref.update(
                    {
                        "cluster": int(self.get_cluster_label(key)),
                    }
                )
            logger.info("Added updated cluster ids")
        except Exception as e:
            traceback_str = traceback.format_exc()
            logger.error("An error occurred: %s", str(e))
            logger.debug(f"Traceback: {traceback_str}")

    def find_nearest_marker(
        self, target_lat: float, target_lon: float
    ) -> Optional[Dict[str, Union[str, Tuple[float, float], int]]]:
        """
        Find the nearest marker within the specified maximum distance.

        Parameters:
        - target_lat (float): Target latitude.
        - target_lon (float): Target longitude.

        Returns:
        - Optional[Dict[str, Union[str, Tuple[float, float], int]]]: Nearest marker information or None if not found.
        """
        target_location = (target_lat, target_lon)
        nearest_marker = None
        min_distance = float("inf")

        for marker in self.markers:
            marker_location = marker["marker_cord"]
            distance = geodesic(target_location, marker_location).kilometers

            if distance < min_distance and distance <= self.max_distance_km:
                min_distance = distance
                nearest_marker = marker
        logger.info("Returned nearest markers successfully.")
        return nearest_marker

    def get_total_markers_in_each_cluster(self):
        cluster_counts = Counter(marker["cluster_label"] for marker in self.markers)
        return dict(cluster_counts)

    def calculate_percentile(self, dictionary, key):
        values = list(dictionary.values())
        values_below = sum(value < dictionary[key] for value in values)
        total_values = len(values)

        percentile = (values_below / total_values) * 100

        return percentile

    def rate_clusters(self):
        cluster_counts = self.get_total_markers_in_each_cluster()
        total_markers = len(self.markers)
        # Calculate percentile for each cluster
        cluster_percentiles = {
            key: self.calculate_percentile(cluster_counts, key)
            for key in cluster_counts
        }
        logger.info("Successfully calullated percentiles")
        # Assign star ratings based on percentiles
        cluster_ratings = {}
        for cluster_label, percentile in cluster_percentiles.items():
            if percentile >= 80:
                rating = 1
            elif 60 <= percentile < 80:
                rating = 2
            elif 40 <= percentile < 60:
                rating = 3
            elif 20 <= percentile < 40:
                rating = 4
            elif 0 <= percentile < 20:
                rating = 4
            cluster_ratings[cluster_label] = rating  # type:ignore

        self.cluster_ratings = cluster_ratings
        logger.info("Successfully Assigned ratings")
        # print(type(cluster_ratings))

        try:
            doc_ref = self.firebaseClient.collection("Stats")
            for key, value in cluster_ratings.items():
                doc_ref.document(f"{key}").set({"marker_star": value})
            logger.info("Successfully Updated to FireStoere")
        except Exception as e:
            traceback_str = traceback.format_exc()
            logger.error("An error occurred: %s", str(e))
            logger.debug(f"Traceback: {traceback_str}")

    def statsByCoord(
        self, lat: float, lon: float
    ) -> Optional[Dict[str, Union[str, Tuple[float, float], int]]]:
        """
        Retrieve statistics for a given set of coordinates.

        Parameters:
        - lat (float): Latitude.
        - lon (float): Longitude.

        Returns:
        - Optional[Dict[str, Union[str, Tuple[float, float], int]]]: Statistics for the given coordinates or None if not found.
        """
        marker = self.find_nearest_marker(target_lat=lat, target_lon=lon)
        try:
            data = (
                self.firebaseClient.collection("Stats")
                .document(f"{marker['cluster_label']}")  # type: ignore
                .get()
            )
            logger.info("successfully got Statf for given coord")
            return data.to_dict()
        except Exception as e:
            traceback_str = traceback.format_exc()
            logger.error("An error occurred: %s", str(e))
            logger.debug(f"Traceback: {traceback_str}")


stats = statsNearYou(firebase_clent=firestoreDB, max_distance_km=5.0)
