import traceback
from pprint import pformat
from typing import Dict, Optional, Union, List, Tuple

from geopy.distance import geodesic

import numpy as np
from collections import Counter
from sklearn.cluster import DBSCAN

from main import logger
from db.fireStoreDB import firestoreDB, GeoPoint
from core.errors.Markers import MarkerNotFoundError, SOSNotFoundError

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
        self.max_distance_km = max_distance_km

        self.getAllMarkers()
        self.getAllSOS()
        self.getAllEvents()

        self.cluster_markers_fn()
        self.cluster_SOS_Reports_fn()
        self.cluster_Events_fn()

        logger.info("Creadted statsNearYou object.")
        self.rate_clusters()
        self.rate_SOS_clusters()
        self.rate_Events_clusters()

    def get_SOS_cluster_label(self, target_marker_id: str) -> int:
        """
        Get the cluster label for a given marker ID.

        Parameters:
        - target_marker_id (str): Marker ID.

        Returns:
        - int: Cluster label.
        """
        for marker in self.SOS_Reports:
            if marker["SOS_Reports-id"] == target_marker_id:
                logger.info("Successful got cluster label for given marker.")
                return marker["cluster_label"]
        raise MarkerNotFoundError(
            f"Marker ID {target_marker_id} not found in the list."
        )

    def get_Events_cluster_label(self, target_marker_id: str) -> int:
        """
        Get the cluster label for a given marker ID.

        Parameters:
        - target_marker_id (str): Marker ID.

        Returns:
        - int: Cluster label.
        """
        for marker in self.Events:
            if marker["Events-id"] == target_marker_id:
                logger.info("Successful got cluster label for given marker.")
                return marker["cluster_label"]
        raise MarkerNotFoundError(
            f"Marker ID {target_marker_id} not found in the list."
        )

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

    def getAllSOS(
        self,
    ) -> None:
        """
        Retrieve all SOSReports from Firebase and store them in the instance.
        """
        SOS_Reports = []
        try:
            SOS_Reports_get = self.firebaseClient.collection("SOS_Reports").get()
            logger.info("Successfully retrived all SOS_Reports")

        except Exception as e:
            traceback_str = traceback.format_exc()
            logger.error("An error occurred: %s", str(e))
            logger.debug(f"Traceback: {traceback_str}")
        try:
            for m in SOS_Reports_get:  # type: ignore
                SOS_Report = {
                    "SOS_Reports-id": m.id,
                    "SOS_Reports_cord": (
                        m.to_dict()["incidentPosition"].to_protobuf().latitude,
                        m.to_dict()["incidentPosition"].to_protobuf().longitude,
                    ),
                }
                SOS_Reports.append(SOS_Report)
        except Exception as e:
            traceback_str = traceback.format_exc()
            logger.error("An error occurred: %s", str(e))
            logger.debug(f"Traceback: {traceback_str}")
        logger.info("Successfully got all SOS_Reports into python dict")
        self.SOS_Reports = SOS_Reports

    def getAllEvents(
        self,
    ) -> None:
        """
        Retrieve all Events from Firebase and store them in the instance.
        """
        Events = []
        try:
            Events_get = self.firebaseClient.collection("Events").get()
            logger.info("Successfully retrived all Events")

        except Exception as e:
            traceback_str = traceback.format_exc()
            logger.error("An error occurred: %s", str(e))
            logger.debug(f"Traceback: {traceback_str}")
        try:
            for m in Events_get:  # type: ignore
                Event = {
                    "Events-id": m.id,
                    "Events_cord": (
                        m.to_dict()["location"].to_protobuf().latitude,
                        m.to_dict()["location"].to_protobuf().longitude,
                    ),
                }
                Events.append(Event)
        except Exception as e:
            traceback_str = traceback.format_exc()
            logger.error("An error occurred: %s", str(e))
            logger.debug(f"Traceback: {traceback_str}")
        logger.info("Successfully got all SOS_Reports into python dict")
        self.Events = Events

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
        try:
            for m in markers_get:  # type: ignore
                marker = {
                    "marker-id": m.id,
                    "marker_cord": (m.to_dict()["lat"], m.to_dict()["long"]),
                }
                markers.append(marker)
        except Exception as e:
            traceback_str = traceback.format_exc()
            logger.error("An error occurred: %s", str(e))
            logger.debug(f"Traceback: {traceback_str}")
        logger.info("Successfully got all Markers into python dict")
        self.markers = markers

    def cluster_Events_fn(self) -> None:
        """
        Cluster SOS_Reports by coordinates using DBSCAN.
        """
        coordinates = np.array([marker["Events_cord"] for marker in self.Events])
        # Perform DBSCAN clustering
        labels = dbscan.fit_predict(coordinates)
        logger.info("Clustered SOS_Reports successfully.")

        # Add cluster labels to the markers
        for i, marker in enumerate(self.Events):
            marker["cluster_label"] = labels[i]
        logger.info("Updated Clusters with cluster ids.")
        logger.info(pformat(self.Events))

    def cluster_SOS_Reports_fn(self) -> None:
        """
        Cluster SOS_Reports by coordinates using DBSCAN.
        """
        coordinates = np.array(
            [marker["SOS_Reports_cord"] for marker in self.SOS_Reports]
        )
        # Perform DBSCAN clustering
        labels = dbscan.fit_predict(coordinates)
        logger.info("Clustered SOS_Reports successfully.")

        # Add cluster labels to the markers
        for i, marker in enumerate(self.SOS_Reports):
            marker["cluster_label"] = labels[i]
        logger.info("Updated Clusters with cluster ids.")
        logger.info(pformat(self.SOS_Reports))

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

    def getClusteredSOS_Reports(self) -> list[dict]:
        return self.SOS_Reports

    def getClusteredMarkers(self) -> list[dict]:
        return self.markers

    def getClusteredEvents(self) -> list[dict]:
        return self.Events

    def upadteClusterIDSOSfirestore(self) -> None:
        """
        Update cluster IDs in Firestore for all markers.
        """
        marker_ids = [marker["SOS_Reports-id"] for marker in self.SOS_Reports]
        try:
            for key in marker_ids:
                ref = self.firebaseClient.collection("SOS_Reports").document(str(key))
                ref.update(
                    {
                        "cluster": int(self.get_SOS_cluster_label(key)),
                    }
                )
            logger.info("Added updated cluster ids")
        except Exception as e:
            traceback_str = traceback.format_exc()
            logger.error("An error occurred: %s", str(e))
            logger.debug(f"Traceback: {traceback_str}")

    def upadteClusterIDEventsfirestore(self) -> None:
        """
        Update Events cluster IDs in Firestore for all markers.
        """
        marker_ids = [marker["Events-id"] for marker in self.Events]
        try:
            for key in marker_ids:
                ref = self.firebaseClient.collection("Events").document(str(key))
                ref.update(
                    {
                        "cluster": int(self.get_Events_cluster_label(key)),
                    }
                )
            logger.info("Added updated Events cluster ids")
        except Exception as e:
            traceback_str = traceback.format_exc()
            logger.error("An error occurred: %s", str(e))
            logger.debug(f"Traceback: {traceback_str}")

    def upadteClusterIDfirestore(self) -> None:
        """
        Update cluster IDs in Firestore for all markers.
        """
        marker_ids = [marker["marker-id"] for marker in self.markers]
        try:
            for key in marker_ids:
                ref = self.firebaseClient.collection("Markers").document(str(key))
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

    def find_nearest_SOS_Reports(
        self, target_lat: float, target_lon: float
    ) -> Optional[Dict[str, Union[str, Tuple[float, float], int]]]:
        """
        Find the nearest SOS_Reports within the specified maximum distance.

        Parameters:
        - target_lat (float): Target latitude.
        - target_lon (float): Target longitude.

        Returns:
        - Optional[Dict[str, Union[str, Tuple[float, float], int]]]: Nearest marker information or None if not found.
        """
        target_location = (target_lat, target_lon)
        nearest_marker = None
        min_distance = float("inf")

        for marker in self.SOS_Reports:
            marker_location = marker["SOS_Reports_cord"]
            distance = geodesic(target_location, marker_location).kilometers

            if distance < min_distance and distance <= self.max_distance_km:
                min_distance = distance
                nearest_marker = marker
        logger.info("Returned nearest SOS_Reports successfully.")
        if nearest_marker is not None:
            return nearest_marker
        else:
            return None

    def find_nearest_Events(
        self, target_lat: float, target_lon: float
    ) -> Optional[Dict[str, Union[str, Tuple[float, float], int]]]:
        """
        Find the nearest Events within the specified maximum distance.

        Parameters:
        - target_lat (float): Target latitude.
        - target_lon (float): Target longitude.

        Returns:
        - Optional[Dict[str, Union[str, Tuple[float, float], int]]]: Nearest marker information or None if not found.
        """
        target_location = (target_lat, target_lon)
        nearest_marker = None
        min_distance = float("inf")
        
        # logger.debug(self.Events)

        for marker in self.Events:
            marker_location = marker["Events_cord"]
            distance = geodesic(target_location, marker_location).kilometers

            if distance < min_distance and distance <= self.max_distance_km:
                min_distance = distance
                nearest_marker = marker
        logger.info("Returned nearest Events successfully.")
        if nearest_marker is not None:
            return nearest_marker
        else:
            return None

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
        if nearest_marker is not None:
            return nearest_marker
        else:
            return None

    def get_total_SOS_Reports_in_each_cluster(self):
        cluster_counts = Counter(marker["cluster_label"] for marker in self.SOS_Reports)
        print(dict(cluster_counts))
        return dict(cluster_counts)

    def get_total_Events_in_each_cluster(self):
        cluster_counts = Counter(marker["cluster_label"] for marker in self.Events)
        print(dict(cluster_counts))
        return dict(cluster_counts)

    def get_total_markers_in_each_cluster(self):
        cluster_counts = Counter(marker["cluster_label"] for marker in self.markers)
        print(dict(cluster_counts))
        return dict(cluster_counts)

    def calculate_percentile(self, dictionary, key):
        values = list(dictionary.values())
        values_below = sum(value < dictionary[key] for value in values)
        total_values = len(values)

        percentile = (values_below / total_values) * 100
        return percentile

    def rate_SOS_clusters(self):
        cluster_counts = self.get_total_SOS_Reports_in_each_cluster()
        # Calculate percentile for each cluster
        cluster_percentiles = {
            key: self.calculate_percentile(cluster_counts, key)
            for key in cluster_counts
        }
        logger.info("Successfully calullated SOS percentiles")
        # Assign star ratings based on percentiles
        cluster_ratings = {}
        for cluster_label, percentile in cluster_percentiles.items():
            rating = 0.05 * percentile
            cluster_ratings[cluster_label] = rating  # type:ignore

        self.SOS_cluster_ratings = cluster_ratings
        logger.info("Successfully Assigned SOS ratings")
        # print(type(cluster_ratings))

        try:
            doc_ref = self.firebaseClient.collection("Stats")
            for key, value in cluster_ratings.items():
                doc_ref.document(f"SOS_{key}").set({"SOS_Reports_star": value})
                doc_ref.document(f"SOS_{key}").update(
                    {"SOS_Reports_count": cluster_counts[key]}
                )
            logger.info("Successfully Updated to FireStoere")
        except Exception as e:
            traceback_str = traceback.format_exc()
            logger.error("An error occurred: %s", str(e))
            logger.debug(f"Traceback: {traceback_str}")

    def rate_Events_clusters(self):
        cluster_counts = self.get_total_Events_in_each_cluster()

        # Calculate percentile for each cluster
        cluster_percentiles = {
            key: self.calculate_percentile(cluster_counts, key)
            for key in cluster_counts
        }
        logger.info("Successfully calullated Events percentiles")
        # Assign star ratings based on percentiles
        cluster_ratings = {}
        for cluster_label, percentile in cluster_percentiles.items():
            rating = 0.05 * percentile
            cluster_ratings[cluster_label] = rating  # type:ignore

        self.Events_cluster_ratings = cluster_ratings
        logger.info("Successfully Assigned Events ratings")
        # print(type(cluster_ratings))

        try:
            doc_ref = self.firebaseClient.collection("Stats")
            for key, value in cluster_ratings.items():
                doc_ref.document(f"Events_{key}").set({"Events_star": value})
                doc_ref.document(f"Events_{key}").update(
                    {"Events_count": cluster_counts[key]}
                )
            logger.info("Successfully Updated to FireStoere")
        except Exception as e:
            traceback_str = traceback.format_exc()
            logger.error("An error occurred: %s", str(e))
            logger.debug(f"Traceback: {traceback_str}")

    def rate_clusters(self):
        cluster_counts = self.get_total_markers_in_each_cluster()
        # Calculate percentile for each cluster
        cluster_percentiles = {
            key: self.calculate_percentile(cluster_counts, key)
            for key in cluster_counts
        }
        logger.info("Successfully calullated percentiles")
        # Assign star ratings based on percentiles
        cluster_ratings = {}
        for cluster_label, percentile in cluster_percentiles.items():
            rating = 0.05 * percentile
            cluster_ratings[cluster_label] = rating  # type:ignore

        self.cluster_ratings = cluster_ratings
        logger.info("Successfully Assigned ratings")

        try:
            doc_ref = self.firebaseClient.collection("Stats")
            for key, value in cluster_ratings.items():
                doc_ref.document(f"{key}").set({"marker_star": value})
                doc_ref.document(f"{key}").update({"marker_count": cluster_counts[key]})
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
        try:
            marker = self.find_nearest_marker(target_lat=lat, target_lon=lon)
            logger.debug("##marker:")
            logger.debug(marker)
        except Exception as e:
            traceback_str = traceback.format_exc()
            logger.error("An error occurred: %s", str(e))
            logger.debug(f"Traceback: {traceback_str}")
            marker = None
        try:
            SOS = self.find_nearest_SOS_Reports(target_lat=lat, target_lon=lon)
        except Exception as e:
            traceback_str = traceback.format_exc()
            logger.error("An error occurred: %s", str(e))
            logger.debug(f"Traceback: {traceback_str}")
            SOS = None
        try:
            Events = self.find_nearest_Events(target_lat=lat, target_lon=lon)
            logger.debug("##EVNETS:")
            logger.debug(Events)
        except Exception as e:
            traceback_str = traceback.format_exc()
            logger.error("An error occurred: %s", str(e))
            logger.debug(f"Traceback: {traceback_str}")
            Events = None
        try:
            if marker is not None and SOS is not None and Events is not None:
                logger.debug("marker is not None and SOS is not None and Events is not None")
                data = (
                    self.firebaseClient.collection("Stats")
                    .document(f"{marker['cluster_label']}")  # type: ignore
                    .get()
                )
                data2 = (
                    self.firebaseClient.collection("Stats")
                    .document(f"SOS_{SOS['cluster_label']}")  # type: ignore
                    .get()
                )
                data3 = (
                    self.firebaseClient.collection("Stats")
                    .document(f"Events_{Events['cluster_label']}")  # type: ignore
                    .get()
                )
                logger.debug(data3.to_dict())
                logger.info("successfully got Stats for given coord")
                res_dict = data.to_dict()
                res_dict.update(data2.to_dict())
                res_dict.update(data3.to_dict())
                res_dict.update(
                    {
                        "Marker_cluster": int(marker["cluster_label"]),  # type: ignore
                        "SOS_cluster": int(SOS["cluster_label"]),  # type: ignore
                        "Events_cluster": int(Events["cluster_label"]),  # type: ignore
                    }
                )
            
            elif marker is None and SOS is not None and Events is not None:
                logger.debug("marker is None and SOS is not None and Events is not None")
                data2 = (
                    self.firebaseClient.collection("Stats")
                    .document(f"SOS_{SOS['cluster_label']}")  # type: ignore
                    .get()
                )
                data3 = (
                    self.firebaseClient.collection("Stats")
                    .document(f"Events_{Events['cluster_label']}")  # type: ignore
                    .get()
                )
                logger.info("successfully got Stats for given coord")
                res_dict = data2.to_dict()
                res_dict.update(data3.to_dict())
                res_dict.update(
                    {
                        "Marker_cluster": int(-2),
                        "marker_star": int(5),
                        "marker_count": 0,
                        "SOS_cluster": int(SOS["cluster_label"]),  # type: ignore
                        "Events_cluster": int(Events["cluster_label"]),  # type: ignore
                    }
                )  # type: ignore
            elif marker is not None and SOS is None and Events is not None:
                logger.debug("marker is not None and SOS is None and Events is not None")
                data = (
                    self.firebaseClient.collection("Stats")
                    .document(f"{marker['cluster_label']}")  # type: ignore
                    .get()
                )
                data3 = (
                    self.firebaseClient.collection("Stats")
                    .document(f"Events_{Events['cluster_label']}")  # type: ignore
                    .get()
                )
                logger.info("successfully got Stats for given coord")
                res_dict = data.to_dict()
                res_dict.update(data3.to_dict())
                res_dict.update(
                    {
                        "Marker_cluster": int(marker["cluster_label"]),  # type: ignore
                        "Events_cluster": int(-2),
                        "Events_Reports_star": int(5),
                        "Events_Reports_count": 0,
                        "SOS_cluster": int(SOS["cluster_label"]),  # type: ignore
                    }
                )  # type: ignore         
            elif marker is not None and SOS is not None and Events is None:
                logger.debug("marker is not None and SOS is None and Events is not None")
                data = (
                    self.firebaseClient.collection("Stats")
                    .document(f"{marker['cluster_label']}")  # type: ignore
                    .get()
                )
                data2 = (
                    self.firebaseClient.collection("Stats")
                    .document(f"SOS_{SOS['cluster_label']}")  # type: ignore
                    .get()
                )
                logger.info("successfully got Stats for given coord")
                res_dict = data.to_dict()
                res_dict.update(data2.to_dict())
                res_dict.update(
                    {
                        "Marker_cluster": int(marker["cluster_label"]),  # type: ignore
                        "SOS_cluster": int(SOS["cluster_label"]),
                        "Events_cluster": int(-2),
                        "Events_Reports_star": int(5),
                        "Events_Reports_count": 0,
                    }
                )
            
            elif marker is None and SOS is not None and Events is None:
                logger.debug("SOS is not None and marker is None and Events is None")
                data = (
                    self.firebaseClient.collection("Stats")
                    .document(f"{marker['cluster_label']}")  # type: ignore
                    .get()
                )
                logger.info("successfully got Stats for given coord")
                res_dict = data.to_dict()
                res_dict.update(
                    {
                        "SOS_cluster": int(SOS["cluster_label"]),  # type: ignore
                        "Marker_cluster": int(-2),
                        "Marker_Reports_star": int(5),
                        "Marker_Reports_count": 0,
                        "Events_cluster": int(-2),
                        "Events_Reports_star": int(5),
                        "Events_Reports_count": 0,
                    }
                )         
            elif marker is not None and SOS is None and Events is None:
                logger.debug("SOS is not None and marker is None and Events is None")
                data = (
                    self.firebaseClient.collection("Stats")
                    .document(f"{marker['cluster_label']}")  # type: ignore
                    .get()
                )
                logger.info("successfully got Stats for given coord")
                res_dict = data.to_dict()
                res_dict.update(
                    {
                        "Marker_cluster": int(marker["cluster_label"]),  # type: ignore
                        "SOS_cluster": int(-2),
                        "SOS_Reports_star": int(5),
                        "SOS_Reports_count": 0,
                        "Events_cluster": int(-2),
                        "Events_Reports_star": int(5),
                        "Events_Reports_count": 0,
                    }
                )
            elif marker is None and SOS is None and Events is not None:
                logger.debug("Events is not None and marker is None and Events is None")
                data = (
                    self.firebaseClient.collection("Stats")
                    .document(f"Events_{Events['cluster_label']}")  # type: ignore
                    .get()
                )
                logger.info("successfully got Stats for given coord")
                res_dict = data.to_dict()
                res_dict.update(
                    {
                        "Events_cluster": int(Events["cluster_label"]),  # type: ignore
                        "Marker_cluster": int(-2),
                        "Marker_star": int(5),
                        "Marker_count": 0,
                        "SOS_cluster": int(-2),
                        "SOS_Reports_star": int(5),
                        "SOS_Reports_count": 0,
                    }
                )
            
            else:
                res_dict = {
                    "Marker_cluster": int(-2),
                    "SOS_cluster": int(-2),
                    "SOS_Reports_star": int(5),
                    "marker_star": int(5),
                    "SOS_Reports_count": 0,
                    "marker_count": 0,
                    "Events_cluster": int(-2),
                    "Events_Reports_star": int(5),
                    "Events_Reports_count": 0,
                }
            
            return res_dict  # type: ignore
        except Exception as e:
            traceback_str = traceback.format_exc()
            logger.error("An error occurred: %s", str(e))
            logger.debug(f"Traceback: {traceback_str}")


stats = statsNearYou(firebase_clent=firestoreDB, max_distance_km=5.0)
