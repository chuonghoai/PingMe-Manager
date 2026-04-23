import 'package:flutter/material.dart';
import 'package:pingme_manager/features/map/services/dto/create_event_request.dart';
import '../../services/map_event_service.dart';
import '../../models/map_event_model.dart';

class MapEventController extends ChangeNotifier {
  final MapEventService _service = MapEventService();

  List<MapEventModel> events = [];
  bool isLoading = false;
  bool isCreating = false;
  String? errorMessage;

  Future<void> fetchEvents() async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      final events = await _service.getAllEvent();
      this.events = events;
    } catch (e) {
      errorMessage = e.toString();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  /// Create new event
  Future<bool> createEvent(CreateEventRequest event) async {
    isCreating = true;
    errorMessage = null;
    notifyListeners();

    try {
      final newEvent = await _service.createEvent(event);
      events.add(newEvent);
      return true;
    } catch (e) {
      errorMessage = e.toString();
      return false;
    } finally {
      isCreating = false;
      notifyListeners();
    }
  }

  /// Delete event
  Future<bool> deleteEvent(String eventId) async {
    try {
      final success = await _service.deleteEvent(eventId);
      if (success) {
        events.removeWhere((e) => e.id == eventId);
        notifyListeners();
      }
      return success;
    } catch (e) {
      errorMessage = e.toString();
      notifyListeners();
      return false;
    }
  }

  void clearError() {
    errorMessage = null;
    notifyListeners();
  }
}
