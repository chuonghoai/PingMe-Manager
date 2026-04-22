// ignore_for_file: use_super_parameters

import 'package:flutter/material.dart';

class MapControlButtons extends StatelessWidget {
  final VoidCallback onCenterMe;
  final VoidCallback onRefresh;
  final VoidCallback onOpenEvents;

  const MapControlButtons({
    Key? key,
    required this.onCenterMe,
    required this.onRefresh,
    required this.onOpenEvents,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Positioned(
      right: 16,
      bottom: 40,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          FloatingActionButton(
            heroTag: 'map_events',
            onPressed: onOpenEvents,
            backgroundColor: Colors.white,
            shape: const CircleBorder(),
            child: const Icon(Icons.star_rounded, color: Colors.amber, size: 36),
          ),
          const SizedBox(height: 16),

          FloatingActionButton(
            heroTag: 'map_refresh',
            onPressed: onRefresh,
            backgroundColor: Colors.white,
            foregroundColor: Colors.blueAccent,
            mini: true,
            child: const Icon(Icons.refresh),
          ),
          const SizedBox(height: 16),

          FloatingActionButton(
            heroTag: 'map_center',
            onPressed: onCenterMe,
            backgroundColor: Colors.white,
            foregroundColor: Colors.blueAccent,
            child: const Icon(Icons.my_location),
          ),
        ],
      ),
    );
  }
}
