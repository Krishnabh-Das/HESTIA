import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hestia/features/core/controllers/marker_map_controller.dart';

class SOSMiniMapController extends GetxController {
  static SOSMiniMapController get instance => Get.find();

  RxSet<Marker> markers = <Marker>{}.obs;
  var tappedPosition = MarkerMapController.instance.currPos.value;

  Future<void> addCurrMarkerInMiniMap() async {
    if (MarkerMapController.instance.currPos.value != null) {
      var currMarker = Marker(
          markerId: const MarkerId("miniMapCurr"),
          position: MarkerMapController.instance.currPos.value!,
          icon: BitmapDescriptor.defaultMarker);
      markers.add(currMarker);
    }
  }

  Future<void> miniMapTapMarker(LatLng position) async {
    var tapMarker = Marker(
        markerId: const MarkerId("miniMapTapMarker"),
        position: position,
        icon: BitmapDescriptor.defaultMarker);
    markers.assignAll({tapMarker});
    print("New mini tap marker: $tapMarker");
  }
}
