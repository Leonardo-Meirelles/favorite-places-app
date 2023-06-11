import 'dart:convert';

import 'package:http/http.dart' as http;

const key = 'AIzaSyB9jLSmjU8pcNwWZb7qSUkoMFKlp1wkZfg';

class HttpClient {
  static String get apiKey {
    return key;
  }

  static Future<String> getLocationAddress(String lat, String lng) async {
    final String serviceUrl =
        'https://maps.googleapis.com/maps/api/geocode/json?latlng=$lat,$lng&key=$key';

    try {
      final url = Uri.parse(
        serviceUrl,
      );

      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
      );

      final decodedResponse = json.decode(response.body);

      final String address = decodedResponse['results'][0]['formatted_address'];

      return address;
    } catch (e) {
      throw Exception(e);
    }
  }

  static Future getStaticMapLocation(String lat, String lng) async {
    final String serviceUrl =
        'https://maps.googleapis.com/maps/api/staticmap?center=$lat,$lng&zoom=16&size=600x300&maptype=roadmap&markers=color:red%7Clabel:A%7C$lat,$lng&key=$key';

    try {
      final url = Uri.parse(
        serviceUrl,
      );

      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
      );

      final decodedResponse = response.body;

      // final String address = decodedResponse['results'][0]['formatted_address'];

      return decodedResponse;
    } catch (e) {
      throw Exception(e);
    }
  }
}
