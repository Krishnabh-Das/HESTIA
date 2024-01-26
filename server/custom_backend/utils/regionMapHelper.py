from scipy.spatial import ConvexHull
from google.cloud.firestore import GeoPoint
from google.cloud.firestore_v1.base_query import FieldFilter

import numpy as np
from itertools import combinations
from geopy.distance import geodesic

from utils.GeoLoc import geoLoc
from configs.db import firestoreDB

def calculate_convex_hull_area(coords):
    """
    Calculates the area of the convex hull formed by a set of coordinates.

    Args:
    - `coords` (list of tuples): List of coordinate tuples (latitude, longitude).

    Returns:
    - float: The area of the convex hull.
    """
    hull = ConvexHull(coords)
    return hull.volume

def select_bounding_coords(coordinates:list)->list:
    """
    Selects the bounding coordinates with the maximum convex hull area.

    Args:
    - `coordinates` (list of GeoPoint): List of GeoPoint coordinates.

    Returns:
    - list of GeoPoint: Bounding coordinates with the maximum convex hull area.
    """
    max_area = 0
    max_area_coords = None

    # Iterate through all combinations of coordinates
    for i in range(len(coordinates), -1,-1):
        for comb in combinations(coordinates, i):        # Assuming you want to form a triangle (change to 4 for quadrilateral, etc.)
            if not all(c in comb for c in coordinates):  # Skip combinations where not all coordinates are included
                continue
            area = calculate_convex_hull_area(np.array(comb))
            if area > max_area:
                max_area = area
                max_area_coords = comb

    coordList = [GeoPoint(x[0], x[1]) for x in max_area_coords] # type: ignore
    return coordList

def get_dict_by_regionMapId(regionMaps, regionMap_id):
    """
    Retrieves a dictionary containing region map data based on the regionMap_id.

    Args:
    - `regionMaps` (list of dict): List of region map dictionaries.
    - `regionMap_id` (str): ID of the region map.

    Returns:
    - dict or None: Dictionary containing region map data or None if not found.
    """
    for region_map in regionMaps:
        if region_map['regionMap_id'] == regionMap_id:
            return region_map
    return None

def get_marker_cord_by_id(markers_, marker_id):
    """
    Retrieves the GeoPoint coordinates of a marker based on its ID.

    Args:
    - `markers_` (list of dict): List of marker dictionaries.
    - `marker_id` (str): ID of the marker.

    Returns:
    - GeoPoint or None: GeoPoint coordinates of the marker or None if not found.
    """
    for marker in markers_:
        if marker['marker-id'] == marker_id:
            return GeoPoint(marker['marker_cord'][0],marker['marker_cord'][1])
    return None

def get_marker_cord_by_id_tuple(markers_, marker_id):
    """
    Retrieves the coordinates tuple of a marker based on its ID.

    Args:
    - `markers_` (list of dict): List of marker dictionaries.
    - `marker_id` (str): ID of the marker.

    Returns:
    - tuple or None: Coordinates tuple of the marker or None if not found.
    """
    for marker in markers_:
        if marker['marker-id'] == marker_id:
            return marker['marker_cord']
    return None

def markersDB(start_date, end_date):
    """
    Retrieves markers from Firestore within a specified date range.

    Args:
    - `start_date` (datetime): Start date of the range.
    - `end_date` (datetime): End date of the range.

    Returns:
    - list of dict: List of marker dictionaries.
    """
    markers_ = []
    markers_get = firestoreDB.collection('Markers').where(filter=FieldFilter('time', ">=", start_date)).where(filter=FieldFilter('time', "<", end_date)).get()
    # markers_get = db.collection('Markers').get()
    for m in markers_get:
        marker = {
            "marker-id":m.to_dict()["id"],
            "marker_cord":(m.to_dict()["lat"],m.to_dict()["long"]),
            }
        markers_.append(marker)
    
    return markers_

