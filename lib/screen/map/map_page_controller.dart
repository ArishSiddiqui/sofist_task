import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapPageController {
  CameraPosition currentLoc = const CameraPosition(
    target: LatLng(19.2096565, 72.8289816),
    zoom: 13.0,
  );

  Marker marker = const Marker(
    markerId: MarkerId('location'),
    infoWindow: InfoWindow(title: 'Kandivali'),
    icon: BitmapDescriptor.defaultMarker,
    // icon: await BitmapDescriptor.fromAssetImage(ImageConfiguration(size: Size(10, 10)), 'assets/marker.png').then((value) => null),
    position: LatLng(19.2096565, 72.8289816),
  );

  final List<Map<String, dynamic>> locations = const [
    {
      "college_name": "Thakur College",
      "position": LatLng(19.2059, 72.8737),
    },
    {
      "college_name": "Wilson College",
      "position": LatLng(18.9563, 72.8108),
    }
  ];
  final bottomIndex = StateProvider<int>((ref) => 0);
  final dropValue = StateProvider<Map<String, dynamic>?>((ref) => null);

  final Completer<GoogleMapController> mapController =
      Completer<GoogleMapController>();

  Future<void> goToLocation() async {
    final GoogleMapController controller = await mapController.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(currentLoc));
  }
}
