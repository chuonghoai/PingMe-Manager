// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:ui' as ui;
import 'package:pingme_manager/features/map/ui/widget/event_marker_painter.dart';

class MarkerGenerator {
  static Future<BitmapDescriptor> getIconFromEmoji(String emoji, {Size size = const Size(120, 150)}) async {
    final ui.PictureRecorder pictureRecorder = ui.PictureRecorder();
    final Canvas canvas = Canvas(pictureRecorder);
    
    final painter = EventMarkerPainter(emoji: emoji);
    painter.paint(canvas, size);

    final ui.Picture picture = pictureRecorder.endRecording();
    final ui.Image image = await picture.toImage(size.width.toInt(), size.height.toInt());
    
    final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
    if (byteData == null) return BitmapDescriptor.defaultMarker;
    
    final uint8List = byteData.buffer.asUint8List();

    return BitmapDescriptor.fromBytes(uint8List);
  }
}