import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:pingme_manager/features/map/models/map_event_model.dart';
import 'package:pingme_manager/features/map/models/reward_model.dart';
import 'package:pingme_manager/features/map/services/location_service.dart';
import 'package:pingme_manager/features/map/ui/controller/map_event_controller.dart';
import 'package:pingme_manager/features/map/utils/marker_generator.dart';

class MapController extends ChangeNotifier {
  final LocationService _locationService = LocationService();
  GoogleMapController? mapController;

  LatLng currentLocation = const LatLng(10.7769, 106.7009);

  bool isLoading = true;
  bool isLocationEnabled = false;
  bool isPickingLocation = false;
  LatLng? selectedLocation;

  Set<Marker> markers = {};
  final Map<String, BitmapDescriptor> _iconCache = {};
  late MapEventController _eventController;
  late Function(MapEventModel) _onShowDetail;

  /// Init controller
  Future<void> initialize({
    required MapEventController eventController,
    required Function(MapEventModel) onShowDetail,
  }) async {
    _eventController = eventController;
    _onShowDetail = onShowDetail;

    isLoading = true;
    notifyListeners();

    await Future.wait([initMap(), _eventController.fetchEvents()]);
    _eventController.addListener(_handleEventsChanged);
    _handleEventsChanged();

    isLoading = false;
    notifyListeners();
  }

  Future<void> _handleEventsChanged() async {
    await updateMarkers(_eventController.events, _onShowDetail);
  }

  @override
  void dispose() {
    _eventController.removeListener(_handleEventsChanged);
    super.dispose();
  }

  Future<void> initMap() async {
    final LatLng? deviceLocation = await _locationService.getCurrentLocation();
    if (deviceLocation != null) {
      currentLocation = deviceLocation;
      isLocationEnabled = true;
    } else {
      isLocationEnabled = false;
    }
  }

  void onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  /// Convert list events to marker
  Future<void> updateMarkers(
    List<MapEventModel> events,
    Function(MapEventModel) onMarkerTap,
  ) async {
    isLoading = true;
    notifyListeners();
    final newMarkers = <Marker>{};

    if (selectedLocation != null) {
      newMarkers.add(
        Marker(
          markerId: const MarkerId('selected_location'),
          position: selectedLocation!,
          icon: BitmapDescriptor.defaultMarkerWithHue(
            BitmapDescriptor.hueAzure,
          ),
        ),
      );
    }

    for (var event in events) {
      if (event.latitude != null && event.longitude != null) {
        final reward = RewardDefinitions.getReward(event.rewardItem);
        final emoji = reward?.emoji ?? '🎁';

        if (!_iconCache.containsKey(emoji)) {
          _iconCache[emoji] = await MarkerGenerator.getIconFromEmoji(emoji);
        }
        final customIcon = _iconCache[emoji]!;

        newMarkers.add(
          Marker(
            markerId: MarkerId(event.id ?? UniqueKey().toString()),
            position: LatLng(event.latitude!, event.longitude!),
            icon: customIcon,
            infoWindow: InfoWindow(title: event.name, snippet: reward?.name),
            onTap: () => onMarkerTap(event),
          ),
        );
      }
    }

    markers = newMarkers;
    isLoading = false;
    notifyListeners();
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

  /// Button: start picking location
  void startPickingLocation() {
    isPickingLocation = true;
    selectedLocation = null;
    notifyListeners();
  }

  void cancelPickingLocation() {
    isPickingLocation = false;
    selectedLocation = null;
    notifyListeners();
  }

  void selectLocationOnMap(LatLng location) {
    if (isPickingLocation) {
      selectedLocation = location;
      updateMarkers([], (_) {});
      notifyListeners();
    }
  }
}
