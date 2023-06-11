import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path_provider/path_provider.dart' as syspaths;
import 'package:path/path.dart' as path;
import 'package:sqflite/sqflite.dart' as sql;
import 'package:sqflite/sqlite_api.dart';

import '../models/favorite_place_model.dart';

Future<Database> _getDatabase() async {
  final database = await sql.openDatabase(
    path.join(
      await sql.getDatabasesPath(),
      'favorite_places.db',
    ),
    onCreate: (db, version) {
      return db.execute(
        'CREATE TABLE places(id TEXT PRIMARY KEY, place_name TEXT, image_path TEXT, latitude REAL, longitude REAL, address TEXT)',
      );
    },
    version: 1,
  );

  return database;
}

final favoritePlacesProvider =
    StateNotifierProvider<FavoritePlacesNotifier, List<FavoritePlaceModel>>(
  (ref) => FavoritePlacesNotifier(),
);

class FavoritePlacesNotifier extends StateNotifier<List<FavoritePlaceModel>> {
  FavoritePlacesNotifier() : super(const []);

  Future<void> loadInitialData() async {
    final database = await _getDatabase();

    final data = await database.query('places');

    final places = data
        .map(
          (row) => FavoritePlaceModel(
            id: row['id'] as String,
            placeName: row['place_name'] as String,
            image: File(row['image_path'] as String),
            location: PlaceLocationModel(
              latitude: row['latitude'] as double,
              longitude: row['longitude'] as double,
              address: row['address'] as String,
            ),
          ),
        )
        .toList();

    state = places;
  }

  void addFavoritePlace({
    required String placeName,
    required File image,
    required PlaceLocationModel location,
  }) async {
    final appDirectory = await syspaths.getApplicationDocumentsDirectory();

    final fileName = path.basename(image.path);

    final copiedImage = await image.copy('${appDirectory.path}/$fileName');

    final newPlace = FavoritePlaceModel(
      placeName: placeName,
      image: image,
      location: location,
    );

    final database = await _getDatabase();

    database.insert('places', {
      'id': newPlace.id,
      'place_name': newPlace.placeName,
      'image_path': copiedImage.path,
      'latitude': newPlace.location.latitude,
      'longitude': newPlace.location.longitude,
      'address': newPlace.location.address,
    });

    state = [...state, newPlace];
  }

  void removeFavoritePlace(FavoritePlaceModel place) {
    state = [
      for (final item in state)
        if (item != place) item,
    ];
  }
}
