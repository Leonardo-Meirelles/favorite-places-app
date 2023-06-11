import 'dart:io';

import 'package:uuid/uuid.dart';

var uuid = const Uuid();

class PlaceLocationModel {
  const PlaceLocationModel({
    required this.latitude,
    required this.longitude,
    required this.address,
  });

  final double latitude;
  final double longitude;
  final String address;
}

class FavoritePlaceModel {
  FavoritePlaceModel({
    required this.placeName,
    required this.image,
    required this.location,
    String? id,
  }) : id = id ?? uuid.v4();

  final String id;
  final String placeName;
  final File image;
  final PlaceLocationModel location;
}
