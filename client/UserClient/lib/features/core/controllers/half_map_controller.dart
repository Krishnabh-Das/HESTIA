import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hestia/data/repositories/auth_repositories.dart';

class HalfMapController extends GetxController {
  static HalfMapController get instance => Get.find();

  RxSet<Marker> allHalfMapMarkers = <Marker>{}.obs;

  Future<void> makeHalfMapMarkers(var listofRetrievedMarkers) async {
    var userID = AuthRepository().getUserId();

    print("makeHalfMapMarkers is called : $listofRetrievedMarkers");

    for (var map in listofRetrievedMarkers) {
      LatLng? position = map["lat"] != null && map["long"] != null
          ? LatLng(map["lat"], map["long"])
          : null;

      if (position != null) {
        bool isUsersMarker;
        if (map["userid"] == userID) {
          isUsersMarker = true;
        } else {
          isUsersMarker = false;
        }

        Marker marker = Marker(
            markerId: MarkerId("${map["id"]}"),
            position: position,
            infoWindow: isUsersMarker
                ? const InfoWindow(title: "Your Marker")
                : const InfoWindow(title: "Other's Marker"),
            icon: isUsersMarker
                ? BitmapDescriptor.defaultMarker
                : BitmapDescriptor.defaultMarkerWithHue(
                    BitmapDescriptor.hueGreen));

        allHalfMapMarkers.add(marker);
      }
    }
  }

  Future<void> removeMarkerFromHalfMap(String markerId) async {
    late Marker markerToRemove;
    for (var marker in allHalfMapMarkers) {
      if (marker.markerId.value == markerId) {
        markerToRemove = marker;
      }
    }

    allHalfMapMarkers.remove(markerToRemove);
  }
}