def is_within_distance(coord1, coord2, max_distance:int=2000):
    """
    Checks if two coordinates are within a specified distance.

    Args:
    - `coord1` (GeoPoint): First coordinate.
    - `coord2` (GeoPoint): Second coordinate.
    - `max_distance` (int): Maximum distance threshold (default is 2000 meters).

    Returns:
    - bool: True if within distance, False otherwise.
    """
    distance = geodesic(coord1, coord2).meters
    return distance <= max_distance

def getRegionmapDB():
    """
    Retrieves region maps from Firestore.

    Returns:
    - tuple: A tuple containing Firestore query result and a list of region map dictionaries.
    """
    regionMaps = []
    regionMaps_get = firestoreDB.collection('RegionMap').get()
    for m in regionMaps_get:
        data = m.to_dict()
        data["regionMap_id"]= m.id
        regionMaps.append(data)
        
    for r in regionMaps:
        r['central_coord'] = (r['central_coord'].to_protobuf().latitude, r['central_coord'].to_protobuf().longitude)
        r['coords'] = [(x.to_protobuf().latitude, x.to_protobuf().longitude)for x in r['coords']]
        
    return regionMaps_get, regionMaps

def getParings(markers_, regionMaps):
    """
    Finds pairings between markers and region maps based on distance.

    Args:
    - `markers_` (list of dict): List of marker dictionaries.
    - `regionMaps` (list of dict): List of region map dictionaries.

    Returns:
    - dict: Dictionary containing marker IDs
    and corresponding region map IDs based on proximity.
    """
    parings = {}
    for marker in markers_:
        marker_coord = marker['marker_cord']
        for region_map in regionMaps:
            for coord in region_map['coords']:
                if is_within_distance(marker_coord, coord):
                    parings[marker['marker-id']]=region_map['regionMap_id']
       
    return parings

def createCoordinateCluster(coordinates):
    """
    Creates clusters of coordinates based on proximity.

    Args:
    - `coordinates` (list of GeoPoint): List of GeoPoint coordinates.

    Returns:
    - list of lists: List of coordinate clusters.
    """
    coordinate_clusters = []

    # Iterate through each coordinate
    for coord in coordinates:
        # Check if the coordinate is within 500 meters of any existing cluster
        found_cluster = False
        for cluster in coordinate_clusters:
            if any(is_within_distance(coord, c) for c in cluster):
                cluster.append(coord)
                found_cluster = True
                break

        # If not within 500 meters of any existing cluster, create a new cluster
        if not found_cluster:
            coordinate_clusters.append([coord])
    
    return coordinate_clusters

def addNewRegionMaps(coordinate_clusters, markers_):
    """
    Creates and adds new region maps to the Firestore database.

    Args:
    - coordinate_clusters (list): A list of lists, where each inner list contains coordinates (latitude, longitude).
    - markers_ (list): A list of dictionaries representing markers with 'marker-id' and 'marker_cord' keys.

    Returns:
    list: A list of dictionaries representing the added region maps, each containing 'central_coord', 'coords', and 'markers'.
    """
    region_data = []
    for coords_lst in coordinate_clusters:
        marker_ids = [entry['marker-id'] for entry in markers_ if entry['marker_cord'] in coords_lst]
        
        average_latitude = sum(lat for lat, lon in coords_lst) / len(coords_lst)
        average_longitude = sum(lon for lat, lon in coords_lst) / len(coords_lst)
        
        locname = geoLoc.reverse(f"{average_latitude}, {average_longitude}")

        central_coord = GeoPoint(average_latitude, average_longitude)

        data = {
            "central_coord": central_coord,
            "location": locname.address, # type: ignore
            "coords": [GeoPoint(x[0],x[1]) for x in coords_lst],
            "markers":marker_ids
        }
        region_data.append(data)
        
    for data in  region_data:
        update_time, rm_ref = firestoreDB.collection('RegionMap').add(data)
    return region_data
