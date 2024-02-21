import 'package:flutter/foundation.dart';
import 'package:geocoding/geocoding.dart';

Future<String> getPlacemarks(double lat, double long) async {
  try {
    List<Placemark> placemarks = await placemarkFromCoordinates(lat, long);

    var address = '';

    if (placemarks.isNotEmpty) {
      // Concatenate non-null components of the address

      var streets = placemarks.reversed
          .map((placemark) => placemark.street)
          .where((street) => street != null);

      // Filter out unwanted parts
      streets = streets.where((street) =>
          street!.toLowerCase() !=
          placemarks.reversed.last.locality!
              .toLowerCase()); // Remove city names
      streets =
          streets.where((street) => !street!.contains('+')); // Remove codes

      address += streets.join(', ');

      address += ', ${placemarks.reversed.last.subLocality ?? ''}';
      address += ', ${placemarks.reversed.last.locality ?? ''}';
      address += ', ${placemarks.reversed.last.subAdministrativeArea ?? ''}';
      address += ', ${placemarks.reversed.last.administrativeArea ?? ''}';
      address += ', ${placemarks.reversed.last.postalCode ?? ''}';
      address += ', ${placemarks.reversed.last.country ?? ''}';
    }

    debugPrint("Current address: $address");

    return address;
  } catch (e) {
    debugPrint("Error getting placemarks: $e");
    return "No Address";
  }
}
