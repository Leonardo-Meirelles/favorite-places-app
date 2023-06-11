import 'package:favorite_places_app/models/favorite_place_model.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

class GoogleMapsView extends StatefulWidget {
  const GoogleMapsView({
    super.key,
    this.location,
  });

  // const GoogleMapsView({
  //   super.key,
  //   this.location = const PlaceLocationModel(
  //     latitude: 37.422,
  //     longitude: -122,
  //     address: '',
  //   ),
  // });

  final PlaceLocationModel? location;

  @override
  State<GoogleMapsView> createState() => _GoogleMapsViewState();
}

class _GoogleMapsViewState extends State<GoogleMapsView> {
  PlaceLocationModel? currentLocation;
  late bool isSelecting;

  LatLng? _pickedOnMapLocation;

  @override
  void initState() {
    super.initState();
    if (widget.location == null) {
      isSelecting = true;
      _getLocation();
    } else {
      currentLocation = widget.location;
      isSelecting = false;
    }
  }

  void _getLocation() async {
    Location location = Location();

    bool serviceEnabled;
    PermissionStatus permissionGranted;
    LocationData locationData;

    serviceEnabled = await location.serviceEnabled();

    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();

      if (!serviceEnabled) {
        return;
      }
    }

    permissionGranted = await location.hasPermission();

    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await location.requestPermission();

      if (permissionGranted != PermissionStatus.granted) {
        return;
      }
    }

    locationData = await location.getLocation();

    if (locationData.latitude == null || locationData.longitude == null) {
      return;
    }

    setState(() {
      currentLocation = PlaceLocationModel(
        latitude: locationData.latitude!,
        longitude: locationData.longitude!,
        address: '',
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget content = const Center(
      child: CircularProgressIndicator(),
    );

    if (currentLocation != null) {
      content = GoogleMap(
        onTap: (position) {
          isSelecting
              ? setState(() {
                  _pickedOnMapLocation = position;
                })
              : null;
        },
        initialCameraPosition: CameraPosition(
          target: LatLng(
            currentLocation!.latitude,
            currentLocation!.longitude,
          ),
          zoom: 16,
        ),
        markers: _pickedOnMapLocation == null && isSelecting
            ? {}
            : {
                Marker(
                  markerId: const MarkerId('m1'),
                  position: _pickedOnMapLocation ??
                      LatLng(
                        currentLocation!.latitude,
                        currentLocation!.longitude,
                      ),
                ),
              },
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(isSelecting ? 'Pick your Location' : 'Your Location'),
        actions: [
          if (isSelecting)
            IconButton(
              onPressed: () {
                Navigator.of(context).pop(_pickedOnMapLocation);
              },
              icon: const Icon(Icons.save),
            ),
        ],
      ),
      body: content,
    );
  }
}
