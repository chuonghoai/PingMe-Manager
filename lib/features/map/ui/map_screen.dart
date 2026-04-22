// ignore_for_file: use_super_parameters

import 'package:flutter/material.dart';
import 'package:pingme_manager/features/map/ui/map_controller.dart';
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

              MapControlButtons(
                onRefresh: _controller.refreshMap,
                onCenterMe: _controller.centerMe,
              ),
            ],
          );
        },
      ),
    );
  }
}
