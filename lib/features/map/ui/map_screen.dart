// ignore_for_file: use_super_parameters

import 'package:flutter/material.dart';
import 'package:pingme_manager/features/map/ui/components/event_edit_component.dart';
import 'package:pingme_manager/features/map/ui/components/map_event_components.dart';
import 'package:pingme_manager/features/map/ui/controller/map_controller.dart';
import 'package:pingme_manager/features/map/ui/widget/map_control_buttons.dart';
import 'components/google_map_view.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({Key? key}) : super(key: key);

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  late final MapController _controller;

  @override
  void initState() {
    super.initState();
    _controller = MapController();
    _controller.initMap();
  }

  @override
  void dispose() {
    _controller.dispose();
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
        listenable: _controller,
        builder: (context, child) {
          if (_controller.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          return Stack(
            children: [
              GoogleMapView(controller: _controller),

              if (!_controller.isPickingLocation)
                MapControlButtons(
                  onRefresh: _controller.refreshMap,
                  onCenterMe: _controller.centerMe,
                  onOpenEvents: () {
                    showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      backgroundColor: Colors.transparent,
                      builder: (context) => MapEventComponents(
                        onCreateNewTriggered: () {
                          Navigator.pop(context);
                          _controller.startPickingLocation();
                        },
                      ),
                    );
                  },
                ),

              if (_controller.isPickingLocation)
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
                            _controller.selectedLocation == null
                                ? 'Hãy chạm vào bản đồ để chọn vị trí'
                                : 'Đã chọn vị trí: ${_controller.selectedLocation!.latitude.toStringAsFixed(4)}, ${_controller.selectedLocation!.longitude.toStringAsFixed(4)}',
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
                                onPressed: _controller.cancelPickingLocation,
                                child: const Text(
                                  'Hủy',
                                  style: TextStyle(color: Colors.red),
                                ),
                              ),
                              ElevatedButton(
                                onPressed: _controller.selectedLocation == null
                                    ? null
                                    : () {
                                        final loc =
                                            _controller.selectedLocation!;
                                        _controller.cancelPickingLocation();
                                        showDialog(
                                          context: context,
                                          builder: (context) =>
                                              EventEditComponent(
                                                latitude: loc.latitude,
                                                longitude: loc.longitude,
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
