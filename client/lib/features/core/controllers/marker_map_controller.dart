import 'dart:io';

import 'package:custom_info_window/custom_info_window.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hestia/features/core/screens/maps/MarkerMap/AddMarkerDetailsScreen.dart';
import 'package:image_picker/image_picker.dart';
import 'package:location/location.dart';

class MarkerMapController extends GetxController {
  static MarkerMapController get instance => Get.find();

  // -- CHANGING MAP TYPE
  final Rx<MapType> _currentMapType = MapType.normal.obs;
  MapType get currentMapType => _currentMapType.value;
  void toggleMap() {
    _currentMapType.value = _currentMapType.value == MapType.normal
        ? MapType.satellite
        : MapType.normal;
  }

  // -- MARKERS
  RxSet<Marker> markers = <Marker>{}.obs;
  RxSet<Marker> fixedMarkers = <Marker>{}.obs;

  // Add Markers when tapped
  void addTapMarkers(LatLng position, int id) {
    markers.clear();
    markers.add(
      Marker(
        markerId: MarkerId('$id'),
        position: position,
        draggable: true,
        onDragEnd: (value) => tapPosition = value,
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
      ),
    );

    markers.addAll(fixedMarkers);
  }

  // Delete all the Markers except which are fixed
  void deleteMarkersExceptFixed() {
    markers
      ..clear()
      ..addAll(fixedMarkers);
  }

  // Add a specific made up marker (but not adding Current Location in fixed)
  void addSpecificMarker(Marker marker, bool isCurr) {
    markers.add(marker);
    if (!isCurr) fixedMarkers.add(marker);
  }

  // Home Marker Add (To navigate Back to home)
  void homeMarkerAdd(Marker marker) {
    markers
      ..clear()
      ..add(marker);

    markers.addAll(fixedMarkers);
  }

  // -- CURRENT POSITION
  Rx<LatLng?> currPos = Rx<LatLng?>(null);

  void updateCurrPos(LatLng latLng) {
    currPos.value = latLng;
  }

  // -- CUSTOM INFO CONTROLLER OF MARKER
  Rx<CustomInfoWindowController> customInfoWindowController =
      CustomInfoWindowController().obs;

  void updateGoogleControllerForCustomInfoWindowController(
      GoogleMapController googleMapController) {
    customInfoWindowController.value.googleMapController = googleMapController;
  }

  // ------------------------------- VARIABLES (NON OBSERVABLE) --------------------------

  // Used to get the current location
  final Location locationController = Location();

  // Random Camera Position at Google Plex
  static const CameraPosition kGooglePlex =
      CameraPosition(target: LatLng(37.42, -125.08), zoom: 13);

  // Tracks the current Tapped Lat & Long (Position) => For Camera Mechanism
  LatLng? tapPosition;

  // -- Unique MarkerId & Image
  int id = 1;
  late File image = File('');

  // -- Animate Camera to current Location
  late final GoogleMapController googleMapController;

  // ------------------------------- FUNCTIONS ---------------------------------

  // -- Take permission and get current location
  Future<void> getUserLocation() async {
    try {
      bool serviceEnabled;
      PermissionStatus permissionGranted;

      serviceEnabled = await MarkerMapController.instance.locationController
          .serviceEnabled();

      if (!serviceEnabled) {
        serviceEnabled = await MarkerMapController.instance.locationController
            .requestService();
        if (!serviceEnabled) {
          return;
        }
      }

      permissionGranted =
          await MarkerMapController.instance.locationController.hasPermission();
      if (permissionGranted == PermissionStatus.denied) {
        permissionGranted = await MarkerMapController
            .instance.locationController
            .requestPermission();

        if (permissionGranted != PermissionStatus.granted) {
          updateCurrPos(LatLng(
              kGooglePlex.target.latitude, kGooglePlex.target.longitude));

          return;
        }
      }

      LocationData currentLocation =
          await MarkerMapController.instance.locationController.getLocation();

      updateCurrPos(
          LatLng(currentLocation.latitude!, currentLocation.longitude!));

      Marker currPosMarker = Marker(
        markerId: const MarkerId('currentLocation'),
        position: currPos.value!,
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
        infoWindow: const InfoWindow(
          title: "Your Current Location",
        ),
      );
      addSpecificMarker(currPosMarker, true);
    } catch (e) {
      print("Error getting user location: $e");
    }
  }

  // Open Camera / Gallery for Marker Description
  Future<void> getImage(bool isCamera) async {
    try {
      final pickedFile = await ImagePicker().pickImage(
        source: isCamera ? ImageSource.camera : ImageSource.gallery,
      );

      if (pickedFile != null) {
        File image = File(pickedFile.path);

        // Use 'await' when navigating to ImageScreen
        Marker? result = await Get.to(
          () => ImageScreen(
            image: image,
            position: tapPosition!,
            id: id,
            customInfoWindowController: customInfoWindowController.value,
          ),
        );

        // If 'result' is not null, it means the user posted an image
        if (result != null) {
          // Add the returned marker to the _markers list
          addSpecificMarker(result, false);
          id++;
        }
      }
    } catch (e) {
      print("Error picking image: $e");
    }
  }

  // Add the marker of the current location and move the camera there
  Future<void> moveToCurrLocation() async {
    googleMapController
        .animateCamera(CameraUpdate.newLatLngZoom(currPos.value!, 13));

    final marker = Marker(
        markerId: const MarkerId("currentLocation"),
        position: currPos.value!,
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
        infoWindow: const InfoWindow(title: "Current Location"));

    homeMarkerAdd(marker);
  }
}
