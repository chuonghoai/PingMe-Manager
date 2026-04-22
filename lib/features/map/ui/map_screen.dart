// ignore_for_file: use_super_parameters

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:pingme_manager/features/map/models/map_event_model.dart';
import 'package:pingme_manager/features/map/ui/components/event_detail_component.dart';
import 'package:pingme_manager/features/map/ui/components/event_edit_component.dart';
import 'package:pingme_manager/features/map/ui/components/map_event_components.dart';
import 'package:pingme_manager/features/map/ui/controller/map_controller.dart';
import 'package:pingme_manager/features/map/ui/controller/map_event_controller.dart';
import 'package:pingme_manager/features/map/ui/widget/map_control_buttons.dart';
import 'components/google_map_view.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({Key? key}) : super(key: key);

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  late final MapController _mapController;
  late final MapEventController _eventController;

  @override
  void initState() {
    super.initState();
    _mapController = MapController();
    _eventController = MapEventController();
    _mapController.initialize(
      eventController: _eventController,
      onShowDetail: (event) => _showEventDetail(event),
    );
  }

  void _showEventDetail(MapEventModel event) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) =>
          EventDetailComponent(event: event, eventController: _eventController),
    );
  }

  @override
  void dispose() {
    _mapController.dispose();
    _eventController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Bản đồ hệ thống'),
        backgroundColor: Colors.blueAccent,
      ),
      body: ListenableBuilder(
        listenable: _mapController,
        builder: (context, child) {
          if (_mapController.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          return Stack(
            children: [
              GoogleMapView(controller: _mapController),

              if (!_mapController.isPickingLocation)
                MapControlButtons(
                  onRefresh: _mapController.refreshMap,
                  onCenterMe: _mapController.centerMe,
                  onOpenEvents: () {
                    showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      backgroundColor: Colors.transparent,
                      builder: (context) => MapEventComponents(
                        onCreateNewTriggered: () {
                          Navigator.pop(context);
                          _mapController.startPickingLocation();
                        },
                        onNavigateToEvent: (lat, lng) {
                          _mapController.animateCameraTo(LatLng(lat, lng));
                        },
                      ),
                    );
                  },
                ),

              if (_mapController.isPickingLocation)
                Positioned(
                  bottom: 40,
                  left: 16,
                  right: 16,
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            _mapController.selectedLocation == null
                                ? 'Hãy chạm vào bản đồ để chọn vị trí'
                                : 'Đã chọn vị trí: ${_mapController.selectedLocation!.latitude.toStringAsFixed(4)}, ${_mapController.selectedLocation!.longitude.toStringAsFixed(4)}',
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 16),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              TextButton(
                                onPressed: _mapController.cancelPickingLocation,
                                child: const Text(
                                  'Hủy',
                                  style: TextStyle(color: Colors.red),
                                ),
                              ),
                              ElevatedButton(
                                onPressed:
                                    _mapController.selectedLocation == null
                                    ? null
                                    : () {
                                        final loc =
                                            _mapController.selectedLocation!;
                                        _mapController.cancelPickingLocation();
                                        showDialog(
                                          context: context,
                                          builder: (context) =>
                                              EventEditComponent(
                                                latitude: loc.latitude,
                                                longitude: loc.longitude,
                                                eventController: _eventController,
                                              ),
                                        );
                                      },
                                child: const Text('Tiếp tục'),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}
