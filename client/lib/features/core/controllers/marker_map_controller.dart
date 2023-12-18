import 'dart:io';
import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hestia/data/repositories/auth_repositories.dart';
import 'package:hestia/data/repositories/firebase_queries_for_markers/firebase_queries_for_markers.dart';
import 'package:hestia/data/repositories/firebase_queries_for_regionMap/firebase_queries_for_regionMap.dart';
import 'package:hestia/features/core/screens/maps/MarkerMap/widgets/custom_marker.dart';
import 'package:hestia/utils/constants/images_strings.dart';
import 'package:hestia/utils/constants/sizes.dart';
import 'package:http/http.dart' as http;
import 'package:custom_info_window/custom_info_window.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hestia/data/repositories/firebase_query_repository/firebase_query_for_users.dart';
import 'package:hestia/features/core/screens/maps/MarkerMap/AddMarkerDetailsScreen.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:location/location.dart';
import 'package:path_provider/path_provider.dart';
import 'package:widget_to_marker/widget_to_marker.dart';

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

  // -- SHOW POLYGON
  Rx<bool> showPolygon = false.obs;
  RxSet<Polygon> polygons = <Polygon>{}.obs;
  void toggleShowPolygon() async {
    showPolygon.value = !showPolygon.value;

    if (showPolygon.value) {
      polygons.value =
          await FirebaseQueryForRegionMap().getPolygonsFromFirestore();
      markers.clear();
    } else {
      markers.addAll(fixedMarkers);
    }
  }

  // -- CHECK IF INFO WINDOW OPENED OR CLOSED
  Rx<bool> IsInfoWindowOpen = false.obs;
  void changeValueOfInfoWindowOpen(bool value) {
    IsInfoWindowOpen.value = value;
  }

  // -- MARKERS
  RxSet<Marker> markers = <Marker>{}.obs;
  Set<Marker> fixedMarkers = <Marker>{};

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
    print("inside addspecificmarker: $markers");
    if (!isCurr) {
      print("Added fixedMarkers");
      fixedMarkers.add(marker);
    }

    markers.add(marker);
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

  // -- Loading Effect in Buttons (For POST Button)
  Rx<bool> isloading = false.obs;
  void toggleIsLoading() {
    isloading.value = !isloading.value;
  }

  // ------------------------------- VARIABLES (NON OBSERVABLE) --------------------------

  // MarkerScreen Context (for Bottom Sheet)
  late BuildContext context;

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
        icon: await const HexagonWidget(
          imagePath: MyAppImages.profile2,
        ).toBitmapDescriptor(
          logicalSize: const Size(50, 50),
          imageSize: const Size(180, 180),
        ),
        infoWindow: const InfoWindow(
          title: "Your Current Location",
        ),
      );

      addSpecificMarker(currPosMarker, true);
    } catch (e) {
      print("Error getting user location: $e");
    }
  }

  // -- Open Camera / Gallery for Marker Description
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

  // -- Add the marker of the current location and move the camera there
  Future<void> moveToCurrLocation() async {
    customInfoWindowController.value.hideInfoWindow!();
    googleMapController
        .animateCamera(CameraUpdate.newLatLngZoom(currPos.value!, 16));

    final marker = Marker(
        markerId: const MarkerId("currentLocation"),
        position: currPos.value!,
        icon: await const HexagonWidget(
          imagePath: MyAppImages.profile2,
        ).toBitmapDescriptor(
            logicalSize: const Size(50, 50), imageSize: const Size(180, 180)),
        infoWindow: const InfoWindow(title: "Current Location"));

    homeMarkerAdd(marker);
  }

  // -- Making Custom Markers
  Marker MakeFixedMarker(
    int id,
    LatLng position,
    CustomInfoWindowController customInfoWindowController,
    String desc,
    Timestamp? time,
    String imageUrl,
    bool hasDelete,
  ) {
    print('Creating marker with id: $id');

    Marker marker = Marker(
      markerId: MarkerId('$id'),
      position: position,
      draggable: true,
      onDrag: (LatLng value) {
        print('Marker $id dragged to position: $value');
        position = value;
        customInfoWindowController.hideInfoWindow!();
      },
      onTap: () async {
        print('Marker $id tapped');

        customInfoWindowController.addInfoWindow!(
            infoWindow(desc, null, id, time, hasDelete), position);

        Directory tempDir = await getTemporaryDirectory();
        String appDirPath = '${tempDir.path}/HESTIA/MarkerImages/';
        File? imageFile = File('$appDirPath/image_file$id.png');

        File? image = imageFile.existsSync()
            ? imageFile
            : await getImageFile(imageUrl, id);
        customInfoWindowController.addInfoWindow!(
            infoWindow(desc, image, id, time, hasDelete), position);
      },
      icon: BitmapDescriptor.defaultMarkerWithHue(
        BitmapDescriptor.hueRed,
      ),
    );

    print('Marker created: $marker');
    return marker;
  }

  // -- Making Custom Info Window For Custom Marker (or Fixed Markers)
  Widget infoWindow(
      String text, File? image, int markerid, Timestamp? time, bool hasDelete) {
    print('Creating info window for marker $markerid');
    changeValueOfInfoWindowOpen(true);

    return GestureDetector(
      onTap: () {
        print('Info window tapped for marker $markerid');
        MarkerDetailsBottomSheet(image, text, time);
      },
      child: Container(
        width: 250,
        height: 300,
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(15.0),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 280,
              height: 100,
              decoration: BoxDecoration(
                image: image != null
                    ? DecorationImage(
                        image: FileImage(image),
                        fit: BoxFit.fitWidth,
                        filterQuality: FilterQuality.high,
                      )
                    : null,
                borderRadius: const BorderRadius.all(Radius.circular(15.0)),
                color: Colors.red[400],
              ),
              child: image == null
                  ? const Center(
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 4,
                      ),
                    )
                  : time != null
                      ? Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: Align(
                            alignment: Alignment.topLeft,
                            child: Text(
                              formatTimestamp(time),
                              style: const TextStyle(
                                  fontSize: 11,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w400),
                            ),
                          ),
                        )
                      : null,
            ),
            Padding(
              padding: const EdgeInsets.all(10),
              child: Text(
                text,
                overflow: TextOverflow.ellipsis,
                maxLines: 2,
                style: const TextStyle(
                  color: Colors.black87,
                  fontWeight: FontWeight.w500,
                  fontSize: 15,
                ),
              ),
            ),
            const Spacer(),
            hasDelete
                ? TextButton(
                    onPressed: () async {
                      print('Delete button pressed for marker $markerid');
                      customInfoWindowController.value.hideInfoWindow!();
                      deleteMarkerFromFixedandUpdateMarkers(markerid);
                      await FirebaseQueryForUsers()
                          .deleteImageFromFirebaseStorage(
                              "MarkerImages/$markerid");
                      await FirebaseQueryForUsers()
                          .deleteMarkerFromFirestoreUsers(markerid);
                    },
                    child: const Text(
                      "Delete",
                      style: TextStyle(color: Colors.red),
                    ),
                  )
                : TextButton(
                    onPressed: () {}, child: const Text("Other's Marker")),
          ],
        ),
      ),
    );
  }

  String formatTimestamp(Timestamp timestamp) {
    DateTime dateTime = timestamp.toDate();

    String formattedTime = DateFormat.jm().format(dateTime); // Format: 11:15 AM
    String formattedDate =
        DateFormat('d MMM, y').format(dateTime); // Format: 12 Sept, 2023

    return '$formattedTime, $formattedDate';
  }

  // -- Bottom Sheet for getting Marker Details
  Future<dynamic> MarkerDetailsBottomSheet(
      File? image, String text, Timestamp? time) {
    return showModalBottomSheet(
        backgroundColor: Colors.white,
        isScrollControlled: true,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(30))),
        context: context,
        builder: (context) {
          return Wrap(
            children: [
              Padding(
                  padding: const EdgeInsets.fromLTRB(MyAppSizes.defaultSpace, 4,
                      MyAppSizes.defaultSpace, MyAppSizes.defaultSpace),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: double.infinity,
                        height: 200,
                        decoration: BoxDecoration(
                          image: image != null
                              ? DecorationImage(
                                  image: FileImage(image),
                                  fit: BoxFit.cover,
                                  filterQuality: FilterQuality.high,
                                )
                              : null,
                          borderRadius:
                              const BorderRadius.all(Radius.circular(25)),
                          color: Colors.red[400],
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      time != null
                          ? Text(formatTimestamp(time),
                              style: const TextStyle(
                                  fontSize: 13,
                                  color: Colors.black87,
                                  fontWeight: FontWeight.w400))
                          : Container(),
                      const SizedBox(
                        height: 10,
                      ),
                      Text(
                        text,
                        style: const TextStyle(
                          color: Colors.black87,
                          fontWeight: FontWeight.w500,
                          fontSize: 15,
                        ),
                      ),
                    ],
                  ))
            ],
          );
        });
  }

  // -- Delete a specific marker from the Markers using id
  void deleteMarkerFromFixedandUpdateMarkers(int markerid) {
    Marker? markerToRemove;

    for (Marker marker in fixedMarkers) {
      if (marker.markerId == MarkerId(markerid.toString())) {
        markerToRemove = marker;
        break;
      }
    }

    if (markerToRemove != null) {
      fixedMarkers.remove(markerToRemove);
      markers.remove(markerToRemove);

      print('Marker with id $markerid removed from fixedMarker');
    } else {
      print('Marker with id $markerid not found in fixedMarker');
    }
  }

  // -- Get Image From URL (Use to get the firebase Storage Images)
  Future<File> getImageFile(String imageUrl, int id) async {
    final response = await http.get(Uri.parse(imageUrl));

    // Convert the response body to bytes
    Uint8List bytes = response.bodyBytes;

    // Get the app's temporary directory
    Directory tempDir = await getTemporaryDirectory();

    // Create the necessary directories
    String appDirPath = '${tempDir.path}/HESTIA/MarkerImages/';
    Directory(appDirPath).createSync(recursive: true);

    // Create a temporary file in the app's temporary directory
    File imageFile = File('$appDirPath/image_file$id.png');

    // Write the bytes to the file
    await imageFile.writeAsBytes(bytes);

    return imageFile;
  }

  // -- Make Markers from Firestore Maps (& store it in fixed markers)
  Future<void> makeMarkersFromJson() async {
    try {
      print('Start makeMarkersFromJson');

      var listofAllMarkers =
          await FirebaseQueryForMarkers().getMarkersFromMarkers();
      print('List of markers retrieved successfully');

      print('Number of all markers: ${listofAllMarkers.length}');

      var userID = AuthRepository().getUserId();

      for (var map in listofAllMarkers) {
        print('Processing user marker: $map');

        LatLng? position = map["lat"] != null && map["long"] != null
            ? LatLng(map["lat"], map["long"])
            : null;

        if (position != null) {
          print('User marker position: $position');
          // File? image = await getImageFile(map["imageUrl"], map["id"]);
          // print('User marker image loaded: $image');

          bool isUsersMarker;
          if (map["userid"] == userID) {
            isUsersMarker = true;
          } else {
            isUsersMarker = false;
          }

          Marker marker = MakeFixedMarker(
            map["id"],
            position,
            customInfoWindowController.value,
            map["description"] ?? "",
            map["time"],
            map["imageUrl"],
            isUsersMarker,
          );

          print('marker created: $marker');

          // Adding the marker to Markers & fixed Markers list
          addSpecificMarker(marker, false);
          print('marker added to lists');
        }
      }

      print('End makeMarkersFromJson');
      print("Markers List: $markers");
    } catch (error) {
      print('Error making markers: $error');
    }
  }
}
