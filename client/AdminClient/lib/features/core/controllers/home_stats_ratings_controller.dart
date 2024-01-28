import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';

class HomeStatsRatingController extends GetxController {
  static HomeStatsRatingController get instance => Get.find();

  Rx<double> homelessSightingsRate = 0.0.obs;
  Rx<double> crimeRate = 0.0.obs;

  Future<void> getHomelessSightingsRate(double? lat, double? long) async {
    try {
      var url = Uri.https(
          "hestiabackend-vu6qon67ia-el.a.run.app", "/viz/getStatsByCoord");

      print("Homeless Sightings lat: $lat, long: $long");
      var payload = {"lat": lat ?? 0.0, "lon": long ?? 0.0};

      var body = json.encode(payload);
      var response = await http.post(url,
          headers: {'Content-Type': 'application/json'}, body: body);

      if (response.statusCode == 200) {
        var jsonResponse = json.decode(utf8.decode(response.bodyBytes));
        print(
            "Updated the Homeless Sightings Rate ${jsonResponse["marker_star"]}");
        homelessSightingsRate.value = jsonResponse["marker_star"]
            .toDouble(); // Updated the Homeless Sightings Rate
        crimeRate.value = jsonResponse["SOS_Reports_star"]
            .toDouble(); // Updated the Crime Rate
      } else {
        print("Request failed with status: ${response.statusCode}");
      }
    } catch (e) {
      print("Error in getting Rates for Homeless Sightings $e");
    }
  }
}
