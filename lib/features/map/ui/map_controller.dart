import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapController extends ChangeNotifier {
  GoogleMapController? mapController;

  final LatLng defaultLocation = const LatLng(10.7769, 106.7009);

  bool isLoading = true;

  Future<void> initMap() async {
    await Future.delayed(const Duration(milliseconds: 500));
    isLoading = false;
    notifyListeners();
  }

  void onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  /// Button: center me
  void centerMe() {
    if (mapController != null) {
      mapController!.animateCamera(
        CameraUpdate.newLatLngZoom(defaultLocation, 14.0),
      );
    }
  }

  /// Nút Refresh
  void refreshMap() {
    debugPrint("Admin đang refresh dữ liệu bản đồ...");

    isLoading = true;
    notifyListeners();

    Future.delayed(const Duration(milliseconds: 500), () {
      isLoading = false;
      notifyListeners();
    });
  }
}
