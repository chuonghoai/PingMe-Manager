// ignore_for_file: use_super_parameters

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:pingme_manager/features/map/ui/map_controller.dart';

class GoogleMapView extends StatelessWidget {
  final MapController controller;

  const GoogleMapView({Key? key, required this.controller}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GoogleMap(
      onMapCreated: controller.onMapCreated,
      initialCameraPosition: CameraPosition(
        target: controller.defaultLocation,
        zoom: 13,
      ),
      myLocationEnabled: false, 
      myLocationButtonEnabled: false,
      zoomControlsEnabled: false,
      mapToolbarEnabled: false,
      compassEnabled: false,
    );
  }
}