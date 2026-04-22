import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:pingme_manager/features/map/services/location_service.dart';

class MapController extends ChangeNotifier {
  final LocationService _locationService = LocationService();
  GoogleMapController? mapController;

  LatLng currentLocation = const LatLng(10.7769, 106.7009);

  bool isLoading = true;
  bool isLocationEnabled = false;

  Future<void> initMap() async {
    isLoading = true;
    notifyListeners();

    final LatLng? deviceLocation = await _locationService.getCurrentLocation();

    if (deviceLocation != null) {
      currentLocation = deviceLocation;
      isLocationEnabled = true;
    } else {
      isLocationEnabled = false;
    }

    isLoading = false;
    notifyListeners();
  }

  void onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  /// Button: center me
  Future<void> centerMe() async {
    if (mapController == null) return;

    final LatLng? deviceLocation = await _locationService.getCurrentLocation();

    if (deviceLocation != null) {
      currentLocation = deviceLocation;
      mapController!.animateCamera(
        CameraUpdate.newLatLngZoom(currentLocation, 16.0),
      );
      isLocationEnabled = true;
    } else {
      debugPrint("Không thể lấy vị trí. Vui lòng bật GPS.");
    }
    notifyListeners();
  }

  /// Button: refresh map
  void refreshMap() {
    initMap();
  }
}
